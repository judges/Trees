//
//  LandscapeDetailViewController.m
//  Trees
//
//  Created by Sean Clifford on 12/22/10.
//  Copyright 2010 NCPTT/National Park Service. All rights reserved.
//

#import "LandscapeDetailViewController.h"
#import "Landscape.h"
#import "LandscapePhotoViewController.h"

@interface LandscapeDetailViewController (PrivateMethods)
- (void)updatePhotoButton;
@end

@implementation LandscapeDetailViewController

@synthesize landscape, assessmentArray;

@synthesize tableHeaderView, photoButton, nameTextField, address1TextField, cityTextField, stateTextField, zipTextField, gpsTextField;

#pragma mark -
#pragma mark View controller

-(id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query { 
    //initializes and passes landscape from parent controller
	if(query && [query objectForKey:@"landscape"]){ 
		self.landscape = (Landscape*) [query objectForKey:@"landscape"]; 
	} 
    return self; 
} 

- (void)viewDidLoad {
	[super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Create and set the table header view.
    if (tableHeaderView == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"LandscapeDetailHeaderView" owner:self options:nil];
        self.tableView.tableHeaderView = tableHeaderView;
        self.tableView.allowsSelectionDuringEditing = YES;
		self.tableView.backgroundColor  = [UIColor colorWithRed:0.369 green:0.435 blue:0.200 alpha:1.0]; //darker green
		self.tableView.tableHeaderView.backgroundColor = [UIColor colorWithRed:0.369 green:0.435 blue:0.200 alpha:1.0]; //darker green
    }
	
	//load assosciated assessment records
	assessmentArray = [[NSMutableArray alloc] initWithCapacity:0];
	NSArray *descriptors = [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO] autorelease]];
	NSArray *tempArray = [[NSArray alloc] initWithArray:[[landscape mutableSetValueForKey:@"inventoryItems"] sortedArrayUsingDescriptors:descriptors]];
	for (InventoryItem *i in tempArray) {
		[assessmentArray addObjectsFromArray:[NSArray arrayWithArray:[i.assessments sortedArrayUsingDescriptors:descriptors]]];
	}
	[tempArray release];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
	for (Image *i in [landscape mutableSetValueForKeyPath:@"images"]) {
		if ([i.isThumbnail boolValue] == YES) {
			[photoButton setImage:[UIImage imageWithData:i.image_data] forState:UIControlStateNormal];
		}
	}
    
	self.navigationItem.title = landscape.name;
    nameTextField.text = landscape.name;    
    address1TextField.text = landscape.address1;    
	cityTextField.text = landscape.city;
	stateTextField.text = landscape.state;
	zipTextField.text = landscape.zip;
    gpsTextField.text = landscape.gps;    
	[self updatePhotoButton];
	
	// Update landscape attributes and inventory items on return. - to be added later
    [self.tableView reloadData]; 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    self.tableHeaderView = nil;
	self.photoButton = nil;
	self.nameTextField = nil;
	self.address1TextField = nil;
	self.cityTextField = nil;
	self.stateTextField = nil;
	self.zipTextField = nil;
	self.gpsTextField = nil;
	[super viewDidUnload];
}

#pragma mark -
#pragma mark Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
	[self updatePhotoButton];
	nameTextField.enabled = editing;
	address1TextField.enabled = editing;
	cityTextField.enabled = editing;
	stateTextField.enabled = editing;
	zipTextField.enabled = editing;
	gpsTextField.enabled = editing;
	[self.navigationItem setHidesBackButton:editing animated:YES];
	[self.tableView beginUpdates];
    [self.tableView endUpdates];
	

	/*
	 If editing is finished, save the managed object context.
	 */
	if (!editing) {
		
		NSError *error = nil;
		if (![[(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate] managedObjectContext] save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	
	if (textField == nameTextField) {
		landscape.name = nameTextField.text;
		self.navigationItem.title = landscape.name;
	}
	else if (textField == address1TextField) {
		landscape.address1 = address1TextField.text;
	}
	else if (textField == cityTextField) {
		landscape.city = cityTextField.text;
	}
	else if (textField == stateTextField) {
		landscape.state = stateTextField.text;
	}
	else if (textField == zipTextField) {
		landscape.zip = zipTextField.text;
	}
	else if (textField == gpsTextField) {
		landscape.gps = gpsTextField.text;
	}
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}


#pragma mark -
#pragma mark Moving rows

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL canMove = NO;

    return canMove;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	//just one for now
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [assessmentArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	//Right now there are only tree assessments so this is pretty simple
	//But this is loading the nibs from the assessment page, eventually we should create cells specifically for this table
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
	return assessmentCell;
}

- (void)configureCell:(AssessmentTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	Assessment *assessment = [assessmentArray objectAtIndex:indexPath.row];
	cell.assessment = assessment;
	//This logic should probably be moved into the assessment cell class, since it only needs the assessment to fill the rest in
//	cell.landscapeName.text = assessment.landscape.name;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    NSString *date= [dateFormatter stringFromDate:assessment.created_at];
    [dateFormatter release];
    cell.date.text = date;
    cell.itemName.text = assessment.inventoryItem.name;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Assessment *assessment = [assessmentArray objectAtIndex:indexPath.row];
    NSDictionary *query = [NSDictionary dictionaryWithObject:assessment forKey:@"assessment"];
    if([assessment.type.name isEqualToString:@"Tree"]) {
        [[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:@"land://assessments/TreeViewAndInput"] applyQuery:query] applyAnimated:YES]];
    }
}

#pragma mark -
#pragma mark Photo

- (IBAction)photoTapped {
    // If in editing state, then display an image picker; if not, create and push a photo view controller.
	if (self.editing) {
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.delegate = self;
		[self presentModalViewController:imagePicker animated:YES];
		[imagePicker release];
	} else {	
		LandscapePhotoViewController *landscapePhotoViewController = [[LandscapePhotoViewController alloc] init];
        landscapePhotoViewController.hidesBottomBarWhenPushed = YES;
		landscapePhotoViewController.landscape = landscape;
		[self.navigationController pushViewController:landscapePhotoViewController animated:YES];
		[landscapePhotoViewController release];
	}
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo {
	
	for (Image *i in [landscape mutableSetValueForKeyPath:@"images"]) {
		if ([i.isThumbnail boolValue] == YES) {
			i.isThumbnail = [NSNumber numberWithBool: NO];
		}
	}
	
    // Create an image object for the new image.
	Image *image = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:landscape.managedObjectContext];
	image.isThumbnail = [NSNumber numberWithBool:YES];
	[[landscape mutableSetValueForKey:@"images"] addObject:image];
	
	// Set the image for the image managed object.
	image.image_data = UIImageJPEGRepresentation(selectedImage, 1.0);
	
	// Create a thumbnail version of the image for the landscape object.
	// following code sourced at: http://tharindufit.wordpress.com/2010/04/19/how-to-create-iphone-photos-like-thumbs-in-an-iphone-app/
	
	CGFloat ratio = 100.0;

	// first crop to a rectangle and then scale the cropped image to ratio
	CGRect cropRect;
	if (selectedImage.size.width == selectedImage.size.height) {
		// height and width are same - do not crop here
		cropRect = CGRectMake(0.0, 0.0, selectedImage.size.width, selectedImage.size.height);
	} else if (selectedImage.size.width > selectedImage.size.height) {
		// width is longer - take height and adjust xgap to crop
		int xgap = (selectedImage.size.width - selectedImage.size.height)/2;
		cropRect = CGRectMake(xgap, 0.0, selectedImage.size.height, selectedImage.size.height);
	} else {
		// height is longer - take height and adjust ygap to crop
		int ygap = (selectedImage.size.height - selectedImage.size.width)/2;
		cropRect = CGRectMake(0.0, ygap, selectedImage.size.width, selectedImage.size.width);
	}
	// crop image with calcuted crop rect
	CGImageRef imageRef = CGImageCreateWithImageInRect([selectedImage CGImage], cropRect);
	UIImage *cropped = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	// scale the image to ratio to create proper thumb
	NSData *pngData = UIImagePNGRepresentation(cropped);
	UIImage *myThumbNail    = [[UIImage alloc] initWithData:pngData];
	
	// begin an image context that will essentially keep our new image
	UIGraphicsBeginImageContext(CGSizeMake(ratio,ratio));
	
	// now redraw our image in a smaller rectangle.
	[myThumbNail drawInRect:CGRectMake(0.0, 0.0, ratio, ratio)];
	
	// save the image from the current context
	image.image_data = UIImageJPEGRepresentation(UIGraphicsGetImageFromCurrentImageContext(), 1.0);
	UIGraphicsEndImageContext();

	//[selectedImage drawInRect:rect];
	[myThumbNail release];	
	
	
    [self dismissModalViewControllerAnimated:YES];
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}


- (void)updatePhotoButton {
	/*
	 How to present the photo button depends on the editing state and whether the landscape has a thumbnail image.
	 * If the landscape has a thumbnail, set the button's highlighted state to the same as the editing state (it's highlighted if editing).
	 * If the landscape doesn't have a thumbnail, then: if editing, enable the button and show an image that says "Choose Photo" or similar; if not editing then disable the button and show nothing.  
	 */
	BOOL editing = self.editing;
	BOOL hasThumb = NO;
	for (Image *i in [landscape mutableSetValueForKeyPath:@"images"]) {
		if ([i.isThumbnail boolValue] == YES) {
			hasThumb = YES;
		}
	}
	if (hasThumb == YES) {
		photoButton.highlighted = editing;
	} else {
		photoButton.enabled = editing;
		
		if (editing) {
			[photoButton setImage:[UIImage imageNamed:@"photo_camera.png"] forState:UIControlStateNormal];
		} else {
			//[photoButton setImage:nil forState:UIControlStateNormal];
			[photoButton setImage:[UIImage imageNamed:@"photo_camera.png"] forState:UIControlStateNormal];
		}
	}
}


#pragma mark -
#pragma mark dealloc

- (void)dealloc {
	[assessmentArray release];
    [tableHeaderView release];
    [photoButton release];
    [nameTextField release];
    [address1TextField release];
    [cityTextField release];
    [stateTextField release];
    [zipTextField release];
    [gpsTextField release];
    [super dealloc];
}


@end
