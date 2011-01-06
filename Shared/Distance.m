// 
//  Distance.m
//  Trees
//
//  Created by Evan on 12/27/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import "Distance.h"


@implementation Distance 

@dynamic m;
@dynamic in;
@dynamic cm;
@dynamic ft;

-(void)willSave {
	
	if (([[self.changedValues allKeys] containsObject:@"cm"] || [[self.changedValues allKeys] containsObject:@"m"]) && !([[self.changedValues allKeys] containsObject:@"ft"] || [[self.changedValues allKeys] containsObject:@"in"])) {
		//metric was changed
		
		NSNumber *theCM;
		NSNumber *theM;
		//get new value if changed, otherwise get the stored value
		if ([[self.changedValues allKeys] containsObject:@"cm"]) {
			theCM = [self.changedValues valueForKey:@"cm"];
		} else {
			theCM = self.cm;
		}
		if ([[self.changedValues allKeys] containsObject:@"m"]) {
			theM = [self.changedValues valueForKey:@"m"];
		} else {
			theM = self.m;
		}

		NSNumber *inches = [NSNumber numberWithInt: round(([theCM intValue] + ([theM intValue]* 100)) / 2.54)]; 
		NSNumber *feet = [NSNumber numberWithInt: 0];
		while ([inches intValue] >= 12) {
			feet = [NSNumber numberWithInt:[feet intValue] + 1];
			inches = [NSNumber numberWithInt:[inches intValue] - 12];
		}
		self.ft = [NSNumber numberWithInt:[feet intValue]];
		self.in = [NSNumber numberWithInt:[inches intValue]];
	} else if (([[self.changedValues allKeys] containsObject:@"ft"] || [[self.changedValues allKeys] containsObject:@"in"]) && !([[self.changedValues allKeys] containsObject:@"cm"] || [[self.changedValues allKeys] containsObject:@"m"])) {
		//imperial was changed
		
		NSNumber *theFT;
		NSNumber *theIN;
		//get new value if changed, otherwise get the stored value
		if ([[self.changedValues allKeys] containsObject:@"ft"]) {
			theFT = [self.changedValues valueForKey:@"ft"];
		} else {
			theFT = self.ft;
		}
		if ([[self.changedValues allKeys] containsObject:@"in"]) {
			theIN = [self.changedValues valueForKey:@"in"];
		} else {
			theIN = self.in;
		}
		
		NSNumber *centimeters = [NSNumber numberWithInt:round(([theIN intValue] + ([theFT intValue] * 12)) / 0.3937)];
		NSNumber *meters = [NSNumber numberWithInt:0];
		while ([centimeters intValue] >= 100) {
			meters = [NSNumber numberWithInt:[meters intValue] + 1];
			centimeters = [NSNumber numberWithInt:[centimeters intValue] - 100];
		}
		self.m = [NSNumber numberWithInt:[meters intValue]];
		self.cm = [NSNumber numberWithInt:[centimeters intValue]];
	} else {
		//ready to save once we get here. The above options end up calling willSave again, so this else ensures that there's no inf loop
	}
}
@end
