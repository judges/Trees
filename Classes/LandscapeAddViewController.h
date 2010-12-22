//
//  LandscapeAddViewController.h
//  Trees
//
//  Created by Sean Clifford on 12/22/10.
//  Copyright 2010 NCPTT/National Park Service. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@protocol LandscapeAddDelegate;
@class Landscape;

@interface LandscapeAddViewController : UIViewController <UITextFieldDelegate>
{
	@private
	
	Landscape *landscape;
	UITextField *nameTextField;
	id <LandscapeAddDelegate> delegate;
}

@property(nonatomic, retain) Landscape *landscape;
@property(nonatomic, retain) IBOutlet UITextField *nameTextField;
@property(nonatomic, assign) id <LandscapeAddDelegate> delegate;

-(void)save;
-(void)cancel;

@end



@end

@protocol LandscapeAddDelegate <NSObject> 
// landscape == nil on cancel
- (void)landscapeAddViewController:(LandscapeAddViewController *)landscapeAddViewController didAddLandscape:(Landscape *)landscape;

@end
