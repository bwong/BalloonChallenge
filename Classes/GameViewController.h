//
//  GameViewController.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 2/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameView.h"

#define kGameStatePaused 1
#define kGameStateRunning 2
@interface GameViewController : UIViewController <UIActionSheetDelegate> {
	GameView *gv;
	NSInteger gameState;
	UILabel *beginLabel;
	NSTimer *gameTimer;
	NSTimer *balloonTimer;
	NSMutableArray *balloons;
}
@property (nonatomic, retain) IBOutlet GameView *gv;
@property (nonatomic, retain) IBOutlet UILabel *beginLabel;
@property (nonatomic) NSInteger gameState;
@property (nonatomic, retain) NSTimer *gameTimer;
@property (nonatomic, retain) NSTimer *balloonTimer;
@property (nonatomic, retain) NSMutableArray *balloons;

- (void) createBalloon;
- (IBAction) touchScreen: (id) sender;
- (BOOL) didTouchBalloon: (Balloon *) balloon withTouch: (UITouch *) touch;
-(IBAction) wonGame: (BOOL) didWin 
		  withScore: (NSInteger) score;

@end
