//
//  BalloonChallengeViewController.m
//  BalloonChallenge
//
//  Created by Brian Wong on 2/6/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "BalloonChallengeViewController.h"

@implementation BalloonChallengeViewController
@synthesize gameViewController;

/* START BRIAN'S CODE */
@synthesize highScoresViewController;
@synthesize optionsViewController;
@synthesize helpViewController;
/* END BRIAN'S CODE */

-(IBAction) gameButtonPressed: (id) sender {
	[self presentModalViewController:gameViewController animated:YES];
}

/* START BRIAN'S CODE */

// User pressed highscores button put up highscores view
- (IBAction) highScoresButtonPressed: (id) sender {
	[self presentModalViewController:highScoresViewController animated:YES];    
}

// User pressed options button put up options view
- (IBAction) optionsButtonPressed: (id) sender {
	[self presentModalViewController:optionsViewController animated:YES];        
}

// User pressed help button put up help view
- (IBAction) helpButtonPressed: (id) sender {
	[self presentModalViewController:helpViewController animated:YES];        
}

/* END BRIAN'S CODE */

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
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
	gameViewController = nil;
}


- (void)dealloc {
	[gameViewController release];
    [super dealloc];
}

@end
