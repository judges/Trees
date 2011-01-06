//
//  TreePart.h
//  Trees
//
//  Created by Evan on 1/6/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Part.h"

@class AssessmentTree;

@interface TreePart :  Part  
{
}

@property (nonatomic, retain) AssessmentTree * assessmentTree;

@end



