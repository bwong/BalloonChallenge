//
//  GameViewController.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 2/21/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "GameViewController.h"
#import "BalloonFactory.h"
#import "ChallengeFactory.h"
#import "PlayerDatabase.h"
#import "MathChallenge.h"
#import "GameView.h"


@implementation GameViewController
@synthesize totalScore,startTime, levelTimer, timeLeft, gameState, beginLabel, gv, gameTimer, balloonTimer, scoreLabel, score;
@synthesize pauseButton;
@synthesize level;
@synthesize isExiting;
@synthesize gameOverViewController;
@synthesize pauseDialogueShowing;
@synthesize resignActiveCalled;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	if (gameState == kGameStatePaused && pauseDialogueShowing == NO)
		return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
	else {
		return NO;
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
//	BalloonChallengeAppDelegate *appDelegate = 
//	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	self.gameOverViewController.gameOverDelegate = self;

	//no balloons moving
	self.totalScore = 0;
	currentBalloon = 0;
	balloonsLeft = 0;
	balloons = [[NSMutableArray alloc] init];
	self.gameState = kGameStatePaused;
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillResign)
												 name:UIApplicationWillResignActiveNotification 
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationDidBecomeActive)
												 name:UIApplicationDidBecomeActiveNotification 
											   object:nil];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	if (self.isExiting) {
		self.isExiting = NO;
		return;
	}

	self.gameState = kGameStatePaused;
	
	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	self.level = appDelegate.defaultPlayer.level;
	currentDifficulty = appDelegate.gameState.currentDifficulty;
	[appDelegate stopMusic];
	[appDelegate setMusicPlayer:e_music2];
	[appDelegate playMusic];
	
	[self setupGame];
}

- (void) resetScore: (NSInteger) myscore andTime: (NSInteger) time {
	self.score = myscore;
	scoreLabel.text = [NSString stringWithFormat:@"%d",myscore];
	timeLeft.text = [NSString stringWithFormat:@"%d",time];
}

- (IBAction) pausePressed {
	if (pauseDialogueShowing)
		return;	
	pauseDialogueShowing = YES;

	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	[appDelegate pauseMusic];
	
	if (gameState==kGameStateRunning) {
		gameState = kGameStatePauseMidGame;

	} 
	
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Paused" 
						  message:@""
						  delegate:self 
						  cancelButtonTitle:@"Resume!"
						  otherButtonTitles:@"Level Menu", nil];
	
	[alert show];
	[alert release];
}

- (void) applicationDidBecomeActive {
	//check if the window is active
	if (self.view.window==nil)
		return;	
	resignActiveCalled = NO;

	[self pausePressed];
}

- (void) applicationWillResign {
	//check if the window is active
	if (self.view.window==nil)
		return;	
	self.resignActiveCalled = YES;

	if (gameState==kGameStateRunning) {
		self.gameState = kGameStatePauseMidGame;
		BalloonChallengeAppDelegate *appDelegate = 
		(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
		[appDelegate pauseMusic];
	} 
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	//if cancelling because application will resign
	if (resignActiveCalled) {
		self.resignActiveCalled = NO;
		return;
	}
	self.pauseDialogueShowing = NO;

	if (buttonIndex ==0) {
		if (self.gameState == kGameStatePauseMidGame) {
			self.gameState = kGameStateRunning;
		}
		BalloonChallengeAppDelegate *appDelegate = 
		(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
		[appDelegate playMusic];
	}
	if (buttonIndex == 1) {
		//stop timers
		[self stopTimers];
		[self exitGame];
	}
}

//this is not when the view unloads, but when we exit the game view to the main menu
-(void) exitGame {
	
	gameState = kGameStatePaused;

	[self resetScore:0 andTime:startTime];
	totalScore = 0;

	if (mc != nil) {
		[mc release];
		mc = nil;
	}
	
	//clear out balloons
	[self clearAllBalloons];

	//stop music
	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	[appDelegate stopMusic];
	[appDelegate setMusicPlayer:e_music1];
	[appDelegate playMusic];
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void) decrementTime {
	if (gameState!=kGameStateRunning) {
		return;
	}
	//each time decrementTime is called, try to clear the popped balloons
	[self clearPoppedBalloons];
	
	NSString *timeStr = timeLeft.text; 
	int secI = [timeStr intValue];
	secI-=1;
	timeLeft.text = [NSString stringWithFormat:@"%d",secI];
	if ( secI<=0) {
		//TIME IS UP!
		[self wonGame:kTimeIsUp];
	}
	
}

- (void) startBalloon {
	//if there are no more balloons to start, just return
	if (currentBalloon==totalBalloons || gameState != kGameStateRunning)
		return;
	Balloon * b = [balloons objectAtIndex:currentBalloon];
	b.yVelocity = [mc getBalloonSpeed];
	currentBalloon += 1;
}

- (void) gameLoop {
	if (gameState == kGameStateRunning){
		
		for (int i = gv.subviews.count; i>0; i--) {
			Balloon *b = [gv.subviews objectAtIndex:i-1];
			if ( [b isMemberOfClass:[Balloon class]] ) {
				[ (Balloon *) b move];
				if ((b.frame.origin.y + b.frame.size.height) < 0 ) {					
					// check if the balloon missed was a correct answer
					if ([mc isCorrectAnswer:b.label.text]) {
						//misses++;
						//self.score += mc.ptsIncorrect;
						b.score = mc.ptsIncorrect;
						//if (self.score < 0) {
//							self.score = 0;
//						}
						[b popTimer];
						//scoreLabel.text = [NSString stringWithFormat:@"%d",self.score];
					} else {
						balloonsLeft--;
						// remove the balloon
						[b removeFromSuperview];
						// all the balloons are gone end the game
						if (balloonsLeft == 0) {
							[self wonGame:kNoMoreBalloons];
						}
					}
					

				}
			}
		}		
	}
	else if (gameState == kGameStatePaused) {
	}
}

- (void) clearPoppedBalloons {
	//release old balloons
	for (UIView *b in gv.subviews) {
		if ( [b isMemberOfClass:[Balloon class]] && [(Balloon*) b isPopped] ) {
			[b removeFromSuperview];
		}
	}
	
}

- (void) clearAllBalloons {
	//release old balloons
	currentBalloon = 0;
	for (UIView *b in gv.subviews) {
		if ( [b isMemberOfClass:[Balloon class]] ) {
			[b removeFromSuperview];
			[b release];
		}
	}
	[balloons removeAllObjects];
}

- (void) setupGame {
	if (mc != nil)
		[mc release];
	
	//Set challenge
	mc = [ChallengeFactory createChallengeByLevel:level andDifficulty:currentDifficulty];
	
	gv.backgroundImg.image = [UIImage imageNamed:@"bg_balloons.png"];
	gv.backgroundImg.alpha = 0.70f;
	gv.textView.text = mc.challengeText;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		gv.textView.font = [UIFont fontWithName:@"Marker Felt" size:32.0];
	} else {
		gv.textView.font = [UIFont fontWithName:@"Marker Felt" size:18.0];
	}

	gv.textView.hidden = NO;
	gv.textBackground.hidden = NO;
	
	//gv.textView.userInteractionEnabled = YES;

	[gv.textView resignFirstResponder];
	[gv.textView flashScrollIndicators];
	
	beginLabel.text = [NSString stringWithFormat:@"Tap To Start:\n%@!",[mc getChallengeString]];
	
	hits=0;
	misses=0;
	
	//get array of answers
	NSArray* numbers = mc.challengeAnswers;
	totalBalloons = balloonsLeft = numbers.count;
	Balloon *b;

	for (NSString* str in numbers) {
		int thescore = mc.ptsIncorrect;
		if ([mc isCorrectAnswer:str]) {
			thescore = mc.ptsCorrect;
		}
		if (mc.challengeType == ChallengeColor)
			b = [BalloonFactory createBalloonWithColor:[str intValue]
											   andText:str
											   inFrame:gv.frame
											 withScore:thescore];
		else {
			b = [BalloonFactory createBalloonWithText:str
											  inFrame:gv.frame
											withScore:thescore];
		}
		b.balloonDelegate = self;

		[balloons addObject:b];
		[self.gv addSubview:b];
	}
	
}

-(void) balloonPopped: (Balloon*) b {
	
	if (b.score>0) {
		hits++;
	} else {
		misses++;
	}
	score += b.score;	
	if (self.score < 0)
		self.score=0;

	scoreLabel.text = [NSString stringWithFormat:@"%d",score];
	balloonsLeft--;
	// all the balloons are gone end the game
	if (balloonsLeft == 0) {
		[self wonGame:kNoMoreBalloons];
	}
}

-(void) startTimers{
    if (gameTimer || levelTimer || balloonTimer) { 
        gameTimer=Nil;
    }
	
	//timer for the game
	gameTimer = [NSTimer scheduledTimerWithTimeInterval:0.04f 
												 target:self
											   selector:@selector(gameLoop) 
											   userInfo:nil 
												repeats:YES];
	//timer for the clock
	levelTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f 
												  target:self
												selector:@selector(decrementTime) 
												userInfo:nil 
												 repeats:YES];
	
	//start a balloon every x seconds
	balloonTimer = [NSTimer scheduledTimerWithTimeInterval:(mc.releaseSpeed)
													target:self
												  selector:@selector(startBalloon) 
												  userInfo:nil 
												   repeats:YES];
	
	
	gameState = kGameStateRunning;
}

-(void) stopTimers{
	gameState = kGameStatePaused;

    if (gameTimer) {
        [gameTimer invalidate];
        gameTimer=nil;
    }
	if (levelTimer) {
		[levelTimer invalidate];
		levelTimer = nil;
	}
	if (balloonTimer) {
		[balloonTimer invalidate];
		balloonTimer = nil;
	}
}

- (void) touchesBegan: (NSSet *) touches 
			withEvent: (UIEvent *) event {
	//if game is in paused state, first touch starts the game
	if (gameState == kGameStatePaused) {
		if ( CGRectContainsPoint(pauseButton.frame, [[touches anyObject] locationInView:nil])) {
			[self pausePressed];
			return;
		}
		gv.backgroundImg.image = mc.gameImage;
		gv.backgroundImg.alpha = 1.0f;
		
		[pauseButton setEnabled:YES];
		startTime = mc.seconds;
	
		gv.textView.hidden = YES;
		gv.textBackground.hidden = YES;
		beginLabel.text = [NSString stringWithFormat:@"%@!", [mc getChallengeString]];
		[self resetScore:0 andTime:startTime];
		
		[self startTimers];
	} 
}


-(IBAction) wonGame: (int) reason {
	//stop timers
	[self stopTimers];
	
	//clear out balloons
	[self clearAllBalloons];

	//set allert message
	NSMutableString* winLabel = nil;
	
	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	Player *p = appDelegate.defaultPlayer;
	
	float percent = 0.0f;
	
	//update stats if hit at least one balloon
	if (hits != 0) {
		float temphits = hits;
		float tempmisses = misses;
        int timeElapsed = startTime - [timeLeft.text intValue];
		percent = (temphits/(temphits+tempmisses));
		[p addPlayerStatsForLevel:level 
					andDifficulty:currentDifficulty 
					   andCorrect:temphits
					 andIncorrect:tempmisses
						  andTime:timeElapsed];
	}
	NSMutableString* percentCorrectStr;
	percent *=100;
	if (percent >= 70 && percent < 80) {
		percentCorrectStr = [NSMutableString stringWithFormat:@"Well done, you got %d%% correct!", (int) percent];
	} else if (percent >= 80 && percent < 90) {
		percentCorrectStr = [NSMutableString stringWithFormat:@"You are good, you got %d%% correct!", (int) percent];
	} else if (percent >= 90 && percent < 100) {
		percentCorrectStr = [NSMutableString stringWithFormat:@"Excellent job, you got %d%% correct!", (int) percent];
	} else if (percent == 100) {
		percentCorrectStr = [NSMutableString stringWithFormat:@"Perfect! You are amazing, %d%% correct!", (int) percent];
	} else {
		percentCorrectStr = [NSMutableString stringWithFormat:@"That was hard, you got %d%% correct!", (int) percent];
	}

	if (percent > mc.percentCorrect*100) {
		// if win, increment total score
		totalScore += score;
		
		BOOL isHighScore = [appDelegate.highScoreArray isHighScore:totalScore];
		NSString *highScore = [NSMutableString stringWithString:@""];
		
        //If this is a high score, add something to the info
        if (isHighScore)
		{
			highScore = [NSMutableString stringWithString:@"Congratulations, You have a High Score!\n\n"];
			//update high score list
            [appDelegate.highScoreArray addScore:totalScore withName:p.name];
		}		
		
		Level *templevel = [Level levelWithGame:level.game withProgression:level.progression withChallenge:level.challenge];
		if ([templevel isLastLevel:templevel.game]) {
			winLabel = [NSMutableString stringWithFormat:@"Congratulations, you completed this math challenge!\n\n"
						"YOU ARE A MATH WIZ!\n\n"
						"Try the Practice Mode and work on levels that you have not perfected. "
						"Be amazed at how your math skills grow!"];
			// all
		} else {
			[templevel incrementLevel];
			Level *l = [p.currentStats.highestLevel valueForKey:[templevel getGameName]];

			if ([templevel compare:l]==NSOrderedAscending) {
				[p.currentStats.highestLevel setValue:templevel forKey:[templevel getGameName]];
			}
			
			winLabel = [NSMutableString stringWithFormat:
						@"%@%@\n\nNext Level: %@",
						highScore, 
						percentCorrectStr,
						[templevel getChallengeName]];
			// high score try again and level menu
		}
		
	} else {
		winLabel = [NSMutableString stringWithFormat:@"%s\nKeep practicing to improve your grade!",
					[percentCorrectStr UTF8String]];
		// try again and level menu

	}
			 [self showGameOverWithText:winLabel 
					  andPercentCorrect:percent];
}


-(void) showGameOverWithText:(NSString*)text 
		   andPercentCorrect:(int)percentCor {

	[self presentModalViewController:gameOverViewController animated:YES];

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		gameOverViewController.gameOverLabel.font = [UIFont fontWithName:@"Marker Felt" size:32.0];
	} else {
		gameOverViewController.gameOverLabel.font = [UIFont fontWithName:@"Marker Felt" size:18.0];
	}
	
	gameOverViewController.gameOverLabel.text = text;
	[gameOverViewController.tableData setObject:[NSString stringWithFormat:@"%d%%", (int) percentCor] forKey:[[GameOverViewController gameOverStats] objectAtIndex:0]];
	[gameOverViewController.tableData setObject:[NSString stringWithFormat:@"%d", self.score] forKey:[[GameOverViewController gameOverStats] objectAtIndex:1]];
	[gameOverViewController.tableData setObject:[NSString stringWithFormat:@"%d", self.totalScore] forKey:[[GameOverViewController gameOverStats] objectAtIndex:2]];
	
	if (percentCor < mc.percentCorrect*100) {
		gameOverViewController.nextLevelButton.enabled = NO;
	} else {
		gameOverViewController.nextLevelButton.enabled = YES;
	}
	[gameOverViewController.nextLevelButton setBackgroundImage:[UIImage imageNamed:@"balloon_red_cross.png"]
													  forState:UIControlStateDisabled];
}


-(void) levelMenuPressed: (id) sender {
	self.isExiting = YES;
	[gameOverViewController dismissModalViewControllerAnimated:NO];
	//[gameOverViewController release];

	[self exitGame];
}

-(void) nextLevelPressed {
	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	[appDelegate.defaultPlayer.level incrementLevel];
	[gameOverViewController dismissModalViewControllerAnimated:NO];
}

-(void) playAgainPressed {

	//level was incremented, so reset it
	//level = appDelegate.defaultPlayer.level;
	//[appDelegate.defaultPlayer.level decrementLevel];
	[gameOverViewController dismissModalViewControllerAnimated:NO];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[mc release];
	[gv release];
	[level release];
	[scoreLabel release];
	[beginLabel release];
	[timeLeft release];
	[gameTimer release];
	[levelTimer release];
	[balloonTimer release];
	[balloons release];
    [super dealloc];
}


@end
