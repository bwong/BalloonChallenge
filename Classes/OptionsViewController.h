//
//  OptionsViewController.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 2/9/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "BalloonChallengeAppDelegate.h"
#import "PlayerSelectViewController.h"

@interface OptionsViewController : UIViewController <PlayerSelectDelegate> {
	PlayerSelectViewController *selectViewController;
		
    // Player Name Field
    UITextField *playerName;
    
    // Button allows user to select a different player profile
    UIButton *selectDiffPlayerButton;
    
    // Different Categories
    NSArray *category;
	
    // Toolbar to hold the back and save bar item button
    UIToolbar *optionsToolbar;
	
}

@property (nonatomic, retain) IBOutlet UITextField *playerName;
@property (nonatomic, retain) IBOutlet UIButton *selectDiffPlayerButton;
@property (nonatomic, retain) IBOutlet UIToolbar *optionsToolbar;
@property (nonatomic, retain) IBOutlet PlayerSelectViewController *selectViewController;
@property (nonatomic, retain) NSArray *category;

// Save Information for Default Player for the Session
- (void) saveButtonItemPressed;

// Go Back to Main Window
- (void) backButtonItemPressed;

// User wants to choose a different player profile
- (IBAction) selectDifferentPlayerButtonPressed: (id) sender;
   
// Helper function for removing Keyboard from screen
- (IBAction)backgroundTap:(id)sender;

@end


