//
//  ImageTree.h
//  Trees
//
//  Created by Sean Clifford on 1/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Tree;

@interface ImageTree :  NSManagedObject  
{
}

@property (nonatomic, retain) id image;
@property (nonatomic, retain) Tree * tree;

@end



