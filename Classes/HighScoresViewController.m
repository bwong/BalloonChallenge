//
//  HighScoresViewController.m
//  BalloonChallenge
//
//  Created by Brian Wong on 2/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HighScoresViewController.h"
#import "GameView.h"
#import "PlayerViewController.h"
#import "GroupFactory.h"


@implementation HighScoresViewController

@synthesize playerTableView;
@synthesize playerViewController;

// Return the user to the Main Menu
- (void) mainMenuButtonPressed {
    [self dismissModalViewControllerAnimated:YES];
   // [self modalViewController];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	//BalloonChallengeAppDelegate *appDelegate = 
	//	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	//players = [appDelegate.playerDatabaseObj playerNames];
	
	// Setup the Main Menu Bar Button Item
	// so the user has a way back to main menu
	UIBarButtonItem *mainButton = [[UIBarButtonItem alloc] 
								   initWithTitle:@"Back" 
								   style:UIBarButtonItemStyleDone 
								   target:self
								   action:@selector(mainMenuButtonPressed)]; 
	//self.parentViewController.view.opaque = YES;
	//self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_balloons.png"]];
	//self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_balloons.png"]];
	//self.tableView.separatorColor = [UIColor clearColor];
	//self.tableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.5f];
	playerTableView.backgroundColor = [UIColor clearColor];
    self.navigationItem.leftBarButtonItem = mainButton;
	[mainButton release];
    self.title = @"High Scores";
}

- (void)viewWillAppear:(BOOL)animated {
	
	//BalloonChallengeAppDelegate *appDelegate = 
	//(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	//players = [appDelegate.playerDatabaseObj playerNames];

    // Refresh the table view
	[playerTableView reloadData];
	[playerTableView flashScrollIndicators];
	self.view.opaque = NO;

    [super viewWillAppear:animated];
}
- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	// create the parent view that will hold header Label
	UIView* customView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, playerTableView.bounds.size.width, 44.0)] autorelease];
	//customView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.9];
	
	// create the button object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor blackColor];
	headerLabel.shadowColor = [UIColor grayColor];
	[headerLabel setShadowOffset:CGSizeMake(1, 1)];

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		headerLabel.font = [UIFont fontWithName:@"Marker Felt" size:28.0];
	} else {
		headerLabel.font = [UIFont fontWithName:@"Marker Felt" size:23.0];
	}
	
	headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
	
	// If you want to align the header text as centered
	//headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
	

	if (section == 0 )
		headerLabel.text = @"Grade Book (Touch to see Grades):";
	else if (section == 1)
		headerLabel.text =  @"High Scores (Time Challenges):";
	else if (section == 2)
		headerLabel.text =  @"High Scores (Learning Game):";
	
	[customView addSubview:headerLabel];
	[headerLabel release];
	return customView;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	playerTableView = nil;
	playerViewController = nil;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate *)[[UIApplication sharedApplication] delegate];

	if (section == 0) 
		return [[appDelegate.playerDatabaseObj playerNames] count];
	else if (section == 1) 
		return [[GroupFactory progressions] count];
	else if (section == 2) 
		return [appDelegate.highScoreArray numPlayers];
	return 0;
	
}

- (CGFloat) tableView:(UITableView *) tableView 
heightForRowAtIndexPath: (NSIndexPath*) indexPath {
	if (indexPath.section==1)
		return 40;
	return 35;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Set up the cell...
    NSUInteger row = [indexPath row];
    
	if (indexPath.section == 0 ) {
		cell.userInteractionEnabled = YES;
		// Setup thet table to have the little '>' symbol
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.textLabel.text = [[appDelegate.playerDatabaseObj playerNames] objectAtIndex:row];
		cell.detailTextLabel.text = nil;
    } else if (indexPath.section == 1 ) {
		cell.detailTextLabel.text = nil;

		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		// Setup thet table to have the little '>' symbol
		cell.textLabel.text = [[[GroupFactory progressions] objectAtIndex:row] name];
		HighScore* hs = [appDelegate.playerDatabaseObj highScoreForTimeChallenge:row];
		if (hs.score>0) {
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%d (%@)", hs.score,hs.name];
		}
//
//		CGRect nameLabelRect = CGRectMake(160, 2, 120, 15);
//		UILabel *nameLabel = [[UILabel alloc]initWithFrame:nameLabelRect];
//		nameLabel.textAlignment = UITextAlignmentRight;
//		HighScore* hs = [appDelegate.playerDatabaseObj highScoreForTimeChallenge:row];
//		if (hs.score>0) {
//			nameLabel.text = hs.name;
//		}
//		nameLabel.backgroundColor = [UIColor clearColor];
//
//		nameLabel.font = [UIFont boldSystemFontOfSize:13];
//		[cell.contentView addSubview:nameLabel];
//		[nameLabel release];
//		
//		CGRect scoreLabelRect = CGRectMake(215, 21, 85, 15);
//		UILabel *scoreLabel = [[UILabel alloc]initWithFrame:scoreLabelRect];
//		scoreLabel.textAlignment = UITextAlignmentLeft;
//		scoreLabel.backgroundColor = [UIColor clearColor];
//
//		if (hs.score>0) {
//			scoreLabel.text = [NSString stringWithFormat:@"Score:\t\t%d",hs.score];
//		}
//		scoreLabel.font = [UIFont boldSystemFontOfSize:13];
//		[cell.contentView addSubview:scoreLabel];
//		[scoreLabel release];
    } else if (indexPath.section == 2 ) {
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		HighScore *hs = [appDelegate.highScoreArray.highScores objectAtIndex:row];
		cell.textLabel.text = [NSString stringWithFormat: @"%d. %s",row+1, [hs.name UTF8String]];
		// Score will be shown to the left of the name
		cell.detailTextLabel.text = [NSString stringWithFormat: @"%d", hs.score];
		
	} 
    return cell;
}

// User makes a selection on the highscore table
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get AppDelegate for Global Information
    BalloonChallengeAppDelegate *appDelegate = 
        (BalloonChallengeAppDelegate *)[[UIApplication sharedApplication] delegate];
    

	NSUInteger row = [indexPath row];
    if (indexPath.section == 0 ) {
		Player *selectedPlayer = [appDelegate.playerDatabaseObj findPlayerWithName:[[appDelegate.playerDatabaseObj playerNames] objectAtIndex:row]];
		
		// Pass selected player's information to the PlayerViewController
		playerViewController.player = selectedPlayer;
		[self.navigationController pushViewController:playerViewController animated:YES];
		
    }  
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void)dealloc {
    [playerTableView release];
    [playerViewController release];
    [super dealloc];
}


@end



