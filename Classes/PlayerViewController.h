//
//  PlayerViewController.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 3/3/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"

typedef enum {
	highestLevel,
	highestScore,
	timePlayed,
	numPlayerStats
} PlayerStatsEnum;

@interface PlayerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {

	Player *player;
	UITableView *statsTable;
}

@property (nonatomic, retain) Player *player;
@property (nonatomic, retain) IBOutlet UITableView *statsTable;

- (IBAction) clearStats;

@end
