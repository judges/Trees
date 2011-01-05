//
//  TreeListTableViewController.h
//  Trees
//
//  Created by Sean Clifford on 12/27/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_Shared.h"
#import "TreeAddViewController.h"
#import "InventoryItem.h"
#import "InventoryTree.h"
#import "TreeListTableViewController.h"
#import "TreeDetailViewController.h"
#import "TreeTableViewCell.h"


@class InventoryTree;
@class TreeTableViewCell;

@interface TreeListTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, TreeAddDelegate> {
	
@private
	
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (void)showTree:(InventoryTree *)tree animated:(BOOL)animated;
- (void)configureCell:(TreeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

