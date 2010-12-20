//
//  Photo.h
//  landscapes
//
//  Created by Evan Cordell on 8/16/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Image;

@interface Photo :  NSManagedObject  
{
}

@property (nonatomic, retain) NSSet* images;

@end


@interface Photo (CoreDataGeneratedAccessors)
- (void)addImagesObject:(Image *)value;
- (void)removeImagesObject:(Image *)value;
- (void)addImages:(NSSet *)value;
- (void)removeImages:(NSSet *)value;

@end

