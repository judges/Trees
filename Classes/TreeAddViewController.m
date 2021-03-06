//
//  TreeAddViewController.m
//  Trees
//
//  Created by Sean Clifford on 1/3/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import "TreeAddViewController.h"
#import "InventoryTree.h"
#import "Landscape.h"
#import "Type.h"
#import "AppDelegate_Shared.h"

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
    NSError *error = nil;

	/*Note to Sean:
	   The code that was here before was adding new "American Cemetery" and "Tree" records every time it ran
	   which bothered me so I changed it to this. Now new trees will point to the existing American Cemetery
	   and Tree objects in core data.
	 
	   But, you're going to have to get rid of this eventually, because the user should be selecting the type and the landscape
	   Although this code could be useful for that, too.
	 */
	
	NSManagedObjectContext *managedObjectContext = [(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Type" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name == %@)", @"Tree"];
	[fetchRequest setPredicate:predicate];
	Type *treeType = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] objectAtIndex:0];
	
	
	entity = [NSEntityDescription entityForName:@"Landscape" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	predicate = [NSPredicate predicateWithFormat:@"(name == %@)", @"American Cemetery"];
	[fetchRequest setPredicate:predicate];
	Landscape *landscape = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] objectAtIndex:0]; 
	[fetchRequest release];
	
	tree.type = treeType;
	
    tree.name = nameTextField.text;
	tree.created_at = [NSDate date];
	tree.landscape = landscape;
	
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
