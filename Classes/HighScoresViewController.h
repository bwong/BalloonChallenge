//
//  HighScoresViewController.h
//  BalloonChallenge
//
//  Created by Brian Wong on 2/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BalloonChallengeAppDelegate.h"
#import "PlayerViewController.h"

@interface HighScoresViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	UITableView *playerTableView;
	PlayerViewController *playerViewController;
}

@property (nonatomic, retain) IBOutlet UITableView *playerTableView;
@property (nonatomic, retain) IBOutlet PlayerViewController *playerViewController;

@end
