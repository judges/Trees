//
//  TreeCrownCondition.h
//  Trees
//
//  Created by Evan on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "TreeOption.h"

@class TreeCrown;

@interface TreeCrownCondition :  TreeOption  
{
}

@property (nonatomic, retain) NSSet* crown;

@end


@interface TreeCrownCondition (CoreDataGeneratedAccessors)
- (void)addCrownObject:(TreeCrown *)value;
- (void)removeCrownObject:(TreeCrown *)value;
- (void)addCrown:(NSSet *)value;
- (void)removeCrown:(NSSet *)value;

@end

