//
//  Tree.h
//  Trees
//
//  Created by Sean Clifford on 1/3/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Tree :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * gps;
@property (nonatomic, retain) id thumbnailImage;
@property (nonatomic, retain) NSManagedObject * image;

@end



