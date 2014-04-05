//
//  SoundcloudContentView.m
//  iFind
//
//  Created by Andrew Milenius on 3/30/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "SoundcloudContentView.h"

@interface SoundcloudContentView()
    //The content of the SoundcloudContentView, a textview for users to write a message in.
    @property (nonatomic, strong) UITextField *textView;
    //Button image for the SoundcloudContentView
    @property (nonatomic, strong) UIImage *buttonImage;
    @property (nonatomic, strong) UIImageView *albumArt;
    @property (nonatomic, strong) UILabel *songDetails;

@end

@implementation SoundcloudContentView

//initWithFrame, sets up textView and adds it to the view
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        CGRect main = [UIScreen mainScreen].bounds;
        self.textView = [[UITextField alloc] initWithFrame:CGRectMake(60,0,main.size.width-60, 60)];
        self.textView.delegate = self;
        self.textView.placeholder = @"Paste Soundcloud link here...";
        self.textView.backgroundColor = [UIColor colorWithRed:0.68 green:0.71 blue:0.71 alpha:0.3];
        [self.textView addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];

        UIButton * pasteButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 0, (main.size.width-60)*.4, 60)];
        [pasteButton setTitle:@"Clipboard\nPaste" forState:UIControlStateNormal];
        pasteButton.backgroundColor = [UIColor colorWithRed:0.68 green:0.71 blue:0.71 alpha:0.4];
        pasteButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        pasteButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [pasteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(((main.size.width-60)*.4)+61, 0, (main.size.width-60)*.4, 60)];
        [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
        deleteButton.backgroundColor = [UIColor colorWithRed:0.68 green:0.71 blue:0.71 alpha:0.4];
        deleteButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        deleteButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [deleteButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [deleteButton setEnabled:NO];
        
        UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(2*((main.size.width-60)*.4)+62, 0, ((main.size.width-60)*.2)-2, 60)];
        [helpButton setTitle:@"?" forState:UIControlStateNormal];
        helpButton.backgroundColor = [UIColor colorWithRed:0.68 green:0.71 blue:0.71 alpha:0.4];
        helpButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        helpButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [helpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        self.albumArt = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, 60, 60)];
        [self.albumArt setImage:[UIImage imageNamed:@"music_beamed_note.png"]];
        
        self.songDetails = [[UILabel alloc] initWithFrame:CGRectMake(61, 60, main.size.width-61, 60)];
        [self.songDetails setText:@" Select a song or playlist..."];
        self.songDetails.textAlignment = NSTextAlignmentLeft;
        self.songDetails.textColor = [UIColor blackColor];
        
        
        
        
        
        //self.soundCloudIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"soundcloud.png"]];

        UIImageView *soundCloudIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
        [soundCloudIcon setImage:[UIImage imageNamed:@"soundcloud.png"]];
        
        [self addSubview:soundCloudIcon];
        [self addSubview:pasteButton];
        [self addSubview:deleteButton];
        [self addSubview:helpButton];
        [self addSubview:self.albumArt];
        [self addSubview:self.songDetails];
    }
    return self;
}

//Generic init method allowing textcontentview to specify its own dimensions and buttonimage
//This calls initWithFrame.  Only use init method on textcontentview
-(id) init {
    CGRect main = [UIScreen mainScreen].bounds;
    self = [self initWithFrame:CGRectMake(0,0,main.size.width, 120)];
    self.backgroundColor = [UIColor colorWithRed:0.68 green:0.71 blue:0.71 alpha:0.4];
    if(self) {
        self.buttonImage = [UIImage imageNamed:@"soundcloud.png"];
    }
    return self;
}

-(void) textFieldDidChange {
    NSLog(@"%@",self.textView.text);
    
    NSURL *trackURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.soundcloud.com/resolve.json?url=%@&client_id=17bb2cf97cb0c0db9c8e6e5bd4523979", self.textView.text]];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:trackURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        CGRect main = [UIScreen mainScreen].bounds;
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        if (httpResponse.statusCode == 200){
            UIView *previewPane = [[UIView alloc] initWithFrame:CGRectMake(0, 60, main.size.width, 60)];
            NSError *e = nil;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&e];
            
            UIImageView *artwork = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, 60, 60)];
            
//            [artwork setImage:[UIImage imageNamed:@"soundcloud.png"]];
          [artwork setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dictionary objectForKey:@"artwork_url"]]]]];
            
            NSLog(@"%@", [dictionary objectForKey:@"artwork_url"]);
            
//            [previewPane addSubview:artwork];
            
            [self addSubview:artwork];
            
            
            
        }
        
    }];
    
    [task resume];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(id)contentData {
    return self.textView.text;
}

-(void)clearData {
    self.textView.text = @"";
}

@end
