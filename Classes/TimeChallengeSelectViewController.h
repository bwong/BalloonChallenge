//
//  TimeChallengeSelectViewController.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 7/11/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimeChallengeViewController;

@interface TimeChallengeSelectViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView *gameSelectTable;
	TimeChallengeViewController *timeChallengeViewController;

}

@property (retain,nonatomic) IBOutlet UITableView *gameSelectTable;
@property (retain,nonatomic) IBOutlet TimeChallengeViewController *timeChallengeViewController;


- (void) mainMenuButtonPressed: (id) sender;
- (UIImage *)scale:(UIImage *)image toSize:(CGSize)size;
- (void) setupViews;

@end
