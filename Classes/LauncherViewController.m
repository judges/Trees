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

- (void)prepopulateDb {    
	
	if ([[allRecords objectAtIndex:0] count] == 0 && [[allRecords objectAtIndex:1] count] == 0 && [[allRecords objectAtIndex:2] count] == 0) {
		NSManagedObjectContext *managedObjectContext = [(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate] managedObjectContext];
		
		Landscape *landscape = [NSEntityDescription insertNewObjectForEntityForName:@"Landscape" inManagedObjectContext:managedObjectContext];
		landscape.name = @"American Cemetery";
		landscape.address1 = @"131 Second Street";
		landscape.city = @"Natchitoches";
		landscape.state = @"LA";
		landscape.zip = @"71457";
		landscape.gps = @"31.753833,-93.091053";
		
		Type *type = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:managedObjectContext];
		type.name = @"Tree";
		
		InventoryTree *inventoryTree = [NSEntityDescription insertNewObjectForEntityForName:@"InventoryTree" inManagedObjectContext:managedObjectContext];
		inventoryTree.name = @"St. Denis' Oak";
		inventoryTree.gps = @"31.754472,-93.091375";
		inventoryTree.created_at = [NSDate date];
		inventoryTree.landscape = landscape;
		inventoryTree.type = type;
		
		AssessmentTree *assessmentTree = [NSEntityDescription insertNewObjectForEntityForName:@"AssessmentTree" inManagedObjectContext:managedObjectContext];
		assessmentTree.assessor = @"Evan Cordell";
		assessmentTree.created_at = [NSDate date];
		assessmentTree.inventoryItem = inventoryTree;
		[[inventoryTree mutableSetValueForKeyPath:@"assessments"] addObject:assessmentTree];
		
		NSString *treeOptionsPath = [[NSBundle mainBundle] pathForResource:@"TreeOptions" ofType:@"xml"];
		NSData *treeOptionsData = [NSData dataWithContentsOfFile:treeOptionsPath];
		NSMutableArray *typeArray = [[NSMutableArray alloc] initWithCapacity:0];
		if (treeOptionsData) {
			DDXMLDocument *treeOptionsDoc = [[DDXMLDocument alloc] initWithData:treeOptionsData options:0 error:nil];
			DDXMLElement *rootNode = [treeOptionsDoc rootElement];
			//conditions
			for (DDXMLElement *part in [rootNode children]) {
				PartType *partType = [NSEntityDescription insertNewObjectForEntityForName:@"PartType" inManagedObjectContext:managedObjectContext];
				partType.name = [part stringValue];
				[typeArray addObject:partType];
				for(DDXMLElement *option in [[part childAtIndex:0] children])
				{
					PartCondition *condition = [NSEntityDescription insertNewObjectForEntityForName:@"PartCondition" inManagedObjectContext:managedObjectContext];
					condition.name = [option stringValue];
					condition.partType = partType;
				}
				for(DDXMLElement *option in [[part childAtIndex:1] children])
				{
					PartRecommendation *recommendation = [NSEntityDescription insertNewObjectForEntityForName:@"PartRecommendation" inManagedObjectContext:managedObjectContext];
					recommendation.name = [option stringValue];
					recommendation.partType = partType;
				}
			}
			
			
			TreePart *treeForm = [NSEntityDescription insertNewObjectForEntityForName:@"TreePart" inManagedObjectContext:managedObjectContext];
			treeForm.partType = [typeArray objectAtIndex:0];
			assessmentTree.form = treeForm;
			TreePart *treeCrown = [NSEntityDescription insertNewObjectForEntityForName:@"TreePart" inManagedObjectContext:managedObjectContext];
			treeForm.partType = [typeArray objectAtIndex:1];
			assessmentTree.crown = treeCrown;
			TreePart *treeTrunk = [NSEntityDescription insertNewObjectForEntityForName:@"TreePart" inManagedObjectContext:managedObjectContext];
			treeForm.partType = [typeArray objectAtIndex:2];
			assessmentTree.trunk = treeTrunk;
			TreePart *treeRootFlare = [NSEntityDescription insertNewObjectForEntityForName:@"TreePart" inManagedObjectContext:managedObjectContext];
			treeForm.partType = [typeArray objectAtIndex:3];
			assessmentTree.rootflare = treeRootFlare;
			TreePart *treeRoots = [NSEntityDescription insertNewObjectForEntityForName:@"TreePart" inManagedObjectContext:managedObjectContext];
			treeForm.partType = [typeArray objectAtIndex:4];
			assessmentTree.roots = treeRoots;
			TreePart *treeOverall = [NSEntityDescription insertNewObjectForEntityForName:@"TreePart" inManagedObjectContext:managedObjectContext];
			treeForm.partType = [typeArray objectAtIndex:5];
			assessmentTree.overall = treeOverall;
			
			[typeArray release];
			
			NSError *error;
			if (![managedObjectContext save:&error]) {
				NSLog(@"Whoops, couldn't save: %@", error);
			}
			
			[treeOptionsDoc release];
		}
	}
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
	
	//prepopulate database
	[self prepopulateDb];
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
	switch (indexPath.section) {
		case 0:
		{
			static NSString *LandscapeCellIdentifier = @"LandscapeCellIdentifier";
			
			LandscapeTableViewCell *landscapeCell = (LandscapeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:LandscapeCellIdentifier];
			if (landscapeCell == nil) {
				landscapeCell = [[[LandscapeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LandscapeCellIdentifier] autorelease];
				landscapeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			landscapeCell.landscape = [[filteredRecords objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
			return landscapeCell;
			break;
		}
		case 1:
		{
			//this will need to handle other types later
			static NSString *TreeCellIdentifier = @"TreeCellIdentifier";
			
			TreeTableViewCell *treeCell = (TreeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TreeCellIdentifier];
			if (treeCell == nil) {
				treeCell = [[[TreeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TreeCellIdentifier] autorelease];
				treeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			treeCell.tree = [[filteredRecords objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
			return treeCell;
			break;
		}
		case 2:
		{
			//this will need to handle other types later
			static NSString *AssessmentCellIdentifier = @"AssessmentTableViewCell";
			
			AssessmentTableViewCell *assessmentCell = (AssessmentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:AssessmentCellIdentifier];
			if (assessmentCell == nil) {
				NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AssessmentTableViewCell" owner:nil options:nil];
				for (id currentObject in topLevelObjects) {
					if ([currentObject isKindOfClass:[UITableViewCell class]]) {
						assessmentCell = (AssessmentTableViewCell *) currentObject;
						break;
					}
				}
			}
			assessmentCell.assessment = [[filteredRecords objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
			assessmentCell.landscapeName.text = assessmentCell.assessment.inventoryItem.landscape.name;
			assessmentCell.itemName.text = assessmentCell.assessment.inventoryItem.name;
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateStyle:NSDateFormatterLongStyle];
			NSString *date= [dateFormatter stringFromDate:assessmentCell.assessment.created_at];
			[dateFormatter release];
			assessmentCell.date.text = date;
			return assessmentCell;
			break;
		}
		default:
		{
			return [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"backup"] autorelease];
			break;
		}
	}
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}
/* Maybe we can find a good way to use this later
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	return [NSArray arrayWithObjects:@"Landscapes", @"Inventory", @"Assessments", nil];
}*/

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
		{
			NSDictionary *query = [NSDictionary dictionaryWithObject:[[filteredRecords objectAtIndex:0] objectAtIndex:indexPath.row] forKey:@"landscape"];
			[[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:@"land://Landscapes/LandscapeDetailView?"] applyQuery:query] applyAnimated:YES]];
			break;
		}
		case 1:
		{
			InventoryItem *item = [[filteredRecords objectAtIndex:1] objectAtIndex:indexPath.row];
			NSDictionary *query = [NSDictionary dictionaryWithObject:item forKey:@"inventorytree"];
			if([item.type.name isEqualToString:@"Tree"]) {
				[[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:@"land://Trees/TreeDetailView?"] applyQuery:query] applyAnimated:YES]];
			}
			break;
		}
		case 2:
		{
			Assessment *assessment = [[filteredRecords objectAtIndex:2] objectAtIndex:indexPath.row];
			NSDictionary *query = [NSDictionary dictionaryWithObject:assessment forKey:@"assessment"];
			if([assessment.inventoryItem.type.name isEqualToString:@"Tree"]) {
				[[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:@"land://assessments/TreeViewAndInput"] applyQuery:query] applyAnimated:YES]];
			}
			break;
		}
		default:
			break;
	}
}

#pragma mark -
#pragma mark IASKAppSettingsViewControllerDelegate protocol

- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
    [self dismissModalViewControllerAnimated:YES];
	
	// code here to reconfigure the app for changed settings
}

@end

