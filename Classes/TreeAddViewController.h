//
//  TreeAddViewController.h
//  Trees
//
//  Created by Sean Clifford on 1/3/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TreeAddDelegate;
@class InventoryTree;

@interface TreeAddViewController : UIViewController <UITextFieldDelegate>
{
@private
	
	InventoryTree *tree;
	UITextField *nameTextField;
	id <TreeAddDelegate> delegate;
}

@property(nonatomic, retain) Tree *tree;
@property(nonatomic, retain) IBOutlet UITextField *nameTextField;
@property(nonatomic, assign) id <TreeAddDelegate> delegate;

-(void)save;
-(void)cancel;

@end




@protocol TreeAddDelegate <NSObject> 
// tree == nil on cancel
- (void)treeAddViewController:(TreeAddViewController *)treeAddViewController didAddTree:(Tree *)tree;

@end
