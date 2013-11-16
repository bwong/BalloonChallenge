//
//  PlayerViewController.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 3/3/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "PlayerViewController.h"
#import "ChallengeFactory.h"
#import "GroupFactory.h"

@implementation PlayerViewController


@synthesize statsTable;
@synthesize player;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Gradebook";
	statsTable.backgroundColor = [UIColor clearColor];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
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
	if (buttonIndex ==0) {
		return;
	}
	if (buttonIndex == 1) {
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
    // Refresh the table view
	[statsTable reloadData];
	[statsTable flashScrollIndicators];
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
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[GroupFactory mathgroups] count] + 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if(section == 0)
		return @"Player Statistics (Learning Game)";
	ChallengeGroup* p = [[GroupFactory mathgroups] objectAtIndex:section-1];
	return p.name;

}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0)
		return 3;
	ChallengeGroup* p = [[GroupFactory mathgroups] objectAtIndex:section-1];
	return [p.subgroups count];	

}
- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    return 28;
}
- (CGFloat) tableView:(UITableView *) tableView 
heightForRowAtIndexPath: (NSIndexPath*) indexPath {
	return 34;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
				
				
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [hl getChallengeName] ];
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
    
    return cell;
}


- (void)dealloc {
    // release variables

	[player release];
    [super dealloc];
}


@end
