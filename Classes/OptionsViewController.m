//
//  OptionsViewController.m
//  BalloonChallenge
//
//  Created by Brian Wong on 2/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OptionsViewController.h"


@implementation OptionsViewController

@synthesize playerName;
@synthesize levelLabel;
@synthesize backButton;
@synthesize saveButton;
@synthesize gameDifficulty;

// Go Back to Main Window
- (IBAction) backButtonPressed: (id) sender {
    [self dismissModalViewControllerAnimated:YES];
}

// Save Information for Default Player for the Session
- (IBAction) saveButtonPressed: (id) sender {
    // Save Player Info
    // Our AppDelegate has the master player database object
    // so to access it, we need to get the delegate.
    BalloonChallengeAppDelegate *appDelegate = 
        (BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
    int level = [levelLabel.text intValue];
    Player *newPlayer = [[Player alloc] initWithName:playerName.text 
                                      andDifficulty:gameDifficulty 
                                           andLevel:level 
                                       andHighscore:0];
    appDelegate.defaultPlayer = newPlayer;
    [appDelegate.playerDatabaseObj addPlayer:playerName.text 
                     withDifficultySettingAt:gameDifficulty 
                           andLevelSettingAt:level 
                              andHighscoreOf:0];
}

// Switching Levels
- (IBAction) sliderChanged: (id) sender {
    UISlider *slider = (UISlider *) sender;
    int levelInt = (int) (slider.value);
    NSString *newText = [[NSString alloc] initWithFormat:@"%d",levelInt];
    levelLabel.text = newText;
    [newText release];
}

// Selecting Difficulty
- (IBAction) segmentSelected: (id) sender {
    if ([sender selectedSegmentIndex] == kDifficultyEasy)
    {
        gameDifficulty = kDifficultyEasy;
    }
    if ([sender selectedSegmentIndex] == kDifficultyNormal)
    {
        gameDifficulty = kDifficultyNormal;
    }
    if ([sender selectedSegmentIndex] == kDifficultyHard)
    {
        gameDifficulty = kDifficultyHard;
    }
}

// Helper function for removing Keyboard from screen
- (IBAction)textFieldDoneEditing:(id)sender {
	[sender resignFirstResponder];
}

// Helper function for removing Keyboard from screen
- (IBAction)backgroundTap:(id)sender {
    [playerName resignFirstResponder];	
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
    [playerName release];
    [levelLabel release];
    [backButton release];
    [saveButton release];
    [super dealloc];
}


@end
