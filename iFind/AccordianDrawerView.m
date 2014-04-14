//
//  AccordianDrawerView.m
//  iFind
//
//  Created by Bradley Menchl on 4/10/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "AccordianDrawerView.h"
#import "SoundcloudPaneView.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AccordianDrawerView()
@property (nonatomic) UILabel *title;
@end

@implementation AccordianDrawerView

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, 40)];
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.font = [UIFont fontWithName:@"Futura" size:24];
    [self addSubview:self.title];
    return self;
}

+ (AccordianDrawerView *) createGeneralInfoDrawer:(PFObject *)info frame:(CGRect)frame {
    AccordianDrawerView *generalDrawer = [[AccordianDrawerView alloc] initWithFrame:frame];
    generalDrawer.title.text = @"Information";
    UILabel *dropLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, generalDrawer.frame.size.height/2, generalDrawer.frame.size.width, 40)];
    dropLocationLabel.textAlignment = NSTextAlignmentCenter;
    dropLocationLabel.font = [UIFont fontWithName:@"Futura" size:20];
    PFGeoPoint *dropGeoPoint = info[ParseMetaDropLocationKey];
    CLLocation *dropLoc = [[CLLocation alloc] initWithLatitude:dropGeoPoint.latitude longitude:dropGeoPoint.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:dropLoc completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSString * city = [placemark locality]; // city
            NSString * country = [placemark country]; // country
            dropLocationLabel.text = [NSString stringWithFormat:@"Found in %@, %@", city, country];
        }
        [generalDrawer addSubview:dropLocationLabel];
    }];
    return generalDrawer;
}

- (void) setContent:(NSObject *)content {
    _content = content;
    if([self.content isKindOfClass:[NSString class]]) {
        self.title.text = @"Message";
        UILabel *contentContainer = [[UILabel alloc] init];
        contentContainer.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
        contentContainer.layer.cornerRadius = 10;
        contentContainer.layer.masksToBounds = YES;
        contentContainer.textAlignment = NSTextAlignmentCenter;
        contentContainer.lineBreakMode = NSLineBreakByWordWrapping;
        contentContainer.numberOfLines = 0;
        contentContainer.text = (NSString *)self.content;
        CGRect frame = CGRectMake(20, self.frame.size.width/2, self.frame.size.width - 40, 0);
        frame.size.height = [contentContainer sizeThatFits:CGSizeMake(self.frame.size.width, FLT_MAX)].height;
        frame = CGRectOffset(frame, 0, -frame.size.height/2);
        contentContainer.frame = frame;
        [self addSubview:contentContainer];
    }
    
    else if([self.content isKindOfClass:[PFFile class]]) {
        self.title.text = @"Photo";
        PFImageView *contentContainer = [[PFImageView alloc] initWithFrame:CGRectMake(0, 50, self.frame.size.width, self.frame.size.height-50)];
        contentContainer.file = (PFFile *)self.content;
        [contentContainer loadInBackground];
        [self addSubview:contentContainer];
    }
    
    else if([self.content isKindOfClass:[NSNumber class]]) {
        self.title.text = @"Soundcloud Track";
        SoundcloudPaneView *contentContainer = [[SoundcloudPaneView alloc] initWithSoundcloudID:(NSNumber*)self.content frame:CGRectMake(0, 50, self.frame.size.width, 60)];
        [self addSubview:contentContainer];
        NSLog(@"pane frame: (%f,%f,%f,%f)",contentContainer.frame.origin.x, contentContainer.frame.origin.y, contentContainer.frame.size.width, contentContainer.frame.size.height);
    }
}

@end
