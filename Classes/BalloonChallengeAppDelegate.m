//
//  BalloonChallengeAppDelegate.m
//  BalloonChallenge
//
//  Created by Brian Wong on 2/6/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "BalloonChallengeAppDelegate.h"
#import "BalloonChallengeViewController.h"

@implementation BalloonChallengeAppDelegate

@synthesize window;
@synthesize viewController;

@synthesize defaultPlayer;
@synthesize playerDatabaseObj;
@synthesize playerDatabaseArray;

/* START BRIAN'S CODE */
// Generates a file name for "quotes.plist" in the user's Document directory.
- (NSString *) dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                         NSUserDomainMask, 
                                                         YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:hsFilename];
}
/* END BRIAN'S CODE */

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
       
    [window addSubview:viewController.view];
    
    /* START BRIAN'S CODE */
    NSString *filePath = [self dataFilePath];
    
    if ( [[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        // The "highscores.plist" file exists lets load it with
        // the stored data.
        NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[self dataFilePath]];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        // Game Information that was Archived
        
        // Get the default player information
        self.defaultPlayer = [unarchiver decodeObjectForKey:@"defaultPlayer"];
        
        // Get the database object that was archived
        self.playerDatabaseObj = [unarchiver decodeObjectForKey:@"playerDBObj"];
        
        // Get the array from the players that was archived
        self.playerDatabaseArray = [unarchiver decodeObjectForKey:@"playerDatabaseArray"];
        
        [unarchiver finishDecoding];
        [unarchiver release];
        [data release];
    }
    else
    {
        PlayerDatabase *myPlayerDB = [[PlayerDatabase alloc] init];
        
        [myPlayerDB addPlayer:@"Player 1" withDifficultySettingAt:2 andLevelSettingAt:10 andHighscoreOf:500];
        [myPlayerDB addPlayer:@"Player 2" withDifficultySettingAt:1 andLevelSettingAt:5 andHighscoreOf:400];
        [myPlayerDB addPlayer:@"Player 3" withDifficultySettingAt:1 andLevelSettingAt:4 andHighscoreOf:300];
        [myPlayerDB addPlayer:@"Player 4" withDifficultySettingAt:1 andLevelSettingAt:3 andHighscoreOf:200];
        [myPlayerDB addPlayer:@"Player 5" withDifficultySettingAt:0 andLevelSettingAt:1 andHighscoreOf:100];

        playerDatabaseObj = myPlayerDB;
        playerDatabaseArray = [myPlayerDB playerArray];
    }
    
    /* END BRIAN'S CODE */
    
    [window makeKeyAndVisible];
}

/* START BRIAN'S CODE */
- (void)applicationWillTerminate:(UIApplication *)application {
	// Save quote data
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    // Save Default Player
    [archiver encodeObject:defaultPlayer forKey:@"defaultPlayer"];
    // Save DB Object
    [archiver encodeObject:playerDatabaseObj forKey:@"playerDBObj"];
    // Save Array
    [archiver encodeObject:playerDatabaseArray forKey:@"playerDatabaseArray"];
    
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
    [archiver release];
    [data release];
}
/* END BRIAN'S CODE */


- (void)dealloc {
    [defaultPlayer release];
    [playerDatabaseObj release];
    [playerDatabaseArray release];
    [viewController release];
    [window release];
    [super dealloc];
}


@end
