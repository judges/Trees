//
//  TreeFormRecommendation.h
//  Trees
//
//  Created by Evan on 1/6/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "TreeOption.h"

@class TreeForm;

@interface TreeFormRecommendation :  TreeOption  
{
}

@property (nonatomic, retain) NSSet* form;

@end


@interface TreeFormRecommendation (CoreDataGeneratedAccessors)
- (void)addFormObject:(TreeForm *)value;
- (void)removeFormObject:(TreeForm *)value;
- (void)addForm:(NSSet *)value;
- (void)removeForm:(NSSet *)value;

@end

