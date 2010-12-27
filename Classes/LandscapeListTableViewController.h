//
//  LandscapeListTableViewController.h
//  Trees
//
//  Created by Sean Clifford on 12/22/10.
//  Copyright 2010 NCPTT/National Park Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LandscapeAddViewController.h"
#import "AppDelegate_Shared.h"

@class Landscape;
@class LandscapeTableViewCell;

@interface LandscapeListTableViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	
@private

	NSFetchedResultsController *fetchedResultsController_;
	NSManagedObjectContext *managedObjectContext_;
	
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

 - (void)showLandscape:(Landscape *)landscape animated:(BOOL)animated;
 - (void)configureCell:(LandscapeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
