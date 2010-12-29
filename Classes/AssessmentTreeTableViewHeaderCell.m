//
//  AssessmentTreeTableViewHeaderCell.m
//  Trees
//
//  Created by Evan on 12/29/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import "AssessmentTreeTableViewHeaderCell.h"


@implementation AssessmentTreeTableViewHeaderCell
@synthesize label;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[label release];
    [super dealloc];
}


@end
