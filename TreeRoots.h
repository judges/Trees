//
//  TreeRoots.h
//  Trees
//
//  Created by Evan on 1/6/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Photo.h"

@class AssessmentTree;
@class TreeRootsCondition;
@class TreeRootsRecommendation;

@interface TreeRoots :  Photo  
{
}

@property (nonatomic, retain) NSSet* condition;
@property (nonatomic, retain) AssessmentTree * tree;
@property (nonatomic, retain) NSSet* recommendation;

@end


@interface TreeRoots (CoreDataGeneratedAccessors)
- (void)addConditionObject:(TreeRootsCondition *)value;
- (void)removeConditionObject:(TreeRootsCondition *)value;
- (void)addCondition:(NSSet *)value;
- (void)removeCondition:(NSSet *)value;

- (void)addRecommendationObject:(TreeRootsRecommendation *)value;
- (void)removeRecommendationObject:(TreeRootsRecommendation *)value;
- (void)addRecommendation:(NSSet *)value;
- (void)removeRecommendation:(NSSet *)value;

@end

