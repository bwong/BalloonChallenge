//
//  OptionsViewController.h
//  BalloonChallenge
//
//  Created by Brian Wong on 2/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BalloonChallengeAppDelegate.h"

#define kDifficultyEasy     0
#define kDifficultyNormal   1
#define kDifficultyHard     2

@interface OptionsViewController : UIViewController {
    UITextField *playerName;
    UILabel *levelLabel;
    UIButton *backButton;
    UIButton *saveButton;
    
    int gameDifficulty;
}

@property (nonatomic, retain) IBOutlet UITextField *playerName;
@property (nonatomic, retain) IBOutlet UILabel *levelLabel;
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UIButton *saveButton;
@property int gameDifficulty;


// Save Information for Default Player for the Session
- (IBAction) saveButtonPressed: (id) sender;

// Go Back to Main Window
- (IBAction) backButtonPressed: (id) sender;

// Switching Levels
- (IBAction) sliderChanged: (id) sender;

// Selecting Difficulty
- (IBAction) segmentSelected: (id) sender;
   
// Helper function for removing Keyboard from screen
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;

@end
