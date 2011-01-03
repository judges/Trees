//
//  TreePhotoViewController.m
//  Trees
//
//  Created by Sean Clifford on 1/3/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import "TreePhotoViewController.h"
#import "Tree.h"

@implementation TreePhotoViewController

@synthesize tree;
@synthesize imageView;

- (void)loadView {
	self.title = @"Photo";
	
    imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor blackColor];
    
    self.view = imageView;
}


- (void)viewWillAppear:(BOOL)animated {
    imageView.image = [tree.image valueForKey:@"image"];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)dealloc {
    [imageView release];
    [tree release];
    [super dealloc];
}


@end