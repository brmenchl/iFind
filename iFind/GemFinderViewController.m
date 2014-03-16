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
    NSArray *locations;
    CLLocationDistance closestDistance;
}
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *gemsArray;
@property (nonatomic, weak) PFObject * firstGemInInventory;
@property (nonatomic, weak) PFObject * closestGem;

@end

@implementation GemFinderViewController

- (void)viewDidLoad {
    if(turnOnLocationServicesAlert == nil) {
        turnOnLocationServicesAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Please turn on your location services" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    }
    
    [super viewDidLoad];
    [self startUpdating];
}

- (void)viewWillAppear:(BOOL)animated {
	[self.locationManager startUpdatingLocation];
	[super viewWillAppear:animated];
    self.dropButton.enabled = self.firstGemInInventory;
    self.pickupButton.enabled = closestDistance < PickUpDistance;
}

- (void)viewDidDisappear:(BOOL)animated {
	[self.locationManager stopUpdatingLocation];
	[super viewDidDisappear:animated];
}

- (void) startUpdating {
    if(self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    [self.locationManager startUpdatingLocation];
}

- (IBAction)dropButtonPress:(id)sender {
    if(![CLLocationManager locationServicesEnabled]) {
        [turnOnLocationServicesAlert show];
    }
    else {
        [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
            if (!error) {
                self.firstGemInInventory[ParseLocationKey] = geoPoint;
                self.firstGemInInventory[ParseLastOwnerKey] = [PFUser currentUser].username;
                self.firstGemInInventory[ParseDroppedKey] = [NSNumber numberWithBool:YES];
                [self.firstGemInInventory saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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
                        self.dropButton.enabled = NO;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:GemDroppedNotification object:nil];
                        });
                    }
                    else {
                        NSLog(@"Failed to save.");
                    }
                }];
            }
            else {
                NSLog(@"HOUSTON");
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
			NSLog(@"error in geo query");
		}
        else {
			NSMutableArray *gemsToAdd = [[NSMutableArray alloc] initWithCapacity:ParseGemQueryLimit];
            NSMutableArray *gemsToRemove = [[NSMutableArray alloc] initWithCapacity:ParseGemQueryLimit];
			NSMutableArray *queriedGems = [[NSMutableArray alloc] initWithCapacity:ParseGemQueryLimit];

            
			for (PFObject *object in objects) {
				Gem *newGem = [[Gem alloc] initWithPFObject:object];
				[queriedGems addObject:newGem];
                CLLocation *gemLoc = [[CLLocation alloc] initWithLatitude:newGem.coordinate.latitude longitude:newGem.coordinate.longitude];
                CLLocationDistance distance = [currentLocation distanceFromLocation:gemLoc];
                if(!self.closestGem || (distance < closestDistance && [[PFUser currentUser].username isEqualToString:[newGem.object objectForKey:ParseLastOwnerKey]])) {
                    self.closestGem = newGem.object;
                    closestDistance = distance;
                }
				for (Gem *oldGem in self.gemsArray) {
					if (![newGem equalToGem:oldGem]) {
                        [gemsToAdd addObject:newGem];
                    }
				}
			}

			for (Gem *oldGem in self.gemsArray) {
				for (Gem *queriedGem in queriedGems) {
					if (![oldGem equalToGem:queriedGem]) {
                        [gemsToRemove addObject:oldGem];
					}
				}
			}

			[self.mapView removeAnnotations:gemsToRemove];
            [self.gemsArray removeObjectsInArray:gemsToRemove];
			[self.mapView addAnnotations:gemsToAdd];
			[self.gemsArray addObjectsFromArray:gemsToAdd];
            [self grabNextGemToDrop];
            
        }
	}];
}
- (void) grabNextGemToDrop {
    if(!self.firstGemInInventory && [[PFUser currentUser] objectForKey:ParseInventoryCountKey] > 0) {
        PFQuery *query = [PFQuery queryWithClassName:ParseGemName];
        [query whereKey:ParseLastOwnerKey equalTo:[PFUser currentUser].username];
        query.limit = 1;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error) {
                self.firstGemInInventory = [objects lastObject];
                if(self.firstGemInInventory) {
                    self.dropButton.enabled = YES;
                }
            }
        }];
    }
}
@end
