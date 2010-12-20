//
//  Assessment.h
//  landscapes
//
//  Created by Evan Cordell on 8/16/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Photo.h"

@class AssessmentType;
@class Landscape;

@interface Assessment :  Photo  
{
}

@property (nonatomic, retain) NSString * assessor;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) Landscape * landscape;
@property (nonatomic, retain) AssessmentType * type;

@end



