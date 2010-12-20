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

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

		self.title = @"Landscapes";
		//Set navigation bar color
		self.navigationBarTintColor = [UIColor colorWithRed:0.180 green:0.267 blue: 0.173 alpha:1.0];
		
		
	}
	return self;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	//return TTIsSupportedOrientation(interfaceOrientation);
	//return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	return YES;
}





-(void)reloadLauncherView
{
    [self viewWillAppear:NO ];
}



- (void)dealloc {
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)loadView {
	[super loadView];
	
	_launcherView = [[TTLauncherView alloc] initWithFrame:self.view.bounds];
	_launcherView.backgroundColor = [UIColor colorWithRed:0.486 green:0.318 blue:
									 0.192 alpha:1.0];
	_launcherView.opaque = YES;
	_launcherView.delegate = self;
	_launcherView.columnCount = 3;
 
	
	_launcherView.pages = [NSArray arrayWithObjects:
						   [NSArray arrayWithObjects:
							[[[TTLauncherItem alloc] initWithTitle:@"Landscapes"
															 image:@"bundle://landscapes-57.png"
															   URL:@"land://Landscapes"  canDelete:NO] autorelease],

							/*
							[[[TTLauncherItem alloc] initWithTitle:@"Inventory"
															 image:@"bundle://inventory-57.png"
															   URL:@"land://Inventory" canDelete:NO] autorelease],
							*/
							
							[[[TTLauncherItem alloc] initWithTitle:@"Assessments"
															 image:@"bundle://assessments-57.png"
															   URL:@"land://assessments" canDelete:NO] autorelease],

							
							/*
							[[[TTLauncherItem alloc] initWithTitle:@"Tasks"
															 image:@"bundle://tasks-57.png"
															   URL:@"land://Tasks" canDelete:NO] autorelease],							
							
							*/
							
							[[[TTLauncherItem alloc] initWithTitle:@"Trees"
															 image:@"bundle://tree-57.png"
															   URL:@"land://Trees" canDelete:NO] autorelease],	

							/*
							[[[TTLauncherItem alloc] initWithTitle:@"Cemetery"
															 image:@"bundle://cemetery-57.png"
															   URL:@"land://Cemetery" canDelete:NO] autorelease],								
							
							[[[TTLauncherItem alloc] initWithTitle:@"Structures"
															 image:@"bundle://structures-57.png"
															   URL:@"land://Structures" canDelete:NO] autorelease],
							
							[[[TTLauncherItem alloc] initWithTitle:@"Wildlife"
															 image:@"bundle://wildlife-57.png"
															   URL:@"land://Wildlife" canDelete:NO] autorelease],
							
							*/
							 
							[[[TTLauncherItem alloc] initWithTitle:@"Photos"
															 image:@"bundle://photos-57.png"
															   URL:@"land://Photos" canDelete:NO] autorelease],		
							
							/*
							
							[[[TTLauncherItem alloc] initWithTitle:@"Maps"
															 image:@"bundle://maps-57.png"
															   URL:@"land://Maps" canDelete:NO] autorelease],								
							
							*/
							 
							 
							[[[TTLauncherItem alloc] initWithTitle:@"Settings"
															 image:@"bundle://settings-57.png"
															   URL:@"land://data/Settings" canDelete:NO] autorelease],								
							[[[TTLauncherItem alloc] initWithTitle:@"NCPTT Web"
															 image:@"bundle://ncptt-57.png"
															   URL:@"http://www.ncptt.nps.gov" canDelete:NO] autorelease],								

							
							
							
							
							nil],
						   
						   

						   [NSArray arrayWithObjects:
						
							
							[[[TTLauncherItem alloc] initWithTitle:@"NPS"
															 image:@"bundle://nps-57.png"
															   URL:@"http://www.nps.gov" canDelete:NO] autorelease],								

							
							nil],
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
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTLauncherViewDelegate


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


@end

