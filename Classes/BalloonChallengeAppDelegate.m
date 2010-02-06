//
//  BalloonChallengeAppDelegate.m
//  BalloonChallenge
//
//  Created by Brian Wong on 2/6/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "BalloonChallengeAppDelegate.h"
#import "BalloonChallengeViewController.h"

@implementation BalloonChallengeAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
