//
//  HighScoresViewController.h
//  BalloonChallenge
//
//  Created by Brian Wong on 2/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BalloonChallengeAppDelegate.h"

@interface HighScoresViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *playerNameList;
    UITableView *playerTableView;
    UIButton *mainMenuButton;
}

@property (nonatomic, retain) NSMutableArray *playerNameList;
@property (nonatomic, retain) IBOutlet UITableView *playerTableView;
@property (nonatomic, retain) IBOutlet UIButton *mainMenuButton;

- (IBAction) mainMenuButtonPressed: (id) sender;

@end
