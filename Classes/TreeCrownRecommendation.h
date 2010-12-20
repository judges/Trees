//
//  TreeCrownRecommendation.h
//  landscapes
//
//  Created by Evan Cordell on 8/16/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>

@class TreeCrown;

@interface TreeCrownRecommendation :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* crown;

@end


@interface TreeCrownRecommendation (CoreDataGeneratedAccessors)
- (void)addCrownObject:(TreeCrown *)value;
- (void)removeCrownObject:(TreeCrown *)value;
- (void)addCrown:(NSSet *)value;
- (void)removeCrown:(NSSet *)value;

@end

