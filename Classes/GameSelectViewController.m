//
//  GameSelectViewController.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 4/24/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "GameSelectViewController.h"
#import "ChallengeFactory.h"
#import "GroupFactory.h"
#import "PracticeSelectViewController.h"

@implementation GameSelectViewController

@synthesize gameViewController;
@synthesize gameSelectTable;
@synthesize tableHolderView;
@synthesize gameStartHolderView;
@synthesize gameLabel;
@synthesize toolBar;
@synthesize continueLabel;
@synthesize highestLevel;
@synthesize practiceSelectViewController;

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

	[self.toolBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];	

	[self.gameStartHolderView addSubview:continueLabel];
	self.continueLabel.frame = gameStartHolderView.bounds;

	
	ChallengeGroup* g = [[GroupFactory games] objectAtIndex:1];
	self.gameLabel.text = g.name;
}

// User pressed play button put up game view
-(IBAction) practiceButtonPressed: (id) sender {
	[self presentModalViewController:practiceSelectViewController animated:YES];
}


- (void) viewWillAppear:(BOOL)animated {
	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	highestLevel = [appDelegate.defaultPlayer.currentStats.highestLevel valueForKey:gameLabel.text];
	
	if ( [highestLevel compare:[Level levelWithGame:1 withProgression:0 withChallenge:0]] == NSOrderedSame ) {
		self.continueLabel.text = @"Start New Game!";
	} else {
		self.continueLabel.text = @"Continue Game!";
	}

	[self.gameSelectTable reloadData];
	//[self displayViews];

	[super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation
										  duration:(NSTimeInterval) duration {
	[self setupButtons];
	
}

- (void) setupButtons {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		if(self.interfaceOrientation == UIInterfaceOrientationPortrait || 
		   self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			self.gameStartHolderView.frame = CGRectMake(173, 49, 397, 180);
			self.tableHolderView.frame = CGRectMake(107, 250, 534, 742);
		
		} else {
			self.gameStartHolderView.frame = CGRectMake(292, 44, 397, 151);
			self.tableHolderView.frame = CGRectMake(224, 185, 534, 550);
		}
	}
}

-(void) gameSelected: (NSObject *) obj {
	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];

	if ( [obj isMemberOfClass:[Level class]]){
		appDelegate.defaultPlayer.level = (Level*)obj;
	} 

	[self presentModalViewController:gameViewController animated:NO];
	//[self dismissModalViewControllerAnimated:NO];
}

- (void) mainMenuButtonPressed: (id) sender {
    // Go back to Main Menu
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction) continueViewClick {

	[self gameSelected:highestLevel];
	//[self popBalloonAnimation:0];
}

- (void) popBalloonAnimation: (int) from {
	self.gameStartHolderView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.0f, 0.0f);
	self.tableHolderView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.0f, 0.0f);

	CGAffineTransform balloonBig = CGAffineTransformScale(CGAffineTransformIdentity, 1.3f, 1.1f);
	if (from == 0)  {
		[UIView beginAnimations:@"grow" context:gameStartHolderView];
		self.gameStartHolderView.transform = balloonBig;
		[UIView setAnimationDidStopSelector:@selector(popEnded:finished:context:)];
	}
	else {
		[UIView beginAnimations:@"grow" context:tableHolderView];
		self.tableHolderView.transform = balloonBig;
		[UIView setAnimationDidStopSelector:@selector(popEnded:finished:context:)];
	}
	[UIView setAnimationRepeatCount:1];
	[UIView setAnimationDuration:0.2f];
	[UIView setAnimationDelegate:self];

	[UIView commitAnimations];
}

- (void) popEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	if ([finished boolValue]) {
		((UIView*) context).transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.0f, 0.0f);
		CGAffineTransform normal = CGAffineTransformScale(CGAffineTransformIdentity, .01f, .01f);

		[UIView beginAnimations:@"shrink" context:context];
		[UIView setAnimationRepeatCount:1];
		[UIView setAnimationDuration:0.2f];
		[UIView setAnimationDelegate:self];
		((UIView*) context).transform = normal;
		[UIView setAnimationDidStopSelector:@selector(popEnded2:finished:context:)];
		
		[UIView commitAnimations];	
		BalloonChallengeAppDelegate *appDelegate = 
		(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
		[appDelegate playPopSound:e_Pop1];
	}
}
- (void) popEnded2:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	Level *level;
	if ( context == gameStartHolderView)
		level = highestLevel;
	else
		level = appDelegate.defaultPlayer.level;
	
	[self gameSelected:level];
}

- (void) viewDidAppear:(BOOL)animated {
	[gameSelectTable flashScrollIndicators];
}

- (void) displayViews {
	CGAffineTransform offScreen = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.0f, 0.0f-tableHolderView.frame.size.height);
	CGAffineTransform onScreen = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.0f, 0.0f);
	CGAffineTransform offScreen1 = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.0f, 0.0f-gameStartHolderView.frame.size.height);
	CGAffineTransform onScreen1 = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.0f, 0.0f);
	
	tableHolderView.transform = offScreen;
	gameStartHolderView.transform = offScreen1;
	
	[UIView beginAnimations:@"move" context:self];
	[UIView setAnimationDuration:.6f];
	[UIView setAnimationDelegate:self];
	//[UIView setAnimationDidStopSelector:@selector(wobbleView:finished:context:)];
	gameStartHolderView.transform = onScreen1;
	tableHolderView.transform = onScreen;
	
	[UIView commitAnimations];
}

- (void) wobbleView:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {	
	CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-3.0));
	CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(3.0));
	CGAffineTransform start = CGAffineTransformRotate(CGAffineTransformIdentity, 0);
	gameStartHolderView.transform = start;  // starting point

	gameStartHolderView.transform = leftWobble;  // starting point
	
	[UIView beginAnimations:@"wobble" context:self];
	[UIView setAnimationRepeatAutoreverses:YES]; // important
	//wobble indefinitely
	[UIView setAnimationRepeatCount:10000000];
	[UIView setAnimationDuration:0.9];
	gameStartHolderView.transform = rightWobble; // end here & auto-reverse
	[UIView commitAnimations];
	
}
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	self.gameViewController = nil;
	self.gameSelectTable = nil;
	self.tableHolderView = nil;
	self.gameStartHolderView = nil;
	self.gameLabel = nil;
	self.toolBar = nil;
	self.continueLabel = nil;
	self.highestLevel = nil;
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[GroupFactory mathgroups] count];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    return 32;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
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
	ChallengeGroup* g = [[GroupFactory mathgroups] objectAtIndex:section];
	headerLabel.text = g.name;

	[customView addSubview:headerLabel];
	[headerLabel release];
	return customView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	ChallengeGroup* g = [[GroupFactory mathgroups] objectAtIndex:section];
	return g.name;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	ChallengeGroup* g = [[GroupFactory mathgroups] objectAtIndex:section];
	return [g.subgroups count];
	
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
	NSUInteger row = [indexPath row];

	Level *level = [Level levelWithGame:1 withProgression:indexPath.section withChallenge:row];

	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	Level *highLevel = [appDelegate.defaultPlayer.currentStats.highestLevel valueForKey:[level getGameName]];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		cell.textLabel.font = [UIFont fontWithName:@"Marker Felt" size:22.0];
	} else {
		cell.textLabel.font = [UIFont fontWithName:@"Marker Felt" size:14.0];
	}
	if ([level compare:highLevel] == NSOrderedAscending) {
		cell.userInteractionEnabled = NO;
		cell.textLabel.textColor = [UIColor darkGrayColor];

	} else {
		cell.userInteractionEnabled = YES;
		cell.textLabel.textColor = [UIColor blackColor];
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

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
	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	appDelegate.defaultPlayer.level = [Level levelWithGame:1 withProgression:indexPath.section withChallenge:row];
	

	[self gameSelected:appDelegate.defaultPlayer.level];
	//[self popBalloonAnimation:1];
}

- (void)dealloc {
	[gameViewController release];
	[practiceSelectViewController release];
	[gameStartHolderView release];
	[gameSelectTable release];
	[tableHolderView release];
	[gameLabel release];
	[toolBar release];
	[continueLabel release];
	[highestLevel release];
    [super dealloc];
}


@end
