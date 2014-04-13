//
//  GGCompassViewController.m
//  iFind
//
//  Created by Andrew Milenius on 4/11/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "GGCompassViewController.h"
#import "AppDelegate.h"
#import "ALRadialMenu.h"
#import "UIImage+ImageEffects.h"

#define PI 3.14159265


@interface GGCompassViewController (){
    double rotation;
}
//Private property for locationManager, used to update current location
@property (nonatomic, retain) CLLocation *currentLocation;

//PFObject representing the closest Parse gem object to the player
@property (nonatomic, strong) PFObject * closestGem;
//Private view controller reference for the modal addcontentviewcontroller
@property (nonatomic, strong) GGAddContentViewController *addContentViewController;

//Alertview to notify user that location services are off and we cannot track their location
@property (nonatomic, strong) UIAlertView *turnOnLocationServicesAlert;


@end

@implementation GGCompassViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        rotation = 0;
        self.closestGem = nil;
        self.currentLocation = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Create alertview
    if(!self.turnOnLocationServicesAlert) {
        self.turnOnLocationServicesAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Please turn on your location services" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    }
    
    
    //Initialize addContentViewController in background to speed up having it appear
    self.addContentViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GGAddContentVC"];
    self.addContentViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.addContentViewController.delegate = self;
    
    self.currentLocation = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).currentLocation;
    
    [self queryClosestGem];

    
    [self.compassImage setImage:[UIImage imageNamed:@"big_compass.png"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"didUpdateHeading"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedLocationNotification:)
                                                 name:@"didUpdateLocationNotification"
                                               object:nil];
    self.compassImage.layer.anchorPoint = CGPointMake(.5, .5);
    
    self.view.backgroundColor = [UIColor colorWithRed:0.79 green:0.64 blue:0.02 alpha:1];
    self.distanceView.backgroundColor = [UIColor clearColor];
    self.distanceTitle.textColor = [UIColor colorWithRed:0.61 green:0.2 blue:0.12 alpha:1];
    self.pageTitle.textColor = [UIColor colorWithRed:0.61 green:0.2 blue:0.12 alpha:1];
    self.distanceLabel.textColor = [UIColor colorWithRed:0.61 green:0.2 blue:0.12 alpha:1];
    self.milesLabel.textColor = [UIColor colorWithRed:0.61 green:0.2 blue:0.12 alpha:1];
    
    
    
    [self.dropButton setTitleColor:[UIColor colorWithRed:0.61 green:0.2 blue:0.12 alpha:1] forState:UIControlStateNormal];
    [self.pickUpButton setTitleColor:[UIColor colorWithRed:0.61 green:0.2 blue:0.12 alpha:1] forState:UIControlStateNormal];
    [self.pickUpButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.pickUpButton setEnabled:NO];
    
    
    
    
    
}

- (IBAction)didTapDropButton:(id)sender{
    
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
    UIImage *blurImage = [screenshot applyBlurWithRadius:3 tintColor:[UIColor colorWithWhite:1 alpha:0.4] saturationDeltaFactor:1 maskImage:nil];
    self.addContentViewController.blurImage = blurImage;
    
    //Present AddContentViewController
    [self.view.window.rootViewController presentViewController:self.addContentViewController animated:YES completion:NULL];
    
}

- (void)dropGemWithContent:(NSArray *)content {



}

- (void)queryClosestGem{
    
    if (self.currentLocation == nil) {
		NSLog(@"current location got a nil location!");
        return;
	}
    
    //Create Parse query on gem table
    PFQuery *query = [PFQuery queryWithClassName:ParseGemClassName];
    //Query for posts near current location
	PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:self.currentLocation.coordinate.latitude longitude:self.currentLocation.coordinate.longitude];
	[query whereKey:ParseGemCurrentLocationKey nearGeoPoint:point];
    
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *result, NSError *error) {
    
        if (error){
            
           NSLog(@"%@", [[[error userInfo] objectForKey:@"NSUnderlyingErrorKey"]localizedDescription]);
            
        }
        else{
            
            [result fetchIfNeeded];
            
            self.closestGem = result;
            
            if (self.closestGem){
                PFGeoPoint *geopoint = [self.closestGem objectForKey:ParseGemCurrentLocationKey];
                
                PFGeoPoint *currentLoc = [PFGeoPoint geoPointWithLocation:self.currentLocation];
                
                double distance = [currentLoc distanceInMilesTo:geopoint];
                NSLog(@"distance: %f",distance);
                double temp = distance * 100;
                temp = (double)((int)(temp+0.5));
                distance = temp/100;
                NSLog(@"rounded distance: %f",distance);
                
                self.distanceLabel.text = [NSString stringWithFormat:@"%.2f",distance];
            }
            
            
        }
    
    
    
    }];
    
    
}


- (void)receivedLocationNotification:(NSNotification *) notification {
    
    NSLog(@"wahoo!");
    
    CLLocationManager *manager = (CLLocationManager*)notification.object;
    
    self.currentLocation = manager.location;
    
    PFGeoPoint *geopoint = [self.closestGem objectForKey:ParseGemCurrentLocationKey];
    
    PFGeoPoint *currentLoc = [PFGeoPoint geoPointWithLocation:self.currentLocation];
    
    double distance = [currentLoc distanceInMilesTo:geopoint];
    NSLog(@"distance: %f",distance);
    double temp = distance * 100;
    temp = (double)((int)(temp+0.5));
    distance = temp/100;
    NSLog(@"rounded distance: %f",distance);
    
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f",distance];

}

- (void)receivedNotification:(NSNotification *) notification {
    
    
    if (self.closestGem && self.currentLocation){
        
        PFGeoPoint *geopoint = [self.closestGem objectForKey:ParseGemCurrentLocationKey];
    
        CLLocationManager *manager = (CLLocationManager*)notification.object;
    
        double degrees = manager.heading.trueHeading;
            
        double tan_degrees = 0;
        
        if (degrees != 0 && degrees != 180){
            
            if (degrees < 180){
                tan_degrees = 90 - degrees;
            }
            else{
                tan_degrees = 270 - degrees;
            }
            
            double line_slope = tan(tan_degrees * PI/180);
            
            
            double x_along_heading = 1;
            double y_along_heading = line_slope;
            
            double target_x = geopoint.longitude - self.currentLocation.coordinate.longitude;
            double target_y = geopoint.latitude - self.currentLocation.coordinate.latitude;
            
//            target_y*=-1;
//            target_x*=-1;
            
            //NSLog(@"%f %f",target_x,target_y);
            
//            target_x = 1;
//            target_y = 0;
            
            double arc_cos_val = ((x_along_heading*target_x)+(y_along_heading*target_y))/(sqrt(pow(x_along_heading, 2)+pow(y_along_heading, 2))*sqrt(pow(target_x, 2)+pow(target_y, 2)));
            
            arc_cos_val = acos(arc_cos_val);
            
            double target_angle = -1;
            
            if (target_x > 0){
                if (target_y > 0){
                    target_angle = atan(target_x/target_y) * (180/PI);
                }
                else{
                    target_angle = (atan((-1*target_y)/target_x) * (180/PI)) + 90;
                
                }
            }
            else{
                if (target_y > 0){
                    target_angle = (atan(target_y/(-1*target_x)) * (180/PI)) + 270;
                }
                else{
                    target_angle = (atan((-1*target_x)/(-1*target_y)) * (180/PI)) + 180;
                }
            }
            
            
            
            //NSLog(@"%f %f %f %f",degrees, tan_degrees, line_slope, arc_cos_val);
            
            
            
//            NSLog(@"%f", target_angle);
            
            //GOOD SHIT
            
            rotation = (degrees * (PI/180)) - (target_angle * (PI/180));
            
            if ((degrees > target_angle && degrees < target_angle + 180)){
                rotation*=-1;
            }
            else if (degrees > target_angle+180){
                rotation = PI - arc_cos_val;
            }
            else if (degrees < target_angle){
                rotation*=-1;
            }
            
//            NSString* tempString = [[NSString alloc] initWithFormat:@"%f \n acos: %f \n rotate: %f",degrees, arc_cos_val,rotation];
//            
//            self.distanceTitle.text = tempString;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.0001];
            self.compassImage.layer.affineTransform = CGAffineTransformMakeRotation(rotation);
            [UIView commitAnimations];
        }
        else{
            NSLog(@"what the hell: %@ %@",self.currentLocation,self.closestGem);
        }
    
    }
    else{
        NSLog(@"%@ %@",self.closestGem,self.currentLocation);
    }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
