//
//  BalloonChallengeViewController.h
//  BalloonChallenge
//
//  Created by Brian Wong on 2/6/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"
#import "HighScoresViewController.h"
#import "OptionsViewController.h"
#import "HelpViewController.h"

@interface BalloonChallengeViewController : UIViewController {
	GameViewController *gameViewController;
    
    /* START BRIAN'S CODE */
    HighScoresViewController *highScoresViewController;
    OptionsViewController *optionsViewController;
    HelpViewController *helpViewController;
    /* END BRIAN'S CODE */
}

@property (nonatomic, retain) IBOutlet GameViewController *gameViewController;

/* START BRIAN'S CODE */
@property (nonatomic, retain) IBOutlet HighScoresViewController *highScoresViewController;
@property (nonatomic, retain) IBOutlet OptionsViewController *optionsViewController;
@property (nonatomic, retain) IBOutlet HelpViewController *helpViewController;
/* END BRIAN'S CODE */

-(IBAction) gameButtonPressed: (id) sender;


/* START BRIAN'S CODE */
// User pressed highscores button put up highscores view
- (IBAction) highScoresButtonPressed: (id) sender;

// User pressed options button put up options view
- (IBAction) optionsButtonPressed: (id) sender;

// User pressed help button put up help view
- (IBAction) helpButtonPressed: (id) sender;
/* END BRIAN'S CODE */

@end

