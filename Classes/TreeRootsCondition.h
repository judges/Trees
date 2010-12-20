//
//  TreeRootsCondition.h
//  landscapes
//
//  Created by Evan Cordell on 8/16/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>

@class TreeRoots;

@interface TreeRootsCondition :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* roots;

@end


@interface TreeRootsCondition (CoreDataGeneratedAccessors)
- (void)addRootsObject:(TreeRoots *)value;
- (void)removeRootsObject:(TreeRoots *)value;
- (void)addRoots:(NSSet *)value;
- (void)removeRoots:(NSSet *)value;

@end

