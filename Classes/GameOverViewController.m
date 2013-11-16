//
//  GameOverViewController.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 5/2/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "GameOverViewController.h"
#import "HighScoresViewController.h"
#import "IpadHighScoreViewController.h"
#import "TimeChallengeViewController.h"

static NSMutableArray *timeChallengeStats;
static NSMutableArray *gameOverStats;


@implementation GameOverViewController

@synthesize gameOverDelegate;

@synthesize nextLevelButton;
@synthesize playAgainButton;
@synthesize gradeButton;
@synthesize levelMenuButton;
@synthesize levelMenuTouched;
@synthesize gameOverLabel;
@synthesize tableData, statsTable, levelName, playerName;

+(NSMutableArray *) timeChallengeStats {
	if (nil == timeChallengeStats)
		timeChallengeStats = [[NSMutableArray allocWithZone:[self zone]] 
					  initWithObjects: 
					  [NSString stringWithFormat:@"Levels Complete:"],
					  [NSString stringWithFormat:@"Balloons Popped:"],
					  [NSString stringWithFormat:@"Time (sec):"],
					  [NSString stringWithFormat:@"Biggest Combo:"],
					  [NSString stringWithFormat:@"Final Score:"],
					  [NSString stringWithFormat:@"Record Levels:"],
					  [NSString stringWithFormat:@"Record Balloons:"],
					  [NSString stringWithFormat:@"Record Time (sec):"],
					  [NSString stringWithFormat:@"Record Combo:"],
					  [NSString stringWithFormat:@"Record Score:"],
					  nil];
	return timeChallengeStats;
}

+(NSMutableArray *) gameOverStats {
	if (nil == gameOverStats)
		gameOverStats = [[NSMutableArray allocWithZone:[self zone]] 
							  initWithObjects: 
							  [NSString stringWithFormat:@"%% Correct:"],
							  [NSString stringWithFormat:@"Score:"],
							  [NSString stringWithFormat:@"Total Score:"],
							  nil];
	return gameOverStats;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation
										  duration:(NSTimeInterval) duration {
	[self setupButtons];

}

-(IBAction) buttonPressed: (id) sender {
	
	if(gameOverDelegate != nil) {

		if (sender == nextLevelButton) {
			if([gameOverDelegate respondsToSelector:@selector(nextLevelPressed)]) {
				[gameOverDelegate performSelector:@selector(nextLevelPressed) withObject:self];
			}
		} else if (sender == playAgainButton) {
			if([gameOverDelegate respondsToSelector:@selector(playAgainPressed)]) {
				[gameOverDelegate performSelector:@selector(playAgainPressed) withObject:self];
			}
		} else if (sender == gradeButton) {
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
				highScoresViewController = [[[IpadHighScoreViewController alloc] 
											 initWithNibName:@"IpadHighScoreViewController"
											 bundle:nil] autorelease];		
			} else {
				highScoresViewController = [[[HighScoresViewController alloc] 
											 initWithNibName:@"HighScoresViewController"
											 bundle:nil] autorelease];		
			}
			
			UINavigationController *highScoreNavController = [[UINavigationController alloc] initWithRootViewController:highScoresViewController];
			[self presentModalViewController:highScoreNavController animated:YES];
			[highScoreNavController release];
			//[highScoresViewController release];
			
		} else if (sender == levelMenuButton) {
			[gameOverDelegate performSelector:@selector(levelMenuPressed:) withObject:self];

		}
	}
}

-(void) setupButtons {
	if(gameOverDelegate != nil) {
		BOOL timeChallenge = ([gameOverDelegate isKindOfClass:[TimeChallengeViewController class]]);

		if (timeChallenge) {
			//show correct buttons
			self.nextLevelButton.hidden = YES;
			self.gradeButton.hidden = YES;

			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
				if(self.interfaceOrientation == UIInterfaceOrientationPortrait || 
				   self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
					self.playAgainButton.frame = CGRectMake(140, 720, 195, 230);
					self.levelMenuButton.frame = CGRectMake(430, 720, 195, 230);
					self.statsTable.frame = CGRectMake(205, 262, 350, 440);

					
				} else {
					self.playAgainButton.frame = CGRectMake(550, 315, 195, 230);
					self.levelMenuButton.frame = CGRectMake(785, 315, 195, 230);
					self.statsTable.frame = CGRectMake(100, 260, 350, 440);
				}
			}
			else {
				self.playAgainButton.frame = CGRectMake(50, 365, 100, 111);
				self.levelMenuButton.frame = CGRectMake(170, 365, 100, 111);
				self.statsTable.frame = CGRectMake(16,122,286,240);

			}
		} else {
			self.nextLevelButton.hidden = NO;
			self.gradeButton.hidden = NO;

			
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
				if(self.interfaceOrientation == UIInterfaceOrientationPortrait || 
				   self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
					self.nextLevelButton.frame = CGRectMake(5, 510, 195, 230);
					self.playAgainButton.frame = CGRectMake(188, 590, 195, 230);
					self.gradeButton.frame = CGRectMake(380, 510, 195, 230);
					self.levelMenuButton.frame = CGRectMake(563, 590, 195, 230);
					self.statsTable.frame = CGRectMake(205, 262, 330, 160);
				} else {
					self.nextLevelButton.frame = CGRectMake(450, 262, 195, 230);
					self.playAgainButton.frame = CGRectMake(540, 500, 195, 230);
					self.gradeButton.frame = CGRectMake(780, 500, 195, 230);
					self.levelMenuButton.frame = CGRectMake(680, 262, 195, 230);
					self.statsTable.frame = CGRectMake(50, 280, 330, 160);
				}
			}
			else {
				self.statsTable.frame = CGRectMake(16,136,286,95);
			}
		}

	}
}

-(void) viewWillAppear:(BOOL)animated {
	self.levelMenuTouched = NO;
	[self setupButtons];
	[statsTable reloadData];
	[super viewWillAppear:animated];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
//	[self wobbleView:levelMenuButton];
//	[self wobbleView:playAgainButton];
//	[self wobbleView:gradeButton];
//	[self wobbleView:nextLevelButton];
	self.tableData = [[NSMutableDictionary alloc] init];

    [super viewDidLoad];
}

- (void) wobbleView: (UIView *) v {
	
	CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-6.0));
	CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(6.0));
	
	v.transform = leftWobble;  // starting point
	[UIView beginAnimations:@"wobble" context:self];
	[UIView setAnimationRepeatAutoreverses:YES]; // important
	//wobble indefinitely
	[UIView setAnimationRepeatCount:100000];
	[UIView setAnimationDuration:0.9];
	v.transform = rightWobble; // end here & auto-reverse
	[UIView commitAnimations];
	
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}
- (void)viewDidDisappear:(BOOL)animated {

	[super viewDidDisappear:animated];
}
#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	BOOL timeChallenge = ([gameOverDelegate isKindOfClass:[TimeChallengeViewController class]]);
	
	if (timeChallenge) {
		return 2;
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return 38;
	} else {
		return 20;
	}
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//	// create the parent view that will hold header Label
//	UIView* customView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.bounds.size.width, 44.0)] autorelease];
//	//customView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.9];
//	
//	// create the button object
//	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//	headerLabel.backgroundColor = [UIColor clearColor];
//	headerLabel.opaque = NO;
//	headerLabel.textColor = [UIColor blackColor];
//	headerLabel.highlightedTextColor = [UIColor whiteColor];
//	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//		headerLabel.font = [UIFont fontWithName:@"Marker Felt" size:24.0];
//	} else {
//		headerLabel.font = [UIFont fontWithName:@"Marker Felt" size:16.0];
//	}
//	
//	headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
//	
//	// If you want to align the header text as centered
//	//headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
//	BOOL timeChallenge = ([gameOverDelegate isKindOfClass:[TimeChallengeViewController class]]);
//	if (timeChallenge) {
//		if (section == 0)
//			headerLabel.text =  [NSString stringWithFormat:@"Current Game:"];
//		else 
//			headerLabel.text =  [NSString stringWithFormat:@"Player Record's:"];
//	} else {
//		headerLabel.text =  [NSString stringWithFormat:@"Last Level:"];
//	}	
//	
//	[customView addSubview:headerLabel];
//	[headerLabel release];
//	return customView;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (CGFloat) tableView:(UITableView *) tableView 
heightForRowAtIndexPath: (NSIndexPath*) indexPath {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return 36;
	} else {
		return 20;
	}

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	BOOL timeChallenge = ([gameOverDelegate isKindOfClass:[TimeChallengeViewController class]]);
	if (timeChallenge) {
		if (section == 0)
			return [NSString stringWithFormat:@"Current Game: %@", levelName];
		else 
			return [NSString stringWithFormat:@"%@'s Records:",playerName];
	} else {
		return [NSString stringWithFormat:@"Last Level:"];
	}
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	BOOL timeChallenge = ([gameOverDelegate isKindOfClass:[TimeChallengeViewController class]]);
	
	if (timeChallenge) 
		return 5;
	else 
		return 3;
	
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	//    BalloonChallengeAppDelegate *appDelegate = 
	//	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	//int currentHighLevel = appDelegate.defaultPlayer.currentStats.highestLevel;
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = [UIColor clearColor];
	}
    //cell.
    // Set up the cell...
	
    NSUInteger row = [indexPath row];
	
	//	BalloonChallengeAppDelegate *appDelegate = 
	//	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	//	NSInteger timeSec = [appDelegate.defaultPlayer.currentStats timeForProgression:[[GroupFactory progressions] objectAtIndex:row]];
	//	cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",timeSec];
	BOOL timeChallenge = ([gameOverDelegate isKindOfClass:[TimeChallengeViewController class]]);
	
	if (timeChallenge) {
		if (indexPath.section == 0) {
			cell.textLabel.text = [[GameOverViewController timeChallengeStats] objectAtIndex:row];
			cell.detailTextLabel.text = [self.tableData objectForKey:cell.textLabel.text];

		} else {
			cell.textLabel.text = [[GameOverViewController timeChallengeStats] objectAtIndex:row+5];
			cell.detailTextLabel.text = [self.tableData objectForKey:cell.textLabel.text];
		}
	} else {
		cell.textLabel.text = [[GameOverViewController gameOverStats] objectAtIndex:row];
		cell.detailTextLabel.text = [self.tableData objectForKey:cell.textLabel.text];
	}

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		cell.textLabel.font = [UIFont fontWithName:@"Marker Felt" size:28];
		cell.detailTextLabel.font = [UIFont fontWithName:@"Marker Felt" size:28];
		cell.textLabel.textColor = UIColor.blackColor;
		cell.textLabel.shadowColor = UIColor.whiteColor;
		cell.detailTextLabel.textColor = UIColor.blackColor;
		cell.detailTextLabel.shadowColor = UIColor.whiteColor;
		[cell.textLabel setShadowOffset:CGSizeMake(1, 1)];
		[cell.detailTextLabel setShadowOffset:CGSizeMake(1, 1)];
	
	} else {
		cell.textLabel.font = [UIFont fontWithName:@"Marker Felt" size:16.0];
		cell.detailTextLabel.font = [UIFont fontWithName:@"Marker Felt" size:16.0];
		cell.textLabel.textColor = UIColor.blackColor;
		cell.textLabel.shadowColor = UIColor.grayColor;
		cell.detailTextLabel.textColor = UIColor.blackColor;
		cell.detailTextLabel.shadowColor = UIColor.grayColor;
		[cell.textLabel setShadowOffset:CGSizeMake(1, 1)];
		[cell.detailTextLabel setShadowOffset:CGSizeMake(1, 1)];
	}
	//cell.textLabel.frame = cell.frame;
	
    return cell;
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	gameOverLabel = nil;
	nextLevelButton = nil;
	playAgainButton = nil;
	gradeButton = nil;
	levelMenuButton = nil;
	highScoresViewController = nil;
	tableData = nil;
	statsTable = nil;
}


- (void)dealloc {
	[gameOverLabel release];
	[nextLevelButton release];
	[playAgainButton release];
	[gradeButton release];
	[levelMenuButton release];
	[highScoresViewController release];
    [statsTable release];
	[tableData release];
	[super dealloc];
}


@end
