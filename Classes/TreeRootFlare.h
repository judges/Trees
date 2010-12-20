//
//  TreeRootFlare.h
//  landscapes
//
//  Created by Evan Cordell on 8/16/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Photo.h"

@class AssessmentTree;
@class TreeRootFlareCondition;
@class TreeRootFlareRecommendation;

@interface TreeRootFlare :  Photo  
{
}

@property (nonatomic, retain) TreeRootFlareCondition * condition;
@property (nonatomic, retain) AssessmentTree * tree;
@property (nonatomic, retain) TreeRootFlareRecommendation * recommendation;

@end



