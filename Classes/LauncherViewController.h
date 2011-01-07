//
//  LauncherViewController.h
//  landscapes
//
//  Created by Sean Clifford on 7/26/10.
//  Copyright 2010 National Park Service/NCPTT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import "IASKAppSettingsViewController.h"
#import "AppDelegate_Shared.h"
#import "Assessment.h"
#import "PartCondition.h"
#import "PartRecommendation.h"
#import "PartType.h"
#import "LandscapeTableViewCell.h"
#import "AssessmentTableViewCell.h"
#import "TreeTableViewCell.h"
#import "DDXML.h"

@interface LauncherViewController : TTViewController <TTLauncherViewDelegate, IASKSettingsDelegate, UITextFieldDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate> {
	TTLauncherView* _launcherView;
	UISearchDisplayController *searchController;
	NSArray *allRecords;
	NSArray *filteredRecords;
}

@property (nonatomic, retain) UISearchBar *theSearchBar;
@property (nonatomic, retain) NSArray *allRecords;
@property (nonatomic, retain) NSArray *filteredRecords;

- (void)filterContentForSearchText:(NSString*)searchText;
- (void)prepopulateDb;
@end
