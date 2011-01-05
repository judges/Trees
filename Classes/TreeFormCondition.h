//
//  TreeFormCondition.h
//  Trees
//
//  Created by Evan on 1/4/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "TreeOption.h"

@class TreeForm;

@interface TreeFormCondition :  TreeOption  
{
}

@property (nonatomic, retain) NSSet* form;

@end


@interface TreeFormCondition (CoreDataGeneratedAccessors)
- (void)addFormObject:(TreeForm *)value;
- (void)removeFormObject:(TreeForm *)value;
- (void)addForm:(NSSet *)value;
- (void)removeForm:(NSSet *)value;

@end

