//
//  AssessmentTreeCRViewController.m
//  landscapes
//
//  Created by Evan Cordell on 8/3/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import "AssessmentTreeCRViewController.h"



@implementation AssessmentTreeCRViewController

@synthesize whichId, conditionStringArray, recommendationStringArray, conditionArray, recommendationArray, treePart, isEditing, conditionTableView, recommendationTableView;
@synthesize selectedConditionIndices, selectedRecommendationIndices, tapCount, tapTimer, tappedRow, editingRow;

-(id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query { 
    if (self = [super initWithNibName:@"AssessmentTreeCRView" bundle:[NSBundle mainBundle]]){
        if(query && [query objectForKey:@"treePart"] && [query objectForKey:@"id"]){ 
            //Grabs the id that called the page so we know which properties to load.
            whichId = [query objectForKey:@"id"];
			//set tap count to zero
			tapCount = 0;
			//set tappedRow
			tappedRow = 0;
			//no rows being edited at start
			editingRow = -1;
            //pass the TreeAssessment from the previous view
            treePart = [query objectForKey:@"treePart"];
            //initialize the arrays to store the conditions and recommendations
            conditionStringArray = [[NSMutableArray alloc] init];
            recommendationStringArray = [[NSMutableArray alloc] init];
            //create imagepicker
            imagePicker = [[UIImagePickerController alloc] init];
			//create textbox for popup
			addTextField = [[UITextField alloc] initWithFrame:CGRectMake(15.0, 45.0, 254.0, 25.0)];
			[addTextField setBackgroundColor:[UIColor whiteColor]];
            //set appropriate title
            switch ([whichId intValue]) {
                case 1:
                    self.title = @"Tree Form";
                    break;
                case 2:
                    self.title = @"Tree Crown";
                    break;
                case 3:
                    self.title = @"Tree Trunk";
                    break;
                case 4:
                    self.title = @"Tree Root Flare";
                    break;
                case 5:
                    self.title = @"Tree Roots";
                    break;
                case 6:
                    self.title = @"Tree Overall";
                    break;
                default:
                    break;
            }
        }
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //load data into the condition and recommendation arrays from core data
    if(!managedObjectContext){
        managedObjectContext = [(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
	// Include an Add + button
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    self.navigationItem.rightBarButtonItem = addButtonItem;
    [addButtonItem release];
	
	//fetch all of the options
    NSFetchRequest *cFetchRequest = [[NSFetchRequest alloc] init];
    NSFetchRequest *rFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *cEntity = [NSEntityDescription entityForName:@"PartCondition" inManagedObjectContext:managedObjectContext];
    NSEntityDescription *rEntity = [NSEntityDescription entityForName:@"PartRecommendation" inManagedObjectContext:managedObjectContext];
	[cFetchRequest setEntity:cEntity];
    [rFetchRequest setEntity:rEntity];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(partType == %@)", treePart.partType];
	[cFetchRequest setPredicate:predicate];
	[rFetchRequest setPredicate:predicate];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [cFetchRequest setSortDescriptors:sortDescriptors];
    [rFetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    conditionArray = [[NSMutableArray alloc] initWithArray:[managedObjectContext executeFetchRequest:cFetchRequest error:&error]];
    recommendationArray = [[NSMutableArray alloc] initWithArray:[managedObjectContext executeFetchRequest:rFetchRequest error:&error]];
    selectedConditionIndices = [[NSMutableArray alloc] init];
    selectedRecommendationIndices = [[NSMutableArray alloc] init];
	
	//determine selected indices
	[self findSelectedItems];
	
	//add names to seperate string array
    for (PartOption *item in conditionArray)
	{
		[conditionStringArray addObject:item.name];
	}
	for (PartOption *item in recommendationArray)
	{
		[recommendationStringArray addObject:item.name];
	}
	
    [cFetchRequest release];
    [rFetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
}
- (void)findSelectedItems {
	int cCtr = 0;
    int rCtr = 0;
	[selectedConditionIndices removeAllObjects];
	[selectedRecommendationIndices removeAllObjects];
    for (PartCondition *item in conditionArray) {
		if ([[treePart valueForKey:@"condition"] containsObject:item]) {
			[selectedConditionIndices addObject:[NSNumber numberWithInt:cCtr]];
		}
		++cCtr;
	}
	for (PartRecommendation *item in recommendationArray) {
		if ([[treePart valueForKey:@"recommendation"] containsObject:item]) {
			[selectedRecommendationIndices addObject:[NSNumber numberWithInt:rCtr]];
		}
		++rCtr;
	}      
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // There is only one section.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return number of rows for each tableview
	if (tableView == self.conditionTableView) {
        return [conditionArray count];
    } else if (tableView == self.recommendationTableView) {
        return [recommendationArray count];
    } else {
        // shouldn't get here
		return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	//Grab the recommendations and conditions from the arrays and populate the tableviews
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CR"] autorelease];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	if (tableView == self.conditionTableView) {
		cell.textLabel.text = [conditionStringArray objectAtIndex:indexPath.row];
		for (NSNumber *selected in selectedConditionIndices) {
			if ([selected intValue] == indexPath.row) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
		}
    } else if (tableView == self.recommendationTableView) {
        cell.textLabel.text = [recommendationStringArray objectAtIndex:indexPath.row];
		for (NSNumber *selected in selectedRecommendationIndices) {
			if ([selected intValue] == indexPath.row) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
		}
	}    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//checking for double taps here
    if(tapCount == 1 && tapTimer != nil && tappedRow == indexPath.row){
        //double tap -- call up the edit screen
		tapCount = 0;
        [tapTimer invalidate];
        [self setTapTimer:nil];
		
		//set editing bool
		isEditing = TRUE;
		editingRow = indexPath.row;
		
		//show alert entrybox
        if ([conditionTableView isHidden]) {
			UIAlertView *editAlertView = [[UIAlertView alloc] initWithTitle:@"Edit Recommendation" message:@"this gets covered" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
			addTextField.text = [recommendationStringArray objectAtIndex:indexPath.row];
			[editAlertView addSubview:addTextField];
			[editAlertView show];
			[editAlertView release];
		} else {
			UIAlertView *editAlertView = [[UIAlertView alloc] initWithTitle:@"Edit Condition" message:@"this gets covered" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
			addTextField.text = [conditionStringArray objectAtIndex:indexPath.row];
			[editAlertView addSubview:addTextField];
			[editAlertView show];
			[editAlertView release];
		}
		
    }
    else if(tapCount == 0){
        //This is the first tap -- toggle the checkmark
        tapCount = tapCount + 1;
        tappedRow = indexPath.row;
		
		//This is essentially a complex selector call to the singleTap function using an NSInvocation
		NSMethodSignature *singleTapSignature = [AssessmentTreeCRViewController instanceMethodSignatureForSelector:@selector(singleTapWithATableView:withAnIndexPath:)];
		NSInvocation *singleTapInvocation = [NSInvocation invocationWithMethodSignature:singleTapSignature];
		[singleTapInvocation setTarget:self];
		[singleTapInvocation setSelector:@selector(singleTapWithATableView:withAnIndexPath:)];
		//This may seem wrong, but arguments 0 and 1 are reserved internally by objc, so 2 and 3 is right
		[singleTapInvocation setArgument:&tableView atIndex:2];
		[singleTapInvocation setArgument:&indexPath atIndex:3];
		
		[self setTapTimer:[NSTimer scheduledTimerWithTimeInterval:0.3 invocation:singleTapInvocation repeats:NO]];
    }
    else if(tappedRow != indexPath.row){
        //tap on new row
        tapCount = 0;
        if(tapTimer != nil){
			[tapTimer invalidate];
			[self setTapTimer:nil];
        }
    }
}

- (void)singleTapWithATableView:(UITableView *)tableView withAnIndexPath:(NSIndexPath *)indexPath {
	if(tapTimer != nil){
        tapCount = 0;
        tappedRow = -1;
    }
	//check if unchecked and uncheck if checked, persist those changes in the datastore
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	if (cell.accessoryType == UITableViewCellAccessoryNone) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		if (tableView == self.conditionTableView) {
			[selectedConditionIndices addObject:[NSNumber numberWithInt: indexPath.row]];
			[[treePart mutableSetValueForKey:@"condition"] addObject:[conditionArray objectAtIndex:indexPath.row]];
		} else if (tableView == self.recommendationTableView) {
			[selectedRecommendationIndices addObject:[NSNumber numberWithInt: indexPath.row]];
			[[treePart mutableSetValueForKey:@"recommendation"] addObject:[recommendationArray objectAtIndex:indexPath.row]];
		} 
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
		if (tableView == self.conditionTableView) {
			[selectedConditionIndices removeObject:[NSNumber numberWithInt: indexPath.row]];
			[[treePart mutableSetValueForKey:@"condition"] removeObject:[conditionArray objectAtIndex:indexPath.row]];
		} else if (tableView == self.recommendationTableView) {
			[selectedRecommendationIndices removeObject:[NSNumber numberWithInt: indexPath.row]];
			[[treePart mutableSetValueForKey:@"recommendation"] removeObject:[recommendationArray objectAtIndex:indexPath.row]];
		}
	}
	NSError *error;
	if (![managedObjectContext save:&error]) {
		NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
	}
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	//Enables swipe to delete
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		if ([conditionTableView isHidden]) {
			[self deleteRecommendation:[indexPath row]];
			[recommendationTableView reloadData];
		} else {
			[self deleteCondition:[indexPath row]];
			[conditionTableView reloadData];
		}

	}
}

-(IBAction)segmentSwitch:(id)sender {
    //switch between the views for condition and recommendation
    UISegmentedControl *segmentedButton = (UISegmentedControl *) sender;
    if (segmentedButton.selectedSegmentIndex == 0) {
        [conditionTableView setHidden:NO];
        [recommendationTableView setHidden:YES];
    } else {
        [conditionTableView setHidden:YES];
        [recommendationTableView setHidden:NO];
    }
}

- (void)add:(id)sender {
	//set editing bool
	isEditing = FALSE;
	
	//show modal entry box
	if ([conditionTableView isHidden]) {
		UIAlertView *addAlertView = [[UIAlertView alloc] initWithTitle:@"Enter Recommendation" message:@"this gets covered" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
		[addAlertView addSubview:addTextField];
		[addAlertView show];
		[addAlertView release];
	} else {
		UIAlertView *addAlertView = [[UIAlertView alloc] initWithTitle:@"Enter Condition" message:@"this gets covered" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
		[addAlertView addSubview:addTextField];
		[addAlertView show];
		[addAlertView release];
	}
}

//UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0: //Cancel clicked
			break;
		case 1: //OK clicked
			if ([conditionTableView isHidden]) {
				if (isEditing) {
					[self editRecommendation];
				} else {
					[self addRecommendation];
				}
				[recommendationTableView reloadData];
			} else {
				if (isEditing) {
					[self editCondition];
				} else {
					[self addCondition];
				}
				[conditionTableView reloadData];
			}
			break;
		default:
			break;
	}
	addTextField.text = @"";
}

- (void)didPresentAlertView:(UIAlertView *)alertView {
	//show the keyboard when the modal view pops up
	[addTextField becomeFirstResponder];
}

- (void)addCondition {
    //adds a new condition record
	PartCondition *item = [NSEntityDescription insertNewObjectForEntityForName:@"PartCondition" inManagedObjectContext:managedObjectContext];
	item.name = [addTextField text];
	[conditionArray addObject:item];
	[[treePart mutableSetValueForKey:@"condition"] addObject:item];
	
	NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
	NSString *conditionString = [NSString stringWithString:[addTextField text]];
    [conditionStringArray addObject:conditionString];
	//resort string and object arrays
	[conditionStringArray sortUsingDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES] autorelease]]];
	[conditionArray sortUsingDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease]]];
	//recalculate selected indices
	[self findSelectedItems];
}

- (void)addRecommendation {
    //adds a new recommendation record
	PartRecommendation *item = [NSEntityDescription insertNewObjectForEntityForName:@"PartRecommendation" inManagedObjectContext:managedObjectContext];
	item.name = [addTextField text];
	[recommendationArray addObject:item];
	[[treePart mutableSetValueForKey:@"recommendation"] addObject:item];
	
	NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    NSString *recommendationString = [NSString stringWithString:[addTextField text]];
    [recommendationStringArray addObject:recommendationString];
	//resort string and object arrays
	[recommendationStringArray sortUsingDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES] autorelease]]];
	[recommendationArray sortUsingDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease]]];
	//recalculate selected indices
	[self findSelectedItems];
}
	 
- (void)editCondition {
    //edit existing condition record
	[self deleteCondition:editingRow];
	[self addCondition];
}

- (void)editRecommendation {
    //edit existing recommendation record
	[self deleteRecommendation:editingRow];
	[self addRecommendation];
}

- (void)deleteCondition:(NSInteger)row {
    //delete a condition record
	PartOption *item = [conditionArray objectAtIndex:row];
	[managedObjectContext deleteObject:item];
    NSError *error;
    if (![managedObjectContext save:&error]) {
       NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    } else {
		//only remove from screen if it's removed from the db (this should always happen)
		[conditionArray removeObjectAtIndex:row];
		[conditionStringArray removeObjectAtIndex:row];
	}
	//resort string and object arrays
	[conditionStringArray sortUsingDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES] autorelease]]];
	[conditionArray sortUsingDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease]]];
	//recalculate selected indices
	[self findSelectedItems];
}

- (void)deleteRecommendation:(NSInteger)row {
    //delete a recommendation entry
	PartOption *item = [recommendationArray objectAtIndex:row];
	[managedObjectContext deleteObject:item];
    NSError *error;
    if (![managedObjectContext save:&error]) {
		NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    } else {
		//only remove from screen if it's removed from the db (this should always happen)
		[recommendationArray removeObjectAtIndex:row];
		[recommendationStringArray removeObjectAtIndex:row];
	}
	//resort string and object arrays
	[recommendationStringArray sortUsingDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES] autorelease]]];
	[recommendationArray sortUsingDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease]]];
	//recalculate selected indices
	[self findSelectedItems];
}
			 
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


-(IBAction)photoButtonClick:(id)sender {
    //user clicked photo button
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Add Existing", @"View Photos", nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleDefault;
    [popupQuery showInView:self.view];
    [popupQuery release];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera; 
        imagePicker.allowsEditing = NO; 
        imagePicker.delegate = self;
        [self presentModalViewController:imagePicker animated:YES];
    } else if (buttonIndex == 1) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; 
        imagePicker.allowsEditing = NO; 
        imagePicker.delegate = self;
        [self presentModalViewController:imagePicker animated:YES];
    } else if (buttonIndex == 2) {
        //flip to ttimageview thing
        NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:@"TreePart", @"entity", [treePart objectID] , @"objectID", nil];
		[[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:@"land://Photos"] applyQuery:query] applyAnimated:YES]];
    } else if (buttonIndex == 3) {
        //cancel
    }
}

- (void)imagePickerController: (UIImagePickerController *)picker
        didFinishPickingImage: (UIImage *)image
                  editingInfo: (NSDictionary *)editingInfo {
    
    Image *newPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:managedObjectContext];
    newPhoto.image_data = UIImageJPEGRepresentation(image, 1.0);
	newPhoto.image_caption = @"Tree Part";
	NSMutableSet *photos = [treePart mutableSetValueForKey:@"images"];
	[photos addObject:newPhoto];
	[treePart setValue:photos forKey:@"images"];
    
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error saving image: %@", error);
    }
    [managedObjectContext processPendingChanges];
    [[imagePicker parentViewController] dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
    // in case of cancel, get rid of picker
    [[picker parentViewController] dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"Memory Warning");
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[treePart release];
	[whichId release];
	[tapTimer release];
    [conditionStringArray release];
    [recommendationStringArray release];
    [conditionArray release];
    [recommendationArray release];
	[selectedConditionIndices release];
	[selectedRecommendationIndices release];
	[conditionTableView release];
	[recommendationTableView release];
    [imagePicker release];
	[addTextField release];
    [super dealloc];
}


@end
