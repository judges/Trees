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

@interface Landscape :  Photo 
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSSet* inventoryItems;


@property (nonatomic, retain) NSString *address1;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *zip;
@property (nonatomic, retain) NSString *gps;

@end


@interface Landscape (CoreDataGeneratedAccessors)
- (void)addAssessmentsObject:(Assessment *)value;
- (void)removeAssessmentsObject:(Assessment *)value;
- (void)addAssessments:(NSSet *)value;
- (void)removeAssessments:(NSSet *)value;

@end

