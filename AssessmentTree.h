//
//  AssessmentTree.h
//  Trees
//
//  Created by Evan on 1/6/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Assessment.h"

@class Caliper;
@class Height;
@class TreeCrown;
@class TreeForm;
@class TreeOverall;
@class TreeRootFlare;
@class TreeRoots;
@class TreeTrunk;

@interface AssessmentTree :  Assessment  
{
}

@property (nonatomic, retain) Height * height;
@property (nonatomic, retain) TreeForm * form;
@property (nonatomic, retain) TreeRootFlare * rootflare;
@property (nonatomic, retain) TreeRoots * roots;
@property (nonatomic, retain) TreeTrunk * trunk;
@property (nonatomic, retain) Caliper * caliper;
@property (nonatomic, retain) TreeOverall * overall;
@property (nonatomic, retain) TreeCrown * crown;

@end



