//
//  AssessmentTableViewCell.m
//  landscapes
//
//  Created by Evan Cordell on 7/27/10.
//  Copyright National Park Service/NCPTT 2010. All rights reserved.
//

#import "AssessmentTableViewCell.h"

@implementation AssessmentTableViewCell

@synthesize assessment;
@synthesize landscapeName;
@synthesize typeName;
@synthesize date;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)dealloc {
    [assessment release];
    [landscapeName release];
    [typeName release];
    [date release];
    [super dealloc];
}


@end
