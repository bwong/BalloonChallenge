//
//  GameSelectViewController.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 4/24/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"
#import "GameSelectView.h"

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
@class PracticeSelectViewController;

@interface GameSelectViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	GameViewController *gameViewController;
	PracticeSelectViewController *practiceSelectViewController;
	UITableView *gameSelectTable;
	UIView *tableHolderView;
	UIView *gameStartHolderView;
	UILabel *gameLabel;
	UIToolbar *toolBar;
	UILabel *continueLabel;
	Level *highestLevel;
}
@property (retain,nonatomic) Level *highestLevel;

@property (retain,nonatomic) IBOutlet UIToolbar *toolBar;
@property (retain,nonatomic) IBOutlet UILabel *continueLabel;
@property (retain,nonatomic) IBOutlet UIView *tableHolderView;
@property (retain,nonatomic) IBOutlet UIView *gameStartHolderView;
@property (retain,nonatomic) IBOutlet UILabel *gameLabel;
@property (retain,nonatomic) IBOutlet UITableView *gameSelectTable;
@property (nonatomic, retain) IBOutlet GameViewController *gameViewController;
@property (nonatomic, retain) IBOutlet PracticeSelectViewController *practiceSelectViewController;

- (void) mainMenuButtonPressed: (id) sender;
- (void) displayViews;
- (IBAction) continueViewClick;
-(IBAction) practiceButtonPressed: (id) sender;
- (void) setupButtons;
- (void) popBalloonAnimation: (int) from;
-(void) gameSelected: (NSObject *) obj;

- (UIImage *)scale:(UIImage *)image toSize:(CGSize)size;

@end
