//
//  TreeAddViewController.m
//  Trees
//
//  Created by Sean Clifford on 1/3/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import "TreeAddViewController.h"
#import "InventoryTree.h"

@implementation TreeAddViewController

@synthesize tree;
@synthesize nameTextField;
@synthesize delegate;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[super viewDidLoad];
	
    // Configure navigation bar
	self.navigationItem.title=@"Add Tree";
	
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    [cancelButtonItem release];
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    [saveButtonItem release];
	
	[nameTextField becomeFirstResponder];
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == nameTextField) {
		[nameTextField resignFirstResponder];
		[self save];
	}
	return YES;
}

- (void)save {
    
    tree.name = nameTextField.text;
	tree.created_at = [NSDate date];
	
	NSError *error = nil;
	if (![tree.managedObjectContext save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}		
    
	[self.delegate treeAddViewController:self didAddTree:tree];
}

- (void)cancel {
	
	[tree.managedObjectContext deleteObject:tree];
	
	NSError *error = nil;
	if (![tree.managedObjectContext save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}		
	
    [self.delegate treeAddViewController:self didAddTree:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // All but upside down
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}



- (void)viewDidUnload {
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	self.nameTextField = nil;
	
}


- (void)dealloc {
	[tree release];
	[nameTextField release];
	[delegate release];
    [super dealloc];
}


@end
