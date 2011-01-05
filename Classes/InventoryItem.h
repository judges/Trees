//
//  InventoryItem.h
//  Trees
//
//  Created by Evan on 1/4/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Photo.h"

@class Assessment;
@class InventoryType;
@class Landscape;

@interface InventoryItem :  Photo  
{
}

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) Landscape * landscape;
@property (nonatomic, retain) InventoryType * type;
@property (nonatomic, retain) NSSet* assessments;

@end


@interface InventoryItem (CoreDataGeneratedAccessors)
- (void)addAssessmentsObject:(Assessment *)value;
- (void)removeAssessmentsObject:(Assessment *)value;
- (void)addAssessments:(NSSet *)value;
- (void)removeAssessments:(NSSet *)value;

@end
