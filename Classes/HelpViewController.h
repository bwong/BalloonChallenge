//
//  HelpViewController.h
//  BalloonChallenge
//
//  Created by Brian Wong on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HelpViewController : UIViewController {
    UIButton *mainMenuButton;
}

@property (nonatomic, retain) IBOutlet UIButton *mainMenuButton;

- (IBAction) mainMenuButtonPressed: (id) sender;

@end
