//
//  LandscapeDetailViewController.h
//  Trees
//
//  Created by Sean Clifford on 12/22/10.
//  Copyright 2010 NCPTT/National Park Service. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate_Shared.h"

@class Landscape;

@interface LandscapeDetailViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate> {

	Landscape *landscape;

	UIView *tableHeaderView;    
	UIButton *photoButton;
	UITextField *nameTextField;
	UITextField *address1TextField;
	UITextField *cityTextField;
	UITextField *stateTextField;
	UITextField *zipTextField;
	UITextField *gpsTextField;	
	
}

@property (nonatomic, retain) Landscape *landscape;
@property (nonatomic, retain) IBOutlet UIView *tableHeaderView;
@property (nonatomic, retain) IBOutlet UIButton *photoButton;
@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) IBOutlet UITextField *address1TextField;
@property (nonatomic, retain) IBOutlet UITextField *cityTextField;
@property (nonatomic, retain) IBOutlet UITextField *stateTextField;
@property (nonatomic, retain) IBOutlet UITextField *zipTextField;
@property (nonatomic, retain) IBOutlet UITextField *gpsTextField;

- (IBAction)photoTapped;

@end
