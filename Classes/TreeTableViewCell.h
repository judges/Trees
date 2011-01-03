//
//  TreeTableViewCell.h
//  Trees
//
//  Created by Sean Clifford on 1/3/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tree.h"

@interface TreeTableViewCell : UITableViewCell {
	
	Tree *tree;
    
    UIImageView *imageView;
    UILabel *nameLabel;
    UILabel *gpsLabel;
    UILabel *timeStampLabel;	
}

@property (nonatomic, retain) Tree *tree;

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *gpsLabel;
@property (nonatomic, retain) UILabel *timeStampLabel;

@end

