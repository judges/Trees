//
//  LandscapeDetailViewController.h
//  Trees
//
//  Created by Sean Clifford on 12/22/10.
//  Copyright 2010 NCPTT/National Park Service. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@class Landscape;


@interface LandscapeDetailViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate> {

	Landscape *landscape;

	
	UIView *tableHeaderView;    
	UIButton *photoButton;
	UITextField *nameTextField;
	UITextField *overviewTextField;
	UITextField *prepTimeTextField;	
	
}

@property (nonatomic, retain) Landscape *landscape;


@property (nonatomic, retain) IBOutlet UIView *tableHeaderView;
@property (nonatomic, retain) IBOutlet UIButton *photoButton;
@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) IBOutlet UITextField *overviewTextField;
@property (nonatomic, retain) IBOutlet UITextField *prepTimeTextField;

- (IBAction)photoTapped;

@end
