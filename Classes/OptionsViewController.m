//
//  OptionsViewController.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 4/6/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "OptionsViewController.h"
#import "ChallengeFactory.h"


@implementation OptionsViewController

@synthesize playerName;
@synthesize selectDiffPlayerButton;
@synthesize category;
@synthesize optionsToolbar;
@synthesize selectViewController;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	selectViewController.playerSelectDelegate = self;
	// Flexible Spacing
    // makes it so we can push the save button to the right
    // and the cancel button to the left
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] 
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                      target:nil 
                                      action:nil];
    
    // Back Button
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
								   initWithTitle:@"Back" 
								   style:UIBarButtonItemStyleDone
								   target:self
								   action:@selector(backButtonItemPressed)];
    
    // Save Button
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
								   initWithTitle:@"Save" 
                                   style:UIBarButtonItemStyleBordered
								   target:self
								   action:@selector(saveButtonItemPressed)];
    
    // Set up our tool bar
    NSArray *toolbarItems = [NSArray arrayWithObjects:backButton, flexibleSpace, saveButton, nil];
    [optionsToolbar setItems:toolbarItems animated:NO]; 
	[flexibleSpace release];
	[backButton release];
	[saveButton release];
	[super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

// Go Back to Main Window
- (void) backButtonItemPressed{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) playerSelected: (NSString*) name {
	self.playerName.text = name;
}

// Select Different Player
// Go Back to Main Window
- (IBAction) selectDifferentPlayerButtonPressed: (id) sender {
	[self resignFirstResponder];
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
		[self presentModalViewController:selectViewController animated:YES]; 
	}
}

// Save Information for Default Player for the Session
- (void) saveButtonItemPressed {
    // Our AppDelegate has the master player database object
    // so to access it, we need to get the delegate.
    BalloonChallengeAppDelegate *appDelegate = 
        (BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	Player* p = appDelegate.defaultPlayer;
    // Save Player Info
	NSString *tempName = [NSString stringWithString:p.name];
	Level *tempLevel = p.level;
	
    // get current selected player and update default player info
	[p setPlayerName:playerName.text
			   Level:tempLevel];
	
	if ( [appDelegate.playerDatabaseObj isPlayerNameDuplicate: playerName.text] ) 
	{
		//revert to saved
		[p setPlayerName:tempName
				   Level:tempLevel];
		// Don't Allow a user to add duplicate player names
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Choose a different name" 
                              message:@"This player already exists, please change the name before saving." 
                              delegate:nil 
                              cancelButtonTitle:@"Okay." 
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
		return;
	}
	

	
    [self dismissModalViewControllerAnimated:YES];
}




// Helper function for removing Keyboard from screen
- (IBAction)backgroundTap:(id)sender {
    [sender resignFirstResponder];	
}

// Setup up view
- (void)viewWillAppear:(BOOL)animated {
    self.title = @"Options";	
    BalloonChallengeAppDelegate *appDelegate = 
        (BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	Player *p = appDelegate.defaultPlayer;
    
    // Get player name and display in text field
	[self playerSelected:p.name];
	
    [super viewWillAppear:animated];
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
    [playerName release];
    [selectDiffPlayerButton release];
    [category release];
    [optionsToolbar release];
    [super dealloc];
}


@end
