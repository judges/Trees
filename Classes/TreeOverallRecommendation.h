//
//  TreeOverallRecommendation.h
//  landscapes
//
//  Created by Evan Cordell on 8/16/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>

@class TreeOverall;

@interface TreeOverallRecommendation :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* overall;

@end


@interface TreeOverallRecommendation (CoreDataGeneratedAccessors)
- (void)addOverallObject:(TreeOverall *)value;
- (void)removeOverallObject:(TreeOverall *)value;
- (void)addOverall:(NSSet *)value;
- (void)removeOverall:(NSSet *)value;

@end

