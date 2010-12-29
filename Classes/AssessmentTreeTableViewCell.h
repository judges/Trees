//
//  AssessmentTreeTableViewCell.h
//  Trees
//
//  Created by Evan on 12/29/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AssessmentTreeTableViewCell : UITableViewCell {
	IBOutlet UILabel *conditionLabel;
	IBOutlet UILabel *recommendationLabel;
}
@property (nonatomic, retain) UILabel *conditionLabel;
@property (nonatomic, retain) UILabel *recommendationLabel;
@end
