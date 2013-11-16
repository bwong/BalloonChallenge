//
//  GameViewController.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 2/21/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "GameOverViewController.h"
#import "Balloon.h"

#define kGameStatePauseMidGame 0
#define kGameStatePaused 1
#define kGameStateRunning 2

#define kTimeIsUp 0
#define kNoMoreBalloons 1

@class MathChallenge;
@class GameView;

@interface GameViewController : UIViewController <UIAlertViewDelegate, BalloonDelegate, GameOverDelegate, UIApplicationDelegate> {
	BOOL isExiting;
	BOOL resignActiveCalled;
	BOOL pauseDialogueShowing;
	
	GameView *gv;
	GameOverViewController *gameOverViewController;
	NSInteger gameState;
	UILabel *scoreLabel;
	NSInteger score;
	NSInteger totalScore;
	UILabel *beginLabel;
	UILabel *timeLeft;
	NSTimer *gameTimer;
	NSTimer *levelTimer;
	NSTimer *balloonTimer;
	UIButton *pauseButton;

	//what balloon are we on in list of started balloons
	int currentBalloon;
	//total balloons this round
	int totalBalloons;
	//how many left to go in this round
	int balloonsLeft;
	// keeps track of number correct per level
	int hits;
	// keeps track of incorrect
	int misses;
	// level we are on
	Level *level;
	
	//the percent correct to win the current challenge
	float percentCorrect;
	//the seconds between each balloon is released
	float releaseInterval;
	
	
	//the list of balloons for the current math challenge
	NSMutableArray *balloons;
	//what time is this level starting at
	NSInteger startTime;
	//holds the info for setting the challenge and returning a list of answersto display
	MathChallenge *mc;
	ChallengeDifficulty currentDifficulty;
}
@property (nonatomic) BOOL isExiting;
@property (nonatomic) BOOL pauseDialogueShowing;
@property (nonatomic) BOOL resignActiveCalled;

@property (nonatomic, retain) IBOutlet GameOverViewController *gameOverViewController;

@property (nonatomic, retain) IBOutlet GameView *gv;
@property (nonatomic, retain) IBOutlet UILabel *beginLabel;
@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLeft;
@property (nonatomic, retain) IBOutlet UIButton *pauseButton;
@property (nonatomic, retain) Level *level;

@property (nonatomic) NSInteger gameState;
@property (nonatomic, retain) NSTimer *gameTimer;
@property (nonatomic, retain) NSTimer *levelTimer;
@property (nonatomic, retain) NSTimer *balloonTimer;
@property (nonatomic) NSInteger startTime;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger totalScore;

- (void) setupGame;
- (void) startTimers;
- (void) stopTimers;
- (void) clearPoppedBalloons;
- (void) startBalloon;
- (void) resetScore: (NSInteger) myscore andTime: (NSInteger) time;
- (IBAction) pausePressed;
- (void) applicationWillResign;
- (void) applicationDidBecomeActive;
- (void) clearAllBalloons;
- (void) exitGame;
-(void) showGameOverWithText:(NSString*)text
		   andPercentCorrect:(int)percentCor;

-(void) levelMenuPressed: (id) sender;
-(void) playAgainPressed;
-(void) nextLevelPressed;

@end
