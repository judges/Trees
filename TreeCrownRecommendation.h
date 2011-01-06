//
//  TreeCrownRecommendation.h
//  Trees
//
//  Created by Evan on 1/6/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "TreeOption.h"

@class TreeCrown;

@interface TreeCrownRecommendation :  TreeOption  
{
}

@property (nonatomic, retain) NSSet* crown;

@end


@interface TreeCrownRecommendation (CoreDataGeneratedAccessors)
- (void)addCrownObject:(TreeCrown *)value;
- (void)removeCrownObject:(TreeCrown *)value;
- (void)addCrown:(NSSet *)value;
- (void)removeCrown:(NSSet *)value;

@end

