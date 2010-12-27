//
//  TreeListTableViewController.h
//  Trees
//
//  Created by Sean Clifford on 12/27/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_Shared.h"


@interface TreeListTableViewController : UITableViewController <NSFetchedResultsControllerDelegate> {

@private
	
	NSFetchedResultsController *fetchedResultsController_;
	NSManagedObjectContext *managedObjectContext_;	
	
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
