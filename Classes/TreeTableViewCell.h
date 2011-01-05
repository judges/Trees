//
//  TreeTableViewCell.h
//  Trees
//
//  Created by Sean Clifford on 1/3/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryTree.h"

@interface TreeTableViewCell : UITableViewCell {
	
	InventoryTree *tree;
    
    UIImageView *imageView;
    UILabel *nameLabel;
    UILabel *gpsLabel;
    UILabel *created_atLabel;	
}

@property (nonatomic, retain) InventoryTree *tree;

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *gpsLabel;
@property (nonatomic, retain) UILabel *created_atLabel;

@end

