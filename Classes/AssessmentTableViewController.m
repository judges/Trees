//
//  AssessmentTableViewController.m
//  landscapes
//
//  Created by Evan Cordell on 7/26/10.
//  Copyright National Park Service/NCPTT 2010. All rights reserved.
//

#import "AssessmentTableViewController.h"


@implementation AssessmentTableViewController
@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize typesArray, landscapesArray;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	  // Name the navigation bar
    self.title = @"Assessments";
    
    //load managedObjectContext from AppDelegate
    if(!managedObjectContext){
        managedObjectContext = [(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    NSError *error=nil;
    
    //initialize actionsheet for adding new records
    typeActionSheet = [[UIActionSheet alloc] initWithTitle:@"Type" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    landscapeActionSheet = [[UIActionSheet alloc] initWithTitle:@"Landscape" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    //set up arrays for type and landscape picker
    typesArray = [[NSMutableArray alloc] init];
    landscapesArray = [[NSMutableArray alloc] init];
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    typePickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    landscapePickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
	
	  // Include an Add + button
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    self.navigationItem.rightBarButtonItem = addButtonItem;
    [addButtonItem release];	
	
	  // Set the table view's row height
    self.tableView.rowHeight = 52.0;
	
    //set up fetchedResultsController
    [self fetchedResultsController];

    //Perform fetch and catch any errors
    [fetchedResultsController performFetch:&error];
    
    //prepopulate if there are no records
    if ([[[fetchedResultsController sections] objectAtIndex:0] numberOfObjects] == 0) {
        [self prepopulateDb];
        [fetchedResultsController performFetch:&error];
    }
    
    //fetch data for type picker
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AssessmentType" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:[managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    for (AssessmentType *at in tmp) {
        [typesArray addObject:at];
    }
    
    //fetch data for landscape picker
    entity = [NSEntityDescription entityForName:@"Landscape" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    tmp = [NSMutableArray arrayWithArray:[managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    for (Landscape *l in tmp) {
        [landscapesArray addObject:l];
    }
    [fetchRequest release];
    
    if (error) {
        NSLog(@"Error occured fetching from db: %@", error);
    }
}
- (void)prepopulateDb {    
       
    Landscape *landscape = [NSEntityDescription insertNewObjectForEntityForName:@"Landscape" inManagedObjectContext:managedObjectContext];
    landscape.name = @"Test Landscape";
    
    AssessmentType *type = [NSEntityDescription insertNewObjectForEntityForName: @"AssessmentType" inManagedObjectContext:managedObjectContext];
    type.name = @"Tree";
    
    AssessmentTree *assessmentTree = [NSEntityDescription insertNewObjectForEntityForName:@"AssessmentTree" inManagedObjectContext:managedObjectContext];
    assessmentTree.assessor = @"Test Assessor";
    assessmentTree.created_at = [NSDate date];
    assessmentTree.landscape = landscape;
    assessmentTree.type = type;
	
	NSString *treeOptionsPath = [[NSBundle mainBundle] pathForResource:@"TreeOptions" ofType:@"xml"];
	NSData *treeOptionsData = [NSData dataWithContentsOfFile:treeOptionsPath];
	if (treeOptionsData) {
		DDXMLDocument *treeOptionsDoc = [[DDXMLDocument alloc] initWithData:treeOptionsData options:0 error:nil];
		DDXMLElement *rootNode = [treeOptionsDoc rootElement];
		//conditions
		for(DDXMLElement *option in [[[rootNode childAtIndex:0] childAtIndex:0] children])
		{
			TreeFormCondition *treeFormCondition = [NSEntityDescription insertNewObjectForEntityForName:@"TreeFormCondition" inManagedObjectContext:managedObjectContext];
			treeFormCondition.name = [option stringValue];
		}
		for(DDXMLElement *option in [[[rootNode childAtIndex:1] childAtIndex:0] children])
		{
			TreeCrownCondition *treeCrownCondition = [NSEntityDescription insertNewObjectForEntityForName:@"TreeCrownCondition" inManagedObjectContext:managedObjectContext];
			treeCrownCondition.name = [option stringValue];
		}
		for(DDXMLElement *option in [[[rootNode childAtIndex:2] childAtIndex:0] children])
		{
			TreeTrunkCondition *treeTrunkCondition = [NSEntityDescription insertNewObjectForEntityForName:@"TreeTrunkCondition" inManagedObjectContext:managedObjectContext];
			treeTrunkCondition.name = [option stringValue];
		}
		for(DDXMLElement *option in [[[rootNode childAtIndex:3] childAtIndex:0] children])
		{
			TreeRootFlareCondition *treeRootFlareCondition = [NSEntityDescription insertNewObjectForEntityForName:@"TreeRootFlareCondition" inManagedObjectContext:managedObjectContext];
			treeRootFlareCondition.name = [option stringValue];
		}
		for(DDXMLElement *option in [[[rootNode childAtIndex:4] childAtIndex:0] children])
		{
			TreeRootsCondition *treeRootsCondition = [NSEntityDescription insertNewObjectForEntityForName:@"TreeRootsCondition" inManagedObjectContext:managedObjectContext];
			treeRootsCondition.name = [option stringValue];
		}
		for(DDXMLElement *option in [[[rootNode childAtIndex:5] childAtIndex:0] children])
		{
			TreeOverallCondition *treeOverallCondition = [NSEntityDescription insertNewObjectForEntityForName:@"TreeOverallCondition" inManagedObjectContext:managedObjectContext];
			treeOverallCondition.name = [option stringValue];
		}
		//recommendations
		for(DDXMLElement *option in [[[rootNode childAtIndex:0] childAtIndex:1] children])
		{
			TreeFormRecommendation *treeFormRecommendation = [NSEntityDescription insertNewObjectForEntityForName:@"TreeFormRecommendation" inManagedObjectContext:managedObjectContext];
			treeFormRecommendation.name = [option stringValue];
		}
		for(DDXMLElement *option in [[[rootNode childAtIndex:1] childAtIndex:1] children])
		{
			TreeCrownRecommendation *treeCrownRecommendation = [NSEntityDescription insertNewObjectForEntityForName:@"TreeCrownRecommendation" inManagedObjectContext:managedObjectContext];
			treeCrownRecommendation.name = [option stringValue];
		}
		for(DDXMLElement *option in [[[rootNode childAtIndex:2] childAtIndex:1] children])
		{
			TreeTrunkRecommendation *treeTrunkRecommendation = [NSEntityDescription insertNewObjectForEntityForName:@"TreeTrunkRecommendation" inManagedObjectContext:managedObjectContext];
			treeTrunkRecommendation.name = [option stringValue];
		}
		for(DDXMLElement *option in [[[rootNode childAtIndex:3] childAtIndex:1] children])
		{
			TreeRootFlareRecommendation *treeRootFlareRecommendation = [NSEntityDescription insertNewObjectForEntityForName:@"TreeRootFlareRecommendation" inManagedObjectContext:managedObjectContext];
			treeRootFlareRecommendation.name = [option stringValue];
		}
		for(DDXMLElement *option in [[[rootNode childAtIndex:4] childAtIndex:1] children])
		{
			TreeRootsRecommendation *treeRootsRecommendation = [NSEntityDescription insertNewObjectForEntityForName:@"TreeRootsRecommendation" inManagedObjectContext:managedObjectContext];
			treeRootsRecommendation.name = [option stringValue];
		}
		for(DDXMLElement *option in [[[rootNode childAtIndex:5] childAtIndex:1] children])
		{
			TreeOverallRecommendation *treeOverallRecommendation = [NSEntityDescription insertNewObjectForEntityForName:@"TreeOverallRecommendation" inManagedObjectContext:managedObjectContext];
			treeOverallRecommendation.name = [option stringValue];
		}
		
		TreeForm *treeForm = [NSEntityDescription insertNewObjectForEntityForName:@"TreeForm" inManagedObjectContext:managedObjectContext];
		assessmentTree.form = treeForm;
		TreeCrown *treeCrown = [NSEntityDescription insertNewObjectForEntityForName:@"TreeCrown" inManagedObjectContext:managedObjectContext];
		assessmentTree.crown = treeCrown;
		TreeTrunk *treeTrunk = [NSEntityDescription insertNewObjectForEntityForName:@"TreeTrunk" inManagedObjectContext:managedObjectContext];
		assessmentTree.trunk = treeTrunk;
		TreeRootFlare *treeRootFlare = [NSEntityDescription insertNewObjectForEntityForName:@"TreeRootFlare" inManagedObjectContext:managedObjectContext];
		assessmentTree.rootflare = treeRootFlare;
		TreeRoots *treeRoots = [NSEntityDescription insertNewObjectForEntityForName:@"TreeRoots" inManagedObjectContext:managedObjectContext];
		assessmentTree.roots = treeRoots;
		TreeOverall *treeOverall = [NSEntityDescription insertNewObjectForEntityForName:@"TreeOverall" inManagedObjectContext:managedObjectContext];
		assessmentTree.overall = treeOverall;
		
		NSError *error;
		if (![managedObjectContext save:&error]) {
			NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
		}
		
		[treeOptionsDoc release];
	}
}

- (void)add:(id)sender {
    //show the type picker with close and select buttons
    [typeActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    
    typePickerView.showsSelectionIndicator = YES;
    typePickerView.dataSource = self;
    typePickerView.delegate = self;
    
    [typeActionSheet addSubview:typePickerView];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Close"]];
    closeButton.momentary = YES; 
    closeButton.frame = CGRectMake(10, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    [typeActionSheet addSubview:closeButton];
    [closeButton release];
    
    UISegmentedControl *selectButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Select"]];
    selectButton.momentary = YES; 
    selectButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    selectButton.segmentedControlStyle = UISegmentedControlStyleBar;
    selectButton.tintColor = [UIColor blackColor];
    [selectButton addTarget:self action:@selector(typeSelected:) forControlEvents:UIControlEventValueChanged];
    [typeActionSheet addSubview:selectButton];
    [selectButton release];
    
    [typeActionSheet showInView:self.view];
    [typeActionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    
    //select the first entry by default
    if([typePickerView numberOfRowsInComponent:0] > 0) {
        [self pickerView:typePickerView didSelectRow:0 inComponent:0];
    }
}

- (void)typeSelected:(id)sender {
    //type has been selected, so hide type picker and show landscape picker
    [typeActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    [landscapeActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    landscapePickerView.showsSelectionIndicator = YES;
    landscapePickerView.dataSource = self;
    landscapePickerView.delegate = self;
    
    [landscapeActionSheet addSubview:landscapePickerView];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Close"]];
    closeButton.momentary = YES; 
    closeButton.frame = CGRectMake(10, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    [landscapeActionSheet addSubview:closeButton];
    [closeButton release];
    
    UISegmentedControl *selectButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Select"]];
    selectButton.momentary = YES; 
    selectButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    selectButton.segmentedControlStyle = UISegmentedControlStyleBar;
    selectButton.tintColor = [UIColor blackColor];
    [selectButton addTarget:self action:@selector(landscapeSelected:) forControlEvents:UIControlEventValueChanged];
    [landscapeActionSheet addSubview:selectButton];
    [selectButton release];
    
    [landscapeActionSheet showInView:self.view];
    [landscapeActionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    
    //select the first entry by default
    if ([landscapePickerView numberOfRowsInComponent:0]>0) {
        [self pickerView:landscapePickerView didSelectRow:0 inComponent:0];
    }
     
}

- (void)landscapeSelected:(id)sender {
    //landscape and type have been selected, so hide landscape picker and add a new record to the db
    [landscapeActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    NSError *error;
    //this could easily be modified to insert objects dynamically rather than with an if.
    if ([selectedType.name isEqualToString:@"Tree"]) {
        AssessmentTree *new = [NSEntityDescription insertNewObjectForEntityForName:@"AssessmentTree" inManagedObjectContext:managedObjectContext];
        new.type = selectedType;
        new.landscape = selectedLandscape;
        new.created_at = [NSDate date];
        TreeCrown *treeCrown = [NSEntityDescription insertNewObjectForEntityForName:@"TreeCrown" inManagedObjectContext:managedObjectContext];
        new.crown = treeCrown;
        TreeForm *treeForm = [NSEntityDescription insertNewObjectForEntityForName:@"TreeForm" inManagedObjectContext:managedObjectContext];
        new.form = treeForm;
        TreeTrunk *treeTrunk = [NSEntityDescription insertNewObjectForEntityForName:@"TreeTrunk" inManagedObjectContext:managedObjectContext];
        new.trunk = treeTrunk;
        TreeRootFlare *treeRootFlare = [NSEntityDescription insertNewObjectForEntityForName:@"TreeRootFlare" inManagedObjectContext:managedObjectContext];
        new.rootflare = treeRootFlare;
        TreeRoots *treeRoots = [NSEntityDescription insertNewObjectForEntityForName:@"TreeRoots" inManagedObjectContext:managedObjectContext];
        new.roots = treeRoots;
        TreeOverall *treeOverall = [NSEntityDescription insertNewObjectForEntityForName:@"TreeOverall" inManagedObjectContext:managedObjectContext];
        new.overall = treeOverall;
        
        if (![managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        [self tableView:(UITableView *)(self.view) didSelectRowAtIndexPath:[fetchedResultsController indexPathForObject:new]];
    }
    
}

- (void)dismissActionSheet:(id)sender {
    //user clicks close on an action sheet
    [typeActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    [landscapeActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    //we only have one component in picker
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    //get number of rows for picker views
    if (thePickerView==typePickerView) {
        return [typesArray count];
    } else {
        return [landscapesArray count];
    }
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //load data into picker views
    if (thePickerView==typePickerView) {
        return [[typesArray objectAtIndex:row] name];
    } else {
        return [[landscapesArray objectAtIndex:row] name];
    }
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //set the selected type or row based on user interaction
    if (thePickerView==typePickerView) {
        selectedType = [typesArray objectAtIndex:row];
    } else {
        selectedLandscape = [landscapesArray objectAtIndex:row];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSInteger count = [[fetchedResultsController sections] count];
    
    if (count == 0) {
        count = 1;
    }
    NSLog(@"Number of Sections fetched: %d", count);
    return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    NSLog(@"Number of Rows fetched: %d", [sectionInfo numberOfObjects]);
    
    return [sectionInfo numberOfObjects];
    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	// Define your row
    NSInteger row = [indexPath row];
	
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
	[self configureCell:assessmentCell atIndexPath:indexPath];
    
    if (row % 2)
        [assessmentCell setBackgroundColor:[UIColor colorWithRed:0.616f green:0.616f blue:0.627f alpha:1.0f]];
    else
        [assessmentCell setBackgroundColor:[UIColor colorWithRed:0.525f green:0.5250f blue:0.541f alpha:1.0f]];
    
    return assessmentCell;
}
- (void)configureCell:(AssessmentTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell
    Assessment *assessment = (Assessment *)[fetchedResultsController objectAtIndexPath:indexPath];
    cell.assessment = assessment;
    cell.landscapeName.text = assessment.landscape.name;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    NSString *date= [dateFormatter stringFromDate:assessment.created_at];
    [dateFormatter release];
    cell.date.text = date;
    cell.typeName.text = assessment.type.name;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [managedObjectContext deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
        NSError *error;
        [managedObjectContext save:&error];
    }   
}



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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Assessment *assessment = (Assessment *)[fetchedResultsController objectAtIndexPath:indexPath];
    NSDictionary *query = [NSDictionary dictionaryWithObject:assessment forKey:@"assessment"];
    if([assessment.type.name isEqualToString:@"Tree"]) {
        [[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:@"land://assessments/TreeViewAndInput"] applyQuery:query] applyAnimated:YES]];
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
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Assessment" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"assessment_cache"];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
        
        [aFetchedResultsController release];
        [fetchRequest release];
        [sortDescriptor release];
        [sortDescriptors release];
    }
    
    return fetchedResultsController;
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
            [self configureCell:(AssessmentTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
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

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [typesArray release];
    [landscapesArray release];
    [typePickerView release];
    [landscapePickerView release];
    [typeActionSheet release];
    [landscapeActionSheet release];
    [fetchedResultsController release];
    [super dealloc];
}


@end

