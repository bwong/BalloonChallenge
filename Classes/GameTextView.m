//
//  GameTextView.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 4/18/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "GameTextView.h"


@implementation GameTextView


- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
	if (self) {
		self.font = [UIFont fontWithName:@"Marker Felt" size:20.0];
		self.editable = NO;
		self.scrollEnabled=YES;
	}
	return self;
}


- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated
{
	// do nothing. This fixes the cursor jumping above the field defect.
}

- (void)viewDidAppear:(BOOL)animated {

	[self flashScrollIndicators];
	self.showsVerticalScrollIndicator = YES;
}


-(void) touchesCancelled: (NSSet *) touches withEvent: (UIEvent *) event 
{		
	if (!self.dragging) {		
		[self.nextResponder touchesBegan: touches withEvent:event]; 
	}		
	
	[super touchesCancelled:touches withEvent: event];
}



- (void)dealloc {
    [super dealloc];
}


@end
