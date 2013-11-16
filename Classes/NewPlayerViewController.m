//
//  NewPlayerViewController.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 3/8/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "NewPlayerViewController.h"


@implementation NewPlayerViewController

@synthesize playerName;

/* Add a done button.  When pressed, we'll inform the next ViewController down on the navController stack
 -- they are the ones who manage the array we'll want to insert the player into.  */
- (void) viewWillAppear:(BOOL) animated {
	[self.navigationItem setTitle:@"New Player"];
	
	// Find the next controller down on the nav controller stack
	NSArray *navControllerStack = self.navigationController.viewControllers;
	UIViewController *parentViewController = [navControllerStack objectAtIndex:([navControllerStack count] - 2)];
	
	// Add a "Done" button to the navigation toolbar
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
								   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
								   target:parentViewController
								   action:@selector(doneAdding)];
	self.navigationItem.rightBarButtonItem = doneButton;
	[doneButton release];
	
	[super viewWillAppear:animated];
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
    [super dealloc];
}


@end
