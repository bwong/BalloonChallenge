//
//  HighScoresViewController.m
//  BalloonChallenge
//
//  Created by Brian Wong on 2/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HighScoresViewController.h"


@implementation HighScoresViewController

@synthesize playerNameList;
@synthesize playerTableView;
@synthesize mainMenuButton;


// Go Back to Main Window
- (IBAction) mainMenuButtonPressed: (id) sender {
    [self dismissModalViewControllerAnimated:YES];
}
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

    
    //self.title = @"Authors";
    
    BalloonChallengeAppDelegate *appDelegate = 
        (BalloonChallengeAppDelegate *)[[UIApplication sharedApplication] delegate];

    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (Player *player in appDelegate.playerDatabaseObj.playerArray)
    {
        NSString *temp = player.name;
        if ( ![array containsObject:temp] )
        {
            [array addObject:temp];
        }
    }
    
    self.playerNameList = array;
    [playerTableView reloadData];
    [array release];
    //[super viewWillAppear:animated];
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

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [playerNameList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
    NSUInteger row = [indexPath row];
    
    BalloonChallengeAppDelegate *appDelegate = 
    (BalloonChallengeAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    Player *cellPlayer = [appDelegate.playerDatabaseObj.playerArray objectAtIndex:row];
    cell.textLabel.text = cellPlayer.name;
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%d", cellPlayer.highscore];
    
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //ADD SOMETHING TO DO WHEN SELECTING ROW
}


- (void)dealloc {
    [playerNameList release];
    [playerTableView release];
    [mainMenuButton release];
    [super dealloc];
}


@end



