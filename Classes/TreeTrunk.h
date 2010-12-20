//
//  TreeTrunk.h
//  landscapes
//
//  Created by Evan Cordell on 8/16/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Photo.h"

@class AssessmentTree;
@class TreeTrunkCondition;
@class TreeTrunkRecommendation;

@interface TreeTrunk :  Photo  
{
}

@property (nonatomic, retain) TreeTrunkCondition * condition;
@property (nonatomic, retain) TreeTrunkRecommendation * recommendation;
@property (nonatomic, retain) AssessmentTree * tree;

@end



