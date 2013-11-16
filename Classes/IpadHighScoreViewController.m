    //
//  IpadHighScoreViewController.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 6/21/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "IpadHighScoreViewController.h"
#import "BalloonChallengeAppDelegate.h"
#import "GroupFactory.h"
#import "Player.h"

@implementation IpadHighScoreViewController

@synthesize statsTable;
@synthesize highScoreTable;
@synthesize player;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

// Return the user to the Main Menu
- (void) mainMenuButtonPressed {
    [self dismissModalViewControllerAnimated:NO];
    //[self modalViewController];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];

	// Setup the Main Menu Bar Button Item
	// so the user has a way back to main menu
	UIBarButtonItem *mainButton = [[UIBarButtonItem alloc] 
								   initWithTitle:@"Back" 
								   style:UIBarButtonItemStyleDone 
								   target:self
								   action:@selector(mainMenuButtonPressed)]; 
#ifdef __IPHONE_3_2

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		self.highScoreTable.backgroundView = nil;
		self.statsTable.backgroundView = nil;
	}
#endif
	
    self.navigationItem.leftBarButtonItem = mainButton;
	[mainButton release];
    self.title = @"High Scores";
}


- (IBAction) clearStats {
	
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Are you sure you want to clear your player's game data?" 
						  message:@""
						  delegate:self 
						  cancelButtonTitle:@"Yes"
						  otherButtonTitles:@"Cancel", nil];
	
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex ==1) {
		return;
	}
	if (buttonIndex == 0) {
		player.level = [Level levelWithGame:1 withProgression:0 withChallenge:0];
		[player.currentStats clearStats];
		[self.statsTable reloadData];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	
	UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] 
									initWithTitle:@"Clear Grades"
									style:UIBarButtonItemStylePlain 
									target:self 
									action:@selector(clearStats)];
	self.navigationItem.rightBarButtonItem = clearButton;
	[clearButton release];
	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString * playerName = appDelegate.defaultPlayer.name;
	self.player = appDelegate.defaultPlayer;
	int pindex = [[appDelegate.playerDatabaseObj playerNames] indexOfObject:playerName];
	
    // Refresh the table view
	[highScoreTable reloadData];
	[highScoreTable flashScrollIndicators];
    [super viewWillAppear:animated];
	
	// Refresh the table view
	[statsTable reloadData];
	[statsTable flashScrollIndicators];
	[self.highScoreTable  selectRowAtIndexPath:[NSIndexPath indexPathForRow:pindex inSection:1]
									  animated:YES 
								scrollPosition:UITableViewScrollPositionNone];
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

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   	if (tableView == highScoreTable) {
		return 3; 
	} else {
		return [[GroupFactory mathgroups] count] + 1;
	}
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if (tableView == highScoreTable) {

		if (section == 0 )
			return @"Grade Book (Touch to see Grades):";
		else if (section == 1)
			return @"High Scores (Time Challenges):";
		else if (section == 2)
			return @"High Scores (Learning Game):";

	} else {
		if(section == 0)
			return @"Player Statistics (Learning Game)";
		ChallengeGroup* p = [[GroupFactory mathgroups] objectAtIndex:section-1];
		return p.name;
	}

	return nil;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (tableView == highScoreTable) {
		if (section == 0) 
			return [[appDelegate.playerDatabaseObj playerNames] count];
		else if (section == 1) 
			return [[GroupFactory progressions] count];
		else if (section == 2) 
			return [appDelegate.highScoreArray numPlayers];
	} else {
		if (section == 0)
			return 3;
		ChallengeGroup* p = [[GroupFactory mathgroups] objectAtIndex:section-1];
		return [p.subgroups count];	
	}

	return 0;
	
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    return 28;
}

- (CGFloat) tableView:(UITableView *) tableView 
heightForRowAtIndexPath: (NSIndexPath*) indexPath {
	if (tableView == highScoreTable) {
		if (indexPath.section==1)
			return 40;
	}
	return 34;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (tableView == highScoreTable) {
		
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
//				if ([cell.contentView viewWithTag:1] != nil) {
//					[(UILabel*)[cell.contentView viewWithTag:1] setFrame:CGRectMake(175, cell.contentView.frame.origin.y+2, 120, 15)];
//					[(UILabel*)[cell.contentView viewWithTag:1] setText:hs.name];
//					[cell setNeedsDisplay];
//				} else {
//					CGRect nameLabelRect = CGRectMake(175, cell.contentView.frame.origin.y+2, 120, 15);
//					UILabel *nameLabel = [[UILabel alloc]initWithFrame:nameLabelRect];
//					nameLabel.textAlignment = UITextAlignmentRight;
//					nameLabel.font = [UIFont boldSystemFontOfSize:13];
//					nameLabel.backgroundColor = [UIColor clearColor];
//					nameLabel.tag = 1;
//					[cell.contentView addSubview:nameLabel];
//					[nameLabel release];
//				}
//				if ([cell.contentView viewWithTag:2] != nil) {
//					[(UILabel*)[cell.contentView viewWithTag:2] setFrame:CGRectMake(230, cell.contentView.frame.size.height/2+2, 85, 15)];
//					[(UILabel*)[cell.contentView viewWithTag:2] setText:[NSString stringWithFormat:@"Score:\t\t%d",hs.score]];
//					[cell setNeedsDisplay];
//				} else {
//					CGRect scoreLabelRect = CGRectMake(230, cell.contentView.frame.size.height/2+2, 85, 15);
//					UILabel *scoreLabel = [[UILabel alloc]initWithFrame:scoreLabelRect];
//					scoreLabel.textAlignment = UITextAlignmentLeft;
//					scoreLabel.font = [UIFont boldSystemFontOfSize:13];
//					scoreLabel.backgroundColor = [UIColor clearColor];
//					scoreLabel.tag = 2;
//					[cell.contentView addSubview:scoreLabel];
//					[scoreLabel release];
//				}
			}
		} else if (indexPath.section == 2 ) {
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			HighScore *hs = [appDelegate.highScoreArray.highScores objectAtIndex:row];
			cell.textLabel.text = [NSString stringWithFormat: @"%d. %s",row+1, [hs.name UTF8String]];
			// Score will be shown to the left of the name
			cell.detailTextLabel.text = [NSString stringWithFormat: @"%d", hs.score];
			
		} 
	} else if (tableView == statsTable) {
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		}
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		// Set up the cell...
		NSUInteger row = [indexPath row];
		if (indexPath.section == 0 ) {
			switch (row) {
				case 0:
					cell.textLabel.text = @"Name";
					cell.detailTextLabel.text = player.name;
					break;
				case 1:
					cell.textLabel.text = @"Highest Level";
					
					ChallengeGroup *g = [[GroupFactory games] objectAtIndex:1];
					Level *hl = [player.currentStats.highestLevel valueForKey:g.name];
					cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [hl getChallengeName]];
					break;
				case 2:
					cell.textLabel.text = @"Total Time Played (sec.)";
					cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", player.currentStats.timePlayed];
					break;	
				default:
					break;
			}
		} else {		
			cell.textLabel.frame = cell.frame;
			Level *l = [Level levelWithGame:1 withProgression:indexPath.section-1 withChallenge:row];
			cell.textLabel.text = [l getChallengeName];
			
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%d%%",[[player.currentStats percentForLevel:l] intValue]];
		}
		
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
		self.player = selectedPlayer;
		[statsTable reloadData];
		//[self.navigationController pushViewController:playerViewController animated:YES];
		
    }  
	//[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}



- (void)dealloc {
	[statsTable release];
	[highScoreTable release];
	[player release];
    [super dealloc];
}


@end
