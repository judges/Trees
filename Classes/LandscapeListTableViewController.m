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


@synthesize managedObjectContext, fetchedResultsController;



#pragma mark -
#pragma mark UIViewController 


- (void)viewDidLoad {
    [super viewDidLoad];

	// Configure navigation bar
	
	self.title	= @"Landscapes";
		
    // Add an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
	// Add an Add button in the navigation bar for this view controller.
	UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    self.navigationItem.rightBarButtonItem = addButtonItem;
    [addButtonItem release];
	
	// Set the table view's row height
    self.tableView.rowHeight = 44.0;
	
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




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // All orientations but upsidedown
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Landscape support

- (void)add:(id)sender {
	// To add a new landscape, create a LandscapeAddViewController.  Present it as a modal view so that the user's focus is on the task of adding the landscape; wrap the controller in a navigation controller to provide a navigation bar for the Done and Save buttons (added by the LandscapeAddViewController in its viewDidLoad method).
    LandscapeAddViewController *addController = [[LandscapeAddViewController alloc] initWithNibName:@"LandscapeAddView" bundle:nil];
    addController.delegate = self;
	
	Landscape *newLandscape = [NSEntityDescription insertNewObjectForEntityForName:@"Landscape" inManagedObjectContext:self.managedObjectContext];
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
    LandscapeDetailViewController *detailViewController = [[LandscapeDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    detailViewController.landscape = landscape;
    
    [self.navigationController pushViewController:detailViewController animated:animated];
    [detailViewController release];
}

#pragma mark -
#pragma mark Table view data methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the count the sections.

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



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

/*

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];

}

*/


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

