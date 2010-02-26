//
//  Player.m
//  BalloonChallenge
//
//  Created by Brian Wong on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Player.h"


@implementation Player

@synthesize name;
@synthesize difficulty;
@synthesize level;
@synthesize highscore;


// Player encoder needed because we're are storing PlayerDatabase
// which is made up of Players
- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject: name forKey:@"name"];
    [encoder encodeInt: difficulty forKey:@"difficulty"];  
    [encoder encodeInt:level forKey:@"level"];  
    [encoder encodeInt:highscore forKey:@"highscore"];  
}

// Player decoder needed because we're are storing PlayerDatabase
// which is made up of Players
- (id) initWithCoder: (NSCoder *) decoder {
    if ( self = [super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
        difficulty = [decoder decodeIntForKey:@"difficulty"];
        level   = [decoder decodeIntForKey:@"level"];
        highscore = [decoder decodeIntForKey:@"highscore"];
    }
    return self;
}

/* Create a new quote with the specified data.  */
- (id) initWithName: (NSString *) newName 
      andDifficulty: (int) newDifficulty
           andLevel: (int) newLevel
       andHighscore: (int) newHighscore {
	if (self = [super init]) {
		self.name = newName;
		difficulty = newDifficulty;
		level = newLevel;
        highscore = newHighscore;
	}
	return self;
	
}

// TBA - Comparison of Player Objects

- (void) dealloc {
	[name release];
	[super dealloc];
}

@end
