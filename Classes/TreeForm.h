//
//  TreeForm.h
//  landscapes
//
//  Created by Evan Cordell on 8/16/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Photo.h"

@class AssessmentTree;
@class TreeFormCondition;
@class TreeFormRecommendation;

@interface TreeForm :  Photo  
{
}

@property (nonatomic, retain) TreeFormCondition * condition;
@property (nonatomic, retain) TreeFormRecommendation * recommendation;
@property (nonatomic, retain) AssessmentTree * tree;

@end



