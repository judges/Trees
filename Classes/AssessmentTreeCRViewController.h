//
//  AssessmentTreeCRViewController.h
//  landscapes
//
//  Created by Evan Cordell on 8/3/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_Shared.h"


@interface AssessmentTreeCRViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, NSFetchedResultsControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    AssessmentTree *tree;
    UIImagePickerController *imagePicker;
    IBOutlet UIView *mainView;
    IBOutlet UIView *conditionView;
    IBOutlet UIView *recommendationView;
    IBOutlet UIPickerView *conditionPicker;
    IBOutlet UIPickerView *recommendationPicker;
    IBOutlet UIButton *photoButton;
    IBOutlet UISegmentedControl *switchControl;
    IBOutlet UIButton *conditionSaveButton;
    IBOutlet UIButton *recommendationSaveButton;
    IBOutlet UIButton *addConditionButton;
    IBOutlet UIButton *addRecommendationButton;
    IBOutlet UIButton *editConditionButton;
    IBOutlet UIButton *editRecommendationButton;
    IBOutlet UIButton *deleteConditionButton;
    IBOutlet UIButton *deleteRecommendationButton;
    IBOutlet UITextField *conditionField;
    IBOutlet UITextField *recommendationField;
    NSMutableArray *conditionStringArray;
    NSMutableArray *recommendationStringArray;
    NSMutableArray *conditionArray;
    NSMutableArray *recommendationArray;
    NSNumber *whichId;
    @private
        NSManagedObjectContext *managedObjectContext;
}
@property  BOOL isEditing;
@property (nonatomic, retain) AssessmentTree *tree;
@property (nonatomic, retain) NSNumber *whichId;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *conditionStringArray;
@property (nonatomic, retain) NSMutableArray *recommendationStringArray;
@property (nonatomic, retain) NSMutableArray *conditionArray;
@property (nonatomic, retain) NSMutableArray *recommendationArray;
-(id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query;
-(IBAction)addCondition;
-(IBAction)addRecommendation;
-(IBAction)editCondition;
-(IBAction)editRecommendation;
-(IBAction)deleteCondition;
-(IBAction)deleteRecommendation;
-(IBAction)conditionSaveButtonClick;
-(IBAction)recommendationSaveButtonClick;
-(IBAction)conditionTypingFinished;
-(IBAction)recommendationTypingFinished;
-(IBAction)segmentSwitch:(id)sender;
-(IBAction)photoButtonClick:(id)sender;
@end
