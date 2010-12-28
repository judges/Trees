// 
//  Distance.m
//  Trees
//
//  Created by Evan on 12/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Distance.h"


@implementation Distance 

@dynamic m;
@dynamic in;
@dynamic cm;
@dynamic ft;

-(void)willSave {
	if([[self.changedValues allKeys] containsObject:@"cm"] && ![[self.changedValues allKeys] containsObject:@"in"]) {
		//metric
		//NSNumber *feet = [NSNumber numberWithDouble: [[self.changedValues valueForKey:@"m"] intValue] / 0.3048];
		//NSNumber *fractionalFeet = [NSNumber numberWithDouble:[feet doubleValue] - round([feet doubleValue])];
		//NSLog(@"%d, %d", [feet doubleValue], [fractionalFeet doubleValue]);
		self.ft = [NSNumber numberWithDouble: [[self.changedValues valueForKey:@"m"] intValue] / 0.3048];
		self.in = [NSNumber numberWithInt: round([[self.changedValues valueForKey:@"cm"] intValue] / 2.54)];
		//NSLog(@"%d, %d, %d, %d", [self.m intValue], [self.cm intValue], [self.ft intValue], [self.in intValue]);
	} else if ([[self.changedValues allKeys] containsObject:@"in"] && ![[self.changedValues allKeys] containsObject:@"cm"]) {
		//imperial
		self.m = [NSNumber numberWithDouble: [[self.changedValues valueForKey:@"ft"] intValue] / 3.2808];
		self.cm = [NSNumber numberWithInt: round([[self.changedValues valueForKey:@"in"] intValue] / 0.3837)];
		//NSLog(@"%d, %d, %d, %d", [self.m intValue], [self.cm intValue], [self.ft intValue], [self.in intValue]);
	} else {
		//ready to save once we get here. The above options end up calling willSave again, so this else ensures that there's no inf loop
	}
}
@end
