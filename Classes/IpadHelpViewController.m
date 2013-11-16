    //
//  IpadHelpViewController.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 6/20/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "IpadHelpViewController.h"


@implementation IpadHelpViewController
@synthesize ipadHelp,ipadThanks;


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (void)viewDidLoad
{
	[self setTextViews];
	[super viewDidLoad];
	
}

-(void) setTextViews {
	NSString *helpStr = @"For Learning Game:"
	"1.  Touch \"Learn\" in Main Menu. From the game select menu, you can touch \"Practice\" to practice any level.\n\n"
	"2.  If this is your first time to play, touch the balloon that says \"Start New Game\" "
	"Otherwise you can continue the game at the highest level achieved.  You can also play "
	"any completed level by selecting that level.\n\n"
	"3. Instruction for playing the current level is shown on the next screen with helpful hints on how to win "
	"the level\n\n"
	"4. Pop as many balloons as you can with the right answers before time runs out!\n\n"
	"5. Once you finish a level successfully, you can go back to that level any time in the Level "
	"Select View. Your high score for that level will show in the level select screen.\n"
	"A - 90% and up\n"
	"B - 80% - 89%\n"
	"C - 70% - 79%\n"
	"X - Below 70% or Incomplete\n\n"
	"6.  Difficulty can be changed in the options page. We recommend:\n"
	"Easy - Kinder - 3rd Grade\n"
	"Normal - 4th - 6th Grade\n"
	"Hard - 7th Grade and up!\n\n"
	"For additional help or feedback! Contact us at support@klivin.com";
	
	
	NSString *thanksStr = @"To my wonderful, supportive wife, thanks for everything! "
	"Thanks to all the wonderful teachers out there who gave input!\n\n"
	"All Credit for music goes to Royalty Free Music by DanoSongs.com, Thanks!\n\n"
	"Another BIG thanks to Jeri Ingalls for her fonts at http://littlehouse.homestead.com\n\n"
	"Last but certainly not least, thanks to Brian Wong for helping us get this app going.";
	[ipadHelp setText:helpStr];
	[ipadThanks setText:thanksStr];
	[ipadHelp setFont:[UIFont fontWithName:@"Marker Felt" size:30.0]];
	[ipadThanks setFont:[UIFont fontWithName:@"Marker Felt" size:30.0]];
}
- (IBAction) mainMenuButtonPressed: (id) sender {
    // Go back to Main Menu
    [self dismissModalViewControllerAnimated:YES];
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
}


- (void)dealloc {
    [super dealloc];
}


@end
