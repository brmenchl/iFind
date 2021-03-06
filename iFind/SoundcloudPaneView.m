//
//  SoundcloudPaneView.m
//  iFind
//
//  Created by Bradley Menchl on 4/14/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "SoundcloudPaneView.h"
@interface SoundcloudPaneView()
@property (nonatomic) UIImageView *artwork;
@property (nonatomic) UILabel *trackTitleLabel;
@property (nonatomic) UILabel *trackArtistLabel;
@property (nonatomic) UIActivityIndicatorView *spinner;
@property (nonatomic) UIButton *playButton;
@property (nonatomic) NSNumber *ID;
@property (nonatomic) NSString *permalink;
@end

@implementation SoundcloudPaneView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (id) initWithSoundcloudID:(NSNumber *)ID frame:(CGRect)frame {
    self = [self initWithFrame:frame];
    if (self) {
        self.ID = ID;
        
        self.artwork = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"music_beamed_note.png"]];
        self.artwork.contentMode = UIViewContentModeScaleAspectFill;
        self.artwork.frame = CGRectMake(10, 65, 160, 160);
        [self addSubview:self.artwork];
        
        NSLog(@"curious: %f",self.frame.size.width);
        self.trackTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 30)];
        self.trackTitleLabel.textAlignment = NSTextAlignmentLeft;
        self.trackTitleLabel.font = [UIFont fontWithName:@"Futura" size:15];
        self.trackTitleLabel.text = @"Loading Title...";
        [self addSubview:self.trackTitleLabel];
        
        self.trackArtistLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, self.frame.size.width-40, 30)];
        self.trackArtistLabel.textAlignment = NSTextAlignmentLeft;
        self.trackArtistLabel.font = [UIFont fontWithName:@"Futura" size:12];
        self.trackArtistLabel.text = @"Loading Artist...";
        [self addSubview:self.trackArtistLabel];
        
        self.spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.frame.size.width-45, 5, 35, 35)];
        self.spinner.hidesWhenStopped = YES;
        [self addSubview:self.spinner];
        
        self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 110, 85, 80, 40)];
        [self.playButton.titleLabel setFont:[UIFont fontWithName:@"Futura" size:14]];
        self.playButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.playButton.titleLabel.numberOfLines = 2;
        self.playButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [self.playButton addTarget:self action:@selector(playButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.playButton setTitle:@"Open Song" forState:UIControlStateNormal];
        self.playButton.backgroundColor = [UIColor grayColor];
        self.playButton.layer.cornerRadius = 8;
        self.playButton.layer.masksToBounds = YES;
        self.playButton.hidden = YES;
        [self addSubview:self.playButton];
        
        [self.spinner startAnimating];
        NSURL *trackURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.soundcloud.com/tracks/%@.json?client_id=17bb2cf97cb0c0db9c8e6e5bd4523979", ID]];
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:trackURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            if (httpResponse.statusCode == 200){
                NSError *e = nil;
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&e];
                [self.trackTitleLabel setText:[dictionary objectForKey:@"title"]];
                [self.trackArtistLabel setText:[[dictionary objectForKey:@"user"] objectForKey:@"username"]];
                self.permalink = [[dictionary objectForKey:@"permalink_url"] copy];
                self.playButton.hidden = NO;
                    if([dictionary objectForKey:@"artwork_url"] != [NSNull null]) {
                        [self.artwork setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dictionary objectForKey:@"artwork_url"]]]]];
                    }
                    else if([[dictionary objectForKey:@"user"] objectForKey:@"avatar_url"] != [NSNull null]) {
                        [self.artwork setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[dictionary objectForKey:@"user"] objectForKey:@"avatar_url"]]]]];
                    }
                [self.spinner stopAnimating];
                
            }
        }];
        [task resume];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //self.artwork.frame = CGRectMake(10, 0, 60, 60);
    //self.trackTitleLabel.frame = CGRectMake(80, 0, 100, 30);
    //self.trackArtistLabel.frame = CGRectMake(80, 30, 100, 30);
}

- (void) playButtonPress:(UIButton*)sender {
    NSString *soundcloudCustomURL = [NSString stringWithFormat:@"soundcloud://tracks:%@",self.ID];
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:soundcloudCustomURL]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:soundcloudCustomURL]];
    }
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.permalink]];
    }
}

@end
