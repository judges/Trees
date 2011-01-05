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
#import "AssessmentTableViewCell.h"

@class Landscape;

@interface LandscapeDetailViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource> {

	Landscape *landscape;
	NSMutableArray *assessmentArray;
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
@property (nonatomic, retain) NSMutableArray *assessmentArray;
@property (nonatomic, retain) IBOutlet UIView *tableHeaderView;
@property (nonatomic, retain) IBOutlet UIButton *photoButton;
@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) IBOutlet UITextField *address1TextField;
@property (nonatomic, retain) IBOutlet UITextField *cityTextField;
@property (nonatomic, retain) IBOutlet UITextField *stateTextField;
@property (nonatomic, retain) IBOutlet UITextField *zipTextField;
@property (nonatomic, retain) IBOutlet UITextField *gpsTextField;

- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query;
- (void)configureCell:(AssessmentTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (IBAction)photoTapped;

@end
