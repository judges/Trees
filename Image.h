//
//  Image.h
//  Trees
//
//  Created by Evan on 1/4/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Photo;

@interface Image :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * image_caption;
@property (nonatomic, retain) NSNumber * isThumbnail;
@property (nonatomic, retain) NSData * image_data;
@property (nonatomic, retain) Photo * owner;

@end



