//
//  TreeOverallCondition.h
//  Trees
//
//  Created by Evan on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "TreeOption.h"

@class TreeOverall;

@interface TreeOverallCondition :  TreeOption  
{
}

@property (nonatomic, retain) NSSet* overall;

@end


@interface TreeOverallCondition (CoreDataGeneratedAccessors)
- (void)addOverallObject:(TreeOverall *)value;
- (void)removeOverallObject:(TreeOverall *)value;
- (void)addOverall:(NSSet *)value;
- (void)removeOverall:(NSSet *)value;

@end

