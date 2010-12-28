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

@interface ImageToDataTransformer : NSValueTransformer {
}
@end

@interface Landscape :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSSet* assessments;


@property (nonatomic, retain) NSString *address1;
@property (nonatomic, retain) NSString *gps;
@property (nonatomic, retain) UIImage *thumbnailImage;
@property (nonatomic, retain) NSManagedObject *image;

@end


@interface Landscape (CoreDataGeneratedAccessors)
- (void)addAssessmentsObject:(Assessment *)value;
- (void)removeAssessmentsObject:(Assessment *)value;
- (void)addAssessments:(NSSet *)value;
- (void)removeAssessments:(NSSet *)value;

@end

