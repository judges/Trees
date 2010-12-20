//
//  Landscape.h
//  landscapes
//
//  Created by Evan Cordell on 8/16/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Photo.h"

@class Assessment;

@interface Landscape :  Photo  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSSet* assessments;

@end


@interface Landscape (CoreDataGeneratedAccessors)
- (void)addAssessmentsObject:(Assessment *)value;
- (void)removeAssessmentsObject:(Assessment *)value;
- (void)addAssessments:(NSSet *)value;
- (void)removeAssessments:(NSSet *)value;

@end

