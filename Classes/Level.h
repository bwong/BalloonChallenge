//
//  Level.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 5/17/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#define gameMask 0xF00
#define progressionMask 0x0F0
#define challengeMask 0x00F

@interface Level : NSObject <NSCopying, NSCoding> {
	int game;
	int progression;
	int challenge;
}

@property (nonatomic) int game;
@property (nonatomic) int progression;
@property (nonatomic) int challenge;

+ (id) levelWithGame: (int) g 
	 withProgression: (int) p 
	   withChallenge: (int) c;

- (void) incrementLevel;
- (void) decrementLevel;
- (NSString *) getChallengeName;
- (NSString *) getGameName;
- (NSString *) getProgressionName;
- (NSComparisonResult) compare: (Level*) otherLevel;
-(BOOL) isLastLevel: (int) gameId;
@end
