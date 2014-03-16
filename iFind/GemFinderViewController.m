//
//  GemFinderViewController.m
//  iFind
//
//  Created by Andrew Milenius on 2/25/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "GemFinderViewController.h"
#import "Gem.h"
#import "AppDelegate.h"

@interface GemFinderViewController () {
    UIAlertView *turnOnLocationServicesAlert;
    CLLocationDistance closestDistance;
}
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *gemsArray;
@property (nonatomic, strong) PFObject * firstGemInInventory;
@property (nonatomic, weak) PFObject * closestGem;

@end

@implementation GemFinderViewController

- (void)viewDidLoad {
    if(turnOnLocationServicesAlert == nil) {
        turnOnLocationServicesAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Please turn on your location services" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    }
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gemDropped:) name:GemDroppedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gemPickedUp:) name:GemPickedUpNotification object:nil];
    
    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.332495f, -122.029095f), MKCoordinateSpanMake(0.008516f, 0.021801f)); //Copied this from anywall..
    [self startUpdating];
}

- (void)viewWillAppear:(BOOL)animated {
	[self.locationManager startUpdatingLocation];
	[super viewWillAppear:animated];
    self.dropButton.enabled = self.firstGemInInventory != nil;
    self.pickupButton.enabled = closestDistance < PickUpDistance;
}

- (void)viewDidDisappear:(BOOL)animated {
	[self.locationManager stopUpdatingLocation];
	[super viewDidDisappear:animated];
}

- (void)dealloc {
	[self.locationManager stopUpdatingLocation];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:GemPickedUpNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:GemDroppedNotification object:nil];
	
}

- (void) startUpdating {
    NSLog(@"UPDATING");
    if(self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    
    
    CLLocation *currentLocation = self.locationManager.location;
	if (currentLocation) {
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
		appDelegate.currentLocation = currentLocation;
	}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"UPDATE");
    NSLog((self.firstGemInInventory != nil) ? @"GOTGEM" : @"NOGEM");
	appDelegate.currentLocation = [locations lastObject];
    MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(appDelegate.currentLocation.coordinate, 305 * 2.0f, 305 * 2.0f);
    //CHECK ANYWALLS FILTER DISTANCE STUFF.  THEY STORE THE LAST ZOOM LEVEL IN USER DEFAULTS AND CREATE A GLOBAL TO REFERENCE IT.  305 is approx 1000 feet, totally arbitrary.
    [self.mapView setRegion:newRegion animated:YES];
    [self queryForAllPostsNearLocation:appDelegate.currentLocation];
}

- (void)gemDropped:(NSNotification *)note {
    NSLog(@"CAUGHT DROP");
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[self queryForAllPostsNearLocation:appDelegate.currentLocation];
}

- (void) gemPickedUp:(NSNotification *)note {
    NSLog(@"CAUGHT PICKUP");
   	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[self queryForAllPostsNearLocation:appDelegate.currentLocation];
}

- (IBAction)dropButtonPress:(id)sender {
    NSLog(@"DROP PRESS");
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(![CLLocationManager locationServicesEnabled]) {
        NSLog(@"UHH");
        [turnOnLocationServicesAlert show];
    }
    else {
        NSLog(@"OK FROM HERE");
        PFGeoPoint *droppedGemLocation = [PFGeoPoint geoPointWithLocation:appDelegate.currentLocation];
        self.firstGemInInventory[ParseLocationKey] = droppedGemLocation;
        self.firstGemInInventory[ParseLastOwnerKey] = [PFUser currentUser].username;
        self.firstGemInInventory[ParseDroppedKey] = [NSNumber numberWithBool:YES];
        NSLog(@"%@", self.firstGemInInventory);
        [self.firstGemInInventory saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(@"WHAT");
            if (error) {
                NSLog(@"Couldn't save");
                NSLog(@"%@", error);
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[[error userInfo] objectForKey:@"error"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alertView show];
                return;
            }
            if (succeeded) {
                NSLog(@"Successfully saved");
                NSLog(@"%@", self.firstGemInInventory);
                [[PFUser currentUser] incrementKey:ParseInventoryCountKey byAmount:@-1];
                [[PFUser currentUser] saveInBackground];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:GemDroppedNotification object:nil];
                });
            }
            else {
                NSLog(@"Failed to save.");
            }
        }];
    }
}

- (IBAction)pickupButtonPress:(id)sender {
    if(![CLLocationManager locationServicesEnabled]) {
        [turnOnLocationServicesAlert show];
    }
    else {
        self.closestGem[ParseLocationKey] = [NSNull null];
        self.closestGem[ParseDroppedKey] = [NSNumber numberWithBool:NO];
        self.closestGem[ParseLastOwnerKey] = [PFUser currentUser].username;
        [self.closestGem saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if(error) {
                NSLog(@"error saving");
            }
            if(succeeded) {
                self.closestGem = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:GemPickedUpNotification object:nil];
                });
            }
            else {
                NSLog(@"error saving");
            }
        }];
    }
}

- (void)queryForAllPostsNearLocation:(CLLocation *)currentLocation {
    NSLog(@"QUERYING");
	PFQuery *query = [PFQuery queryWithClassName:ParseGemName];
    
	if (currentLocation == nil) {
		NSLog(@"current location got a nil location!");
        return;
	}
    
	if ([self.gemsArray count] == 0) {
		query.cachePolicy = kPFCachePolicyCacheThenNetwork;
	}
    
	// Query for posts  near current location.
	PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
	[query whereKey:ParseLocationKey nearGeoPoint:point withinKilometers:MaximumSearchDistance];
	query.limit = ParseGemQueryLimit;
    
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (error) {
            NSLog(@"%@", error);
		}
        else {
            NSLog(@"GOT SOMETHING");
            NSLog(@"%d",[objects count]);
			NSMutableArray *gemsToAdd = [[NSMutableArray alloc] initWithCapacity:ParseGemQueryLimit];
            NSMutableArray *gemsToRemove = [[NSMutableArray alloc] initWithCapacity:ParseGemQueryLimit];
			NSMutableArray *queriedGems = [[NSMutableArray alloc] initWithCapacity:ParseGemQueryLimit];
            BOOL gemIsNew = FALSE;
            BOOL gemIsOld = FALSE;
            
            if([objects count] == 0) {
                NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.mapView annotations]];
                [self.mapView removeAnnotations:pins];
                [self.mapView setShowsUserLocation:YES];
            }
            
			for (PFObject *object in objects) {
				Gem *newGem = [[Gem alloc] initWithPFObject:object];
				[queriedGems addObject:newGem];
                CLLocation *gemLoc = [[CLLocation alloc] initWithLatitude:newGem.coordinate.latitude longitude:newGem.coordinate.longitude];
                CLLocationDistance distance = [currentLocation distanceFromLocation:gemLoc];
                NSLog(@"%@", self.closestGem);
                if(!self.closestGem || (distance < closestDistance && [[PFUser currentUser].username isEqualToString:[newGem.object objectForKey:ParseLastOwnerKey]])) {
                    self.closestGem = newGem.object;
                    closestDistance = distance;
                }
                gemIsNew = TRUE;
				for (Gem *oldGem in self.gemsArray) {
					if ([newGem equalToGem:oldGem]) {
                        gemIsNew = FALSE;
                    }
                    
				}
                if(gemIsNew) {
                    [gemsToAdd addObject:newGem];
                }
			}

			for (Gem *oldGem in self.gemsArray) {
                gemIsOld = TRUE;
				for (Gem *queriedGem in queriedGems) {
					if ([oldGem equalToGem:queriedGem]) {
                        gemIsOld = FALSE;
					}
				}
                if(gemIsOld) {
                    [gemsToRemove addObject:oldGem];
                }
			}
            NSLog(@"%@\t\tGemstoremove", gemsToRemove);
            NSLog(@"%@\t\tGemstoAdd", gemsToAdd);
			[self.mapView removeAnnotations:gemsToRemove];
            [self.gemsArray removeObjectsInArray:gemsToRemove];
            NSLog(@"DUMB ANNOTES REMOVED");
			[self.mapView addAnnotations:gemsToAdd];
			[self.gemsArray addObjectsFromArray:gemsToAdd];
            NSLog(@"GOOD ANNOTES ADDED");
            [self grabNextGemToDrop];
            
        }
	}];
}


- (void) grabNextGemToDrop {
    NSLog(@"GETTING GEM TO DROP");
    if(!self.firstGemInInventory && [[PFUser currentUser] objectForKey:ParseInventoryCountKey] > 0) {
        PFQuery *query = [PFQuery queryWithClassName:ParseGemName];
        [query whereKey:ParseLastOwnerKey equalTo:[PFUser currentUser].username];
        [query whereKey:ParseDroppedKey equalTo:[NSNumber numberWithBool:NO]];
        query.limit = 1;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error) {
                NSLog(@"GOT IT");
                NSLog(@"%@", objects);
                self.firstGemInInventory = [objects lastObject];
                NSLog(@"%@", self.firstGemInInventory);
                if(self.firstGemInInventory != nil) {
                    self.dropButton.enabled = YES;
                }
            }
        }];
    }
}
@end
