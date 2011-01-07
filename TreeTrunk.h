//
//  TreeTrunk.h
//  Trees
//
//  Created by Evan on 1/6/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Photo.h"

@class AssessmentTree;
@class TreeTrunkCondition;
@class TreeTrunkRecommendation;

@interface TreeTrunk :  Photo  
{
}

@property (nonatomic, retain) NSSet* condition;
@property (nonatomic, retain) AssessmentTree * tree;
@property (nonatomic, retain) NSSet* recommendation;

@end


@interface TreeTrunk (CoreDataGeneratedAccessors)
- (void)addConditionObject:(TreeTrunkCondition *)value;
- (void)removeConditionObject:(TreeTrunkCondition *)value;
- (void)addCondition:(NSSet *)value;
- (void)removeCondition:(NSSet *)value;

- (void)addRecommendationObject:(TreeTrunkRecommendation *)value;
- (void)removeRecommendationObject:(TreeTrunkRecommendation *)value;
- (void)addRecommendation:(NSSet *)value;
- (void)removeRecommendation:(NSSet *)value;

@end

