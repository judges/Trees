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

@synthesize landscape;


@synthesize tableHeaderView, photoButton, nameTextField, address1TextField, cityTextField, stateTextField, zipTextField, gpsTextField;

#pragma mark -
#pragma mark View controller

- (void)viewDidLoad {
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Create and set the table header view.
    if (tableHeaderView == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"LandscapeDetailHeaderView" owner:self options:nil];
        self.tableView.tableHeaderView = tableHeaderView;
        self.tableView.allowsSelectionDuringEditing = YES;
		self.tableView.backgroundColor  = [UIColor colorWithRed:0.369 green:0.435 blue:0.200 alpha:1.0]; //darker green
		self.tableView.tableHeaderView.backgroundColor = [UIColor colorWithRed:0.369 green:0.435 blue:0.200 alpha:1.0]; //darker green
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
	
    [photoButton setImage:landscape.thumbnailImage forState:UIControlStateNormal];
	self.navigationItem.title = landscape.name;
    nameTextField.text = landscape.name;    
    address1TextField.text = landscape.address1;    
	cityTextField.text = landscape.city;
	stateTextField.text = landscape.state;
	zipTextField.text = landscape.zip;
    gpsTextField.text = landscape.gps;    
	[self updatePhotoButton];
	
	// Update landscape type and ingredients on return.
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
	
	// Delete any existing image.
	NSManagedObject *oldImage = landscape.image;
	if (oldImage != nil) {
		[landscape.managedObjectContext deleteObject:oldImage];
	}
	
    // Create an image object for the new image.
	NSManagedObject *image = [NSEntityDescription insertNewObjectForEntityForName:@"ImageLandscape" inManagedObjectContext:landscape.managedObjectContext];
	landscape.image = image;
	
	// Set the image for the image managed object.
	[image setValue:selectedImage forKey:@"image"];
	
	// Create a thumbnail version of the image for the landscape object.
	CGSize size = selectedImage.size;
	CGFloat ratio = 0;
	if (size.width > size.height) {
		ratio = 128.0 / size.width;
	} else {
		ratio = 128.0 / size.height;
	}
	CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
	
	UIGraphicsBeginImageContext(rect.size);
	[selectedImage drawInRect:rect];
	landscape.thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
    [self dismissModalViewControllerAnimated:YES];
}

/** generate thumbnail version of given image to show in properly **/
- (UIImage *)generatePhotoThumbnail:(UIImage *)image withRatio:(float)ratio {
	// first crop to a rectangle and then scale the cropped image to ratio
	CGRect cropRect;
	if (image.size.width == image.size.height) {
		// height and width are same - do not crop here
		cropRect = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
	} else if (image.size.width > image.size.height) {
		// width is longer - take height and adjust xgap to crop
		int xgap = (image.size.width - image.size.height)/2;
		cropRect = CGRectMake(xgap, 0.0, image.size.height, image.size.height);
	} else {
		// height is longer - take height and adjust ygap to crop
		int ygap = (image.size.height - image.size.width)/2;
		cropRect = CGRectMake(0.0, ygap, image.size.width, image.size.width);
	}
	// crop image with calcuted crop rect
	CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
	UIImage *cropped = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	// scale the image to ratio to create proper thumb
	NSData *pngData = UIImagePNGRepresentation(cropped);
	UIImage *myThumbNail    = [[UIImage alloc] initWithData:pngData];
	
	// begin an image context that will essentially keep our new image
	UIGraphicsBeginImageContext(CGSizeMake(ratio,ratio));
	
	// now redraw our image in a smaller rectangle.
	[myThumbNail drawInRect:CGRectMake(0.0, 0.0, ratio, ratio)];
	
	// make a copy of the image from the current context
	UIImage *newImage    = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	[myThumbNail release];
	return newImage;
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
	
	if (landscape.thumbnailImage != nil) {
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
    [address1TextField release];
    [cityTextField release];
    [stateTextField release];
    [zipTextField release];
    [gpsTextField release];
    [landscape release];
    [super dealloc];
}


@end
