//
//  LauncherViewController.m
//  landscapes
//
//  Created by Sean Clifford on 7/26/10.
//  Copyright 2010 National Park Service/NCPTT. All rights reserved.
//

#import "LauncherViewController.h"

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation LauncherViewController
@synthesize theSearchBar, allRecords, filteredRecords;

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

		//Set navigation bar title
		self.title = @"Trees";
		
	}
	return self;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)){
		_launcherView.columnCount = 5;
		_launcherView.frame=self.view.bounds;
	
	} else	if((self.interfaceOrientation == UIDeviceOrientationPortrait) || (self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)){
		_launcherView.columnCount = 3;
		_launcherView.frame=self.view.bounds;
	}
	_launcherView.frame = CGRectMake(_launcherView.frame.origin.x, _launcherView.frame.origin.y + 44, _launcherView.frame.size.width, _launcherView.frame.size.height - 44);
	[self.theSearchBar sizeToFit];
}

-(void)reloadLauncherView
{
    [self viewWillAppear:NO ];
}



- (void)dealloc {
	[allRecords release];
	[filteredRecords release];
	[super dealloc];
}

#pragma mark -
#pragma mark UISearchBarDelegate

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
}

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark UISearchDisplayController


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
	//If we need to add scope later, refer to the Apple TableSearch example
    [self filterContentForSearchText:searchString];
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText
{
    [[self.filteredRecords objectAtIndex:0] removeAllObjects];
	[[self.filteredRecords objectAtIndex:1] removeAllObjects];
	[[self.filteredRecords objectAtIndex:2] removeAllObjects];
	
	for (Landscape* l in [allRecords objectAtIndex:0]) {
		NSComparisonResult result = [l.name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
		if (result == NSOrderedSame)
		{
			[[self.filteredRecords objectAtIndex:0] addObject:l];
		}
	}
	for (InventoryItem* i in [allRecords objectAtIndex:1]) {
		NSComparisonResult result = [i.name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
		if (result == NSOrderedSame)
		{
			[[self.filteredRecords objectAtIndex:1] addObject:i];
		}
		result = [i.landscape.name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
		if (result == NSOrderedSame)
		{
			[[self.filteredRecords objectAtIndex:1] addObject:i];
		}
	}
	for (Assessment* a in [allRecords objectAtIndex:2]) {
		NSComparisonResult result = [a.inventoryItem.name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
		if (result == NSOrderedSame)
		{
			[[self.filteredRecords objectAtIndex:2] addObject:a];
		}
		result = [a.inventoryItem.landscape.name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
		if (result == NSOrderedSame)
		{
			[[self.filteredRecords objectAtIndex:2] addObject:a];
		}
	}
}

#pragma mark -
#pragma mark UISearchDisplayDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)loadView {
	[super loadView];
	CGRect  bounds = self.view.bounds;
	[self.theSearchBar sizeToFit];
	
	// launcherView
	_launcherView.frame = CGRectMake(0,45,bounds.size.width,bounds.size.height-2*45); 
	_launcherView = [[TTLauncherView alloc] initWithFrame:self.view.bounds];
	_launcherView.backgroundColor = [UIColor colorWithRed:0.369 green:0.435 blue:0.200 alpha:1.0]; //darker green
	_launcherView.opaque = YES;
	_launcherView.delegate = self;

	
	if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)){
		_launcherView.columnCount = 5;
		_launcherView.frame=self.view.bounds;
		[self.theSearchBar sizeToFit];
		
	} else	if((self.interfaceOrientation == UIDeviceOrientationPortrait) || (self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)){
		_launcherView.columnCount = 3;
		_launcherView.frame=self.view.bounds;
		[self.theSearchBar sizeToFit];
		
	}
	_launcherView.frame = CGRectMake(_launcherView.frame.origin.x, _launcherView.frame.origin.y + 44, _launcherView.frame.size.width, _launcherView.frame.size.height - 44);
	
	_launcherView.pages = [NSArray arrayWithObjects:
						   [NSArray arrayWithObjects:
							[[[TTLauncherItem alloc] initWithTitle:@"Landscapes"
															 image:@"bundle://landscapes.png"
															   URL:@"land://Landscapes"  canDelete:NO] autorelease],

							/*
							[[[TTLauncherItem alloc] initWithTitle:@"Inventory"
															 image:@"bundle://inventory.png"
															   URL:@"land://Inventory" canDelete:NO] autorelease],
							*/

							
							
							[[[TTLauncherItem alloc] initWithTitle:@"Tree Inventory"
															 image:@"bundle://tree.png"
															   URL:@"land://Trees" canDelete:NO] autorelease],								
							
							[[[TTLauncherItem alloc] initWithTitle:@"Assessments"
															 image:@"bundle://assessments.png"
															   URL:@"land://assessments" canDelete:NO] autorelease],

							
							/*
							[[[TTLauncherItem alloc] initWithTitle:@"Tasks"
															 image:@"bundle://tasks.png"
															   URL:@"land://Tasks" canDelete:NO] autorelease],							
							
							*/


							/*
							[[[TTLauncherItem alloc] initWithTitle:@"Cemetery"
															 image:@"bundle://cemetery.png"
															   URL:@"land://Cemetery" canDelete:NO] autorelease],								
							
							[[[TTLauncherItem alloc] initWithTitle:@"Structures"
															 image:@"bundle://structures.png"
															   URL:@"land://Structures" canDelete:NO] autorelease],
							
							[[[TTLauncherItem alloc] initWithTitle:@"Wildlife"
															 image:@"bundle://wildlife.png"
															   URL:@"land://Wildlife" canDelete:NO] autorelease],
							
							*/
							 
							[[[TTLauncherItem alloc] initWithTitle:@"Photos"
															 image:@"bundle://photos.png"
															   URL:@"land://Photos" canDelete:NO] autorelease],		
							
							/*
							
							[[[TTLauncherItem alloc] initWithTitle:@"Maps"
															 image:@"bundle://maps.png"
															   URL:@"land://Maps" canDelete:NO] autorelease],								
							
							*/
							 
							 
							[[[TTLauncherItem alloc] initWithTitle:@"Settings"
															 image:@"bundle://settings.png"
															   URL:@"land://Settings" canDelete:NO] autorelease],		
							
							[[[TTLauncherItem alloc] initWithTitle:@"NCPTT Web"
															 image:@"bundle://ncptt.png"
															   URL:@"http://www.ncptt.nps.gov" canDelete:NO] autorelease],								

							
							
							
							
							nil],
						   
						   
						   /*
						   [NSArray arrayWithObjects:
						
							
							[[[TTLauncherItem alloc] initWithTitle:@"NPS"
															 image:@"bundle://NPS.png"
															   URL:@"http://www.nps.gov" canDelete:NO] autorelease],								

							
							nil],*/
						   nil
						   ];
	[self.view addSubview:_launcherView];
	
	/*
	TTLauncherItem* item = [_launcherView itemWithURL:@"land://data/assessments"];
	item.badgeNumber = 2;
	*/
	
	theSearchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 44.0)] autorelease];
	theSearchBar.delegate = self;
	theSearchBar.showsCancelButton = NO;
	theSearchBar.tintColor=[UIColor colorWithRed:0.180 green:0.267 blue: 0.173 alpha:1.0]; //forest green
	theSearchBar.placeholder = @"Search";
	theSearchBar.showsScopeBar = NO;
	
	searchController = [[UISearchDisplayController alloc] initWithSearchBar:theSearchBar contentsController:self];
	searchController.delegate = self;
	searchController.searchResultsDataSource = self;
	searchController.searchResultsDelegate = self;
	
	[self.view addSubview: theSearchBar];
	
	//load data for searching
	NSError *error;
	NSManagedObjectContext *managedObjectContext = [(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Landscape" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	NSArray *allLandscapes = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	
	entity = [NSEntityDescription entityForName:@"InventoryItem" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	NSArray *allInventoryItems = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	
	entity = [NSEntityDescription entityForName:@"Assessment" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	NSArray *allAssessments = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	
	[fetchRequest release];
	
	allRecords = [[NSArray alloc] initWithObjects:allLandscapes, allInventoryItems, allAssessments, nil];
	
	//load dummy arrays into the filtered results
	NSMutableArray *tmp1 = [[NSMutableArray alloc] initWithCapacity:0];
	NSMutableArray *tmp2 = [[NSMutableArray alloc] initWithCapacity:0];
	NSMutableArray *tmp3 = [[NSMutableArray alloc] initWithCapacity:0];

	filteredRecords = [[NSArray alloc] initWithObjects:tmp1, tmp2, tmp3, nil];
	
	[tmp1 release];
	[tmp2 release];
	[tmp3 release];
}

-(void)viewWillAppear:(BOOL)animated {
    //clear the shared cache
    int urlctr = 0;
    NSString *path = [NSString stringWithFormat:@"images/%d.jpg", urlctr];
    NSString *url = [NSString stringWithFormat:@"temp://%@", path];
    while ([[TTURLCache sharedCache] hasDataForURL:url]) {
        path = [NSString stringWithFormat:@"images/%d.jpg",urlctr];
        url = [NSString stringWithFormat:@"temp://%@", path];
        [[TTURLCache sharedCache] removeURL:url fromDisk:YES];
        ++urlctr;
    }
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.180 green:0.267 blue: 0.173 alpha:1.0]; //forest green
	//self.view.backgroundColor = [UIColor colorWithRed:0.486 green:0.318 blue:0.192 alpha:1.0];		//earth brown
	//self.view.backgroundColor = [UIColor colorWithRed:0.486 green:0.318 blue:0.192 alpha:1.0];			//light green
	self.view.backgroundColor = [UIColor colorWithRed:0.369 green:0.435 blue:0.200 alpha:1.0]; //darker green

	
	
	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTLauncherViewDelegate


- (void)viewDidLoad
{
	[super viewDidLoad];
	
}

// called after the view controller's view is released and set to nil.
// For example, a memory warning which causes the view to be purged. Not invoked as a result of -dealloc.
// So release any properties that are loaded in viewDidLoad or can be recreated lazily.
//
- (void)viewDidUnload
{
	[super viewDidUnload];
	
	// release and set to nil
	[theSearchBar release];
	self.theSearchBar = nil;
}

- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)item {
	TTNavigator *navigator = [TTNavigator navigator];

    //[navigator openURLAction:[TTURLAction actionWithURLPath:item.URL]];
	[navigator openURLAction:[[TTURLAction actionWithURLPath:item.URL] applyAnimated:YES] ];
	
}

- (void)launcherViewDidBeginEditing:(TTLauncherView*)launcher {
	[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc]
												 initWithBarButtonSystemItem:UIBarButtonSystemItemDone
												 target:_launcherView action:@selector(endEditing)] autorelease] animated:YES];
}

- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher {
	[self.navigationItem setRightBarButtonItem:nil animated:YES];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CR"] autorelease];
	switch (indexPath.section) {
		case 0:
			cell.textLabel.text = [[[filteredRecords objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] name];
			break;
		case 1:
			cell.textLabel.text = [[[filteredRecords objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] name];
			break;
		case 2:
			cell.textLabel.text = [[[[filteredRecords objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] inventoryItem] name];
			break;
		default:
			cell.textLabel.text = @"";
			break;
	}
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [[self.filteredRecords objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
		switch (section) {
			case 0:
				return @"Landscapes";
				break;
			case 1:
				return @"Inventory";
				break;
			case 2:
				return @"Assessments";
				break;
			default:
				return @"";
				break;
		}
}
/* Maybe we can find a good way to use this later
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	return [NSArray arrayWithObjects:@"Landscapes", @"Inventory", @"Assessments", nil];
}*/

#pragma mark -
#pragma mark IASKAppSettingsViewControllerDelegate protocol

- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
    [self dismissModalViewControllerAnimated:YES];
	
	// code here to reconfigure the app for changed settings
}

@end

