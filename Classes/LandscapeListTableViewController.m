//
//  LandscapeListTableViewController.m
//  Trees
//
//  Created by Sean Clifford on 12/22/10.
//  Copyright 2010 NCPTT/National Park Service. All rights reserved.
//

#import "LandscapeListTableViewController.h"
#import "LandscapeDetailViewController.h"
#import "Landscape.h"
#import "LandscapeTableViewCell.h"

@implementation LandscapeListTableViewController


@synthesize fetchedResultsController;

#pragma mark -
#pragma mark UIViewController overrides

- (void)viewDidLoad {
    // Configure the navigation bar
    self.title = @"Landscapes";
	
	//Darker Green
	self.tableView.backgroundColor = [UIColor colorWithRed:0.369 green:0.435 blue:0.200 alpha:1.0];
	
	self.tableView.opaque = NO;
	self.tableView.backgroundView = nil;
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];

	
	//load managedObjectContext from AppDelegate
    if(!managedObjectContext){
        managedObjectContext = [(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
	
	//set up fetched results controller
	[self fetchedResultsController];
	
	UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    self.navigationItem.rightBarButtonItem = addButtonItem;
    [addButtonItem release];
    
    // Set the table view's row height
    self.tableView.rowHeight = 59.0;
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}		
}
- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.tableView reloadData];
}
- (void) viewDidUnload {
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Support all orientations except upside down
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark -
#pragma mark Landscape support

- (void)add:(id)sender {
	// To add a new landscape, create a LandscapeAddViewController.  Present it as a modal view so that the user's focus is on the task of adding the landscape; wrap the controller in a navigation controller to provide a navigation bar for the Done and Save buttons (added by the LandscapeAddViewController in its viewDidLoad method).
	
    LandscapeAddViewController *addController = [[LandscapeAddViewController alloc] initWithNibName:@"LandscapeAddView" bundle:nil];
	
    addController.delegate = self;
	
	Landscape *newLandscape = [NSEntityDescription insertNewObjectForEntityForName:@"Landscape" inManagedObjectContext:managedObjectContext];
	addController.landscape = newLandscape;
	
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addController];
    [self presentModalViewController:navigationController animated:YES];
    
    [navigationController release];
    [addController release];
}


- (void)landscapeAddViewController:(LandscapeAddViewController *)landscapeAddViewController didAddLandscape:(Landscape *)landscape {
    if (landscape) {        
        // Show the landscape in a new view controller
        [self showLandscape:landscape animated:NO];
    }
    
    // Dismiss the modal add landscape view controller
    [self dismissModalViewControllerAnimated:YES];
}


- (void)showLandscape:(Landscape *)landscape animated:(BOOL)animated {
    // Create a detail view controller, set the landscape, then push it.
    NSDictionary *query = [NSDictionary dictionaryWithObject:landscape forKey:@"landscape"];
	[[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:@"land://Landscapes/LandscapeDetailView?"] applyQuery:query] applyAnimated:YES]];
}


#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = [[fetchedResultsController sections] count];
    
	if (count == 0) {
		count = 1;
	}
	
    return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
	
    if ([[fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    
    return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Dequeue or if necessary create a LandscapeTableViewCell, then set its landscape to the landscape for the current row.
    static NSString *LandscapeCellIdentifier = @"LandscapeCellIdentifier";
 	
    LandscapeTableViewCell *landscapeCell = (LandscapeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:LandscapeCellIdentifier];
    if (landscapeCell == nil) {
        landscapeCell = [[[LandscapeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LandscapeCellIdentifier] autorelease];
		landscapeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	// Define your row
    NSInteger row = [indexPath row];
	
	UIView *backgroundView = [[UIView alloc] init];
	if ((row % 2) == 0)

		
		//light green
		backgroundView.backgroundColor = [UIColor colorWithRed:0.616 green:0.663 blue:0.486 alpha:1.0];			
		
		
	else


		//darker green color
		backgroundView.backgroundColor = [UIColor colorWithRed:0.369 green:0.435 blue:0.200 alpha:1.0];		
		
		
	landscapeCell.backgroundView = backgroundView;
	[backgroundView release]; 
    
	[self configureCell:landscapeCell atIndexPath:indexPath];
    
    return landscapeCell;
}


- (void)configureCell:(LandscapeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell
	Landscape *landscape = (Landscape *)[fetchedResultsController objectAtIndexPath:indexPath];
    cell.landscape = landscape;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Landscape *landscape = (Landscape *)[fetchedResultsController objectAtIndexPath:indexPath];
    
    [self showLandscape:landscape animated:YES];
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
		
		[managedObjectContext deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
		
		// Save the context.
		NSError *error;
		if (![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}   
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    // Set up the fetched results controller if needed.
    if (fetchedResultsController == nil) {
        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Landscape" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
        
        [aFetchedResultsController release];
        [fetchRequest release];
        [sortDescriptor release];
        [sortDescriptors release];
    }
	
	return fetchedResultsController;
}    



/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	UITableView *tableView = self.tableView;
	
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
			//[self configureCell:(LandscapeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			[self.tableView cellForRowAtIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
		{
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
		}
            break;
	}
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[self.tableView endUpdates];
}



#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[fetchedResultsController release];
    [super dealloc];
}

@end
