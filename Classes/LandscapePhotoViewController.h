//
//  LandscapePhotoViewController.h
//  Trees
//
//  Created by Sean Clifford on 12/22/10.
//  Copyright 2010 NCPTT/National Park Service. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@class Landscape;

@interface LandscapePhotoViewController : UIViewController {
	@private
		Landscape *landscape;
		UIImageView *imageView;
}

@property(nonatomic, retain) Landscape *landscape;
@property(nonatomic, retain) UIImageView *imageView;

@end
