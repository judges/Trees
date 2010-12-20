//
//  TreeTrunkRecommendation.h
//  landscapes
//
//  Created by Evan Cordell on 8/16/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>

@class TreeTrunk;

@interface TreeTrunkRecommendation :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* trunk;

@end


@interface TreeTrunkRecommendation (CoreDataGeneratedAccessors)
- (void)addTrunkObject:(TreeTrunk *)value;
- (void)removeTrunkObject:(TreeTrunk *)value;
- (void)addTrunk:(NSSet *)value;
- (void)removeTrunk:(NSSet *)value;

@end

