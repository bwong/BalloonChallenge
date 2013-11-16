//
//  PlayerSelectViewController.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 6/19/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "PlayerSelectViewController.h"
#import "BalloonChallengeAppDelegate.h"

@implementation PlayerSelectViewController


@synthesize selectPlayerToolbar;
@synthesize playerTable;
@synthesize playerName;
@synthesize playerSelectDelegate;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Select a Player";
	UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
								   initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
								   target:self
								   action:@selector(toggleEditing:)];
	NSArray *toolbarItems = [NSArray arrayWithObject:editButton];
	[self.selectPlayerToolbar setItems:toolbarItems animated:YES]; 
	[editButton release];
	self.playerTable.backgroundColor = [UIColor clearColor];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
}

/* Create our toolbar buttons.  */
- (void)viewWillAppear:(BOOL)animated {
	// Edit/Done button in the bottom toolbar
	self.playerName.text = nil;
	[self.playerTable reloadData];
	[super viewWillAppear:animated];
}

// Helper function for removing Keyboard from screen
- (IBAction)backgroundTap:(id)sender {
	[self.playerName resignFirstResponder];	
}

/* The user has finished entering text for the new item.  Add it to the NamedGroup and pop the NewItemView.  */
- (IBAction) doneAdding {
	[self.playerName resignFirstResponder];	

	NSString *playerNameStr = [NSString stringWithString:playerName.text];
	
	// Get AppDelegate for Global Information
	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	if ( ![appDelegate.playerDatabaseObj isExistingName: playerNameStr] ) 
	{
		if (playerNameStr.length == 0 || playerNameStr.length > 30) {
			// Don't Allow a user to add duplicate player names
			UIAlertView *alert = [[UIAlertView alloc] 
								  initWithTitle:@"Bad Name" 
								  message:@"Player name must be between 1 and 30 letters." 
								  delegate:nil 
								  cancelButtonTitle:@"Okay." 
								  otherButtonTitles:nil];
			[alert show];
			[alert release];
			return;
		}
		// Create New Player Object
		Player *newPlayer = [[Player alloc] initWithName:playerNameStr 
										   andTimePlayed:0];
		// set as default
		appDelegate.defaultPlayer = newPlayer;
		
		// also need to add it to the current list of profiles available
		[appDelegate.playerDatabaseObj addPlayerObj:newPlayer];  
		
		[newPlayer release];
		
		// don't forget ot reload the table view
		[self.playerTable reloadData];
		[self.playerSelectDelegate playerSelected:playerNameStr];
		if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
			[self dismissModalViewControllerAnimated:YES];    
		}
	} else
	{
		// Don't Allow a user to add duplicate player names
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:@"Same Name" 
							  message:@"This player already exists" 
							  delegate:nil 
							  cancelButtonTitle:@"Okay." 
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

- (void) doneEditingTable {
	[self.playerTable setEditing:NO animated:YES];
	UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
								   initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
								   target:self
								   action:@selector(toggleEditing:)];
	NSArray *toolbarItems = [NSArray arrayWithObject:editButton];
	[self.selectPlayerToolbar setItems:toolbarItems animated:YES]; 
	[editButton release];
}


-(IBAction) toggleEditing:(id)sender {
	[self.playerTable setEditing:YES animated:YES];
	UIBarButtonItem *doneButton =
	[[UIBarButtonItem alloc]
	 initWithBarButtonSystemItem:UIBarButtonSystemItemDone
	 target:self
	 action:@selector(doneEditingTable)];
	NSArray *toolbarItems = [NSArray arrayWithObject:doneButton];
	[self.selectPlayerToolbar setItems:toolbarItems animated:YES]; 
	[doneButton release];
}

- (IBAction) showDelete {
	
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Continue Delete" 
						  message:@"Are you sure you want to delete player? All player's game data will be erased."
						  delegate:self 
						  cancelButtonTitle:@"Yes"
						  otherButtonTitles:@"Cancel", nil];
	
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex ==1) {
		[self doneEditingTable];
	}
	if (buttonIndex == 0) {
		//Continue deleting player
		// Get AppDelegate for Global Information
		BalloonChallengeAppDelegate *appDelegate = 
		(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
		
		NSString *delPlayerName = [[appDelegate.playerDatabaseObj playerNames] objectAtIndex:delIndexPath.row];

		if ([appDelegate.defaultPlayer.name compare:delPlayerName] == NSOrderedSame ) {
			if (delIndexPath.row>0) {
				appDelegate.defaultPlayer = [appDelegate.playerDatabaseObj.playerArray objectAtIndex:0];
			}
			else {
				appDelegate.defaultPlayer = [appDelegate.playerDatabaseObj.playerArray objectAtIndex:1];
			}
		}
		[appDelegate.playerDatabaseObj removePlayerWithName:delPlayerName];            
		
		// And, we have to tell the view to remove the cell
		[delTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:delIndexPath]
						 withRowAnimation:YES];
		[self doneEditingTable];
	}
}

/* Perform a table edit.  */
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	

    
    
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		delTableView = tableView;
		delIndexPath = indexPath;
		
		BalloonChallengeAppDelegate *appDelegate = 
		(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
		// Remove it from the array if more than one player
        if ( [[appDelegate.playerDatabaseObj playerNames] count] != 1 )
        {
			[self showDelete];
        }
        else
        {
            // Don't allow users to delete all players, always have atleast one.
            UIAlertView *alert = [[UIAlertView alloc] 
                                  initWithTitle:@"Cannot Delete" 
                                  message:@"You must have at least 1 player" 
                                  delegate:nil 
                                  cancelButtonTitle:@"Okay." 
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
			[self doneEditingTable];

        }
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	return [[appDelegate.playerDatabaseObj playerNames] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	NSUInteger row = [indexPath row];
	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSString *cellName = [[appDelegate.playerDatabaseObj playerNames] objectAtIndex:row];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	if ([cellName compare:appDelegate.defaultPlayer.name] == NSOrderedSame) {
		[tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone]; 
		
	}

	// Set up the cell...

	cell.textLabel.text = cellName;
	
	return cell;
}


// Find the next controller down on the nav controller stack
- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //find player object in current 
    BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	
    // Set default player to the selected one
    Player *temp = (Player* ) [appDelegate.playerDatabaseObj findPlayerWithName: [[appDelegate.playerDatabaseObj playerNames] objectAtIndex:indexPath.row]];
    
	appDelegate.defaultPlayer = temp;
	
	[self resignFirstResponder];

    [self dismissModalViewControllerAnimated:YES];  
	//[self.playerTable reloadData];
	[self.playerSelectDelegate playerSelected:temp.name];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.playerTable = nil;
	self.selectPlayerToolbar = nil;
	self.playerName = nil;
}

- (void)dealloc {
	[selectPlayerToolbar release];
	[playerTable release];
	[playerName release];
	[super dealloc];
}





@end
