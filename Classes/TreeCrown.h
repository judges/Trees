//
//  TreeCrown.h
//  landscapes
//
//  Created by Evan Cordell on 8/16/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Photo.h"

@class AssessmentTree;
@class TreeCrownCondition;
@class TreeCrownRecommendation;

@interface TreeCrown :  Photo  
{
}

@property (nonatomic, retain) TreeCrownCondition * condition;
@property (nonatomic, retain) TreeCrownRecommendation * recommendation;
@property (nonatomic, retain) AssessmentTree * tree;

@end



