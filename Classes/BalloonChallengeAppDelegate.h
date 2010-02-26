//
//  BalloonChallengeAppDelegate.h
//  BalloonChallenge
//
//  Created by Brian Wong on 2/6/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BalloonChallengeViewController;

#import "PlayerDatabase.h"
#import "Player.h"

#define hsFilename @"highscores.plist"

@interface BalloonChallengeAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    BalloonChallengeViewController *viewController;
    
    Player *defaultPlayer;
    PlayerDatabase *playerDatabaseObj;
    NSMutableArray *playerDatabaseArray;
}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BalloonChallengeViewController *viewController;

@property (nonatomic, retain) Player *defaultPlayer;
@property (nonatomic, retain) PlayerDatabase *playerDatabaseObj;
@property (nonatomic, retain) NSMutableArray *playerDatabaseArray;

@end

