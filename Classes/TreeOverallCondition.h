//
//  TreeOverallCondition.h
//  Trees
//
//  Created by Evan on 1/4/11.
//  Copyright 2011 NCPTT. All rights reserved.
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

