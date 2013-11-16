//
//  Balloon.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MathChallenge.h"
#import "BalloonChallengeAppDelegate.h"


#define RADIANS(degrees) ((degrees * M_PI) / 180.0)


@interface Balloon : UIImageView {
	id balloonDelegate;
	int score;
	CGPoint currentPoint;
	CGFloat yVelocity;
	UILabel *label;
	BOOL isPopped;
	BOOL canbetouched;
	BOOL isCorrectAnswer;
	BalloonSoundEnum popSound;
}

@property (nonatomic) BalloonSoundEnum popSound;
@property (assign) id balloonDelegate;
@property CGPoint currentPoint;
@property CGFloat yVelocity;
@property BOOL isPopped;
@property BOOL canbetouched;
@property BOOL isCorrectAnswer;
@property int score;
@property (nonatomic,retain) IBOutlet UILabel *label;

- (void) move;

- (void) playPopSound;
- (void) popTimer;
- (void) popBalloonAnimation;
- (void) wobbleView;

- (void) setX:(CGFloat) xinit 
	 velocity:(CGFloat) vel 
		 text:newText
		image:(UIImage*) img
		score:(int) vscore;

@end

@protocol BalloonDelegate

@required
-(void) balloonPopped: (Balloon *) b;

@optional
-(void) balloonPoppedWithText: (NSString *) text;
-(void) getGameViewFrame;

@end
