//
//  TimeChallengeViewController.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 7/11/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "TimeChallengeViewController.h"
#import "BalloonChallengeAppDelegate.h"
#import "GameView.h"
#import "ChallengeFactory.h"
#import "BalloonFactory.h"
#import "TimeChallengeStats.h"
#import "QuartzCore/CALayer.h"


@implementation TimeChallengeViewController
@synthesize gameState;
@synthesize pauseDialogueShowing, isExiting, resignActiveCalled;
@synthesize gv;
@synthesize timeLabel, challengeLabel;
@synthesize timeElapsed;
@synthesize currentDifficulty;
@synthesize challengeType;
@synthesize mc;
@synthesize timeLevel;
@synthesize pauseButton;
@synthesize balloonLife1, balloonLife2, balloonLife3, balloonLife4, balloonLife5;
@synthesize levelTimer,  gameTimer, balloonTimer;
@synthesize challengeGroupName;
@synthesize levelUpView;
@synthesize gameOverViewController;
@synthesize levelUpViewLabel;
@synthesize maxCombo, currentCombo, comboLabel;
@synthesize score,scoreLabel;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	if (gameState == e_GameStatePaused && pauseDialogueShowing == NO)
		return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
	else {
		return NO;
	}
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	lock = [[NSLock alloc] init];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillResign)
												 name:UIApplicationWillResignActiveNotification 
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationDidBecomeActive)
												 name:UIApplicationDidBecomeActiveNotification 
											   object:nil];

	levelUpView.hidden=YES;

}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (self.isExiting) {
		self.isExiting = NO;
		return;
	}
	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[appDelegate stopMusic];
	[appDelegate setMusicPlayer:e_gemdroids];
	[appDelegate playMusic];
	
	self.gameState = e_GameStatePaused;
	self.currentDifficulty = appDelegate.gameState.currentDifficulty;
	currentBalloon = 0;
	balloonsLeft = 0;
	livesLeft = 5;
	timeLevel = 0;
	timeElapsed = 0;
	score = 0;
	scoreLabel.text = [NSString stringWithFormat:@"0"];
	maxCombo = currentCombo = 0;
	comboLabel.hidden = YES;
	self.timeLabel.text = [NSString stringWithFormat:@"%d",0];
	//self.levelUpView.frame.origin.x = self.view.frame.size.width/2;

	balloons = [[NSMutableArray alloc] init];
	
	[self setLives:livesLeft];
	[self setupLevel];
}

-(void) displayComboView {
	comboLabel.hidden = NO;
	int bonusScore = (currentCombo<10) ? currentCombo : 10;
	comboLabel.text = [NSString stringWithFormat:@"%d Balloon Combo!\n+%d Score!",currentCombo,bonusScore];
	comboLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3f, 1.3f);
	comboLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		gv.textView.font = [UIFont fontWithName:@"Marker Felt" size:40.0];
	} else {
		gv.textView.font = [UIFont fontWithName:@"Marker Felt" size:24.0];
	}
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:1.0];
	[comboLabel setAlpha:.85];
	[UIView commitAnimations];
}


-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[comboLabel setAlpha:0];
	[UIView commitAnimations];
}

- (void) displayLevelUpView {
	
	UIView *viewBeingAnimated = self.levelUpView;
	viewBeingAnimated.frame = [[viewBeingAnimated.layer presentationLayer] frame];
	[viewBeingAnimated.layer removeAllAnimations];

	//levelUpView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 
//													   0-((self.view.frame.size.width/2 - levelUpView.frame.size.width/2)+levelUpView.frame.size.width),
//													   0.0f);
	levelUpView.center = CGPointMake(0-levelUpView.frame.size.width/2, 10+levelUpView.frame.size.height/2);
	levelUpView.hidden=NO;
	
	[UIView beginAnimations:@"movein" context:nil];
	[UIView setAnimationDuration:2.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(flyAway:finished:context:)];
	levelUpView.center = CGPointMake(self.view.bounds.size.width/2, 40+levelUpView.frame.size.height/2);

	//levelUpView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.0f, 0.0f);

	[UIView commitAnimations];
}

- (void) flyAway:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {	
	//levelUpView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.0f, 0.0f);	
	levelUpView.center = CGPointMake(self.view.bounds.size.width/2, 40+levelUpView.frame.size.height/2);

	[UIView beginAnimations:@"moveout" context:nil];
	[UIView setAnimationRepeatCount:1];
	[UIView setAnimationDuration:2.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hideLevelUpView:finished:context:)];
	levelUpView.center = CGPointMake(levelUpView.frame.size.width/2+self.view.bounds.size.width, 10+levelUpView.frame.size.height/2);

	//levelUpView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 
//													   self.view.frame.size.width/2 + levelUpView.frame.size.width/2, 
//													   0.0f);
	[UIView commitAnimations];		
}
- (void) hideLevelUpView:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {	
	levelUpView.hidden=YES;
}


// This will happen only on view appearing
- (void) setupLevel {
	if (self.mc != nil) {
		[self.mc release];
	}
	
	//This initializes the time challenge for the first level,  After this we need to play with the 
	//release speed, velocity and given at every increment of level
	self.mc = [ChallengeFactory timeChallengeWithType:challengeType];

	if (challengeType==e_Multiplication || challengeType == e_Division) {
		[self.mc generateNumAnswers:10];
	}
	else {
		[self.mc generateNumAnswers:((float)mc.seconds/mc.releaseSpeed)+1];
	}


	
	self.gv.backgroundImg.image = mc.gameImage;
	self.gv.backgroundImg.alpha = 0.70f;
	self.gv.textView.text = mc.challengeText;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		self.gv.textView.font = [UIFont fontWithName:@"Marker Felt" size:32.0];
	} else {
		self.gv.textView.font = [UIFont fontWithName:@"Marker Felt" size:18.0];
	}
	
	self.gv.textView.hidden = NO;
	self.gv.textBackground.hidden = NO;
	
	[self.gv.textView resignFirstResponder];
	[self.gv.textView flashScrollIndicators];
	
	self.challengeLabel.text = [NSString stringWithFormat:@"Tap To Start:\n%@!",[mc getChallengeString]];
	self.challengeLabel.textColor = [UIColor redColor];
	hits=0;
	
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

-(void) levelUp {
	self.timeLevel++;
	//clear all the balloons
	[self clearAllBalloons];


	// given refreshes and possibly goes up
	switch (self.challengeType) {
		case e_OddsAndEvens:
		{
			ChallengeType oddsOrEvens = (random()%2) ? ChallengeOdds : ChallengeEvens;
			if (self.mc.challengeType == oddsOrEvens)
				oddsOrEvens = (random()%2) ? ChallengeOdds : ChallengeEvens;
			
			// randomly select odds or evens
			[self.mc setChallenge: oddsOrEvens
				   withGiven:[NSNumber numberWithInt:2]]; 
			
			switch (self.currentDifficulty) {
				case DifficultyHard:
					self.mc.velRange.min += 1;
					self.mc.velRange.max += 1;
					self.mc.releaseSpeed -= .15f;
					break;
				case DifficultyNormal:
					if (timeLevel%2) {
						self.mc.velRange.min += 1;
						self.mc.velRange.max += 1;
						self.mc.releaseSpeed -= .1f;
					}
					break;
				case DifficultyEasy:
					if (timeLevel%3) {
						self.mc.velRange.min += 1;
						self.mc.velRange.max += 1;
						self.mc.releaseSpeed -= .05f;
					}
				default:
					break;
			} 		
			self.mc.ansRange.max += 20;
		}
			break;
		case e_Colors:
		{
			NSNumber *given = [NSNumber numberWithInt:random()%kColorTotal];
			if ([given compare:mc.given] == NSOrderedSame )
				given = [NSNumber numberWithInt:random()%kColorTotal];
			[mc setChallenge:ChallengeColor				   
				   withGiven:given]; 	
			switch (self.currentDifficulty) {
				case DifficultyHard:
					self.mc.velRange.min += 1;
					self.mc.velRange.max += 1;
					self.mc.releaseSpeed -= .15f;
					break;
				case DifficultyNormal:
					if (timeLevel%2) {
						self.mc.velRange.min += 1;
						self.mc.velRange.max += 1;
						self.mc.releaseSpeed -= .1f;
					}
					break;
				case DifficultyEasy:
					if (timeLevel%3) {
						self.mc.velRange.min += 1;
						self.mc.velRange.max += 1;
						self.mc.releaseSpeed -= .05f;
					}
				default:
					break;
			} 

		}
			break;
		case e_Addition:
		{
			// This only to set the initial given, given recalculated by the time challenge view controller
			int min = 10;
			int max = 20;
			if (timeLevel<3) {
				max = 20 + (timeLevel*10);
			} else if (timeLevel<8) {
				self.mc.velRange.min = 2;
				self.mc.velRange.max = 5;
				min = 20;
				max = 30 + (timeLevel-3)*10;
			} else {
				self.mc.velRange.min = 3;
				self.mc.velRange.max = 7;
				min = 40;
				max = 100 + (timeLevel-8)*10;
			}
			NSNumber *given = [ChallengeFactory randomWithMin:min andMax:max];
			if ([given compare:self.mc.given] == NSOrderedSame )
				given = [ChallengeFactory randomWithMin:min andMax:max];
			
			[self.mc setChallenge:ChallengeAddition
				   withGiven:given];
			switch (self.currentDifficulty) {
				case DifficultyHard:
					self.mc.releaseSpeed -= .1f;
					break;
				case DifficultyNormal:
					self.mc.releaseSpeed -= .05f;
					break;
				case DifficultyEasy:
					if (timeLevel%2) {
						self.mc.releaseSpeed -= .05f;
					}
				default:
					break;
			} 
			self.mc.ansRange.min = 1;
			//TODO add negatives
			BOOL negatives = NO;
			if (negatives) {
				self.mc.ansRange.max = [self.mc.given intValue] + 5;
			} else {
				//this means we won't deal with negatives (on normal mode)
				self.mc.ansRange.max = [self.mc.given intValue];
			}
		}
			break;
		case e_Subtraction:
		{
			int min = 10;
			int max = 20;
			if (timeLevel<3) {
				max = 20 + (timeLevel*10);
			} else if (timeLevel<8) {
				self.mc.velRange.min = 1;
				self.mc.velRange.max = 5;
				min = 20;
				max = 30 + (timeLevel-3)*10;
			} else {
				self.mc.velRange.min = 2;
				self.mc.velRange.max = 6;
				min = 40;
				max = 100 + (timeLevel-8)*10;
			}
			NSNumber *given = [ChallengeFactory randomWithMin:min andMax:max];
			if ([given compare:self.mc.given] == NSOrderedSame )
				given = [ChallengeFactory randomWithMin:min andMax:max];
			
			[self.mc setChallenge:ChallengeSubtraction
				   withGiven:given];
			
			switch (self.currentDifficulty) {
				case DifficultyHard:
					self.mc.releaseSpeed -= .1f;
					break;
				case DifficultyNormal:
					self.mc.releaseSpeed -= .05f;
					break;
				case DifficultyEasy:
					if (timeLevel%2) {
						self.mc.releaseSpeed -= .05f;
					}
				default:
					break;
			} 
			self.mc.ansRange.max = [self.mc.given intValue]*2;
			
			//TODO add negatives
			BOOL negatives = NO;
			if (negatives) {
				self.mc.ansRange.min = [self.mc.given intValue] - 5;
			} else {
				//this means we won't deal with negatives (on normal mode)
				self.mc.ansRange.min = [self.mc.given intValue];
			}
		
		}
			break;
		case e_Multiples:
		{
			int min = 3;
			int max = 5;
			if (timeLevel<3) {
			} else if (timeLevel<8) {
				self.mc.velRange.min = 2;
				self.mc.velRange.max = 5;
				min = 3;
				max = 11;
			} else {
				self.mc.velRange.min = 3;
				self.mc.velRange.max = 7;
				min = 4;
				max = 15;
			}
			switch (self.currentDifficulty) {
				case DifficultyHard:
					self.mc.releaseSpeed -= .1f;
					break;
				case DifficultyNormal:
					self.mc.releaseSpeed -= .05f;
					break;
				case DifficultyEasy:
					if (timeLevel%2) {
						self.mc.releaseSpeed -= .05f;
					}
				default:
					break;
			} 
			NSNumber *given = [ChallengeFactory randomWithMin:min andMax:max];
			if ([given compare:self.mc.given] == NSOrderedSame )
				given = [ChallengeFactory randomWithMin:min andMax:max];
			[self.mc setChallenge:ChallengeMultiple
				   withGiven:given];
		}
			break;
		case e_Factors:
		{
			int min = 24;
			int max = 36;
			if (timeLevel<3) {
				self.mc.velRange.min = 2;
				self.mc.velRange.max = 4;
			} else if (timeLevel<8) {
				self.mc.velRange.min = 2;
				self.mc.velRange.max = 5;
				min = 24;
				max = 100;
			} else {
				self.mc.velRange.min = 3;
				self.mc.velRange.max = 7;
				min = 36;
				max = 256;
			}
			switch (self.currentDifficulty) {
				case DifficultyHard:
					self.mc.releaseSpeed -= .1f;
					break;
				case DifficultyNormal:
					self.mc.releaseSpeed -= .05f;
					break;
				case DifficultyEasy:
					if (timeLevel%2) {
						self.mc.releaseSpeed -= .05f;
					}
				default:
					break;
			} 
			NSNumber* testFactor = [ChallengeFactory randomWithMin:min andMax:max];
			int failcount = 0;
			
			while ([MathChallenge isPrime:[testFactor intValue]] && [testFactor compare:self.mc.given] != NSOrderedSame) {
				testFactor = [ChallengeFactory randomWithMin:min andMax:max];
				failcount++;
				if (failcount>50) {
					testFactor = [NSNumber numberWithInt:24];
				}
			}
			self.mc.ansRange.max = [testFactor floatValue]*1.1f;
			[self.mc setChallenge:ChallengeFactors
				   withGiven:testFactor];
		}
			break;
		case e_Multiplication:
		{
			int min = 0;
			int max = 10;
			if (timeLevel<3) {
				self.mc.velRange.min = 1;
				self.mc.velRange.max = 4;
			} else if (timeLevel<8) {
				self.mc.velRange.min = 2;
				self.mc.velRange.max = 4;
			} else {
				self.mc.velRange.min = 2;
				self.mc.velRange.max = 5;
			}
			switch (self.currentDifficulty) {
				case DifficultyHard:
					self.mc.releaseSpeed -= .05f;
					min = 1;
					max = 25;
					break;
				case DifficultyNormal:
					min = 1;
					max = 15;
					if (timeLevel%2) {
						self.mc.releaseSpeed -= .05f;
					}
					break;
				case DifficultyEasy:
					min = 1;
					max = 10;
					if (timeLevel%2) {
						self.mc.releaseSpeed -= .05f;
					}
				default:
					break;
			} 
			self.mc.ansRange.max = max;
			[mc setChallenge:ChallengeMultiplication
				   withGiven:[ChallengeFactory randomWithMin:min andMax:max]
				   withGiven:[ChallengeFactory randomWithMin:min andMax:max]];
		}
			break;
		case e_Division:
		{
			int min = 1;
			int max = 10;
			if (timeLevel<3) {
				self.mc.velRange.min = 1;
				self.mc.velRange.max = 4;
			} else if (timeLevel<8) {
				self.mc.velRange.min = 2;
				self.mc.velRange.max = 2;
			} else {
				self.mc.velRange.min = 2;
				self.mc.velRange.max = 5;
			}
			switch (self.currentDifficulty) {
				case DifficultyHard:
					self.mc.releaseSpeed -= .05f;
					min = 1;
					max = 25;
					break;
				case DifficultyNormal:
					min = 1;
					max = 15;
					if (timeLevel%2) {
						self.mc.releaseSpeed -= .05f;
					}				
					break;
				case DifficultyEasy:
					min = 1;
					max = 10;
					if (timeLevel%2) {
						self.mc.releaseSpeed -= .05f;
					}
				default:
					break;
			} 
			NSNumber* testFactor1 = [ChallengeFactory randomWithMin:min andMax:max];
			NSNumber* testFactor2 = [ChallengeFactory randomWithMin:min andMax:max];

			NSNumber *result = [NSNumber numberWithInt:([testFactor1 intValue]*[testFactor2 intValue])];
			self.mc.ansRange.max = [result intValue]+15;
			[mc setChallenge:ChallengeDivision
				   withGiven:result
				   withGiven:testFactor1];
		}
			break;
		default:
			break;
	}
	if (mc.releaseSpeed <= 0.25f)
		mc.releaseSpeed = 0.25f;
	
	self.mc.numCorrect = (mc.seconds/mc.releaseSpeed)/2+1;
	if (challengeType==e_Multiplication || challengeType == e_Division) {
		self.mc.numCorrect=1;
	}
	//MC is all setup, so display the Level Up Man!
	self.levelUpViewLabel.text = [NSString stringWithFormat:@"Level #%d\n%@!",timeLevel+1,[self.mc getChallengeString]];
	[self displayLevelUpView];

	
	[self rescheduleBalloonTimer];
	
	// setup challenge text 
	challengeLabel.text = [NSString stringWithString:[mc getChallengeString]];
	// if colored ballons setup color
	if (challengeType == e_Colors) {
		switch ([mc.given intValue]) {
			case kColorRed:
				challengeLabel.textColor = [UIColor redColor];
				break;
			case kColorBlue:
				challengeLabel.textColor = [UIColor blueColor];
				break;
			case kColorGreen:
				challengeLabel.textColor = [UIColor greenColor];
				break;
			case kColorYellow:
				challengeLabel.textColor = [UIColor yellowColor];
				break;
			default:
				challengeLabel.textColor = [UIColor redColor];

		}
	} else {
		challengeLabel.textColor = [UIColor redColor];
	}

	//timers keep going through all this
	if (challengeType==e_Multiplication || challengeType == e_Division) {
		[self.mc generateNumAnswers:10];
	}
	else {
		[self.mc generateNumAnswers:((float)mc.seconds/mc.releaseSpeed)+1];
	}
	
	//get array of answers
	NSArray* numbers = mc.challengeAnswers;
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
	
	//start ballons by making this not happen
	//	if (currentBalloon==totalBalloons || gameState != e_GameStateRunning)
	totalBalloons = balloonsLeft = numbers.count;

}

- (void) decrementLives {
	if (currentCombo>maxCombo)
		maxCombo=currentCombo;
	self.comboLabel.hidden = YES;
	currentCombo = 0;
	if (livesLeft>0)
		livesLeft--;
	
	[self setLives:livesLeft];

}

- (void) setLives: (unsigned int) numLives {
	balloonLife5.hidden = YES;
	//showBalloon(balloonLife5);
	balloonLife4.hidden = YES;
	balloonLife3.hidden = YES;
	balloonLife2.hidden = YES;
	balloonLife1.hidden = YES;
	switch (numLives) {
		case 5:
			balloonLife5.hidden = NO;
			//showBalloon(balloonLife5);
		case 4:
			balloonLife4.hidden = NO;
		case 3:
			balloonLife3.hidden = NO;
		case 2:
			balloonLife2.hidden = NO;
		case 1:
			balloonLife1.hidden = NO;
		default:
			break;
	}
}

- (void) touchesBegan: (NSSet *) touches 
			withEvent: (UIEvent *) event {
	//if game is in paused state, first touch starts the game
	if (gameState == e_GameStatePaused) {
		if ( CGRectContainsPoint(pauseButton.frame, [[touches anyObject] locationInView:nil])) {
			[self pausePressed];
			return;
		}
		
		[pauseButton setEnabled:YES];
		gv.backgroundImg.image = mc.gameImage;
		gv.backgroundImg.alpha = 1.0f;
		
		gv.textView.hidden = YES;
		gv.textBackground.hidden = YES;
		// setup challenge text 
		challengeLabel.text = [NSString stringWithString:[mc getChallengeString]];
		// if colored ballons setup color
		if (challengeType == e_Colors) {
			switch ([mc.given intValue]) {
				case kColorRed:
					challengeLabel.textColor = [UIColor redColor];
					break;
				case kColorBlue:
					challengeLabel.textColor = [UIColor blueColor];
					break;
				case kColorGreen:
					challengeLabel.textColor = [UIColor greenColor];
					break;
				case kColorYellow:
					challengeLabel.textColor = [UIColor yellowColor];
					break;
				default:
					challengeLabel.textColor = [UIColor redColor];
					
			}
		} else {
			challengeLabel.textColor = [UIColor redColor];
		}
		[self startTimers];
	} 
}

- (IBAction) pausePressed {
	if (pauseDialogueShowing)
		return;	
	pauseDialogueShowing = YES;
	
	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	[appDelegate pauseMusic];

	if (gameState==e_GameStateRunning) {
		gameState = e_GameStatePauseMidGame;
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
	resignActiveCalled = YES;
	
	if (gameState==e_GameStateRunning) {
		gameState = e_GameStatePauseMidGame;
		BalloonChallengeAppDelegate *appDelegate = 
		(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
		[appDelegate pauseMusic];
	} 
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	//if cancelling because application will resign
	if (resignActiveCalled) {
		resignActiveCalled = NO;
		return;
	}
	pauseDialogueShowing = NO;
	
	if (buttonIndex ==0) {
		if (gameState == e_GameStatePauseMidGame) {
			gameState = e_GameStateRunning;
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
	
	gameState = e_GameStatePaused;
		
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

- (void) clearPoppedBalloons {
	//release old balloons
	for (UIView *b in gv.subviews) {
		if ( [b isMemberOfClass:[Balloon class]] && [(Balloon*) b isPopped] ) {
			[b removeFromSuperview];
		}
	}
	
}

- (void) clearAllBalloons {
	//[lock lock];
	//release old balloons
	currentBalloon = 0;
	for (UIView *b in gv.subviews) {
		if ( [b isMemberOfClass:[Balloon class]] ) {
			[b removeFromSuperview];
			[b release];
		}
	}
	[balloons removeAllObjects];
	//[lock unlock];
}

- (void) incrementTime {
	if (gameState!=e_GameStateRunning) {
		return;
	}
	//each time decrementTime is called, try to clear the popped balloons
	[self clearPoppedBalloons];
	
	NSString *timeStr = timeLabel.text; 
	unsigned int secI = [timeStr intValue];
	secI++;
	timeElapsed = secI;
	timeLabel.text = [NSString stringWithFormat:@"%d",secI];

	if (self.challengeType != e_Multiplication && self.challengeType != e_Division) {
		//Elapse the time whenever you have reached the next number of seconds.
		//If mc.seconds changes during gameplay this logic will change
		if (timeElapsed%mc.seconds == 0)
			[self levelUp];
	}
	
	if (livesLeft == 0) {
		[self endGame];
	} 
}

- (void) gameLoop {
	//[lock lock];
	if (gameState == e_GameStateRunning){
		
		for (int i = [self.gv.subviews count]; i>0; i--) {
			Balloon *b = [self.gv.subviews objectAtIndex:i-1];
			if ( [b isMemberOfClass:[Balloon class]] ) {
				[ (Balloon *) b move];
				if ((b.frame.origin.y + b.frame.size.height) < 0 ) {
					
					// check if the balloon missed was a correct answer
					if (b.isCorrectAnswer) {
						b.score = mc.ptsIncorrect;
						// Pop the balloon!
						[b popTimer];
					} else {
						balloonsLeft--;

						// remove the balloon
						[b removeFromSuperview];
						// all the balloons are level up
						if (balloonsLeft == 0) {
							[self levelUp];
						}
					}
					

				}
			}
		}		
	}
	else if (gameState == e_GameStatePaused) {
	}
	//[lock unlock];
}

- (void) startBalloon {
	//if there are no more balloons to start, just return
	if (currentBalloon==totalBalloons || gameState != e_GameStateRunning)
		return;
	Balloon * b = [balloons objectAtIndex:currentBalloon];
	b.yVelocity = [mc getBalloonSpeed];
	currentBalloon += 1;
}

-(void) startTimers{
    if (gameTimer || levelTimer || balloonTimer) { 
        gameTimer=Nil;
    }
	
	//timer for the game (30fps)
	gameTimer = [NSTimer scheduledTimerWithTimeInterval:0.033f 
												 target:self
											   selector:@selector(gameLoop) 
											   userInfo:nil 
												repeats:YES];
	//timer for the clock
	levelTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f 
												  target:self
												selector:@selector(incrementTime) 
												userInfo:nil 
												 repeats:YES];
	
	//start a balloon every x seconds
	[self rescheduleBalloonTimer];
	
	
	gameState = e_GameStateRunning;
}

-(void) rescheduleBalloonTimer {
	if (balloonTimer) {
		[balloonTimer invalidate];
		balloonTimer = nil;
	}
	balloonTimer = [NSTimer scheduledTimerWithTimeInterval:(mc.releaseSpeed)
													target:self
												  selector:@selector(startBalloon) 
												  userInfo:nil 
												   repeats:YES];
}

-(void) stopTimers{
	gameState = e_GameStatePaused;

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

-(void) balloonPopped: (Balloon*) b {
	
	self.score += b.score;

	if (b.score>0) {
		hits++;
		currentCombo++;
		if (currentCombo>2) {
			score+=currentCombo;
			[self displayComboView];
		}
		if (self.challengeType == e_Multiplication || self.challengeType == e_Division) {
			[self levelUp];
		}
	} else {
		[self decrementLives];

		if (self.challengeType == e_Multiplication || self.challengeType == e_Division) {
			// If this got popped and is off screen, this was a correct answer...level up
			if (b.isCorrectAnswer) {
				[self levelUp];
			}
		}
	}
	scoreLabel.text = [NSString stringWithFormat:@"%d",score];


	balloonsLeft--;
	// all the balloons are gone end the game
	if (livesLeft==0) {
		[self endGame];
	} else if (balloonsLeft == 0) {
		[self levelUp];
	}
}


	
-(void) endGame {
	//stop timers
	[self stopTimers];
	
	//clear out balloons
	[self clearAllBalloons];
	
	//set allert message
	NSMutableString* winLabel = nil;
	
	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	Player *p = appDelegate.defaultPlayer;
	
	//update stats if hit at least one balloon
	[p addPlayerStatsForTimeChallenge:challengeType
							 andLevel:timeLevel
						  andBalloons:hits
							  andTime:timeElapsed
							 andCombo:maxCombo
							 andScore:score];


	TimeChallengeStats *tc = [p.currentStats.timeChallengeStats 
							  objectForKey:[NSNumber numberWithInt:challengeType]];
	
	NSString *highBalloonStr = [NSMutableString stringWithString:@""];
	
	//If this is a high score, add something to the info
	if (score == tc.highScore)
	{
		highBalloonStr = [NSString stringWithFormat:@"Congratulations, you scored %d points, which "
					 "is a record for this challenge!!\n\n",score];
	}		
	
	if (hits >= 100) {
		winLabel = [NSMutableString stringWithFormat:@"%@That is amazing, %@, you popped over 100 balloons!!!",highBalloonStr,p.name];
	} else if (hits >=50) {
		winLabel = [NSMutableString stringWithFormat:@"%@That is excellent, %@, you popped over 50 balloons!",highBalloonStr,p.name];
	} else if (hits >=20) {
		winLabel = [NSMutableString stringWithFormat:@"%@You did great, %@, you popped over 20 balloons!",highBalloonStr,p.name];
	} else if (hits >=10 ) {
		winLabel = [NSMutableString stringWithFormat:@"%@You did a good job, %@, you popped over 10 balloons!",highBalloonStr, p.name];
	} else {
		winLabel = [NSMutableString stringWithFormat:@"%@Good job, %@, keep practicing!  If this challenge is hard "
					"you can go to the learning game in the main menu to practice!",highBalloonStr,p.name];
	}

	gameOverViewController.gameOverDelegate = self;
	[self presentModalViewController:gameOverViewController animated:YES];

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		gameOverViewController.gameOverLabel.font = [UIFont fontWithName:@"Marker Felt" size:32.0];
	} else {
		gameOverViewController.gameOverLabel.font = [UIFont fontWithName:@"Marker Felt" size:18.0];
	}
	
	gameOverViewController.gameOverLabel.text = winLabel;
	gameOverViewController.playerName = p.name;
	gameOverViewController.levelName = challengeGroupName;
	[gameOverViewController.tableData setObject:[NSString stringWithFormat:@"%d", timeLevel] forKey:[[GameOverViewController timeChallengeStats] objectAtIndex:0]];
	[gameOverViewController.tableData setObject:[NSString stringWithFormat:@"%d", hits] forKey:[[GameOverViewController timeChallengeStats] objectAtIndex:1]];
	[gameOverViewController.tableData setObject:[NSString stringWithFormat:@"%d", timeElapsed] forKey:[[GameOverViewController timeChallengeStats] objectAtIndex:2]];
	[gameOverViewController.tableData setObject:[NSString stringWithFormat:@"%d", maxCombo] forKey:[[GameOverViewController timeChallengeStats] objectAtIndex:3]];
	[gameOverViewController.tableData setObject:[NSString stringWithFormat:@"%d", score] forKey:[[GameOverViewController timeChallengeStats] objectAtIndex:4]];
	
	[gameOverViewController.tableData setObject:[NSString stringWithFormat:@"%d", tc.maxLevels] forKey:[[GameOverViewController timeChallengeStats] objectAtIndex:5]];
	[gameOverViewController.tableData setObject:[NSString stringWithFormat:@"%d", tc.maxNumBalloons] forKey:[[GameOverViewController timeChallengeStats] objectAtIndex:6]];
	[gameOverViewController.tableData setObject:[NSString stringWithFormat:@"%d", tc.maxTimeSeconds] forKey:[[GameOverViewController timeChallengeStats] objectAtIndex:7]];
	[gameOverViewController.tableData setObject:[NSString stringWithFormat:@"%d", tc.maxCombo] forKey:[[GameOverViewController timeChallengeStats] objectAtIndex:8]];
	[gameOverViewController.tableData setObject:[NSString stringWithFormat:@"%d", tc.highScore] forKey:[[GameOverViewController timeChallengeStats] objectAtIndex:9]];
}
	
-(void) levelMenuPressed: (id) sender {
	self.isExiting = YES;
	[gameOverViewController dismissModalViewControllerAnimated:NO];
	//[gameOverViewController release];
	
	[self exitGame];
}

-(void) nextLevelPressed {
//just to fulfill delegate methods
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	timeLabel = nil;
	challengeLabel = nil;
	gv = nil;
	balloonLife1 = nil;
	balloonLife2 = nil;
	balloonLife3 = nil;
	balloonLife4 = nil;
	balloonLife5 = nil;
	pauseButton = nil;
	levelUpView = nil;
	comboLabel = nil;
	levelUpView = nil;
	levelUpViewLabel = nil;
	scoreLabel = nil;
}


- (void)dealloc {
	[mc release];
	[lock release];
	[timeLabel release];
	[gv release];
	[mc release];
	[balloons release];
	[challengeLabel release];
	[balloonLife1 release];
	[balloonLife2 release];
	[balloonLife3 release];
	[balloonLife4 release];
	[balloonLife5 release];
	[pauseButton release];
	[challengeGroupName release];
	[levelUpView release];
	[levelUpViewLabel release];
	[comboLabel release];
	[scoreLabel release];
    [super dealloc];
}


@end
