//
//  LandscapeTableViewCell.m
//  Trees
//
//  Created by Sean Clifford on 12/22/10.
//  Copyright 2010 NCPTT/National Park Service. All rights reserved.
//

#import "LandscapeTableViewCell.h"

#pragma mark -
#pragma mark SubviewFrames category

@interface LandscapeTableViewCell (SubviewFrames)
- (CGRect)_imageViewFrame;
- (CGRect)_nameLabelFrame;
- (CGRect)_descriptionLabelFrame;
- (CGRect)_gpsLabelFrame;
@end

#pragma mark -
#pragma mark LandscapeTableViewCell implementation

@implementation LandscapeTableViewCell

@synthesize landscape, imageView, nameLabel, overviewLabel, gpsLabel;



#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imageView];
		
        overviewLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [overviewLabel setFont:[UIFont systemFontOfSize:12.0]];
        [overviewLabel setTextColor:[UIColor darkGrayColor]];
        [overviewLabel setHighlightedTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:overviewLabel];
		
        gpsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        gpsLabel.textAlignment = UITextAlignmentRight;
        [gpsLabel setFont:[UIFont systemFontOfSize:12.0]];
        [gpsLabel setTextColor:[UIColor blackColor]];
        [gpsLabel setHighlightedTextColor:[UIColor whiteColor]];
		gpsLabel.minimumFontSize = 7.0;
		gpsLabel.lineBreakMode = UILineBreakModeTailTruncation;
        [self.contentView addSubview:gpsLabel];
		
        nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [nameLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [nameLabel setTextColor:[UIColor blackColor]];
        [nameLabel setHighlightedTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:nameLabel];
    }
	
    return self;
}


#pragma mark -
#pragma mark Laying out subviews

/*
 To save space, the prep time label disappears during editing.
 */
- (void)layoutSubviews {
    [super layoutSubviews];
	
    [imageView setFrame:[self _imageViewFrame]];
    [nameLabel setFrame:[self _nameLabelFrame]];
    [overviewLabel setFrame:[self _descriptionLabelFrame]];
    [gpsLabel setFrame:[self _gpsLabelFrame]];
    if (self.editing) {
        gpsLabel.alpha = 0.0;
    } else {
        gpsLabel.alpha = 1.0;
    }
}


#define IMAGE_SIZE          42.0
#define EDITING_INSET       10.0
#define TEXT_LEFT_MARGIN    8.0
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

- (CGRect)_descriptionLabelFrame {
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
#pragma mark Landscape set accessor

- (void)setLandscape:(Landscape *)newLandscape {
    if (newLandscape != landscape) {
        [landscape release];
        landscape = [newLandscape retain];
	}
	imageView.image = landscape.thumbnailImage;
	nameLabel.text = landscape.name;
	overviewLabel.text = landscape.overview;
	gpsLabel.text = landscape.gps;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [landscape release];
    [imageView release];
    [nameLabel release];
    [overviewLabel release];
    [gpsLabel release];
    [super dealloc];
}

@end
