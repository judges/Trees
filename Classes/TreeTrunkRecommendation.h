//
//  TreeTrunkRecommendation.h
//  Trees
//
//  Created by Evan on 1/4/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "TreeOption.h"

@class TreeTrunk;

@interface TreeTrunkRecommendation :  TreeOption  
{
}

@property (nonatomic, retain) NSSet* trunk;

@end


@interface TreeTrunkRecommendation (CoreDataGeneratedAccessors)
- (void)addTrunkObject:(TreeTrunk *)value;
- (void)removeTrunkObject:(TreeTrunk *)value;
- (void)addTrunk:(NSSet *)value;
- (void)removeTrunk:(NSSet *)value;

@end

