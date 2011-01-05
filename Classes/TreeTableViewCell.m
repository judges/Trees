//
//  TreeTableViewCell.m
//  Trees
//
//  Created by Sean Clifford on 1/3/11.
//  Copyright 2011 NCPTT. All rights reserved.
//

#import "TreeTableViewCell.h"
#import "Image.h"

#pragma mark -
#pragma mark SubviewFrames category

@interface TreeTableViewCell (SubviewFrames)
- (CGRect)_imageViewFrame;
- (CGRect)_nameLabelFrame;
- (CGRect)_created_atLabelFrame;
- (CGRect)_gpsLabelFrame;
@end


@implementation TreeTableViewCell

@synthesize tree, imageView, nameLabel, created_atLabel, gpsLabel;

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
	
		
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		[imageView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:imageView];
		
        created_atLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [created_atLabel setFont:[UIFont systemFontOfSize:12.0]];
        [created_atLabel setTextColor:[UIColor darkGrayColor]];
        [created_atLabel setHighlightedTextColor:[UIColor whiteColor]];
		[created_atLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:created_atLabel];
	
        gpsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        gpsLabel.textAlignment = UITextAlignmentRight;
        [gpsLabel setFont:[UIFont systemFontOfSize:12.0]];
        [gpsLabel setTextColor:[UIColor blackColor]];
		[gpsLabel setBackgroundColor:[UIColor clearColor]];
        [gpsLabel setHighlightedTextColor:[UIColor whiteColor]];
		gpsLabel.minimumFontSize = 7.0;
		gpsLabel.lineBreakMode = UILineBreakModeTailTruncation;
        [self.contentView addSubview:gpsLabel];
		
        nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [nameLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [nameLabel setTextColor:[UIColor blackColor]];
		[nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setHighlightedTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:nameLabel];
    }
	
    return self;
}



#pragma mark -
#pragma mark Laying out subviews

/*
 To save space, disappear the gpsLabel during editing.
 */
- (void)layoutSubviews {
    [super layoutSubviews];
	
    [imageView setFrame:[self _imageViewFrame]];
    [nameLabel setFrame:[self _nameLabelFrame]];
	[created_atLabel setFrame:[self _created_atLabelFrame]];
    [gpsLabel setFrame:[self _gpsLabelFrame]];
    if (self.editing) {
        gpsLabel.alpha = 0.0;
    } else {
        gpsLabel.alpha = 1.0;
    }
}


#define IMAGE_SIZE          59.0
#define EDITING_INSET       0.0
#define TEXT_LEFT_MARGIN    5.0
#define TEXT_RIGHT_MARGIN   5.0
#define PREP_TIME_WIDTH     80.0

/*
 Return the frame of the various subviews -- these are dependent on the editing state of the cell.
 */
- (CGRect)_imageViewFrame {
    if (self.editing) {
        return CGRectMake(EDITING_INSET, 0.0, IMAGE_SIZE, IMAGE_SIZE);
    }
	else {
        return CGRectMake(0.0, 0.0, IMAGE_SIZE, IMAGE_SIZE);
    }
}

- (CGRect)_nameLabelFrame {
    if (self.editing) {
        return CGRectMake(IMAGE_SIZE + EDITING_INSET + TEXT_LEFT_MARGIN, 4.0, self.contentView.bounds.size.width - IMAGE_SIZE - EDITING_INSET - TEXT_LEFT_MARGIN, 16.0);
    }
	else {
        return CGRectMake(IMAGE_SIZE + TEXT_LEFT_MARGIN, 4.0, self.contentView.bounds.size.width - IMAGE_SIZE - TEXT_RIGHT_MARGIN * 2 - PREP_TIME_WIDTH, 16.0);
    }
}

- (CGRect)_created_atLabelFrame {
    if (self.editing) {
        return CGRectMake(IMAGE_SIZE + EDITING_INSET + TEXT_LEFT_MARGIN, 22.0, self.contentView.bounds.size.width - IMAGE_SIZE - EDITING_INSET - TEXT_LEFT_MARGIN, 16.0);
    }
	else {
        return CGRectMake(IMAGE_SIZE + TEXT_LEFT_MARGIN, 22.0, self.contentView.bounds.size.width - IMAGE_SIZE - TEXT_LEFT_MARGIN, 16.0);
    }
}

- (CGRect)_gpsLabelFrame {
    CGRect contentViewBounds = self.contentView.bounds;
    return CGRectMake(contentViewBounds.size.width - PREP_TIME_WIDTH - TEXT_RIGHT_MARGIN, 4.0, PREP_TIME_WIDTH, 16.0);
}



#pragma mark -
#pragma mark Tree set accessor

- (void)setTree:(InventoryTree *)newTree {
    if (newTree != tree) {
        [tree release];
        tree = [newTree retain];
	}

	for (Image *i in [tree mutableSetValueForKeyPath:@"images"]) {
		if ([i.isThumbnail boolValue] == YES) {
			imageView.image = [UIImage imageWithData:i.image_data];
		}
	}

	
	nameLabel.text = tree.name;
	gpsLabel.text = tree.gps;
}



#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [tree release];
    [imageView release];
    [nameLabel release];
    [created_atLabel release];
    [gpsLabel release];
    [super dealloc];
}



@end
