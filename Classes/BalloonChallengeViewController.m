//
//  BalloonChallengeViewController.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 2/6/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "BalloonChallengeViewController.h"
#import "TimeChallengeSelectViewController.h"
#import "GameSelectViewController.h"

@implementation BalloonChallengeViewController

//@synthesize gameViewController;
@synthesize gameSelectViewController,timeChallengeSelectViewController;
@synthesize highScoresViewController,ipadHighScoreViewController;
@synthesize optionsViewController;
@synthesize helpViewController;
@synthesize ipadHelpViewController;
@synthesize balloon, pop, challenge;
@synthesize play, grades, options, help, timeChallenge;
@synthesize muteButton;
@synthesize segmentedControl;
@synthesize nameView, defName;

- (void)viewDidLoad {
	self.nameView.hidden = YES;
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	if (appDelegate.gameState.isMuted == YES) {
		[ muteButton setImage: [ UIImage imageNamed: @"icon_off.png" ] forState: UIControlStateNormal ];
	} else {
		[ muteButton setImage: [ UIImage imageNamed: @"icon_on.png" ] forState: UIControlStateNormal ];
	}

	segmentedControl.selectedSegmentIndex = appDelegate.gameState.currentDifficulty;	

	[self setupButtons];
	[self displayViews];
	[self shakeButtons];
	[super viewWillAppear:animated];
}


-(void) viewDidAppear:(BOOL)animated {
	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	if (appDelegate.defaultPlayer == nil) {
		self.defName.delegate = self;
		self.nameView.hidden = NO;
		[self.defName becomeFirstResponder];
	}
	[super viewDidAppear:animated];
}

- (IBAction) nameOkPressed {
	if ([self.defName.text isEqualToString:@""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Name" 
														message:@"Please enter a default name!" 
													   delegate:nil cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	self.nameView.hidden=YES;
	[self.defName resignFirstResponder];
	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	Player *newPlayer = [[Player alloc] initWithName:self.defName.text
									   andTimePlayed:0];
	
	appDelegate.defaultPlayer = newPlayer;
	[appDelegate.playerDatabaseObj addPlayerObj:newPlayer];
}

#pragma mark Text Field Delegate Methods
-(BOOL)textField:(UITextField *)aTextField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
	int limit = 25;
	NSRange found = [string rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"/@%&<>;[]"]];
	if (found.length) {
		return NO;
	}
	
    return !([aTextField.text length]>=limit && [string length] >= range.length);
}


// Selecting Difficulty
- (IBAction) segmentSelected: (id) sender {
	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([sender selectedSegmentIndex] == DifficultyEasy)
    {
        appDelegate.gameState.currentDifficulty = DifficultyEasy;
    }
    if ([sender selectedSegmentIndex] == DifficultyNormal)
    {
        appDelegate.gameState.currentDifficulty = DifficultyNormal;
    }
    if ([sender selectedSegmentIndex] == DifficultyHard)
    {
        appDelegate.gameState.currentDifficulty = DifficultyHard;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation
										  duration:(NSTimeInterval) duration {
	[self setupButtons];
	
}
- (void) setupButtons {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		if(self.interfaceOrientation == UIInterfaceOrientationPortrait || 
		   self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			self.timeChallenge.frame = CGRectMake(213, 460, 349, 154);
			self.play.frame = CGRectMake(237, 610, 298, 113);
			self.options.frame = CGRectMake(157, 720, 450, 115);
			self.grades.frame = CGRectMake(216, 850, 340, 91);
			self.muteButton.frame = CGRectMake(685, 960, 40, 30);
			self.segmentedControl.frame = CGRectMake(196, 952, 379, 40);		
			self.help.frame = CGRectMake(55, 960, 35, 35);
		} else {
			self.timeChallenge.frame = CGRectMake(337, 330, 343, 130);
			self.play.frame = CGRectMake(359, 445, 298, 100);
			self.options.frame = CGRectMake(274, 540, 458, 100);
			self.grades.frame = CGRectMake(332, 640, 349, 81);
			self.muteButton.frame = CGRectMake(900, 697, 40, 30);
			self.segmentedControl.frame = CGRectMake(312, 720, 379, 40);
			self.help.frame = CGRectMake(100, 697, 35, 35);

		}
	} else {
		muteButton.frame = CGRectMake(282, 445, 32, 25);
	}
}

- (void) shakeButtons {
	
	CGAffineTransform current = CGAffineTransformScale(CGAffineTransformIdentity, 1.01, 1.01);
	CGAffineTransform current1 = CGAffineTransformScale(CGAffineTransformIdentity, 1.01, 1.01);
	
	CGAffineTransform big = CGAffineTransformScale(CGAffineTransformIdentity, 1.08f, 1.08f);
	CGAffineTransform big1 = CGAffineTransformScale(CGAffineTransformIdentity, 1.08f, 1.08f);
	timeChallenge.transform = current;
	play.transform = current1;
	[UIView beginAnimations:@"big" context:self];
	[UIView setAnimationRepeatCount:1000000];
	[UIView setAnimationDuration:1.1f];
	[UIView setAnimationDelegate:self];
	timeChallenge.transform = big;
	play.transform = big1;
	[UIView commitAnimations];	

}

- (void) displayViews {
	CGAffineTransform offScreen = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.0f, self.view.frame.origin.y-balloon.frame.size.height);
	CGAffineTransform onScreen = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.0f, 0.0f);
	CGAffineTransform offScreen1 = CGAffineTransformTranslate(CGAffineTransformIdentity, self.view.frame.size.width, self.view.frame.origin.y-pop.frame.size.height);
	CGAffineTransform onScreen1 = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.0f, 0.0f);
	CGAffineTransform offScreen2 = CGAffineTransformTranslate(CGAffineTransformIdentity, self.view.frame.origin.x-challenge.frame.size.width, self.view.frame.origin.y-challenge.frame.size.height);
	CGAffineTransform onScreen2 = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.0f, 0.0f);
	
	balloon.transform = offScreen;
	pop.transform = offScreen1;
	challenge.transform = offScreen2;

	[UIView beginAnimations:@"move" context:self];
	[UIView setAnimationDuration:0.6f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(expandView:finished:context:)];
	pop.transform = onScreen1;
	balloon.transform = onScreen;
	challenge.transform = onScreen2;
	
	[UIView commitAnimations];
}


- (void) expandView:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {	
	CGAffineTransform big = CGAffineTransformScale(CGAffineTransformIdentity, 1.15f, 1.15f);
	[UIView beginAnimations:@"growLetters" context:self];
	[UIView setAnimationRepeatCount:1];
	[UIView setAnimationDuration:.5f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(shrinkView:finished:context:)];

	balloon.transform = big;
	pop.transform = big;
	challenge.transform = big;

	[UIView commitAnimations];		
}

- (void) shrinkView:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	CGAffineTransform current = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
	
	[UIView beginAnimations:@"shrinkLetters" context:self];
	[UIView setAnimationRepeatCount:1];
	[UIView setAnimationDuration:.2f];
	[UIView setAnimationDelegate:self];
	
	balloon.transform = current;
	pop.transform = current;
	challenge.transform = current;
	
	[UIView commitAnimations];		
}

// User pressed play button put up game view
-(IBAction) timeChallengeButtonPressed: (id) sender {
	[self presentModalViewController:timeChallengeSelectViewController animated:NO];
}


// User pressed play button put up game view
-(IBAction) gameButtonPressed: (id) sender {
	[self presentModalViewController:gameSelectViewController animated:NO];
}


// User pressed play button put up game view
-(IBAction) muteButtonPressed: (id) sender {
	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	if (appDelegate.gameState.isMuted == YES) {
		[ muteButton setImage: [ UIImage imageNamed: @"icon_on.png" ] forState: UIControlStateNormal ];
		appDelegate.gameState.isMuted=NO;
		[appDelegate playMusic];

	} else {
		[ muteButton setImage: [ UIImage imageNamed: @"icon_off.png" ] forState: UIControlStateNormal ];
		[appDelegate stopMusic];
		appDelegate.gameState.isMuted=YES;
	}
}


// User pressed highscores button put up highscores view
- (IBAction) highScoresButtonPressed: (id) sender {
	highScoresViewController = [[[HighScoresViewController alloc] 
								 initWithNibName:@"HighScoresViewController"
								 bundle:nil] autorelease];
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
		UINavigationController *highScoreNavController = [[UINavigationController alloc] 
														  initWithRootViewController:highScoresViewController];
		[self presentModalViewController:highScoreNavController animated:YES]; 
		[highScoreNavController release];

	}
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		UINavigationController *highScoreNavController = [[UINavigationController alloc] 
														  initWithRootViewController:ipadHighScoreViewController];

		[self presentModalViewController:highScoreNavController  animated:YES]; 
		[highScoreNavController release];
	}	
}

// User pressed options button put up options view
- (IBAction) optionsButtonPressed: (id) sender {
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		optionsViewController = [[[OptionsViewController alloc] 
								  initWithNibName:@"IpadOptionsViewController"
								  bundle:nil] autorelease];
	} else {
		optionsViewController = [[[OptionsViewController alloc] 
								  initWithNibName:@"OptionsViewController"
								  bundle:nil] autorelease];
	}
	
	//UINavigationController *optionsNavController = [[UINavigationController alloc] initWithRootViewController:optionsViewController];
    [self presentModalViewController:optionsViewController animated:YES];
    //[self presentModalViewController:optionsNavController animated:YES];
}

// User pressed help button put up help view
- (IBAction) helpButtonPressed: (id) sender {	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[self presentModalViewController:ipadHelpViewController animated:YES];        
	} else {
		[self presentModalViewController:helpViewController animated:YES];        
	}
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	balloon = nil;
	pop = nil;
	challenge = nil;
	play = nil;
	options = nil;
	grades = nil;
	help = nil;
	gameSelectViewController = nil;
	timeChallengeSelectViewController = nil;
	helpViewController = nil;
	optionsViewController = nil;
	//gameViewController = nil;
	highScoresViewController = nil;
	muteButton = nil;
	defName = nil;
	nameView = nil;
}


- (void)dealloc {
    // release view controllers
	[balloon release];
	[pop release];
	[challenge release];
	[play release];
	[options release];
	[grades release];
	[help release];
	[gameSelectViewController release];
	[timeChallengeSelectViewController release];
	[helpViewController release];
	[optionsViewController release];
	[muteButton release];
	[defName release];
	[nameView release];
	
	//[gameViewController release];
	[highScoresViewController release];
    [super dealloc];
}

@end
