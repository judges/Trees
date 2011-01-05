//
//  TreePhotoViewController.h
//  Trees
//
//  Created by Sean Clifford on 1/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InventoryTree;

@interface TreePhotoViewController : UIViewController {
@private
	InventoryTree *tree;
	UIImageView *imageView;
}

@property(nonatomic, retain) InventoryTree *tree;
@property(nonatomic, retain) UIImageView *imageView;

@end




