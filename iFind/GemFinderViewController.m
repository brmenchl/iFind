//
//  GemFinderViewController.m
//  iFind
//
//  Created by Andrew Milenius on 2/25/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "GemFinderViewController.h"
#import "GemAnnotation.h"
#import <MapKit/MapKit.h>
#import "UIImage+ImageEffects.h"
#import "AppDelegate.h"
#import "ALRadialMenu.h"

@interface GemFinderViewController () {
    UIAlertView *turnOnLocationServicesAlert;
    CLLocationDistance closestDistance;
}
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *gemAnnotationArray;
@property (nonatomic, weak) PFObject * closestGem;
@property (nonatomic, strong) LeaveGemViewController *leaveGemVC;

@end

@implementation GemFinderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.definesPresentationContext = YES;
    if(!turnOnLocationServicesAlert) {
        turnOnLocationServicesAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Please turn on your location services" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    }
    self.leaveGemVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LeaveGemVC"];
    self.leaveGemVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.leaveGemVC.delegate = self;
    [self startUpdating];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.locationManager) {
        [self.locationManager startUpdatingLocation];
    }
    self.dropButton.enabled = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.locationManager stopUpdatingLocation];
    self.dropButton.enabled = NO;
    self.pickUpButton.enabled = NO;
}

- (void) startUpdating {
    if(!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    
    CLLocation *currentLocation = self.locationManager.location;
	if (currentLocation) {
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
		appDelegate.currentLocation = currentLocation;
        self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude), MKCoordinateSpanMake(0.008516f, 0.021801f));
	}
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.currentLocation = [locations lastObject];
    MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(appDelegate.currentLocation.coordinate, 305 * 2.0f, 305 * 2.0f);
    [self.mapView setRegion:newRegion animated:YES];
    [self queryForAllPostsNearLocation:appDelegate.currentLocation];
}

- (void)dropGemWithContent:(NSArray *)content {
    if(![CLLocationManager locationServicesEnabled]) {
        [turnOnLocationServicesAlert show];
        return;
    }
    PFObject *gemMetadata = [PFObject objectWithClassName:ParseGemMetadataClassName];
    PFObject *gemToDrop = [[[PFUser currentUser] objectForKey:ParseUserInventoryKey]lastObject];
    for(NSObject *object in content) {
        if([object isKindOfClass:[NSString class]]) {
            gemMetadata[ParseMetaTextContentKey] = object;
        }
        else if([object isKindOfClass:[UIImage class]]) {
            gemMetadata[ParseMetaImageContentKey] = [PFFile fileWithName:@"image.jpg" data:UIImageJPEGRepresentation((UIImage *)object, 0.05f)];
        }
    }
    gemMetadata[ParseMetaGemReferenceKey] = gemToDrop;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PFGeoPoint *droppedGemLocation = [PFGeoPoint geoPointWithLocation:appDelegate.currentLocation];
    gemToDrop[ParseGemCurrentLocationKey] = droppedGemLocation;
    [gemToDrop[ParseGemLocationsKey] addObject:droppedGemLocation];
    gemToDrop[ParseGemMetadataReferenceKey] = gemMetadata;
    gemToDrop[ParseGemCurrentOwnerKey] = [NSNull null];
    NSLog(@"%@\n\n%@",gemToDrop, gemMetadata);
    [PFObject saveAllInBackground:@[gemToDrop, gemMetadata] block:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"%@", [[[error userInfo] objectForKey:@"NSUnderlyingErrorKey"]localizedDescription]);
        }
        else if (succeeded) {
            [[PFUser currentUser] removeObject:gemToDrop forKey:ParseUserInventoryKey];
            NSLog(@"%@",[PFUser currentUser][ParseUserInventoryKey]);
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error) {
                if (succeeded) {
                    [self queryForAllPostsNearLocation:appDelegate.currentLocation];
                }
                else {
                    NSLog(@"%@", [[[error userInfo] objectForKey:@"NSUnderlyingErrorKey"]localizedDescription]);
                }
            }];
        }
        else {
            NSLog(@"Failed to save. No error.");
        }
    }];
}

- (IBAction)dropButtonPress:(id)sender {
    //Getting image of current screen
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [window bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [window.layer renderInContext:context];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //Blurring the image
    UIImage *blurImage = [screenshot applyBlurWithRadius:1 tintColor:[UIColor colorWithWhite:0 alpha:0.2] saturationDeltaFactor:1 maskImage:nil];

    self.leaveGemVC.blurImage = blurImage;
    [self.view.window.rootViewController presentViewController:self.leaveGemVC animated:YES completion:NULL];
}

- (IBAction)pickUpButtonPress:(id)sender {
    if(![CLLocationManager locationServicesEnabled]) {
        [turnOnLocationServicesAlert show];
        return;
    }
    self.closestGem[ParseGemCurrentLocationKey] = [NSNull null];
    NSLog(@"passed timeline loop");
    [[PFUser currentUser]addObject:self.closestGem[ParseGemMetadataReferenceKey] forKey:ParseUserTimelineKey];
    self.closestGem[ParseGemMetadataReferenceKey] = [NSNull null];
    self.closestGem[ParseGemCurrentOwnerKey] = [PFUser currentUser];
    [[PFUser currentUser] addObject:self.closestGem forKey:ParseUserInventoryKey];
    [PFObject saveAllInBackground:@[self.closestGem, [PFUser currentUser]] block:^(BOOL succeeded, NSError * error) {
        if(error) {
            NSLog(@"%@", [[[error userInfo] objectForKey:@"NSUnderlyingErrorKey"]localizedDescription]);
        }
        if(succeeded) {
            closestDistance = -1;
            self.closestGem = nil;
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [self queryForAllPostsNearLocation:appDelegate.currentLocation];
        }
        else {
            NSLog(@"Failed to save.  No error.");
        }
    }];
}

- (void)queryForAllPostsNearLocation:(CLLocation *)currentLocation {
	if (currentLocation == nil) {
		NSLog(@"current location got a nil location!");
        return;
	}
    PFQuery *query = [PFQuery queryWithClassName:ParseGemClassName];
    
	if ([self.gemAnnotationArray count] == 0) {
		query.cachePolicy = kPFCachePolicyCacheThenNetwork;
	}
    
	// Query for posts  near current location.
	PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
	[query whereKey:ParseGemCurrentLocationKey nearGeoPoint:point withinKilometers:MaximumSearchDistance];
	query.limit = GemQueryLimit;
    
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (error) {
            NSLog(@"%@", [[[error userInfo] objectForKey:@"NSUnderlyingErrorKey"]localizedDescription]);
		}
        else {
			NSMutableArray *gemsToAdd = [[NSMutableArray alloc] initWithCapacity:GemQueryLimit];
            NSMutableArray *gemsToRemove = [[NSMutableArray alloc] initWithCapacity:GemQueryLimit];
			NSMutableArray *queriedGems = [[NSMutableArray alloc] initWithCapacity:GemQueryLimit];
            BOOL gemIsNew = FALSE;
            BOOL gemIsOld = FALSE;
            
            if([objects count] == 0) {
                NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.mapView annotations]];
                [self.mapView removeAnnotations:pins];
                [self.mapView setShowsUserLocation:YES];
            }
            
            BOOL firstLoop = TRUE;
			for (PFObject *object in objects) {
				GemAnnotation *newGem = [[GemAnnotation alloc] initWithPFObject:object];
                if(firstLoop) {
                    CLLocation *newGemLoc = [[CLLocation alloc] initWithLatitude:newGem.coordinate.latitude longitude:newGem.coordinate.longitude];
                    closestDistance = [currentLocation distanceFromLocation:newGemLoc];
                    self.closestGem = [objects firstObject];
                    firstLoop = NO;
                }
				[queriedGems addObject:newGem];
                gemIsNew = TRUE;
				for (GemAnnotation *oldGem in self.gemAnnotationArray) {
					if ([newGem equalToGem:oldGem]) {
                        gemIsNew = FALSE;
                    }
				}
                if(gemIsNew) {
                    [gemsToAdd addObject:newGem];
                }
			}

			for (GemAnnotation *oldGem in self.gemAnnotationArray) {
                gemIsOld = TRUE;
				for (GemAnnotation *queriedGem in queriedGems) {
					if ([oldGem equalToGem:queriedGem]) {
                        gemIsOld = FALSE;
					}
				}
                if(gemIsOld) {
                    [gemsToRemove addObject:oldGem];
                }
			}
			[self.mapView removeAnnotations:gemsToRemove];
            [self.gemAnnotationArray removeObjectsInArray:gemsToRemove];
			[self.mapView addAnnotations:gemsToAdd];
			[self.gemAnnotationArray addObjectsFromArray:gemsToAdd];
            NSMutableArray *inventory = [[PFUser currentUser] objectForKey:ParseUserInventoryKey];
            NSLog(@"inventory: %@",[PFUser currentUser][ParseUserInventoryKey]);
            self.dropButton.enabled = [inventory count] > 0;
        }
	}];
}
@end
