//
//  BalloonChallengeAppDelegate.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 3/6/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "BalloonChallengeAppDelegate.h"
#import "BalloonChallengeViewController.h"
#import "GameViewController.h"

@implementation BalloonChallengeAppDelegate

static NSString *linkToBalloonPop = @"http://bit.ly/ab9AV9";

@synthesize window;
@synthesize viewController;
@synthesize defaultPlayer;
@synthesize highScoreArray;
@synthesize gameState;
@synthesize playerDatabaseObj;
@synthesize currentPlayer;
@synthesize player1;
@synthesize player2;
@synthesize player3;

// Generates a file name for "quotes.plist" in the user's Document directory.
- (NSString *) dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                         NSUserDomainMask, 
                                                         YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:hsFilename];
}

- (void) createDefaultHighScoreList {
	// Setup default values for highscore list and current player
	playerDatabaseObj = [[PlayerDatabase alloc] init];
	highScoreArray = [[HighScoreArray alloc] init];
	
	[highScoreArray addScore:1000 withName:@"Ace"];
	[highScoreArray addScore:600 withName:@"Boomer"];
	[highScoreArray addScore:500 withName:@"Wiz Kid"];
	[highScoreArray addScore:300 withName:@"Sum Fun"];
	[highScoreArray addScore:50 withName:@"Mathy"];

}

- (CompileType) setOsType {
	OSType type = e_Iphone;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		type = e_Ipad;	
	}
	return type;
}


- (void) loadSounds {
	NSBundle *localDirs = [NSBundle mainBundle];

	NSString *path = [localDirs pathForResource:@"balloon" ofType:@"caf"];
	NSString *path1 = [localDirs pathForResource:@"balloon1" ofType:@"caf"];

	AudioServicesCreateSystemSoundID((CFURLRef) [NSURL fileURLWithPath:path], &popSound1);
	AudioServicesCreateSystemSoundID((CFURLRef) [NSURL fileURLWithPath:path1], &popSound2);
}
	

- (void) playPopSound: (BalloonSoundEnum) soundID {
	if (gameState.isMuted==YES)
		return;
	
	switch (soundID) {
		case e_Pop1:
			AudioServicesPlaySystemSound(popSound1);
			break;
		case e_Pop2:
			AudioServicesPlaySystemSound(popSound2);
			break;
		default:
			break;
	}
}

- (void) loadMusic {
	NSString *path1 = [[NSBundle mainBundle] pathForResource:@"three-drops" ofType:@"caf"];
	NSString *path2 = [[NSBundle mainBundle] pathForResource:@"gardens" ofType:@"caf"];
	NSString *path3 = [[NSBundle mainBundle] pathForResource:@"gemdroids" ofType:@"caf"];

	self.player1 = [BalloonChallengeAppDelegate audioPlayerWithContentsOfFile:path1];
	self.player2 = [BalloonChallengeAppDelegate audioPlayerWithContentsOfFile:path2];
	self.player3 = [BalloonChallengeAppDelegate audioPlayerWithContentsOfFile:path3];
	[self.player1 setDelegate:self];
	[self.player2 setDelegate:self];
	[self.player3 setDelegate:self];
	[self setMusicPlayer:e_music1];
}

- (void) playMusic {
	if (self.gameState.isMuted == NO) {
		[self.currentPlayer play];
		currentPlayer.numberOfLoops = -1; 
	}
}

- (void) pauseMusic {
	if (self.gameState.isMuted == NO) {
		if ([self.currentPlayer isPlaying])  
			[self.currentPlayer pause];
	}
}
- (void) stopMusic {
	if (self.gameState.isMuted == NO) {
		if ([self.currentPlayer isPlaying])
			[self.currentPlayer stop];
	}
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [player release];
	player = nil;
}

- (void) setMusicPlayer : (BalloonMusicEnum) musicId {
	switch (musicId) {
		case e_music1:
			self.currentPlayer = self.player1;
			self.currentPlayer.volume = 1.0f;
			break;
		case e_music2:
			self.currentPlayer = self.player2;
			self.currentPlayer.volume = 1.0f;
			break;
		case e_gemdroids:
			self.currentPlayer = self.player3;
			self.currentPlayer.volume = .5f;
			break;

		default:
			break;
	}
	if (self.gameState.isMuted == NO) {
		[self.currentPlayer prepareToPlay];
	}
}

+ (AVAudioPlayer *)audioPlayerWithContentsOfFile:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path];
    AVAudioPlayer *player = [AVAudioPlayer alloc];
    if([player initWithData:data error:Nil]) {
        [player autorelease];
    } else {
        [player release];
        player = nil;
    }
    return player;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if (buttonIndex == 1) {
		NSURL *url = [NSURL URLWithString:linkToBalloonPop];
		[[UIApplication sharedApplication] openURL:url];
		[defaults setBool:YES forKey:@"askedForRating"];
	} else {
		//ask again in 10 days
		[defaults setObject:[NSDate date] forKey:@"firstRun"];
	}
}
-(void) askForRating {
	if (linkToBalloonPop!=nil && ![linkToBalloonPop isEqualToString:@""]) {
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Like This App?"
															message:@"Please rate it in the App Store!"
														   delegate:self
												  cancelButtonTitle:@"No Thanks" 
												  otherButtonTitles:@"Rate It!", nil];
		[alertView show];
		[alertView release];
	}
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	//comment out for debugging
	srandom(time(NULL));

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSString *filePath = [self dataFilePath];

	if (! [defaults objectForKey:@"firstRun"]) {
		[defaults setObject:[NSDate date] forKey:@"firstRun"];
	
		//If this is the first run, just delete the player info, and start fresh.
	    if ( [[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
			[[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
		}
	}
    
    // if already have a plist file
    if ( [[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        // The "db" file exists lets load it with
        // the stored data.
        NSData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        // Game Information that was Archived
        
        // Get the default player information
        self.defaultPlayer = [unarchiver decodeObjectForKey:@"defaultPlayer"];
        
        // Get the database object that was archived
        self.playerDatabaseObj = [unarchiver decodeObjectForKey:@"playerDBObj"];
        
        // Get the array from the players that was archived (high score list)
        self.highScoreArray = [unarchiver decodeObjectForKey:@"highScoreArray"];
        
		// Get the array from the players that was archived (high score list)
        self.gameState = [unarchiver decodeObjectForKey:@"gameState"];
		
        [unarchiver finishDecoding];
        [unarchiver release];
        [data release];
    }
    else
    {
		[self createDefaultHighScoreList];
		gameState = [[GameState alloc] initWithNoSound:NO andTimePerChallenge:45];
		
    }
	
	[application setStatusBarHidden:YES];
	[window addSubview:viewController.view];
    [window makeKeyAndVisible];
	return YES;

}
- (void)applicationDidBecomeActive:(UIApplication *)application {
	[self loadMusic];
	[self loadSounds];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	NSInteger daysSinceInstall = [[NSDate date] timeIntervalSinceDate:[defaults objectForKey:@"firstRun"]] / 86400;
	if (daysSinceInstall >= 9 && [defaults boolForKey:@"askedForRating"] == NO) {
		[self askForRating];
	}
	if (!self.gameState.isMuted) {
	   //load music and sound
	   [self playMusic];
   }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	[self saveAppData];
}
- (void)applicationWillTerminate:(UIApplication *)application {
	[self saveAppData];
}

- (void)saveAppData {
	[self stopMusic];
	// Save game information
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
   
	//dispose of sounds
	AudioServicesDisposeSystemSoundID(popSound1);
    AudioServicesDisposeSystemSoundID(popSound2);
	 
    // Save Default Player
    [archiver encodeObject:defaultPlayer forKey:@"defaultPlayer"];
    // Save DB Object
    [archiver encodeObject:playerDatabaseObj forKey:@"playerDBObj"];
    // Save Array
    [archiver encodeObject:highScoreArray forKey:@"highScoreArray"];
	[archiver encodeObject:gameState forKey:@"gameState"];

    
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
    [archiver release];
    [data release];
}

- (void)dealloc {
    [window release];
    [viewController release];
    [defaultPlayer release];
	[highScoreArray release];
    [playerDatabaseObj release];
	[gameState release];
	[player1 release];
	[player2 release];
	[player3 release];
    [super dealloc];
	
}


@end
