//
//  AssessmentTree.h
//  landscapes
//
//  Created by Evan Cordell on 8/16/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Assessment.h"

@class TreeCrown;
@class TreeForm;
@class TreeOverall;
@class TreeRootFlare;
@class TreeRoots;
@class TreeTrunk;

@interface AssessmentTree :  Assessment  
{
}

@property (nonatomic, retain) NSDecimalNumber * height;
@property (nonatomic, retain) NSDecimalNumber * caliper;
@property (nonatomic, retain) TreeCrown * crown;
@property (nonatomic, retain) TreeRootFlare * rootflare;
@property (nonatomic, retain) TreeRoots * roots;
@property (nonatomic, retain) TreeTrunk * trunk;
@property (nonatomic, retain) TreeOverall * overall;
@property (nonatomic, retain) TreeForm * form;

@end



