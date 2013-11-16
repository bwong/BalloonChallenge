//
//  TimeChallengeViewController.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 7/11/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameOverViewController.h"
#import "AVFoundation/AVAudioPlayer.h"
#import "Balloon.h"

typedef enum {
	e_GameStatePaused,
	e_GameStateRunning,
	e_GameStatePauseMidGame
} GameStateEnum;

@class GameView;

@interface TimeChallengeViewController : UIViewController <UIAlertViewDelegate, BalloonDelegate, GameOverDelegate, UIApplicationDelegate> {
	BOOL isExiting;
	BOOL resignActiveCalled;
	BOOL pauseDialogueShowing;
	// level id
	unsigned int timeLevel;
	//number of lives left
	unsigned int livesLeft;
	unsigned int timeElapsed;
	
	UILabel *timeLabel;
	UIButton *pauseButton;
	UILabel *challengeLabel;

	GameStateEnum gameState;
	GameView *gv;
	MathChallenge *mc;
	ChallengeGroupType challengeType;
	ChallengeDifficulty currentDifficulty;
	
	NSTimer *gameTimer;
	NSTimer *levelTimer;
	NSTimer *balloonTimer;
	NSLock *lock;

	
	UIImageView *balloonLife1;
	UIImageView *balloonLife2;
	UIImageView *balloonLife3;
	UIImageView *balloonLife4;
	UIImageView *balloonLife5;
	
	NSString *challengeGroupName;
	//the list of balloons for the current math challenge
	NSMutableArray *balloons;
	//what balloon are we on in list of started balloons
	int currentBalloon;
	//total balloons this round
	int totalBalloons;
	//how many left to go in this round
	int balloonsLeft;
	// keeps track of number correct per level
	int hits;
	unsigned int currentCombo;
	unsigned int maxCombo;
	unsigned int score;
	
	GameOverViewController *gameOverViewController;

	UILabel *levelUpViewLabel;
	UIView *levelUpView;
	UILabel *comboLabel;
	UILabel *scoreLabel;
}
@property (retain) IBOutlet GameView *gv;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UILabel *challengeLabel;
@property (nonatomic, retain) IBOutlet UIImageView *balloonLife1;
@property (nonatomic, retain) IBOutlet UIImageView *balloonLife2;
@property (nonatomic, retain) IBOutlet UIImageView *balloonLife3;
@property (nonatomic, retain) IBOutlet UIImageView *balloonLife4;
@property (nonatomic, retain) IBOutlet UIImageView *balloonLife5;
@property (nonatomic, retain) IBOutlet UIButton *pauseButton;

@property (nonatomic, retain) IBOutlet UILabel *levelUpViewLabel;
@property (nonatomic, retain) IBOutlet UILabel *comboLabel;
@property (nonatomic, retain) IBOutlet UIView *levelUpView;
@property (retain) IBOutlet GameOverViewController *gameOverViewController;

@property (retain) MathChallenge *mc;
@property (nonatomic, retain) NSTimer *gameTimer;
@property (nonatomic, retain) NSTimer *levelTimer;
@property (nonatomic, retain) NSTimer *balloonTimer;

@property (nonatomic, retain) NSString *challengeGroupName;

@property (nonatomic) BOOL pauseDialogueShowing;
@property (nonatomic) BOOL isExiting;
@property (nonatomic) BOOL resignActiveCalled;

@property (nonatomic) GameStateEnum gameState;
@property (nonatomic) ChallengeGroupType challengeType;
@property (nonatomic) unsigned int timeLevel;
@property (nonatomic) unsigned int timeElapsed;
@property (nonatomic) unsigned int currentCombo;
@property (nonatomic) unsigned int maxCombo;
@property (nonatomic) unsigned int score;
@property (nonatomic,retain) IBOutlet UILabel *scoreLabel;

@property (nonatomic) ChallengeDifficulty currentDifficulty;

- (IBAction) pausePressed;

- (void) setLives: (unsigned int) numLives;
- (void) gameLoop;
- (void) setupLevel;
- (void) startBalloon;
- (void) clearAllBalloons;
- (void) clearPoppedBalloons;
- (void) levelUp;
- (void) exitGame;
- (void) endGame;
- (void) rescheduleBalloonTimer;


- (void) startTimers;
- (void) stopTimers;

- (void) balloonPopped: (Balloon*) b;

- (void) decrementLives;
-(void) displayComboView;
- (void) displayLevelUpView;
- (void) flyAway:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
- (void) hideLevelUpView:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@end
