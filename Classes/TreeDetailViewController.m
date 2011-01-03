//
//  TreeDetailViewController.m
//  Trees
//
//  Created by Sean Clifford on 1/3/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import "TreeDetailViewController.h"
#import "Tree.h"
#import "TreePhotoViewController.h"

@interface TreeDetailViewController (PrivateMethods)
- (void)updatePhotoButton;
@end

@implementation TreeDetailViewController

@synthesize tree;


@synthesize tableHeaderView, photoButton, nameTextField, gpsTextField;

#pragma mark -
#pragma mark View controller

- (void)viewDidLoad {
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Create and set the table header view.
    if (tableHeaderView == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"TreeDetailHeaderView" owner:self options:nil];
        self.tableView.tableHeaderView = tableHeaderView;
        self.tableView.allowsSelectionDuringEditing = YES;
		self.tableView.backgroundColor  = [UIColor colorWithRed:0.369 green:0.435 blue:0.200 alpha:1.0]; //darker green
		self.tableView.tableHeaderView.backgroundColor = [UIColor colorWithRed:0.369 green:0.435 blue:0.200 alpha:1.0]; //darker green
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
	
    [photoButton setImage:tree.thumbnailImage forState:UIControlStateNormal];
	self.navigationItem.title = tree.name;
    nameTextField.text = tree.name;    
    gpsTextField.text = tree.gps;    
	[self updatePhotoButton];
	
	// Update tree attributes and inventory items on return. - to be added later
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
	self.gpsTextField = nil;
	[super viewDidUnload];
}

#pragma mark -
#pragma mark Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
	[self updatePhotoButton];
	nameTextField.enabled = editing;
	gpsTextField.enabled = editing;
	[self.navigationItem setHidesBackButton:editing animated:YES];
	[self.tableView beginUpdates];
    [self.tableView endUpdates];
	
	
	/*
	 If editing is finished, save the managed object context.
	 */
	if (!editing) {
		
		NSManagedObjectContext *context = [(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate] managedObjectContext];
		NSError *error = nil;
		if (![context save:&error]) {
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
		tree.name = nameTextField.text;
		self.navigationItem.title = tree.name;
	}
	else if (textField == gpsTextField) {
		tree.gps = gpsTextField.text;
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
#pragma mark Photo

- (IBAction)photoTapped {
    // If in editing state, then display an image picker; if not, create and push a photo view controller.
	if (self.editing) {
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.delegate = self;
		[self presentModalViewController:imagePicker animated:YES];
		[imagePicker release];
	} else {	
		TreePhotoViewController *treePhotoViewController = [[TreePhotoViewController alloc] init];
        treePhotoViewController.hidesBottomBarWhenPushed = YES;
		treePhotoViewController.tree = tree;
		[self.navigationController pushViewController:treePhotoViewController animated:YES];
		[treePhotoViewController release];
	}
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo {
	
	// Delete any existing image.
	NSManagedObject *oldImage = tree.image;
	if (oldImage != nil) {
		[tree.managedObjectContext deleteObject:oldImage];
	}
	
    // Create an image object for the new image.
	NSManagedObject *image = [NSEntityDescription insertNewObjectForEntityForName:@"ImageTree" inManagedObjectContext:tree.managedObjectContext];
	tree.image = image;
	
	// Set the image for the image managed object.
	[image setValue:selectedImage forKey:@"image"];
	
	// Create a thumbnail version of the image for the tree object.
	// following code sourced at: http://tharindufit.wordpress.com/2010/04/19/how-to-create-iphone-photos-like-thumbs-in-an-iphone-app/
	
	CGFloat ratio = 128.0;
	
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
	tree.thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
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
	 How to present the photo button depends on the editing state and whether the tree has a thumbnail image.
	 * If the tree has a thumbnail, set the button's highlighted state to the same as the editing state (it's highlighted if editing).
	 * If the tree doesn't have a thumbnail, then: if editing, enable the button and show an image that says "Choose Photo" or similar; if not editing then disable the button and show nothing.  
	 */
	BOOL editing = self.editing;
	
	if (tree.thumbnailImage != nil) {
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
    [tableHeaderView release];
    [photoButton release];
    [nameTextField release];
    [gpsTextField release];
    [tree release];
    [super dealloc];
}


@end
