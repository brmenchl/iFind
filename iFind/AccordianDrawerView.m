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
    UILabel *dropLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, generalDrawer.frame.size.width, 70)];
    dropLocationLabel.textAlignment = NSTextAlignmentLeft;
    dropLocationLabel.font = [UIFont fontWithName:@"Futura" size:20];
    dropLocationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    dropLocationLabel.numberOfLines = 2;
    PFGeoPoint *dropGeoPoint = info[ParseMetaDropLocationKey];
    CLLocation *dropLoc = [[CLLocation alloc] initWithLatitude:dropGeoPoint.latitude longitude:dropGeoPoint.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:dropLoc completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSString * city = [placemark locality]; // city
            NSString * state = [placemark administrativeArea]; // country
            dropLocationLabel.text = [NSString stringWithFormat:@"  Found in:\n  %@, %@", city, state];
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
        SoundcloudPaneView *contentContainer = [[SoundcloudPaneView alloc] initWithSoundcloudID:(NSNumber*)self.content frame:CGRectMake(0, 70, self.frame.size.width, 240)];
        [self addSubview:contentContainer];
    }
}

@end
