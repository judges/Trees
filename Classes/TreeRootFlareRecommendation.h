//
//  TreeRootFlareRecommendation.h
//  landscapes
//
//  Created by Evan Cordell on 8/16/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>

@class TreeRootFlare;

@interface TreeRootFlareRecommendation :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* rootflare;

@end


@interface TreeRootFlareRecommendation (CoreDataGeneratedAccessors)
- (void)addRootflareObject:(TreeRootFlare *)value;
- (void)removeRootflareObject:(TreeRootFlare *)value;
- (void)addRootflare:(NSSet *)value;
- (void)removeRootflare:(NSSet *)value;

@end

