//
//  PartCondition.h
//  Trees
//
//  Created by Evan on 1/6/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "PartOption.h"

@class Part;
@class PartType;

@interface PartCondition :  PartOption  
{
}

@property (nonatomic, retain) NSSet* part;
@property (nonatomic, retain) PartType * partType;

@end


@interface PartCondition (CoreDataGeneratedAccessors)
- (void)addPartObject:(Part *)value;
- (void)removePartObject:(Part *)value;
- (void)addPart:(NSSet *)value;
- (void)removePart:(NSSet *)value;

@end

