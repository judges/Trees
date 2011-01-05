//
//  Photo.h
//  Trees
//
//  Created by Evan on 1/4/11.
//  Copyright 2011 NCPTT. All rights reserved.
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

