//
//  TreeOverall.h
//  Trees
//
//  Created by Evan on 1/6/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Photo.h"

@class AssessmentTree;
@class TreeOverallCondition;
@class TreeOverallRecommendation;

@interface TreeOverall :  Photo  
{
}

@property (nonatomic, retain) NSSet* condition;
@property (nonatomic, retain) AssessmentTree * tree;
@property (nonatomic, retain) NSSet* recommendation;

@end


@interface TreeOverall (CoreDataGeneratedAccessors)
- (void)addConditionObject:(TreeOverallCondition *)value;
- (void)removeConditionObject:(TreeOverallCondition *)value;
- (void)addCondition:(NSSet *)value;
- (void)removeCondition:(NSSet *)value;

- (void)addRecommendationObject:(TreeOverallRecommendation *)value;
- (void)removeRecommendationObject:(TreeOverallRecommendation *)value;
- (void)addRecommendation:(NSSet *)value;
- (void)removeRecommendation:(NSSet *)value;

@end

