//
//  BalloonChallengeAppDelegate.h
//  BalloonChallenge
//
//  Created by Brian Wong on 2/6/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BalloonChallengeViewController;

@interface BalloonChallengeAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    BalloonChallengeViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BalloonChallengeViewController *viewController;

@end

