//
//  TreeForm.h
//  Trees
//
//  Created by Evan on 1/4/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Photo.h"

@class AssessmentTree;
@class TreeFormCondition;
@class TreeFormRecommendation;

@interface TreeForm :  Photo  
{
}

@property (nonatomic, retain) NSSet* condition;
@property (nonatomic, retain) NSSet* recommendation;
@property (nonatomic, retain) AssessmentTree * tree;

@end


@interface TreeForm (CoreDataGeneratedAccessors)
- (void)addConditionObject:(TreeFormCondition *)value;
- (void)removeConditionObject:(TreeFormCondition *)value;
- (void)addCondition:(NSSet *)value;
- (void)removeCondition:(NSSet *)value;

- (void)addRecommendationObject:(TreeFormRecommendation *)value;
- (void)removeRecommendationObject:(TreeFormRecommendation *)value;
- (void)addRecommendation:(NSSet *)value;
- (void)removeRecommendation:(NSSet *)value;

@end

