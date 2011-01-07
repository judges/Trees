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
@class TreePart;

@interface AssessmentTree :  Assessment  
{
}

@property (nonatomic, retain) Height * height;
@property (nonatomic, retain) TreePart * crown;
@property (nonatomic, retain) TreePart * rootflare;
@property (nonatomic, retain) TreePart * roots;
@property (nonatomic, retain) TreePart * trunk;
@property (nonatomic, retain) Caliper * caliper;
@property (nonatomic, retain) TreePart * overall;
@property (nonatomic, retain) TreePart * form;

@end



