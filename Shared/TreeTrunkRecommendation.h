//
//  TreeTrunkRecommendation.h
//  Trees
//
//  Created by Evan on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
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

