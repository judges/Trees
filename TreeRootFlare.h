//
//  TreeRootFlare.h
//  Trees
//
//  Created by Evan on 1/6/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Photo.h"

@class AssessmentTree;
@class TreeRootFlareCondition;
@class TreeRootFlareRecommendation;

@interface TreeRootFlare :  Photo  
{
}

@property (nonatomic, retain) NSSet* condition;
@property (nonatomic, retain) NSSet* recommendation;
@property (nonatomic, retain) AssessmentTree * tree;

@end


@interface TreeRootFlare (CoreDataGeneratedAccessors)
- (void)addConditionObject:(TreeRootFlareCondition *)value;
- (void)removeConditionObject:(TreeRootFlareCondition *)value;
- (void)addCondition:(NSSet *)value;
- (void)removeCondition:(NSSet *)value;

- (void)addRecommendationObject:(TreeRootFlareRecommendation *)value;
- (void)removeRecommendationObject:(TreeRootFlareRecommendation *)value;
- (void)addRecommendation:(NSSet *)value;
- (void)removeRecommendation:(NSSet *)value;

@end

