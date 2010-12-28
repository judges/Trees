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
    
    AssessmentTree *assessmentTree;
    UIImagePickerController *imagePicker;
	UIActionSheet *photoActionSheet;
    
    //view page
    IBOutlet UILabel *assessor;
    IBOutlet UILabel *date;
    IBOutlet UILabel *caliper;
    IBOutlet UILabel *height;
    IBOutlet UILabel *formCText;
    IBOutlet UILabel *crownCText;
    IBOutlet UILabel *trunkCText;
    IBOutlet UILabel *rootFlareCText;
    IBOutlet UILabel *rootsCText;
    IBOutlet UILabel *overallCText;
    IBOutlet UILabel *formRText;
    IBOutlet UILabel *crownRText;
    IBOutlet UILabel *trunkRText;
    IBOutlet UILabel *rootFlareRText;
    IBOutlet UILabel *rootsRText;
    IBOutlet UILabel *overallRText;
    
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

//view
@property (nonatomic, retain) UILabel *assessor;
@property (nonatomic, retain) UILabel *date;
@property (nonatomic, retain) UILabel *caliper;
@property (nonatomic, retain) UILabel *height;
@property (nonatomic, retain) UILabel *formCText;
@property (nonatomic, retain) UILabel *crownCText;
@property (nonatomic, retain) UILabel *trunkCText;
@property (nonatomic, retain) UILabel *rootFlareCText;
@property (nonatomic, retain) UILabel *rootsCText;
@property (nonatomic, retain) UILabel *overallCText;
@property (nonatomic, retain) UILabel *formRText;
@property (nonatomic, retain) UILabel *crownRText;
@property (nonatomic, retain) UILabel *trunkRText;
@property (nonatomic, retain) UILabel *rootFlareRText;
@property (nonatomic, retain) UILabel *rootsRText;
@property (nonatomic, retain) UILabel *overallRText;

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

- (void)dismissActionSheet:(id)sender;
- (void)caliperSelected:(id)sender;
- (void)heightSelected:(id)sender;
@end
