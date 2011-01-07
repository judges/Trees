//
//  TreeRootFlareRecommendation.h
//  Trees
//
//  Created by Evan on 1/6/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "TreeOption.h"

@class TreeRootFlare;

@interface TreeRootFlareRecommendation :  TreeOption  
{
}

@property (nonatomic, retain) NSSet* rootflare;

@end


@interface TreeRootFlareRecommendation (CoreDataGeneratedAccessors)
- (void)addRootflareObject:(TreeRootFlare *)value;
- (void)removeRootflareObject:(TreeRootFlare *)value;
- (void)addRootflare:(NSSet *)value;
- (void)removeRootflare:(NSSet *)value;

@end

