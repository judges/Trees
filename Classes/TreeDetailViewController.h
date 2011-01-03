//
//  TreeDetailViewController.h
//  Trees
//
//  Created by Sean Clifford on 1/3/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_Shared.h"

@class Tree;

@interface TreeDetailViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate> {
	
	Tree *tree;
	
	UIView *tableHeaderView;    
	UIButton *photoButton;
	UITextField *nameTextField;
	UITextField *gpsTextField;	
	
}

@property (nonatomic, retain) Tree *tree;

@property (nonatomic, retain) IBOutlet UIView *tableHeaderView;
@property (nonatomic, retain) IBOutlet UIButton *photoButton;
@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) IBOutlet UITextField *gpsTextField;

- (IBAction)photoTapped;

@end

