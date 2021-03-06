//
//  Assessment.h
//  Trees
//
//  Created by Evan on 1/6/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Photo.h"

@class InventoryItem;

@interface Assessment :  Photo  
{
}

@property (nonatomic, retain) NSString * assessor;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) InventoryItem * inventoryItem;

@end



