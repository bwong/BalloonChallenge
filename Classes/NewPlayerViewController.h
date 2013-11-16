//
//  NewPlayerViewController.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 3/8/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewPlayerViewController : UIViewController {
	// New Player Name
}

@property (nonatomic, retain) IBOutlet UITextField *playerName;

// Helper function for removing Keyboard from screen
- (IBAction)textFieldDoneEditing:(id)sender;

// Helper function for removing Keyboard from screen
- (IBAction)backgroundTap:(id)sender;

@end
