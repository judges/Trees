//
//  PhotoSet.h
//  landscapes
//
//  Created by Evan Cordell on 8/9/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

@interface PhotoSet : TTURLRequestModel <TTPhotoSource> {
    NSString *_title;
    NSMutableArray *_photos;
    NSMutableArray *_ids;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) NSMutableArray *photos;
@property (nonatomic, retain) NSMutableArray *ids;
- (id) initWithTitle:(NSString *)title photos:(NSMutableArray *)photos ids:(NSMutableArray *)ids captions:(NSMutableArray *)captions;
- (void)deletePhotoAtIndex:(NSInteger)index;
@end
