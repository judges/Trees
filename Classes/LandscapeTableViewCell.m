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
- (CGRect)_address1LabelFrame;
- (CGRect)_cityLabelFrame;
- (CGRect)_gpsLabelFrame;
@end

#pragma mark -
#pragma mark LandscapeTableViewCell implementation

@implementation LandscapeTableViewCell

@synthesize landscape, imageView, nameLabel, address1Label, cityLabel, stateLabel, zipLabel, gpsLabel;

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		

		
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		[imageView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:imageView];
		
        address1Label = [[UILabel alloc] initWithFrame:CGRectZero];
        [address1Label setFont:[UIFont systemFontOfSize:12.0]];
        [address1Label setTextColor:[UIColor darkGrayColor]];
        [address1Label setHighlightedTextColor:[UIColor whiteColor]];
		[address1Label setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:address1Label];

        cityLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [cityLabel setFont:[UIFont systemFontOfSize:12.0]];
        [cityLabel setTextColor:[UIColor darkGrayColor]];
        [cityLabel setHighlightedTextColor:[UIColor whiteColor]];
		[cityLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:cityLabel];		

        stateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [stateLabel setFont:[UIFont systemFontOfSize:12.0]];
        [stateLabel setTextColor:[UIColor darkGrayColor]];
        [stateLabel setHighlightedTextColor:[UIColor whiteColor]];
		[stateLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:stateLabel];			

        zipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [zipLabel setFont:[UIFont systemFontOfSize:12.0]];
        [zipLabel setTextColor:[UIColor darkGrayColor]];
        [zipLabel setHighlightedTextColor:[UIColor whiteColor]];
		[zipLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:zipLabel];		
		
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
 To save space, the prep time label disappears during editing.
 */
- (void)layoutSubviews {
    [super layoutSubviews];
	
    [imageView setFrame:[self _imageViewFrame]];
    [nameLabel setFrame:[self _nameLabelFrame]];
    [address1Label setFrame:[self _address1LabelFrame]];
    [cityLabel setFrame:[self _cityLabelFrame]];
    [gpsLabel setFrame:[self _gpsLabelFrame]];
    if (self.editing) {
        gpsLabel.alpha = 0.0;
    } else {
        gpsLabel.alpha = 1.0;
    }
}


#define IMAGE_SIZE          64.0
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

- (CGRect)_address1LabelFrame {
    if (self.editing) {
        return CGRectMake(IMAGE_SIZE + EDITING_INSET + TEXT_LEFT_MARGIN, 22.0, self.contentView.bounds.size.width - IMAGE_SIZE - EDITING_INSET - TEXT_LEFT_MARGIN, 16.0);
    }
	else {
        return CGRectMake(IMAGE_SIZE + TEXT_LEFT_MARGIN, 22.0, self.contentView.bounds.size.width - IMAGE_SIZE - TEXT_LEFT_MARGIN, 16.0);
    }
}

- (CGRect)_cityLabelFrame {
    if (self.editing) {
        return CGRectMake(IMAGE_SIZE + EDITING_INSET + TEXT_LEFT_MARGIN, 38.0, self.contentView.bounds.size.width - IMAGE_SIZE - EDITING_INSET - TEXT_LEFT_MARGIN, 16.0);
    }
	else {
        return CGRectMake(IMAGE_SIZE + TEXT_LEFT_MARGIN, 38.0, self.contentView.bounds.size.width - IMAGE_SIZE - TEXT_LEFT_MARGIN, 16.0);
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

	NSString *city = [landscape.city stringByAppendingString:@", "];
	NSString *state = [landscape.state stringByAppendingString:@" "];
	NSString *zip = [landscape.zip stringByAppendingString:@" "];
		
	NSString *cityStateZipString = [[city stringByAppendingString:state] stringByAppendingString:zip];

	imageView.image = landscape.thumbnailImage;
	nameLabel.text = landscape.name;
	address1Label.text = landscape.address1;	
	cityLabel.text = cityStateZipString;	
	gpsLabel.text = landscape.gps;
}






#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [landscape release];
    [imageView release];
    [nameLabel release];
    [address1Label release];
	[cityLabel release];
	[stateLabel release];
	[zipLabel release];
    [gpsLabel release];
    [super dealloc];
}

@end
