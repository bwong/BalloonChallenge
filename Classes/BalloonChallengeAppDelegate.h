//
//  BalloonChallengeAppDelegate.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 2/6/10.
//  Copyright klivin.com 2010. All rights reserved.
//



#import "PlayerDatabase.h"
#import "HighScoreArray.h"
#import "Player.h"
#import "GameState.h"
#import "AudioToolbox/AudioServices.h"
#import "AVFoundation/AVAudioPlayer.h"

@class BalloonChallengeViewController;

#define hsFilename @"filebak"

typedef enum {
	e_Pop1,
	e_Pop2
} BalloonSoundEnum;

typedef enum {
	e_music1,
	e_music2,
	e_gemdroids
} BalloonMusicEnum;

typedef enum {
	e_Iphone,
	e_Ipad
} CompileType;

@interface BalloonChallengeAppDelegate : NSObject 
<UIApplicationDelegate, UIAlertViewDelegate, AVAudioPlayerDelegate> {
    UIWindow *window;
    BalloonChallengeViewController *viewController;
    
    // Global variables to hold player information
    
    // Default/Current Player
    Player *defaultPlayer;
    
    // High Score Array
    HighScoreArray *highScoreArray;
    
    // Database Objects that hold a list of players
    PlayerDatabase *playerDatabaseObj;
	
	GameState *gameState;
	
	SystemSoundID popSound1;
	SystemSoundID popSound2;
	
	AVAudioPlayer *currentPlayer;
	AVAudioPlayer *player1;
	AVAudioPlayer *player2;
	AVAudioPlayer *player3;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BalloonChallengeViewController *viewController;
@property (nonatomic, retain) Player *defaultPlayer;
@property (nonatomic, retain) HighScoreArray *highScoreArray;
@property (nonatomic, retain) PlayerDatabase *playerDatabaseObj;
@property (nonatomic, retain) GameState *gameState;
@property (nonatomic, assign) AVAudioPlayer *currentPlayer;
@property (nonatomic, retain) AVAudioPlayer *player1;
@property (nonatomic, retain) AVAudioPlayer *player2;
@property (nonatomic, retain) AVAudioPlayer *player3;

- (void) playPopSound: (BalloonSoundEnum) soundID;
- (void) loadSounds;
- (void) loadMusic;
- (void) playMusic;
- (void) pauseMusic;
- (void) stopMusic;

- (void) setMusicPlayer : (BalloonMusicEnum) musicId;

+ (AVAudioPlayer *)audioPlayerWithContentsOfFile:(NSString *)path;
- (void) saveAppData;


@end

