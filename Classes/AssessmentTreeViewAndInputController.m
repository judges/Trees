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
	
	heightPickerView.showsSelectionIndicator = YES;
    heightPickerView.dataSource = self;
    heightPickerView.delegate = self;
    
	//stick labels on the right components
	if ([lengthUnits isEqualToString:@"Metric"]) {
		[heightPickerView addLabel:@"m" forComponent:2 forLongestString:@"m"];
		[heightPickerView addLabel:@"cm" forComponent:4 forLongestString:@"cm"];
	} else if ([lengthUnits isEqualToString:@"Imperial"]) {
		[heightPickerView addLabel:@"ft" forComponent:2 forLongestString:@"m"];
		[heightPickerView addLabel:@"in" forComponent:3 forLongestString:@"cm"];
	}
	
    
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    if (self.assessmentTree) {
		
		//display the right caliper and height
		NSString *lengthUnits = [[NSUserDefaults standardUserDefaults] stringForKey:@"lengthUnits"];
		if ([lengthUnits isEqualToString:@"Metric"]) {
			self.caliper.text = [NSString stringWithFormat:@"%dm %dcm", [self.assessmentTree.caliper.m intValue], [self.assessmentTree.caliper.cm intValue]];
			self.height.text = [NSString stringWithFormat:@"%dm %dcm", [self.assessmentTree.height.m intValue], [self.assessmentTree.height.cm intValue]];
			[self.caliperButton setTitle:[NSString stringWithFormat:@"%dm %dcm", [self.assessmentTree.caliper.m intValue], [self.assessmentTree.caliper.cm intValue]] forState:UIControlStateNormal];
			[self.heightButton setTitle:[NSString stringWithFormat:@"%dm %dcm", [self.assessmentTree.height.m intValue], [self.assessmentTree.height.cm intValue]] forState:UIControlStateNormal];
		} else if ([lengthUnits isEqualToString:@"Imperial"]){
			self.caliper.text = [NSString stringWithFormat:@"%dft %din", [self.assessmentTree.caliper.ft intValue], [self.assessmentTree.caliper.in intValue]];
			self.height.text = [NSString stringWithFormat:@"%dft %din", [self.assessmentTree.height.ft intValue], [self.assessmentTree.height.in intValue]];
			[self.caliperButton setTitle:[NSString stringWithFormat:@"%dft %din", [self.assessmentTree.caliper.ft intValue], [self.assessmentTree.caliper.in intValue]] forState:UIControlStateNormal];
			[self.heightButton setTitle:[NSString stringWithFormat:@"%dft %din", [self.assessmentTree.height.ft intValue], [self.assessmentTree.height.in intValue]] forState:UIControlStateNormal];
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
    
    //select the correct rows
    if(self.assessmentTree.caliper == nil) {
        [self pickerView:caliperPickerView didSelectRow:0 inComponent:0];
    } else {
		NSString *lengthUnits = [[NSUserDefaults standardUserDefaults] stringForKey:@"lengthUnits"];
		if ([lengthUnits isEqualToString:@"Metric"]) {
			//meters
			[caliperPickerView selectRow:[self.assessmentTree.caliper.m intValue] inComponent:0 animated:YES];
			//cm - parse out the ones place
			NSInteger ones = [self.assessmentTree.caliper.cm intValue] % 10;
			//cm - parse out tens place
			NSInteger tens = ([self.assessmentTree.caliper.cm intValue] - ones)/10;
			[caliperPickerView selectRow:tens inComponent:1 animated:YES];
			[caliperPickerView selectRow:ones inComponent:2 animated:YES];
		} else if ([lengthUnits isEqualToString:@"Imperial"]) {
			//feet - ones place
			NSInteger ones = [self.assessmentTree.caliper.ft intValue] % 10;
			//feet - tens place
			NSInteger tens = ([self.assessmentTree.caliper.ft intValue] - ones)/10;
			[caliperPickerView selectRow:tens inComponent:0 animated:YES];
			[caliperPickerView selectRow:ones inComponent:1 animated:YES];
			//inches
			[caliperPickerView selectRow:[self.assessmentTree.caliper.in intValue] inComponent:2 animated:YES];
		}
	}
}

-(IBAction)heightClick:(id)sender {
    //show the height picker with close and select buttons
    [heightActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
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
    
    //select the correct rows
    if(self.assessmentTree.height == nil) {
        [self pickerView:heightPickerView didSelectRow:0 inComponent:0];
    } else {
		NSString *lengthUnits = [[NSUserDefaults standardUserDefaults] stringForKey:@"lengthUnits"];
		if ([lengthUnits isEqualToString:@"Metric"]) {
			//meters - parse in base 10
			NSInteger mOnes = ([self.assessmentTree.height.m intValue] % 100) % 10;
			NSInteger mTens = (([self.assessmentTree.height.m intValue] % 100) - mOnes) / 10;
			NSInteger mHundreds = ([self.assessmentTree.height.m intValue] - 10 * mTens - mOnes) / 100;
			[heightPickerView selectRow:mHundreds inComponent:0 animated:YES];
			[heightPickerView selectRow:mTens inComponent:1 animated:YES];
			[heightPickerView selectRow:mOnes inComponent:2 animated:YES];
			
			//cm - parse out the ones place
			NSInteger ones = [self.assessmentTree.height.cm intValue] % 10;
			//cm - parse out tens place
			NSInteger tens = ([self.assessmentTree.height.cm intValue] - ones)/10;
			[heightPickerView selectRow:tens inComponent:3 animated:YES];
			[heightPickerView selectRow:ones inComponent:4 animated:YES];
		} else if ([lengthUnits isEqualToString:@"Imperial"]) {
			//feet - parse in base 10
			NSInteger fOnes = ([self.assessmentTree.height.ft intValue] % 100) % 10;
			NSInteger fTens = (([self.assessmentTree.height.ft intValue] % 100) - fOnes) / 10;
			NSInteger fHundreds = ([self.assessmentTree.height.ft intValue] - 10 * fTens - fOnes) / 100;
			[heightPickerView selectRow:fHundreds inComponent:0 animated:YES];
			[heightPickerView selectRow:fTens inComponent:1 animated:YES];
			[heightPickerView selectRow:fOnes inComponent:2 animated:YES];
			//inches
			[heightPickerView selectRow:[self.assessmentTree.height.in intValue] inComponent:3 animated:YES];
		}
	}
}
- (void)caliperSelected:(id)sender {
	//user clicks done on action sheet
	NSString *lengthUnits = [[NSUserDefaults standardUserDefaults] stringForKey:@"lengthUnits"];
	
	[caliperActionSheet dismissWithClickedButtonIndex:0 animated:YES];
	
	//Get existing record or create new one
	Caliper *cap;
	if (self.assessmentTree.caliper == nil) {
		cap = [NSEntityDescription insertNewObjectForEntityForName:@"Caliper" inManagedObjectContext:managedObjectContext];
	} else {
		cap = self.assessmentTree.caliper;
	}
	
	if ([lengthUnits isEqualToString:@"Imperial"]) {
		cap.ft = [NSNumber numberWithInt:([caliperPickerView selectedRowInComponent:0] * 10 + [caliperPickerView selectedRowInComponent:1])];
		cap.in = [NSNumber numberWithInt:[caliperPickerView selectedRowInComponent:2]];
		[caliperButton setTitle:[NSString stringWithFormat:@"%dft %din", [cap.ft intValue], [cap.in intValue]] forState:UIControlStateNormal];
		self.caliper.text = [NSString stringWithFormat:@"%dft %din", [cap.ft intValue], [cap.in intValue]];
	} else if ([lengthUnits isEqualToString:@"Metric"]) {
		cap.m = [NSNumber numberWithInt:[caliperPickerView selectedRowInComponent:0]];
		cap.cm = [NSNumber numberWithInt:([caliperPickerView selectedRowInComponent:1] * 10 + [caliperPickerView selectedRowInComponent:2])];
		[caliperButton setTitle:[NSString stringWithFormat:@"%dm %dcm", [cap.m intValue], [cap.cm intValue]] forState:UIControlStateNormal];
		self.caliper.text = [NSString stringWithFormat:@"%dm %dcm", [cap.m intValue], [cap.cm intValue]];
	}
	self.assessmentTree.caliper = cap;
	
	NSError *saveError;
	if (![managedObjectContext save:&saveError]) {
		NSLog(@"Saving changes to caliper failed: %@", saveError);
	}
	
}

- (void)heightSelected:(id)sender {
	//user clicks done on action sheet
	NSString *lengthUnits = [[NSUserDefaults standardUserDefaults] stringForKey:@"lengthUnits"];
	
	[heightActionSheet dismissWithClickedButtonIndex:0 animated:YES];
	
	//Get existing record or create new one
	Height *hat;
	if (self.assessmentTree.height == nil) {
		hat = [NSEntityDescription insertNewObjectForEntityForName:@"Height" inManagedObjectContext:managedObjectContext];
	} else {
		hat = self.assessmentTree.height;
	}

	if ([lengthUnits isEqualToString:@"Imperial"]) {
		hat.ft = [NSNumber numberWithInt:([heightPickerView selectedRowInComponent:0] * 100 + [heightPickerView selectedRowInComponent:1] * 10 + [heightPickerView selectedRowInComponent:2])];
		hat.in = [NSNumber numberWithInt:[heightPickerView selectedRowInComponent:3]];
		[heightButton setTitle:[NSString stringWithFormat:@"%dft %din", [hat.ft intValue], [hat.in intValue]] forState:UIControlStateNormal];
		self.height.text = [NSString stringWithFormat:@"%dft %din", [hat.ft intValue], [hat.in intValue]];
	} else if ([lengthUnits isEqualToString:@"Metric"]) {
		hat.m = [NSNumber numberWithInt:([heightPickerView selectedRowInComponent:0] * 100 + [heightPickerView selectedRowInComponent:1] * 10 + [heightPickerView selectedRowInComponent:2])];
		hat.cm = [NSNumber numberWithInt:([heightPickerView selectedRowInComponent:3] * 10 + [heightPickerView selectedRowInComponent:4])];
		[heightButton setTitle:[NSString stringWithFormat:@"%dm %dcm", [hat.m intValue], [hat.cm intValue]] forState:UIControlStateNormal];
		self.height.text = [NSString stringWithFormat:@"%dm %dcm", [hat.m intValue], [hat.cm intValue]];
	}
	self.assessmentTree.height = hat;
	
	NSError *saveError;
	if (![managedObjectContext save:&saveError]) {
		NSLog(@"Saving changes to height failed: %@", saveError);
	}
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

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 6;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 6;
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
		//load standard cell
		static NSString *AssessmentCellIdentifier = @"AssessmentTreeTableViewCell";
		AssessmentTreeTableViewCell *assessmentCell = (AssessmentTreeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:AssessmentCellIdentifier];
		if (assessmentCell == nil) {
			NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AssessmentTreeTableViewCell" owner:nil options:nil];
			for (id currentObject in topLevelObjects) {
				if ([currentObject isKindOfClass:[UITableViewCell class]]) {
					assessmentCell = (AssessmentTreeTableViewCell *) currentObject;
					break;
				}
			}
			[self configureCell:assessmentCell atIndexPath:indexPath];
		}
		return assessmentCell;
}

- (void)configureCell:(AssessmentTreeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	//normal cells
	cell.conditionLabel.text = @"Cond";
	cell.recommendationLabel.text = @"Rec";	
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	static NSString *HeaderIdentifier = @"AssessmentTreeTableViewHeaderCell";
	AssessmentTreeTableViewHeaderCell *headerCell = (AssessmentTreeTableViewHeaderCell *)[tableView dequeueReusableCellWithIdentifier:HeaderIdentifier];
	if (headerCell == nil) {
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AssessmentTreeTableViewHeaderCell" owner:nil options:nil];
		for (id currentObject in topLevelObjects) {
			if ([currentObject isKindOfClass:[UIView class]]) {
				headerCell = (AssessmentTreeTableViewHeaderCell *) currentObject;
				break;
			}
		}
	}
	switch (section) {
		case 0:
			headerCell.label.text = @"Form";
			break;
		case 1:
			headerCell.label.text = @"Crown";
			break;
		case 2:
			headerCell.label.text = @"Trunk";
			break;
		case 3:
			headerCell.label.text = @"Roots";
			break;
		case 4:
			headerCell.label.text = @"Root Flare";
			break;
		case 5:
			headerCell.label.text = @"Overall";
			break;
		default:
			break;
	}
	return headerCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	//set header height
	return 30;
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
     
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
