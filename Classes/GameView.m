//
//  GameView.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 2/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameView.h"


@implementation GameView
@synthesize backgroundImg;
@synthesize gameDelegate;
@synthesize textView, textBackground;

- (id) initWithCoder:(NSCoder *)aDecoder{
	if (self = [super initWithCoder:aDecoder]) {
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
	}
    return self;
}

- (void) touchesBegan: (NSSet *) touches 
			withEvent: (UIEvent *) event {
	[self.nextResponder touchesBegan: touches withEvent:event]; 
}


- (void)dealloc {	
    [super dealloc];
}


@end
