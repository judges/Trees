//
//  LandscapeTableViewCell.h
//  Trees
//
//  Created by Sean Clifford on 12/22/10.
//  Copyright 2010 NCPTT/National Park Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Landscape.h"

@interface LandscapeTableViewCell : UITableViewCell {

	Landscape *landscape;
    
    UIImageView *imageView;
    UILabel *nameLabel;
    UILabel *overviewLabel;
    UILabel *prepTimeLabel;
	
}

@property (nonatomic, retain) Landscape *landscape;

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *overviewLabel;
@property (nonatomic, retain) UILabel *prepTimeLabel;

@end
