//
//  AssessmentViewAndInput.h
//  landscapes
//
//  Created by Evan Cordell on 8/2/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Assessment.h"
#import "AssessmentTree.h"
#import "AssessmentTreeTableViewCell.h"
#import "AssessmentTreeTableViewHeaderCell.h"
#import "Height.h"
#import "Caliper.h"
#import "AppDelegate_Shared.h"
#import "DistancePickerView.h"

@interface AssessmentTreeViewAndInputController : UIViewController <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, 
																	TTPostControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, 
																	UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UIView *viewView;
    IBOutlet UIView *inputView;
    IBOutlet UIButton *photoButton;
    IBOutlet UIButton *notesButton;
	IBOutlet UITableView *assessmentTable;
    AssessmentTree *assessmentTree;
    UIImagePickerController *imagePicker;
	UIActionSheet *photoActionSheet;
	NSArray *conditionArray;																	
	NSArray *recommendationArray;
																		
    //view page
    IBOutlet UILabel *assessor;
    IBOutlet UILabel *date;
    IBOutlet UILabel *caliper;
    IBOutlet UILabel *height;
    
    //input page
    IBOutlet UITextField *assessorField;
    IBOutlet UIButton *caliperButton;
    IBOutlet UIButton *heightButton;
    IBOutlet UIButton *button1;
    IBOutlet UIButton *button2;
    IBOutlet UIButton *button3;
    IBOutlet UIButton *button4;
    IBOutlet UIButton *button5;
    IBOutlet UIButton *button6;
	UIActionSheet *caliperActionSheet;
    UIActionSheet *heightActionSheet;
	DistancePickerView *caliperPickerView;
    DistancePickerView *heightPickerView;
 @private
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) AssessmentTree *assessmentTree;
@property (nonatomic, retain) NSArray *conditionArray;
@property (nonatomic, retain) NSArray *recommendationArray;

//view
@property (nonatomic, retain) UILabel *assessor;
@property (nonatomic, retain) UILabel *date;
@property (nonatomic, retain) UILabel *caliper;
@property (nonatomic, retain) UILabel *height;
@property (nonatomic, retain) UITableView *assessmentTable;
//input
@property (nonatomic, retain) UITextField *assessorField;
@property (nonatomic, retain) UIButton *caliperButton;
@property (nonatomic, retain) UIButton *heightButton;


-(id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query;
-(IBAction)segmentSwitch:(id)sender;
-(IBAction)treeButtonClick:(id)sender;
-(IBAction)saveAssessor:(id)sender;
-(IBAction)caliperClick:(id)sender;
-(IBAction)heightClick:(id)sender;
-(IBAction)photoButtonClick:(id)sender;
-(IBAction)notesButtonClick:(id)sender;
-(void)configureCell:(AssessmentTreeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (void)dismissActionSheet:(id)sender;
- (void)caliperSelected:(id)sender;
- (void)heightSelected:(id)sender;

- (NSInteger)greatestOfInt:(NSInteger)a andInt:(NSInteger)b;

@end
