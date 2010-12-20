//
//  TreeRoots.h
//  landscapes
//
//  Created by Evan Cordell on 8/16/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Photo.h"

@class AssessmentTree;
@class TreeRootsCondition;
@class TreeRootsRecommendation;

@interface TreeRoots :  Photo  
{
}

@property (nonatomic, retain) TreeRootsCondition * condition;
@property (nonatomic, retain) TreeRootsRecommendation * recommendation;
@property (nonatomic, retain) AssessmentTree * tree;

@end



