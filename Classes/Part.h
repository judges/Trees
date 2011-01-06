//
//  Part.h
//  Trees
//
//  Created by Evan on 1/6/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Photo.h"

@class PartRecommendation;

@interface Part :  Photo  
{
}

@property (nonatomic, retain) NSSet* condition;
@property (nonatomic, retain) NSSet* recommendation;

@end


@interface Part (CoreDataGeneratedAccessors)
- (void)addConditionObject:(NSManagedObject *)value;
- (void)removeConditionObject:(NSManagedObject *)value;
- (void)addCondition:(NSSet *)value;
- (void)removeCondition:(NSSet *)value;

- (void)addRecommendationObject:(PartRecommendation *)value;
- (void)removeRecommendationObject:(PartRecommendation *)value;
- (void)addRecommendation:(NSSet *)value;
- (void)removeRecommendation:(NSSet *)value;

@end
