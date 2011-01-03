//
//  LauncherViewController.m
//  landscapes
//
//  Created by Sean Clifford on 7/26/10.
//  Copyright 2010 National Park Service/NCPTT. All rights reserved.
//

#import "LauncherViewController.h"

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation LauncherViewController
@synthesize mySearchBar;

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

		//Set navigation bar title
		self.title = @"Trees";
		
	}
	return self;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)){
		_launcherView.columnCount = 5;
		_launcherView.frame=self.view.bounds;
	
	} else	if((self.interfaceOrientation == UIDeviceOrientationPortrait) || (self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)){
		_launcherView.columnCount = 3;
		_launcherView.frame=self.view.bounds;
	}
}

-(void)reloadLauncherView
{
    [self viewWillAppear:NO ];
}



- (void)dealloc {
	[mySearchBar release];
	[super dealloc];
}

#pragma mark -
#pragma mark UISearchBarDelegate

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[self.mySearchBar resignFirstResponder];
}

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[self.mySearchBar resignFirstResponder];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)loadView {
	[super loadView];
	CGRect  bounds = self.view.bounds;
	[self.mySearchBar sizeToFit];
	
	// launcherView
	_launcherView.frame = CGRectMake(0,45,bounds.size.width,bounds.size.height-2*45); 
	_launcherView = [[TTLauncherView alloc] initWithFrame:self.view.bounds];
	_launcherView.backgroundColor = [UIColor colorWithRed:0.369 green:0.435 blue:0.200 alpha:1.0]; //darker green
	_launcherView.opaque = YES;
	_launcherView.delegate = self;

	
	if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)){
		_launcherView.columnCount = 5;
		_launcherView.frame=self.view.bounds;
		[self.mySearchBar sizeToFit];
		
	} else	if((self.interfaceOrientation == UIDeviceOrientationPortrait) || (self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)){
		_launcherView.columnCount = 3;
		_launcherView.frame=self.view.bounds;
		[self.mySearchBar sizeToFit];
		
	}
 
	
	_launcherView.pages = [NSArray arrayWithObjects:
						   [NSArray arrayWithObjects:
							[[[TTLauncherItem alloc] initWithTitle:@"Landscapes"
															 image:@"bundle://landscapes.png"
															   URL:@"land://Landscapes"  canDelete:NO] autorelease],

							/*
							[[[TTLauncherItem alloc] initWithTitle:@"Inventory"
															 image:@"bundle://inventory.png"
															   URL:@"land://Inventory" canDelete:NO] autorelease],
							*/

							
							
							[[[TTLauncherItem alloc] initWithTitle:@"Tree Inventory"
															 image:@"bundle://tree.png"
															   URL:@"land://Trees" canDelete:NO] autorelease],								
							
							[[[TTLauncherItem alloc] initWithTitle:@"Assessments"
															 image:@"bundle://assessments.png"
															   URL:@"land://assessments" canDelete:NO] autorelease],

							
							/*
							[[[TTLauncherItem alloc] initWithTitle:@"Tasks"
															 image:@"bundle://tasks.png"
															   URL:@"land://Tasks" canDelete:NO] autorelease],							
							
							*/


							/*
							[[[TTLauncherItem alloc] initWithTitle:@"Cemetery"
															 image:@"bundle://cemetery.png"
															   URL:@"land://Cemetery" canDelete:NO] autorelease],								
							
							[[[TTLauncherItem alloc] initWithTitle:@"Structures"
															 image:@"bundle://structures.png"
															   URL:@"land://Structures" canDelete:NO] autorelease],
							
							[[[TTLauncherItem alloc] initWithTitle:@"Wildlife"
															 image:@"bundle://wildlife.png"
															   URL:@"land://Wildlife" canDelete:NO] autorelease],
							
							*/
							 
							[[[TTLauncherItem alloc] initWithTitle:@"Photos"
															 image:@"bundle://photos.png"
															   URL:@"land://Photos" canDelete:NO] autorelease],		
							
							/*
							
							[[[TTLauncherItem alloc] initWithTitle:@"Maps"
															 image:@"bundle://maps.png"
															   URL:@"land://Maps" canDelete:NO] autorelease],								
							
							*/
							 
							 
							[[[TTLauncherItem alloc] initWithTitle:@"Settings"
															 image:@"bundle://settings.png"
															   URL:@"land://Settings" canDelete:NO] autorelease],		
							
							[[[TTLauncherItem alloc] initWithTitle:@"NCPTT Web"
															 image:@"bundle://ncptt.png"
															   URL:@"http://www.ncptt.nps.gov" canDelete:NO] autorelease],								

							
							
							
							
							nil],
						   
						   
						   /*
						   [NSArray arrayWithObjects:
						
							
							[[[TTLauncherItem alloc] initWithTitle:@"NPS"
															 image:@"bundle://NPS.png"
															   URL:@"http://www.nps.gov" canDelete:NO] autorelease],								

							
							nil],*/
						   nil
						   ];
	[self.view addSubview:_launcherView];
	
	/*
	TTLauncherItem* item = [_launcherView itemWithURL:@"land://data/assessments"];
	item.badgeNumber = 2;
	*/
}

-(void)viewWillAppear:(BOOL)animated {
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
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.180 green:0.267 blue: 0.173 alpha:1.0]; //forest green
	//self.view.backgroundColor = [UIColor colorWithRed:0.486 green:0.318 blue:0.192 alpha:1.0];		//earth brown
	//self.view.backgroundColor = [UIColor colorWithRed:0.486 green:0.318 blue:0.192 alpha:1.0];			//light green
	self.view.backgroundColor = [UIColor colorWithRed:0.369 green:0.435 blue:0.200 alpha:1.0]; //darker green

	
	
	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTLauncherViewDelegate


- (void)viewDidLoad
{
	[super viewDidLoad];

	self.mySearchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 44.0)] autorelease];
	self.mySearchBar.delegate = self;
	self.mySearchBar.showsCancelButton = YES;
	self.mySearchBar.tintColor=[UIColor colorWithRed:0.180 green:0.267 blue: 0.173 alpha:1.0]; //forest green
	
	if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)){
		//resize search bar
		
		
	} else	if((self.interfaceOrientation == UIDeviceOrientationPortrait) || (self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)){
		//resize search bar

	}
 	
	[self.view addSubview: self.mySearchBar];
}

// called after the view controller's view is released and set to nil.
// For example, a memory warning which causes the view to be purged. Not invoked as a result of -dealloc.
// So release any properties that are loaded in viewDidLoad or can be recreated lazily.
//
- (void)viewDidUnload
{
	[super viewDidUnload];
	
	// release and set to nil
	self.mySearchBar = nil;
}

- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)item {
	TTNavigator *navigator = [TTNavigator navigator];

    [navigator openURLAction:[TTURLAction actionWithURLPath:item.URL]];
	
}

- (void)launcherViewDidBeginEditing:(TTLauncherView*)launcher {
	[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc]
												 initWithBarButtonSystemItem:UIBarButtonSystemItemDone
												 target:_launcherView action:@selector(endEditing)] autorelease] animated:YES];
}

- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher {
	[self.navigationItem setRightBarButtonItem:nil animated:YES];
}


#pragma mark -
#pragma mark IASKAppSettingsViewControllerDelegate protocol

- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
    [self dismissModalViewControllerAnimated:YES];
	
	// code here to reconfigure the app for changed settings
}

@end

