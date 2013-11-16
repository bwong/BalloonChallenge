//
//  MathChallengeSelectViewController.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 5/24/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "PracticeSelectViewController.h"
#import "GroupFactory.h"

@implementation PracticeSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	gameSelectTable.backgroundColor = [UIColor clearColor];
	//[toolBar setFrame:CGRectMake(0, 0, 320, 35)];	
	[gameStartHolderView addSubview:continueLabel];
	self.continueLabel.text = @"Continue Game";
	ChallengeGroup* g = [[GroupFactory games] objectAtIndex:0];
	gameLabel.text = g.name;
}

- (void) setupButtons {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		if(self.interfaceOrientation == UIInterfaceOrientationPortrait || 
		   self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			self.tableHolderView.frame = CGRectMake(107, 50, 534, 940);
			
		} else {
			self.tableHolderView.frame = CGRectMake(224, 50, 534, 700);
		}
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

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[GroupFactory progressions] count];
}

//- (CGFloat)tableView:(UITableView *)tableView
//heightForHeaderInSection:(NSInteger)section {
//    return 30;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	ChallengeGroup* g = [[GroupFactory progressions] objectAtIndex:section];

	if ([g.subgroups count]==0) {
		return nil;
	}
	// create the parent view that will hold header Label
	UIView* customView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.bounds.size.width, 44.0)] autorelease];
	//customView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.9];
	
	// create the button object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor blackColor];
	headerLabel.highlightedTextColor = [UIColor whiteColor];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		headerLabel.font = [UIFont fontWithName:@"Marker Felt" size:24.0];
	} else {
		headerLabel.font = [UIFont fontWithName:@"Marker Felt" size:16.0];
	}
	headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
	
	// If you want to align the header text as centered
	//headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
	headerLabel.text = g.name;
	
	[customView addSubview:headerLabel];
	[headerLabel release];
	return customView;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0;
//}

//- (CGFloat) tableView:(UITableView *) tableView 
//heightForRowAtIndexPath: (NSIndexPath*) indexPath {
//	return 32;
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	ChallengeGroup* g = [[GroupFactory progressions] objectAtIndex:section];
	if ([g.subgroups count]==0) {
		return nil;
	}
	return g.name;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	ChallengeGroup* g = [[GroupFactory progressions] objectAtIndex:section];
	return [g.subgroups count];
	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	//    BalloonChallengeAppDelegate *appDelegate = 
	//	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	//int currentHighLevel = appDelegate.defaultPlayer.currentStats.highestLevel;
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.backgroundColor = [UIColor clearColor];
    //cell.
    // Set up the cell...
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    NSUInteger row = [indexPath row];
	Level *level = [Level levelWithGame:0 withProgression:indexPath.section withChallenge:row];
	
	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	GradeEnum grade = [appDelegate.defaultPlayer.currentStats gradeForLevel:level];
	switch (grade) {
		case e_GradeA:
			cell.imageView.image = [UIImage imageNamed:@"A.png"];
			break;
		case e_GradeB:
			cell.imageView.image = [UIImage imageNamed:@"B.png"];
			break;
		case e_GradeC:
			cell.imageView.image = [UIImage imageNamed:@"C.png"];
			break;
		default:
			cell.imageView.image = [UIImage imageNamed:@"x.png"];
			break;
	}
	CGSize sz1 = CGSizeMake(32.0f, 32.0f);
	UIImage *i1 = [self scale:cell.imageView.image toSize:sz1];
	cell.imageView.image = i1;
	cell.textLabel.frame = cell.frame;
	cell.textLabel.text = [level getChallengeName];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		cell.textLabel.font = [UIFont fontWithName:@"Marker Felt" size:23.0];
	} else {
		cell.textLabel.font = [UIFont fontWithName:@"Marker Felt" size:15.0];
	}	
    return cell;
}

// User makes a selection on the highscore table
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
  	NSUInteger row = [indexPath row];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	appDelegate.defaultPlayer.level = [Level levelWithGame:0 withProgression:indexPath.section withChallenge:row];
	[self gameSelected:appDelegate.defaultPlayer.level];
	//[self popBalloonAnimation:1];
	
}


@end
