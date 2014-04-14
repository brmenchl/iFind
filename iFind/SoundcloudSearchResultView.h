//
//  SoundcloudSearchResultView.h
//  iFind
//
//  Created by Bradley Menchl on 4/14/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SoundcloudSearchResultView;

@protocol SoundcloudSearchResultViewDelegate <NSObject>
-(void)selectTrackWithDictionary:(NSDictionary *)dictionary;
@end


@interface SoundcloudSearchResultView : UIView
- (id) initWithDictionary:(NSDictionary*)dictionary frame:(CGRect)frame;
 
 @property (nonatomic, assign) id <SoundcloudSearchResultViewDelegate> delegate;
@end
