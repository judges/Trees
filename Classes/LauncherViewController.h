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

@interface LauncherViewController : TTViewController <TTLauncherViewDelegate, IASKSettingsDelegate, UISearchBarDelegate> {
	TTLauncherView* _launcherView;
}

@property (nonatomic, retain) UISearchBar *mySearchBar;

@end
