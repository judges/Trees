//
//  TreeRootFlareCondition.h
//  Trees
//
//  Created by Evan on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "TreeOption.h"

@class TreeRootFlare;

@interface TreeRootFlareCondition :  TreeOption  
{
}

@property (nonatomic, retain) NSSet* rootflare;

@end


@interface TreeRootFlareCondition (CoreDataGeneratedAccessors)
- (void)addRootflareObject:(TreeRootFlare *)value;
- (void)removeRootflareObject:(TreeRootFlare *)value;
- (void)addRootflare:(NSSet *)value;
- (void)removeRootflare:(NSSet *)value;

@end

