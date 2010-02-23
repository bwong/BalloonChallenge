//
//  BalloonChallengeViewController.h
//  BalloonChallenge
//
//  Created by Brian Wong on 2/6/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"

@interface BalloonChallengeViewController : UIViewController {
	GameViewController *gameViewController;
}

@property (nonatomic, retain) IBOutlet GameViewController *gameViewController;

-(IBAction) gameButtonPressed: (id) sender;

@end

