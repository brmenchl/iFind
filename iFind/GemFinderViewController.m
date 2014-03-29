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
    CLLocationDistance closestDistance; //Distance to closest gem
}
//Private property for locationManager, used to update current location
@property (nonatomic, retain) CLLocationManager *locationManager;

//Mutable array for holding the annotations (purely for showing up on the map view) for gems
@property (nonatomic, strong) NSMutableArray *gemAnnotationArray;

//PFObject representing the closest Parse gem object to the player
@property (nonatomic, weak) PFObject * closestGem;

//Private view controller reference for the modal addcontentviewcontroller
@property (nonatomic, strong) AddContentViewController *addContentViewController;

//Alertview to notify user that location services are off and we cannot track their location
@property (nonatomic, strong) UIAlertView *turnOnLocationServicesAlert;
@end

@implementation GemFinderViewController

#pragma ViewController lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Not sure if this is necessary
    self.definesPresentationContext = YES;
    
    //Create alertview
    if(!self.turnOnLocationServicesAlert) {
        self.turnOnLocationServicesAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Please turn on your location services" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    }
    
    //Initialize addContentViewController in background to speed up having it appear
    self.addContentViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LeaveGemVC"];
    self.addContentViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.addContentViewController.delegate = self;
    
    [self startUpdating];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.locationManager) {
        [self.locationManager startUpdatingLocation];
    }
    // We should be resetting drop and pick up gem buttons here, you shouldn't be able to drop or pick up unless valid
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.locationManager stopUpdatingLocation];
}

//initialize locationManager and get initial location
- (void) startUpdating {
    if(!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    CLLocation *currentLocation = self.locationManager.location;
    
    //If currentLocation can be gotten at this point, we should make an else block
	if (currentLocation) {
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
		appDelegate.currentLocation = currentLocation;
        
        //Set viewed region on map to center on user.  The zoom level was copied from parse's app
        self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude), MKCoordinateSpanMake(0.008516f, 0.021801f));
	}
}

#pragma CLLocationManagerDelegate methods

//Gets called upon locationManager updating current location, locations argument is an array, ordered by update time, most recent on back
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //Set global reference to current location
	appDelegate.currentLocation = [locations lastObject];
    
    //Reset viewed region to center on user
    MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(appDelegate.currentLocation.coordinate, 305 * 2.0f, 305 * 2.0f);
    [self.mapView setRegion:newRegion animated:YES];
    
    //Query for nearby gems
    [self queryForAllPostsNearLocation:appDelegate.currentLocation];
}

#pragma AddContentViewControllerDelegate methods

/*
 *  Takes content added in addContentViewController and saves it to Parse in a new gemMetadata Parse object
 *  the gemMetadata Object is created and initialized with:
 *      the relevant content field initialized to added content (if it exists), a pointer to the gem it was created with
 *  the gem Object is created and initialized with:
 *      a pointer to the new gemMetadata object, currentOwner = null, locations array field push back current location,
 *      currentLocation field = current user location
 *  the gem object is removed from the user's inventory array
 *  all three objects (gem, gemMetadata, current user) are saved to Parse
 */
- (void)dropGemWithContent:(NSArray *)content {
    //If location services off
    if(![CLLocationManager locationServicesEnabled]) {
        [self.turnOnLocationServicesAlert show];
        return;
    }
    
    //Create new gemMetadata object, get reference to next gem to drop from current user inventory array
    PFObject *gemMetadata = [PFObject objectWithClassName:ParseGemMetadataClassName];
    PFObject *gemToDrop = [[[PFUser currentUser] objectForKey:ParseUserInventoryKey]anyObject];
    
    //Loop through all added content from AddContentViewController and add content to relevant field in gemMetadata object
    for(NSObject *object in content) {
        if([object isKindOfClass:[NSString class]]) {
            gemMetadata[ParseMetaTextContentKey] = object;
        }
        else if([object isKindOfClass:[UIImage class]]) {
            gemMetadata[ParseMetaImageContentKey] = [PFFile fileWithName:@"image.jpg" data:UIImageJPEGRepresentation((UIImage *)object, 0.05f)];
        }
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PFGeoPoint *droppedGemLocation = [PFGeoPoint geoPointWithLocation:appDelegate.currentLocation];
    gemToDrop[ParseGemCurrentLocationKey] = droppedGemLocation;
    [gemToDrop[ParseGemLocationsKey] addObject:droppedGemLocation];
    gemToDrop[ParseGemMetadataReferenceKey] = gemMetadata;
    gemToDrop[ParseGemCurrentOwnerKey] = [NSNull null];
    gemMetadata[ParseMetaGemReferenceKey] = gemToDrop;
    
    NSLog(@"%@\n\n%@",gemToDrop, gemMetadata);
    //Attempt to save gem and gemMetadata PFObjects
    //THIS ENTIRE SET OF SAVES WILL EVENTUALLY NEED TO BE CHANGED,  APPARENTLY PARSE DOESN'T HANDLE NESTED API CALLS WELL
    [PFObject saveAllInBackground:@[gemToDrop, gemMetadata] block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //Success
            //Remove dropped gem object from current user's inventory
            [[PFUser currentUser] removeObject:gemToDrop forKey:ParseUserInventoryKey];
            NSLog(@"%@",[PFUser currentUser][ParseUserInventoryKey]);
            //Attempt to save current user
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error) {
                if (succeeded) {
                    //Success
                    //Query for new nearby gems
                    [self queryForAllPostsNearLocation:appDelegate.currentLocation];
                }
                else {
                    NSLog(@"%@", [[[error userInfo] objectForKey:@"NSUnderlyingErrorKey"]localizedDescription]);
                }
            }];
        }
        else {
            NSLog(@"%@", [[[error userInfo] objectForKey:@"NSUnderlyingErrorKey"]localizedDescription]);
        }
    }];
}

- (IBAction)dropButtonPress:(id)sender {
    //Getting image of current screen
    //This set of operations takes a little bit, we should figure out a faster way
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [window bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [window.layer renderInContext:context];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Blurring the image with Apple's "UIImage+ImageEffects"
    UIImage *blurImage = [screenshot applyBlurWithRadius:1 tintColor:[UIColor colorWithWhite:0 alpha:0.2] saturationDeltaFactor:1 maskImage:nil];
    [self.addContentViewController.backgroundImageView setImage:blurImage];
    
    //Present AddContentViewController
    [self.view.window.rootViewController presentViewController:self.addContentViewController animated:YES completion:NULL];
}

- (IBAction)pickUpButtonPress:(id)sender {
    if(![CLLocationManager locationServicesEnabled]) {
        //if location services are disabled
        [self.turnOnLocationServicesAlert show];
        return;
    }
    
    [[PFUser currentUser]addObject:self.closestGem[ParseGemMetadataReferenceKey] forKey:ParseUserTimelineKey];
    [[PFUser currentUser] addObject:self.closestGem forKey:ParseUserInventoryKey];
    self.closestGem[ParseGemCurrentLocationKey] = [NSNull null];
    self.closestGem[ParseGemMetadataReferenceKey] = [NSNull null];
    self.closestGem[ParseGemCurrentOwnerKey] = [PFUser currentUser];

    //Attempt to save picked up gem object and current user
    [PFObject saveAllInBackground:@[self.closestGem, [PFUser currentUser]] block:^(BOOL succeeded, NSError * error) {
        if(succeeded) {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            //query for nearby gems
            [self queryForAllPostsNearLocation:appDelegate.currentLocation];
        }
        else {
            NSLog(@"%@", [[[error userInfo] objectForKey:@"NSUnderlyingErrorKey"]localizedDescription]);
        }
    }];
}


/*
 *  Queries Parse for all Gem objects near the current user's location
 *  The method updates the 'closestGem' property as well as it's distance, and refreshes the map view with
 *  Nearby gems
 */
- (void)queryForAllPostsNearLocation:(CLLocation *)currentLocation {
	if (currentLocation == nil) {
		NSLog(@"current location got a nil location!");
        return;
	}
    //Create Parse query on gem table
    PFQuery *query = [PFQuery queryWithClassName:ParseGemClassName];
    
    //set query cache policy
	if ([self.gemAnnotationArray count] == 0) {
		query.cachePolicy = kPFCachePolicyCacheThenNetwork;
	}
    
	//Query for posts near current location
	PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
	[query whereKey:ParseGemCurrentLocationKey nearGeoPoint:point withinKilometers:MaximumSearchDistance];
    
    //Limit query to global query limit
	query.limit = GemQueryLimit;
    
    //Execute query in background
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (error) {
            NSLog(@"%@", [[[error userInfo] objectForKey:@"NSUnderlyingErrorKey"]localizedDescription]);
		}
        else {
			NSMutableArray *gemsToAdd = [[NSMutableArray alloc] initWithCapacity:GemQueryLimit];  //Aray of new gems to appear on map
            NSMutableArray *gemsToRemove = [[NSMutableArray alloc] initWithCapacity:GemQueryLimit]; //Array of gems on map to be deleted
			NSMutableArray *queriedGems = [[NSMutableArray alloc] initWithCapacity:GemQueryLimit]; //Array of Annotations for all gems queried
            BOOL gemIsNew = FALSE;
            BOOL gemIsOld = FALSE;
            
            //if no gems found nearby, wipe map clear of gems
            if([objects count] == 0) {
                NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.mapView annotations]];
                [self.mapView removeAnnotations:pins];
                [self.mapView setShowsUserLocation:YES];
                return;
            }
            
            
            BOOL firstLoop = TRUE;
			for (PFObject *object in objects) {
				GemAnnotation *newGem = [[GemAnnotation alloc] initWithPFObject:object];
                if(firstLoop) {
                    //Gems are returned in order nearest to farthest from current location
                    //Grab first gem to get reference to closest gem
                    CLLocation *newGemLoc = [[CLLocation alloc] initWithLatitude:newGem.coordinate.latitude longitude:newGem.coordinate.longitude];
                    closestDistance = [currentLocation distanceFromLocation:newGemLoc];
                    self.closestGem = [objects firstObject];
                    firstLoop = NO;
                }
				[queriedGems addObject:newGem];
                
                gemIsNew = TRUE;
				for (GemAnnotation *oldGem in self.gemAnnotationArray) {
                    //Loop through all gem annotations from last query
					if ([newGem equalToGem:oldGem]) {
                        gemIsNew = FALSE;
                    }
				}
                if(gemIsNew) {
                    //Gem was not found in old array, must be new
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
                    //Gem is not found in queried gems, should be removed
                    [gemsToRemove addObject:oldGem];
                }
			}
            
            //Remove annotations that don't need to be shown
			[self.mapView removeAnnotations:gemsToRemove];
            [self.gemAnnotationArray removeObjectsInArray:gemsToRemove];
            //Add new annotations
			[self.mapView addAnnotations:gemsToAdd];
			[self.gemAnnotationArray addObjectsFromArray:gemsToAdd];
            
            //Set drop gem button to be enabled if there is a gem to drop
            NSMutableArray *inventory = [[PFUser currentUser] objectForKey:ParseUserInventoryKey];
            NSLog(@"inventory: %@",[PFUser currentUser][ParseUserInventoryKey]);
            self.dropButton.enabled = [inventory count] > 0;
        }
	}];
}
@end
