//
//  GameViewController.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 2/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"
#import "BalloonFactory.h"


@implementation GameViewController
@synthesize gameState, beginLabel, gv, balloons, gameTimer, balloonTimer;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	self.gameState = kGameStatePaused;
	gameTimer = [NSTimer scheduledTimerWithTimeInterval:0.05f 
									 target:self
								   selector:@selector(gameLoop) 
								   userInfo:nil 
									repeats:YES];
//	[self createBalloon];
	//balloonTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f 
//									 target:self
//								   selector:@selector(createBalloon) 
//								   userInfo:nil 
//									repeats:YES];

}
- (void) createBalloon {

	Balloon *b1 = [BalloonFactory createRandomBalloon];
	// b1.bounds = gv.frame;
	[self.gv addSubview:b1];
}

- (void) gameLoop {
	if (gameState == kGameStateRunning){
		for (UIView *b in gv.subviews) {
			if ( [b isMemberOfClass:[Balloon class]] )
				[ (Balloon *) b move];
		}

	}
	else if (gameState == kGameStatePaused) {

		beginLabel.hidden = NO;
	}
}

- (void) clearBalloons {
	//release old balloons
	for (UIView *b in gv.subviews) {
		if ( [b isMemberOfClass:[Balloon class]] ) {
			[b removeFromSuperview];
			[b release];
		}
	}
}

- (void) touchesBegan: (NSSet *) touches 
			withEvent: (UIEvent *) event {
	//when touches begin, if game is paused
	if (gameState == kGameStatePaused) {
		beginLabel.hidden = YES;
		gameState = kGameStateRunning;
		
		[self clearBalloons];

		//create a new balloon
		[self createBalloon];
		[self createBalloon];
		
	} else if (gameState==kGameStateRunning) {
		UITouch *touch = [[event allTouches] anyObject];
		
		for (UIView *b in gv.subviews) {
			if ( [b isMemberOfClass:[Balloon class]] ) {
				if ([self didTouchBalloon:(Balloon *)b withTouch: touch]) {
					gameState = kGameStatePaused;
					[self wonGame:YES withScore:0];
				}
			}
		}
	}
}

- (BOOL) didTouchBalloon: (Balloon *) balloon withTouch: (UITouch *) touch {
	CGPoint location = [touch locationInView:gv];
	CGRect bounds = balloon.frame;

	// does the click location fall in the bounds of the balloon
	if ((location.x >= bounds.origin.x && location.y >= bounds.origin.y) && 
		(location.x <= (bounds.origin.x + bounds.size.width) &&
		location.y <= (bounds.origin.y + bounds.size.height)) ) {
		return YES;
	}
	return NO;
}

-(IBAction) wonGame: (BOOL) didWin 
		  withScore: (NSInteger) score {
	NSMutableString* winLabel = [[NSMutableString alloc] initWithString:@"You Got A High Score!"];
	
	if (!didWin)
		[winLabel setString:@"You Lost"];
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:winLabel
									delegate:self 
								  cancelButtonTitle:@"Play Again?"
							 destructiveButtonTitle:@"Main Menu..."
								  otherButtonTitles:@"High Score...",nil];
	[actionSheet showInView:self.gv];
	[actionSheet release];
}

- (void) actionSheet: (UIActionSheet *) sheet 
didDismissWithButtonIndex: (NSInteger) index {
	//int cancel = [sheet cancelButtonIndex];
	
	[self clearBalloons];
	switch (index) {
		case 2:
			beginLabel.hidden = NO;
			gameState = kGameStatePaused;
			break;
		case 1:
		case 0:
			[self dismissModalViewControllerAnimated:YES];
			gameState = kGameStatePaused;
			break;

		default:
			beginLabel.hidden = NO;
			gameState = kGameStatePaused;
			break;
	} 
	

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
    [super dealloc];
}


@end
