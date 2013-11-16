//
//  GameSelectView.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 4/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameSelectView.h"
#import "BalloonChallengeAppDelegate.h"


@implementation GameSelectView
@synthesize continueView, startOverView;
@synthesize gameSelectDelegate;

- (id) init {
	if (self = [super init]) {

		
	}
	[self wobbleView];

	return self;
}

 




- (void)dealloc {
    [super dealloc];
	//[label release];
	[continueView release];
	[startOverView release];
}


@end
