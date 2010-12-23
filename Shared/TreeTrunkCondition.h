//
//  TreeTrunkCondition.h
//  Trees
//
//  Created by Evan on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "TreeOption.h"

@class TreeTrunk;

@interface TreeTrunkCondition :  TreeOption  
{
}

@property (nonatomic, retain) NSSet* trunk;

@end


@interface TreeTrunkCondition (CoreDataGeneratedAccessors)
- (void)addTrunkObject:(TreeTrunk *)value;
- (void)removeTrunkObject:(TreeTrunk *)value;
- (void)addTrunk:(NSSet *)value;
- (void)removeTrunk:(NSSet *)value;

@end

