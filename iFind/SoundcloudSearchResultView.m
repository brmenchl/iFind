//
//  SoundcloudSearchResultView.m
//  iFind
//
//  Created by Bradley Menchl on 4/14/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "SoundcloudSearchResultView.h"
@interface SoundcloudSearchResultView()
@property (nonatomic) UILabel *trackTitle;
@property (nonatomic) UILabel *trackArtist;
@property (nonatomic) UIButton *playButton;
@property (nonatomic) NSString *artURI;
@property (nonatomic) NSNumber *ID;
@property (nonatomic) NSString *permalink;
@end

@implementation SoundcloudSearchResultView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.trackTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height/2)];
        [self addSubview:self.trackTitle];
        
        self.trackArtist = [[UILabel alloc] initWithFrame:CGRectMake(0,self.bounds.size.height/2, self.bounds.size.width, self.bounds.size.height/2)];
        [self addSubview:self.trackArtist];
        
        self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - 35, 0, 30, 30) ];
        [self.playButton setTitle:@"Open track" forState:UIControlStateNormal];
        [self.playButton addTarget:self action:@selector(didPressPlayButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.playButton];
        
        UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectResult:)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

- (id) initWithDictionary:(NSDictionary*)dictionary frame:(CGRect)frame {
    self = [self initWithFrame:frame];
    if (self) {
        NSLog(@"initWithDict %@",dictionary);
        NSLog(@"%@",(NSNumber*)dictionary[@"id"]);
        [self.trackTitle setText: dictionary[@"title"]];
        [self.trackArtist setText: [dictionary[@"user"] objectForKey:@"username"]];
        if(dictionary[@"artwork_url"] != [NSNull null]) {
            self.artURI = dictionary[@"artwork_url"];
        }
        else if([dictionary[@"user"]objectForKey:@"avatar_url"] != [NSNull null]) {
            self.artURI = [dictionary[@"user"] objectForKey:@"avatar_url"];
        }
        self.ID = dictionary[@"id"];
        self.permalink = dictionary[@"permalink_url"];
    }
    return self;
}

- (void) didPressPlayButton:(UIButton *)sender {
    NSString *soundcloudCustomURL = [NSString stringWithFormat:@"soundcloud://tracks:%@",self.ID];
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:soundcloudCustomURL]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:soundcloudCustomURL]];
    }
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.permalink]];
    }
}

- (void)didSelectResult:(id)sender {
    NSLog(@"recognized tap");
    [self.delegate selectTrackWithDictionary:@{@"ID": self.ID, @"title": self.trackTitle.text, @"artURI": self.artURI}];
}

@end
