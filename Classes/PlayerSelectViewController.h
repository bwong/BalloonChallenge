//
//  PlayerSelectViewController.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 6/19/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PlayerSelectViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
    UIToolbar *selectPlayerToolbar;
    UITableView *playerTable;
	id playerSelectDelegate;
	//The following are pointers to objects for deleting from select player table
//	NSString *delPlayerName;
	UITableView *delTableView;
	NSIndexPath *delIndexPath;
}

@property (nonatomic, retain) IBOutlet UIToolbar *selectPlayerToolbar;
@property (nonatomic, retain) IBOutlet UITableView *playerTable;
@property (nonatomic, retain) IBOutlet UITextField *playerName;
@property (assign) id playerSelectDelegate;


- (IBAction) doneAdding;
- (IBAction)backgroundTap:(id)sender;
-(IBAction) toggleEditing:(id)sender;
- (void) doneEditingTable;

@end

@protocol PlayerSelectDelegate

@required
- (void) playerSelected: (NSString*) name;


@end