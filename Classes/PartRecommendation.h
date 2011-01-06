//
//  PartRecommendation.h
//  Trees
//
//  Created by Evan on 1/6/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "PartOption.h"


@interface PartRecommendation :  PartOption  
{
}

@property (nonatomic, retain) NSSet* part;

@end


@interface PartRecommendation (CoreDataGeneratedAccessors)
- (void)addPartObject:(NSManagedObject *)value;
- (void)removePartObject:(NSManagedObject *)value;
- (void)addPart:(NSSet *)value;
- (void)removePart:(NSSet *)value;

@end

