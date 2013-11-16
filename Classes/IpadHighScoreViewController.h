//
//  IpadHighScoreViewController.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 6/21/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Player;

@interface IpadHighScoreViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *highScoreTable;
	IBOutlet UITableView *statsTable;
	
	Player *player;
}

@property (nonatomic, retain) Player *player;
@property (nonatomic, retain) UITableView *statsTable;
@property (nonatomic, retain) UITableView *highScoreTable;


- (IBAction) clearStats;


@end
