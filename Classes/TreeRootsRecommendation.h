//
//  TreeRootsRecommendation.h
//  Trees
//
//  Created by Evan on 1/4/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "TreeOption.h"

@class TreeRoots;

@interface TreeRootsRecommendation :  TreeOption  
{
}

@property (nonatomic, retain) NSSet* roots;

@end


@interface TreeRootsRecommendation (CoreDataGeneratedAccessors)
- (void)addRootsObject:(TreeRoots *)value;
- (void)removeRootsObject:(TreeRoots *)value;
- (void)addRoots:(NSSet *)value;
- (void)removeRoots:(NSSet *)value;

@end

