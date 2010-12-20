//
//  TreeOverall.h
//  landscapes
//
//  Created by Evan Cordell on 8/16/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Photo.h"

@class AssessmentTree;
@class TreeOverallCondition;
@class TreeOverallRecommendation;

@interface TreeOverall :  Photo  
{
}

@property (nonatomic, retain) TreeOverallCondition * condition;
@property (nonatomic, retain) TreeOverallRecommendation * recommendation;
@property (nonatomic, retain) AssessmentTree * tree;

@end



