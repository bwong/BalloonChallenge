//
//  TimeChallengeSelectViewController.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 7/11/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "TimeChallengeSelectViewController.h"
#import "TimeChallengeViewController.h"
#import "GroupFactory.h"
#import "BalloonChallengeAppDelegate.h"

@implementation TimeChallengeSelectViewController
@synthesize gameSelectTable;
@synthesize timeChallengeViewController;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.gameSelectTable.backgroundColor = [UIColor clearColor];
	self.gameSelectTable.separatorColor = [[UIColor blackColor] colorWithAlphaComponent:.4f];
#ifdef __IPHONE_3_2
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		self.gameSelectTable.backgroundView = nil;
	}
#endif
}

- (void) viewWillAppear:(BOOL)animated {
	[self setupViews];
	[super viewWillAppear:animated];
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation
										  duration:(NSTimeInterval) duration {
	[self setupViews];
}

- (void) setupViews {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		if(self.interfaceOrientation == UIInterfaceOrientationPortrait || 
		   self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			self.gameSelectTable.frame = CGRectMake(78, 97, 551, 725);

		} else {
			self.gameSelectTable.frame = CGRectMake(78, 77, 551, 540);
		}
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (void) mainMenuButtonPressed: (id) sender {
    // Go back to Main Menu
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    gameSelectTable = nil;
	timeChallengeViewController = nil;
}


- (void)dealloc {
	[gameSelectTable release];
	[timeChallengeViewController release];
    [super dealloc];
}
#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView*) tableView
	heightForRowAtIndexPath:(NSIndexPath*) indexPath {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
		return 65;
	else 
		return 40;	
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[GroupFactory progressions] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.backgroundColor = [UIColor clearColor];
    //cell.
    // Set up the cell...
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    NSUInteger row = [indexPath row];
	
	switch (row) {
		case 0:
			cell.imageView.image = [UIImage imageNamed:@"BPC_icon_spectrum.png"];
			break;
		case 1:
			cell.imageView.image = [UIImage imageNamed:@"BPC_icon_oddandeven.png"];
			break;
		case 2:
			cell.imageView.image = [UIImage imageNamed:@"BPC_icon_addition.png"];
			break;
		case 3:
			cell.imageView.image = [UIImage imageNamed:@"BPC_icon_subtract.png"];
			break;
		case 4:
			cell.imageView.image = [UIImage imageNamed:@"BPC_icon_multiply.png"];
			break;
		case 5:
			cell.imageView.image = [UIImage imageNamed:@"BPC_icon_divide.png"];
			break;
		case 6:
			cell.imageView.image = [UIImage imageNamed:@"BPC_icon_multiples.png"];
			break;
		case 7:
			cell.imageView.image = [UIImage imageNamed:@"BPC_icon_factor_tree.png"];
			break;
		default:
			break;
	}

	CGSize sz1;

	cell.textLabel.frame = cell.frame;
	cell.textLabel.text = [[[GroupFactory progressions] objectAtIndex:row] name];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		cell.textLabel.font = [UIFont fontWithName:@"Marker Felt" size:36.0];
		cell.textLabel.textColor = UIColor.whiteColor;
		cell.textLabel.shadowColor = UIColor.blackColor;
		[cell.textLabel setShadowOffset:CGSizeMake(1, 1)];
		sz1 = CGSizeMake(65, 65);

	} else {
		cell.textLabel.font = [UIFont fontWithName:@"Marker Felt" size:20.0];
		cell.textLabel.textColor = UIColor.whiteColor;
		cell.textLabel.shadowColor = UIColor.blackColor;
		[cell.textLabel setShadowOffset:CGSizeMake(1, 1)];

		sz1 = CGSizeMake(40, 40);
	}	
	UIImage *i1 = [self scale:cell.imageView.image toSize:sz1];
	cell.imageView.image = i1;
    return cell;
}

- (UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

// User makes a selection on the highscore table
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
  	NSUInteger row = [indexPath row];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSString *challengeGroupName = [[[GroupFactory progressions] objectAtIndex:row] name];
	
	if ([challengeGroupName compare:@"Colors"] == NSOrderedSame)
		timeChallengeViewController.challengeType = e_Colors;
	else if ([challengeGroupName compare:@"Odds and Evens"] == NSOrderedSame)
		timeChallengeViewController.challengeType = e_OddsAndEvens;
	else if ([challengeGroupName compare:@"Addition"] == NSOrderedSame)
		timeChallengeViewController.challengeType = e_Addition;
	else if ([challengeGroupName compare:@"Subtraction" ] == NSOrderedSame)
		timeChallengeViewController.challengeType = e_Subtraction;
	else if ([challengeGroupName compare:@"Multiples" ] == NSOrderedSame)
		timeChallengeViewController.challengeType = e_Multiples;
	else if ([challengeGroupName compare:@"Factors" ] == NSOrderedSame)
		timeChallengeViewController.challengeType = e_Factors;
	else if ([challengeGroupName compare:@"Multiplication" ] == NSOrderedSame)
		timeChallengeViewController.challengeType = e_Multiplication;
	else if ([challengeGroupName compare:@"Division" ] == NSOrderedSame)
		timeChallengeViewController.challengeType = e_Division;
	else 
		timeChallengeViewController.challengeType = e_Colors;

	[self presentModalViewController:timeChallengeViewController animated:NO];
	timeChallengeViewController.challengeGroupName = challengeGroupName;
}


@end
