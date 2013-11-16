//
//  IpadHelpViewController.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 6/20/10.
//  Copyright 2010 klivin.com. All rights reserved.
//


@interface IpadHelpViewController : UIViewController {
	IBOutlet UIButton *mainMenuButton;

	UITextView *ipadHelp;
	UITextView *ipadThanks;
}
@property (nonatomic, retain) IBOutlet UITextView *ipadHelp;
@property (nonatomic, retain) IBOutlet UITextView *ipadThanks;

-(void) setTextViews;
- (IBAction) mainMenuButtonPressed: (id) sender;

@end
