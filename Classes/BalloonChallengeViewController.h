//
//  BalloonChallengeViewController.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 2/6/10.
//  Copyright klivin 2010. All rights reserved.
//

#import "GameViewController.h"
#import "HighScoresViewController.h"
#import "OptionsViewController.h"
#import "HelpViewController.h"
#import "IpadHelpViewController.h"
#import "IpadHighScoreViewController.h"

@class TimeChallengeSelectViewController;
@class GameSelectViewController;

// Main Menu View Controller
@interface BalloonChallengeViewController : UIViewController <UITextFieldDelegate> {
	
    /*
     * Initialize all View Controllers that can be 
     * selected by the user.
     */
    GameViewController *gameViewController;
    HighScoresViewController *highScoresViewController;
    OptionsViewController *optionsViewController;
    HelpViewController *helpViewController;
    IpadHelpViewController *ipadHelpViewController;
	TimeChallengeSelectViewController *timeChallengeSelectViewController;
	GameSelectViewController *gameSelectViewController;
	IpadHighScoreViewController *ipadHighScoreViewController;

	UIImageView *balloon;
	UIImageView *pop;
	UIImageView *challenge;
	UIButton *timeChallenge;
	UIButton *play;
	UIButton *grades;
	UIButton *options;
	UIButton *help;
	UIButton *muteButton;
	UISegmentedControl *segmentedControl;
	UIView *nameView;
	UITextField *defName;
}

@property (nonatomic, retain) IBOutlet UIView *nameView;
@property (nonatomic, retain) IBOutlet UITextField *defName;

@property (nonatomic, retain) IBOutlet UIButton *play;
@property (nonatomic, retain) IBOutlet UIButton *grades;
@property (nonatomic, retain) IBOutlet UIButton *options;
@property (nonatomic, retain) IBOutlet UIButton *help;
@property (nonatomic, retain) IBOutlet UIButton *timeChallenge;
@property (nonatomic, retain) IBOutlet UIButton *muteButton;

@property (nonatomic, retain) IBOutlet UIImageView *balloon;
@property (nonatomic, retain) IBOutlet UIImageView *pop;
@property (nonatomic, retain) IBOutlet UIImageView *challenge;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

//@property (nonatomic, retain) IBOutlet GameViewController *gameViewController;
@property (nonatomic, retain) IBOutlet TimeChallengeSelectViewController *timeChallengeSelectViewController;
@property (nonatomic, retain) IBOutlet GameSelectViewController *gameSelectViewController;
@property (nonatomic, retain) IBOutlet HighScoresViewController *highScoresViewController;
@property (nonatomic, retain) IBOutlet OptionsViewController *optionsViewController;
@property (nonatomic, retain) IBOutlet HelpViewController *helpViewController;
@property (nonatomic, retain) IBOutlet IpadHelpViewController *ipadHelpViewController;
@property (nonatomic, retain) IBOutlet IpadHighScoreViewController *ipadHighScoreViewController;

- (IBAction) nameOkPressed;
// User pressed play game button put up game view
-(IBAction) gameButtonPressed: (id) sender;
-(IBAction) muteButtonPressed: (id) sender;

// User pressed play game button put up game view
-(IBAction) timeChallengeButtonPressed: (id) sender;

// User pressed highscores button put up highscores view
- (IBAction) highScoresButtonPressed: (id) sender;

// User pressed options button put up options view
- (IBAction) optionsButtonPressed: (id) sender;

// User pressed help button put up help view
- (IBAction) helpButtonPressed: (id) sender;

// Selecting Difficulty
- (IBAction) segmentSelected: (id) sender;

- (void) setupButtons;

- (void) displayViews;
- (void) shakeButtons;
@end

