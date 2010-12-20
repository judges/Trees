//
//  TreeFormCondition.h
//  landscapes
//
//  Created by Evan Cordell on 8/16/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>

@class TreeForm;

@interface TreeFormCondition :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* form;

@end


@interface TreeFormCondition (CoreDataGeneratedAccessors)
- (void)addFormObject:(TreeForm *)value;
- (void)removeFormObject:(TreeForm *)value;
- (void)addForm:(NSSet *)value;
- (void)removeForm:(NSSet *)value;

@end

