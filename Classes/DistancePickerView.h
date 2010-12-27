//
//  DistancePickerView.h
//  Trees
//
//  Created by Evan on 12/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DistancePickerView : UIPickerView {
	NSMutableDictionary *labels;
}

- (void) addLabel:(NSString *)labeltext forComponent:(NSUInteger)component forLongestString:(NSString *)longestString;
- (void) updateLabel:(NSString *)labeltext forComponent:(NSUInteger)component;
@end
