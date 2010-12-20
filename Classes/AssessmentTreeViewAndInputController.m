//
//  AssessmentViewAndInput.m
//  landscapes
//
//  Created by Evan Cordell on 8/2/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import "AssessmentTreeViewAndInputController.h"


@implementation AssessmentTreeViewAndInputController

@synthesize assessmentTree, assessor, date, caliper, height;
@synthesize formCText, crownCText, trunkCText, rootFlareCText, rootsCText, overallCText;
@synthesize formRText, crownRText, trunkRText, rootFlareRText, rootsRText, overallRText;
@synthesize assessorField, caliperField, heightField;

-(id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query { 
    //initializes and passes assessment from parent controller
    if (self = [super initWithNibName:@"AssessmentTreeViewAndInput" bundle:[NSBundle mainBundle]]){ 
        if(query && [query objectForKey:@"assessment"]){ 
            self.assessmentTree = (AssessmentTree*) [query objectForKey:@"assessment"]; 
            imagePicker = [[UIImagePickerController alloc] init];
        } 
    } 
    return self; 
} 
-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    if (self.assessmentTree) {
        self.caliper.text = [NSString stringWithFormat:@"%@ \'", [self.assessmentTree.caliper stringValue]];
        self.height.text = [NSString stringWithFormat:@"%@ \'", [self.assessmentTree.height stringValue]];
        self.formCText.text = self.assessmentTree.form.condition.name;
        self.crownCText.text = self.assessmentTree.crown.condition.name;
        self.trunkCText.text = self.assessmentTree.trunk.condition.name;
        self.rootFlareCText.text = self.assessmentTree.rootflare.condition.name;
        self.rootsCText.text = self.assessmentTree.roots.condition.name;
        self.overallCText.text = self.assessmentTree.overall.condition.name;
        self.formRText.text = self.assessmentTree.form.recommendation.name;
        self.crownRText.text = self.assessmentTree.crown.recommendation.name;
        self.trunkRText.text = self.assessmentTree.trunk.recommendation.name;
        self.rootFlareRText.text = self.assessmentTree.rootflare.recommendation.name;
        self.rootsRText.text = self.assessmentTree.roots.recommendation.name;
        self.overallRText.text = self.assessmentTree.overall.recommendation.name;
        self.assessorField.text = self.assessmentTree.assessor;
        self.caliperField.text = [self.assessmentTree.caliper stringValue];
        self.heightField.text = [self.assessmentTree.height stringValue];
    }
    if (self.formCText.text == nil || self.formRText.text == nil) {
        [button1 setBackgroundImage:[UIImage imageNamed:@"button-notdone.png"] forState:UIControlStateNormal];
    } else {
        [button1 setBackgroundImage:[UIImage imageNamed:@"button-default.png"] forState:UIControlStateNormal];
    }
    if (self.crownCText.text == nil || self.crownRText.text == nil) {
        [button2 setBackgroundImage:[UIImage imageNamed:@"button-notdone.png"] forState:UIControlStateNormal];
    } else {
        [button2 setBackgroundImage:[UIImage imageNamed:@"button-default.png"] forState:UIControlStateNormal];
    }
    if (self.trunkCText.text == nil || self.trunkRText.text == nil) {
        [button3 setBackgroundImage:[UIImage imageNamed:@"button-notdone.png"] forState:UIControlStateNormal];
    } else {
        [button3 setBackgroundImage:[UIImage imageNamed:@"button-default.png"] forState:UIControlStateNormal];
    }
    if (self.rootFlareCText.text == nil || self.rootFlareRText.text == nil) {
        [button4 setBackgroundImage:[UIImage imageNamed:@"button-notdone.png"] forState:UIControlStateNormal];
    } else {
        [button4 setBackgroundImage:[UIImage imageNamed:@"button-default.png"] forState:UIControlStateNormal];
    }
    if (self.rootsCText.text == nil || self.rootsRText.text == nil) {
        [button5 setBackgroundImage:[UIImage imageNamed:@"button-notdone.png"] forState:UIControlStateNormal];
    } else {
        [button5 setBackgroundImage:[UIImage imageNamed:@"button-default.png"] forState:UIControlStateNormal];
    }
    if (self.overallCText.text == nil || self.overallRText.text == nil) {
        [button6 setBackgroundImage:[UIImage imageNamed:@"button-notdone.png"] forState:UIControlStateNormal];
    } else {
        [button6 setBackgroundImage:[UIImage imageNamed:@"button-default.png"] forState:UIControlStateNormal];
    }
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

-(IBAction)segmentSwitch:(id)sender {
    //switch between view and input views
    UISegmentedControl *segmentedButton = (UISegmentedControl *) sender;
    if (segmentedButton.selectedSegmentIndex == 0) {
        [viewView setHidden:NO];
        [inputView setHidden:YES];
    } else {
        [viewView setHidden:YES];
        [inputView setHidden:NO];
    }

}
-(IBAction)photoButtonClick:(id)sender {
    //user clicked photo button
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Add Existing", @"View Photos", nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleDefault;
    [popupQuery showInView:self.view];
    [popupQuery release];
    
}
-(IBAction)notesButtonClick:(id)sender {
    TTPostController *postController = [[TTPostController alloc] init]; 
    postController.delegate = self;
    postController.textView.text = assessmentTree.notes;
    [postController showInView:self.view animated:YES]; 
    [postController release]; 
}
- (void)postController:(TTPostController *)postController 
           didPostText:(NSString *)text 
            withResult:(id)result { 
    assessmentTree.notes = text; 
}
-(IBAction)treeButtonClick:(id)sender {
    //user clicked one of the tree buttons, so send them to the other view with the right id
    int clickId = [[(UIButton*)sender titleLabel].text intValue];
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:self.assessmentTree, @"assessmentTree", [NSNumber numberWithInt:clickId], @"id", nil];
    [[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:@"land://assessments/TreeForm"] applyQuery:query] applyAnimated:YES]];
}
-(IBAction)saveAssessor:(id)sender {
    //edit the assessor field
    [assessorField resignFirstResponder];
    NSError *saveError;
    self.assessmentTree.assessor = [(UITextField*)sender text];
    if (![managedObjectContext save:&saveError]) {
        NSLog(@"Saving changes to assessor failed: %@", saveError);
    }
    self.assessor.text = self.assessmentTree.assessor;
}
-(IBAction)saveCaliper:(id)sender {
    //edit the caliper field
    [caliperField resignFirstResponder];
    self.assessmentTree.caliper = [NSDecimalNumber decimalNumberWithString:[(UITextField*)sender text]];
    NSError *saveError;
    if (![managedObjectContext save:&saveError]) {
       NSLog(@"Saving changes to caliper failed: %@", saveError);
    }
    self.caliper.text = [self.assessmentTree.caliper stringValue];
}
-(IBAction)saveHeight:(id)sender {
    //edit the height field
    [heightField resignFirstResponder];
    self.assessmentTree.height = [NSDecimalNumber decimalNumberWithString:[(UITextField*)sender text]];
    NSError *saveError;
    if (![managedObjectContext save:&saveError]) {
        NSLog(@"Saving changes to height failed: %@", saveError);
    }
    self.height.text = [self.assessmentTree.height stringValue];
}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    if(!managedObjectContext){
        managedObjectContext = [(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    self.title = @"Tree";
    self.assessor.text = self.assessmentTree.assessor;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    NSString *dateStr= [dateFormatter stringFromDate:self.assessmentTree.created_at];
    [dateFormatter release];
    self.date.text = dateStr;
    
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
        NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:@"AssessmentTree", @"entity", assessmentTree.objectID , @"objectID", nil];
        [[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:@"land://Photos"] applyQuery:query] applyAnimated:YES]];
    } else if (buttonIndex == 3) {
        //cancel
    }
}

- (void)imagePickerController: (UIImagePickerController *)picker
        didFinishPickingImage: (UIImage *)image
                  editingInfo: (NSDictionary *)editingInfo {
    NSMutableSet *photos = [assessmentTree mutableSetValueForKey:@"images"];
    Image *newPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:managedObjectContext];
    newPhoto.image_data = UIImageJPEGRepresentation(image, 1.0);
    newPhoto.image_caption = @"Tree Assessment";
    //newPhoto.owner = assessmentTree;
    [photos addObject:newPhoto];
    [assessmentTree setValue:photos forKey:@"images"];
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error saving image.");
    }
    [managedObjectContext processPendingChanges];
    [[imagePicker parentViewController] dismissModalViewControllerAnimated:YES];
    [imagePicker resignFirstResponder];
}


- (void)imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
    // in case of cancel, get rid of picker
    [[imagePicker parentViewController] dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    //[mainView release];
    //[assessment release];
    //[assessmentTree release];
    //[managedObjectContext release];
    [imagePicker release];
    [super dealloc];
}


@end
