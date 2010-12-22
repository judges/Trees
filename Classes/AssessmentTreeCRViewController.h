//
//  AssessmentTreeCRViewController.h
//  landscapes
//
//  Created by Evan Cordell on 8/3/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_Shared.h"


@interface AssessmentTreeCRViewController : UIViewController <NSFetchedResultsControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource> {
    AssessmentTree *tree;
    UIImagePickerController *imagePicker;
    IBOutlet UIView *mainView;
    IBOutlet UITableView *conditionTableView;
    IBOutlet UITableView *recommendationTableView;
    IBOutlet UIButton *photoButton;
    IBOutlet UISegmentedControl *switchControl;
    
    NSMutableArray *conditionStringArray;
    NSMutableArray *recommendationStringArray;
    NSMutableArray *conditionArray;
    NSMutableArray *recommendationArray;
	NSMutableArray *selectedConditionIndices;
	NSMutableArray *selectedRecommendationIndices;
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
@property (nonatomic, retain) NSMutableArray *selectedConditionIndices;
@property (nonatomic, retain) NSMutableArray *selectedRecommendationIndices;
@property (nonatomic, retain) UITableView *conditionTableView;
@property (nonatomic, retain) UITableView *recommendationTableView;
-(id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query;
-(IBAction)addCondition;
-(IBAction)addRecommendation;
-(IBAction)editCondition;
-(IBAction)editRecommendation;
-(IBAction)deleteCondition;
-(IBAction)deleteRecommendation;
-(IBAction)segmentSwitch:(id)sender;
-(IBAction)photoButtonClick:(id)sender;
@end
