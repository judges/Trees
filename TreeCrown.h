//
//  TreeCrown.h
//  Trees
//
//  Created by Evan on 1/6/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Photo.h"

@class AssessmentTree;
@class TreeCrownCondition;
@class TreeCrownRecommendation;

@interface TreeCrown :  Photo  
{
}

@property (nonatomic, retain) NSSet* condition;
@property (nonatomic, retain) AssessmentTree * tree;
@property (nonatomic, retain) NSSet* recommendation;

@end


@interface TreeCrown (CoreDataGeneratedAccessors)
- (void)addConditionObject:(TreeCrownCondition *)value;
- (void)removeConditionObject:(TreeCrownCondition *)value;
- (void)addCondition:(NSSet *)value;
- (void)removeCondition:(NSSet *)value;

- (void)addRecommendationObject:(TreeCrownRecommendation *)value;
- (void)removeRecommendationObject:(TreeCrownRecommendation *)value;
- (void)addRecommendation:(NSSet *)value;
- (void)removeRecommendation:(NSSet *)value;

@end

