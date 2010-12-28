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
@synthesize assessorField, caliperButton, heightButton;

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
	
	//setup actionsheets
	caliperActionSheet = [[UIActionSheet alloc] initWithTitle:@"Caliper" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    heightActionSheet = [[UIActionSheet alloc] initWithTitle:@"Height" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	photoActionSheet = [[UIActionSheet alloc] initWithTitle:@"Photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Add Existing", @"View Photos", nil];
    photoActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	
	//setup pickerviews
	CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    caliperPickerView = [[DistancePickerView alloc] initWithFrame:pickerFrame];
    heightPickerView = [[DistancePickerView alloc] initWithFrame:pickerFrame];
    
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    if (self.assessmentTree) {
		
		//display the right caliper and height
		NSString *lengthUnits = [[NSUserDefaults standardUserDefaults] stringForKey:@"lengthUnits"];
		if ([lengthUnits isEqualToString:@"Metric"]) {
			self.caliper.text = [NSString stringWithFormat:@"%d m %d cm", self.assessmentTree.caliper.m, self.assessmentTree.caliper.cm];
			self.height.text = [NSString stringWithFormat:@"%d m %d cm", self.assessmentTree.height.m, self.assessmentTree.height.cm];
			[self.caliperButton setTitle:[NSString stringWithFormat:@"%d m %d cm", self.assessmentTree.caliper.m, self.assessmentTree.caliper.cm] forState:UIControlStateNormal];
			[self.heightButton setTitle:[NSString stringWithFormat:@"%d m %d cm", self.assessmentTree.height.m, self.assessmentTree.height.cm] forState:UIControlStateNormal];
		} else if ([lengthUnits isEqualToString:@"Imperial"]){
			self.caliper.text = [NSString stringWithFormat:@"%d ft %d in", self.assessmentTree.caliper.ft, self.assessmentTree.caliper.in];
			self.height.text = [NSString stringWithFormat:@"%d ft %d in", self.assessmentTree.height.ft, self.assessmentTree.height.in];
			[self.caliperButton setTitle:[NSString stringWithFormat:@"%d ft %d in", self.assessmentTree.caliper.ft, self.assessmentTree.caliper.in] forState:UIControlStateNormal];
			[self.heightButton setTitle:[NSString stringWithFormat:@"%d in %d in", self.assessmentTree.height.ft, self.assessmentTree.height.in] forState:UIControlStateNormal];
		}
		
        //for now, just show a random selected condition and recommendation
		self.formCText.text = [[self.assessmentTree.form valueForKeyPath:@"condition.name"] anyObject];
		self.crownCText.text = [[self.assessmentTree.crown valueForKeyPath:@"condition.name"] anyObject];
        self.trunkCText.text = [[self.assessmentTree.trunk valueForKeyPath:@"condition.name"] anyObject];
        self.rootFlareCText.text = [[self.assessmentTree.rootflare valueForKeyPath:@"condition.name"] anyObject];
        self.rootsCText.text = [[self.assessmentTree.roots valueForKeyPath:@"condition.name"] anyObject];
        self.overallCText.text = [[self.assessmentTree.overall valueForKeyPath:@"condition.name"] anyObject];
        self.formRText.text = [[self.assessmentTree.form valueForKeyPath:@"recommendation.name"] anyObject];
        self.crownRText.text = [[self.assessmentTree.crown valueForKeyPath:@"recommendation.name"] anyObject];
        self.trunkRText.text = [[self.assessmentTree.trunk valueForKeyPath:@"recommendation.name"] anyObject];
        self.rootFlareRText.text = [[self.assessmentTree.rootflare valueForKeyPath:@"recommendation.name"] anyObject];
        self.rootsRText.text = [[self.assessmentTree.roots valueForKeyPath:@"recommendation.name"] anyObject];
        self.overallRText.text = [[self.assessmentTree.overall valueForKeyPath:@"recommendation.name"] anyObject];
        self.assessorField.text = self.assessmentTree.assessor;
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
    [photoActionSheet showInView:self.view];
    
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

-(IBAction)caliperClick:(id)sender {
	//show the caliper picker with close and select buttons
    [caliperActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    
    caliperPickerView.showsSelectionIndicator = YES;
    caliperPickerView.dataSource = self;
    caliperPickerView.delegate = self;
    
	//stick labels on the right components
	NSString *lengthUnits = [[NSUserDefaults standardUserDefaults] stringForKey:@"lengthUnits"];
	if ([lengthUnits isEqualToString:@"Metric"]) {
		[caliperPickerView addLabel:@"m" forComponent:0 forLongestString:@"m"];
		[caliperPickerView addLabel:@"cm" forComponent:2 forLongestString:@"cm"];
	} else if ([lengthUnits isEqualToString:@"Imperial"]) {
		[caliperPickerView addLabel:@"ft" forComponent:1 forLongestString:@"m"];
		[caliperPickerView addLabel:@"in" forComponent:2 forLongestString:@"cm"];
	}
	
	 
    [caliperActionSheet addSubview:caliperPickerView];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Close"]];
    closeButton.momentary = YES; 
    closeButton.frame = CGRectMake(10, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    [caliperActionSheet addSubview:closeButton];
    [closeButton release];
    
    UISegmentedControl *doneButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
    doneButton.momentary = YES; 
    doneButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    doneButton.segmentedControlStyle = UISegmentedControlStyleBar;
    doneButton.tintColor = [UIColor blackColor];
    [doneButton addTarget:self action:@selector(caliperSelected:) forControlEvents:UIControlEventValueChanged];
    [caliperActionSheet addSubview:doneButton];
    [doneButton release];
    
    [caliperActionSheet showInView:self.view];
    [caliperActionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    
    //select the first entry by default
    if([caliperPickerView numberOfRowsInComponent:0] > 0) {
        [self pickerView:caliperPickerView didSelectRow:0 inComponent:0];
    }
}

-(IBAction)heightClick:(id)sender {
    //show the height picker with close and select buttons
    [heightActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    
    heightPickerView.showsSelectionIndicator = YES;
    heightPickerView.dataSource = self;
    heightPickerView.delegate = self;
    
	//stick labels on the right components
	NSString *lengthUnits = [[NSUserDefaults standardUserDefaults] stringForKey:@"lengthUnits"];
	if ([lengthUnits isEqualToString:@"Metric"]) {
		[heightPickerView addLabel:@"m" forComponent:2 forLongestString:@"m"];
		[heightPickerView addLabel:@"cm" forComponent:4 forLongestString:@"cm"];
	} else if ([lengthUnits isEqualToString:@"Imperial"]) {
		[heightPickerView addLabel:@"ft" forComponent:2 forLongestString:@"m"];
		[heightPickerView addLabel:@"in" forComponent:3 forLongestString:@"cm"];
	}
	
    [heightActionSheet addSubview:heightPickerView];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Close"]];
    closeButton.momentary = YES; 
    closeButton.frame = CGRectMake(10, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    [heightActionSheet addSubview:closeButton];
    [closeButton release];
    
    UISegmentedControl *doneButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
    doneButton.momentary = YES; 
    doneButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    doneButton.segmentedControlStyle = UISegmentedControlStyleBar;
    doneButton.tintColor = [UIColor blackColor];
    [doneButton addTarget:self action:@selector(heightSelected:) forControlEvents:UIControlEventValueChanged];
    [heightActionSheet addSubview:doneButton];
    [doneButton release];
    
    [heightActionSheet showInView:self.view];
    [heightActionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    
    //select the first entry by default
    if([heightPickerView numberOfRowsInComponent:0] > 0) {
        [self pickerView:heightPickerView didSelectRow:0 inComponent:0];
    }
}
- (void)caliperSelected:(id)sender {
	//user clicks done on action sheet
	NSString *lengthUnits = [[NSUserDefaults standardUserDefaults] stringForKey:@"lengthUnits"];
	[caliperActionSheet dismissWithClickedButtonIndex:0 animated:YES];
	

	Caliper *cap = [NSEntityDescription insertNewObjectForEntityForName:@"Caliper" inManagedObjectContext:managedObjectContext];
	if ([lengthUnits isEqualToString:@"Imperial"]) {
		NSLog(@"%d", [caliperPickerView selectedRowInComponent:0] * 10 + [caliperPickerView selectedRowInComponent:1]);
		cap.ft = [NSNumber numberWithInt:([caliperPickerView selectedRowInComponent:0] * 10 + [caliperPickerView selectedRowInComponent:1])];
		cap.in = [NSNumber numberWithInt:[caliperPickerView selectedRowInComponent:2]];
		[caliperButton setTitle:[NSString stringWithFormat:@"%d ft %d in", [cap.ft intValue], [cap.in intValue]] forState:UIControlStateNormal];
		self.caliper.text = [NSString stringWithFormat:@"%d ft %d in", [cap.ft intValue], [cap.in intValue]];
		NSLog(@"%d ft %d in", cap.ft, cap.in);
	} else if ([lengthUnits isEqualToString:@"Metric"]) {
		cap.m = [NSNumber numberWithInt:[caliperPickerView selectedRowInComponent:0]];
		cap.cm = [NSNumber numberWithInt:([caliperPickerView selectedRowInComponent:1] * 10 + [caliperPickerView selectedRowInComponent:2])];
		[caliperButton setTitle:[NSString stringWithFormat:@"%d m %d cm", [cap.m intValue], [cap.cm intValue]] forState:UIControlStateNormal];
		self.caliper.text = [NSString stringWithFormat:@"%d m %d cm", [cap.m intValue], [cap.cm intValue]];
	}
	self.assessmentTree.caliper = cap;
	
	NSError *saveError;
	if (![managedObjectContext save:&saveError]) {
		NSLog(@"Saving changes to caliper failed: %@", saveError);
	}
	
}

- (void)heightSelected:(id)sender {
	//user clicks done on action sheet
	[heightActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)dismissActionSheet:(id)sender {
    //user clicks close on an action sheet
    [caliperActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    [heightActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	//decides how many sections for each picker
	NSString *lengthUnits = [[NSUserDefaults standardUserDefaults] stringForKey:@"lengthUnits"];
	if ([lengthUnits isEqualToString:@"Metric"]) {
		//metric
		if (thePickerView == caliperPickerView) {
			return 3;
		} else {
			return 5;
		}
	} else if ([lengthUnits isEqualToString:@"Imperial"]) {
		//imperial
		if (thePickerView == caliperPickerView) {
			return 3;
		} else {
			return 4;
		}
	} else {
		//won't get here
		return 1;
	}
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    //get number of rows for picker views
	NSString *lengthUnits = [[NSUserDefaults standardUserDefaults] stringForKey:@"lengthUnits"];
    if (thePickerView==caliperPickerView) {
		if ([lengthUnits isEqualToString:@"Metric"]) {
			//metric caliper
			switch (component) {
				case 0:
					//caliper meters list
					//0-12m
					return 13;
					break;
				case 1:
					//caliper centimeters 10s list
					return 10;
					break;
				case 2:
					//caliper centimeters ones list
					return 10;
					break;
				default:
					break;
			}
		} else if ([lengthUnits isEqualToString:@"Imperial"]) {
			//imperial caliper
			switch (component) {
				case 0:
					//caliper feet 10s list
					return 4;
					break;
				case 1:
					//caliper feet ones list
					return 10;
					break;
				case 2:
					//caliper inches list
					//0-11in
					return 12;
					break;
				default:
					break;
			}
		}
    } else {
       //height picker
		if ([lengthUnits isEqualToString:@"Metric"]) {
			//metric height
			switch (component) {
				case 0:
					//height meters hundreds list
					return 2;
					break;
				case 1:
					//height meters tens list
					return 10;
					break;
				case 2:
					//height meters ones list
					return 10;
					break;
				case 3:
					//height centimeters tens list
					return 10;
					break;
				case 4:
					//height centimeters ones list
					return 10;
					break;
				default:
					break;
			}
		} else if ([lengthUnits isEqualToString:@"Imperial"]) {
			//imperial height
			switch (component) {
				case 0:
					//height feet hundreds list
					return 4;
					break;
				case 1:
					//height feet tens list
					return 10;
					break;
				case 2:
					//height feet ones list
					return 10;
					break;
				case 3:
					//height inches list
					return 12;
					break;
				default:
					break;
			}
		}
    }
	//shouldn't ever get here
	return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	NSString *lengthUnits = [[NSUserDefaults standardUserDefaults] stringForKey:@"lengthUnits"];
	if ([lengthUnits isEqualToString:@"Metric"]) {
		if (pickerView == caliperPickerView) {
			//metric caliper - 3 components
			switch (component) {
				case 0:
					return 160;
					break;
				case 1:
					return 50;
					break;
				case 2:
					return 110;
					break;
				default:
					break;
			}
		} else {
			//metric height - 5 components
			switch (component) {
				case 0:
					return 40;
					break;
				case 1:
					return 40;
					break;
				case 2:
					return 100;
					break;
				case 3:
					return 40;
					break;
				case 4:
					return 100;
				default:
					break;
			}
		}
	} else if ([lengthUnits isEqualToString:@"Imperial"]) {
		if (pickerView == caliperPickerView) {
			//imperial caliper - 3 components
			switch (component) {
				case 0:
					return 60;
					break;
				case 1:
					return 100;
					break;
				case 2:
					return 160;
					break;
				default:
					break;
			}
		} else {
			//imperial height - 4 components
			switch (component) {
				case 0:
					return 50;
					break;
				case 1:
					return 50;
					break;
				case 2:
					return 110;
					break;
				case 3:
					return 110;
					break;
				default:
					break;
			}
		}

	}
	return 10;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSString *lengthUnits = [[NSUserDefaults standardUserDefaults] stringForKey:@"lengthUnits"];
	UILabel *label;
	if ([lengthUnits isEqualToString:@"Metric"]) {
		if (pickerView == caliperPickerView) {
			//metric caliper - 3 components
			switch (component) {
				case 0:
				{
					label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
					[label setTextAlignment:UITextAlignmentCenter];
					break;
				}
				case 1:
				{
					label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
					[label setTextAlignment:UITextAlignmentRight];
					break;
				}
				case 2:
				{
					label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 50)];
					[label setTextAlignment:UITextAlignmentLeft];
					break;
				}
				default:
				{
					break;
				}
			}
		} else {
			//metric height - 5 components
			switch (component) {
				case 0:
				{
					label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 50)];
					[label setTextAlignment:UITextAlignmentCenter];
					break;
				}
				case 1:
				{
					label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 50)];
					[label setTextAlignment:UITextAlignmentCenter];
					break;
				}
				case 2:
				{
					label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
					[label setTextAlignment:UITextAlignmentLeft];
					break;
				}
				case 3:
				{
					label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
					[label setTextAlignment:UITextAlignmentRight];
					break;
				}
				case 4:
				{
					label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
					[label setTextAlignment:UITextAlignmentLeft];
					break;
				}
				default:
					break;
			}
		}
	} else if ([lengthUnits isEqualToString:@"Imperial"]) {
		if (pickerView == caliperPickerView) {
			//imperial caliper - 3 components
			switch (component) {
				case 0:
				{
					label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 50)];
					[label setTextAlignment:UITextAlignmentRight];
					break;
				}
				case 1:
				{
					label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
					[label setTextAlignment:UITextAlignmentLeft];
					break;
				}
				case 2:
				{
					label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
					[label setTextAlignment:UITextAlignmentCenter];
					break;
				}
				default:
				{
					break;
				}
			}
		} else {
			//imperial height - 4 components
			switch (component) {
				case 0:
				{
					label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
					[label setTextAlignment:UITextAlignmentCenter];
					break;
				}
				case 1:
				{
					label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
					[label setTextAlignment:UITextAlignmentCenter];
					break;
				}
				case 2:
				{
					label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
					[label setTextAlignment:UITextAlignmentLeft];
					break;
				}
				case 3:
				{
					label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 50)];
					[label setTextAlignment:UITextAlignmentLeft];
					break;
				}

				default:
					break;
			}
		}
		
	}
	label.opaque=NO;
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor blackColor];
	UIFont *font = [UIFont boldSystemFontOfSize:20];
	label.font = font;
	[label setText:[NSString stringWithFormat:@"%d", row]];
	return [label autorelease];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //set the selected type or row based on user interaction
    
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        
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
	if (actionSheet == photoActionSheet) {
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
	} else if (actionSheet == caliperActionSheet) {
		//handle caliper
		
	} else if (actionSheet == heightActionSheet) {
		//handle height
		
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
	[photoActionSheet release];
	[caliperActionSheet release];
	[heightActionSheet release];
	[caliperPickerView release];
	[heightPickerView release];
    [imagePicker release];
    [super dealloc];
}


@end
