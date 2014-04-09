//
//  GGAddContentViewDataSource.h
//  iFind
//
//  Created by Bradley Menchl on 4/7/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GGAddContentViewDataSource <NSObject>

// Indicates the number of rows in the table
-(NSInteger)numberOfRows;

// Obtains the cell for the given row
-(UIView *)cellForRow:(NSInteger)row;

-(NSInteger)totalViewHeight;

@end
