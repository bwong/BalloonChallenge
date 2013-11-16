//
//  GameOverViewController.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 5/2/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)


@interface GameOverViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	id gameOverDelegate;
	UIViewController *highScoresViewController;
	BOOL levelMenuTouched;
	UITableView *statsTable;
	NSMutableDictionary *tableData;
	UILabel *gameOverLabel;

	
	NSString *playerName;
	NSString *levelName;
	
	UIButton *nextLevelButton;
	UIButton *playAgainButton;
	UIButton *gradeButton;
	UIButton *levelMenuButton;
}

@property (assign) id gameOverDelegate;
@property BOOL levelMenuTouched;

@property (nonatomic,retain) IBOutlet UILabel *gameOverLabel;

@property (nonatomic,retain) NSString *playerName;
@property (nonatomic,retain) NSString *levelName;

@property (retain) NSMutableDictionary *tableData;
@property (nonatomic, retain) IBOutlet UITableView *statsTable;

@property (nonatomic,retain) IBOutlet UIButton *nextLevelButton;
@property (nonatomic,retain) IBOutlet UIButton *playAgainButton;
@property (nonatomic,retain) IBOutlet UIButton *gradeButton;
@property (nonatomic,retain) IBOutlet UIButton *levelMenuButton;


-(IBAction) buttonPressed: (id) sender;
- (void) wobbleView: (UIView *) v;
-(void) setupButtons;
+(NSMutableArray *) timeChallengeStats;
+(NSMutableArray *) gameOverStats;

@end

@protocol GameOverDelegate 
@required
-(void) levelMenuPressed: (id) sender;
-(void) playAgainPressed;
-(void) nextLevelPressed;
@optional

@end
