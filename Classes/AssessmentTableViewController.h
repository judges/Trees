//
//  AssessmentTableViewController.h
//  landscapes
//
//  Created by Evan Cordell on 7/26/10.
//  Copyright National Park Service/NCPTT 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_Shared.h"
#import "AssessmentTableViewCell.h"

//needed to prepopulate the database
#import "Assessment.h"
#import "Landscape.h"
#import "AssessmentTree.h"
#import "AssessmentType.h"
#import "TreeCrown.h"
#import "TreeForm.h"
#import "TreeTrunk.h"
#import "TreeRootFlare.h"
#import "TreeRoots.h"
#import "TreeOverall.h"
#import "TreeOption.h"
#import "TreeCrownCondition.h"
#import "TreeCrownRecommendation.h"
#import "TreeFormCondition.h"
#import "TreeFormRecommendation.h"
#import "TreeOverallCondition.h"
#import "TreeOverallRecommendation.h"
#import "TreeRootFlareCondition.h"
#import "TreeRootFlareRecommendation.h"
#import "TreeRootsCondition.h"
#import "TreeRootsRecommendation.h"
#import "TreeTrunkCondition.h"
#import "TreeTrunkRecommendation.h"
#import "Image.h"
#import "Photo.h"
#import "DDXML.h"
#import "InventoryItem.h"
#import "InventoryTree.h"
#import	"InventoryType.h"

@interface AssessmentTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    UIActionSheet *typeActionSheet;
    UIActionSheet *landscapeActionSheet;
	UIActionSheet *InventoryActionSheet;
    UIPickerView *typePickerView;
    UIPickerView *landscapePickerView;
    NSMutableArray *typesArray;
    NSMutableArray *landscapesArray;
    Landscape *selectedLandscape;
    AssessmentType *selectedType;
    @private
        NSFetchedResultsController *fetchedResultsController;
        NSManagedObjectContext *managedObjectContext;
    
}
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSMutableArray *typesArray;
@property (nonatomic, retain) NSMutableArray *landscapesArray;

- (void)configureCell:(AssessmentTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)prepopulateDb;
- (void)dismissActionSheet:(id)sender;
- (void)typeSelected:(id)sender;
@end
