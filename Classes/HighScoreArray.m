//
//  HighScoreArray.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 3/21/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "HighScoreArray.h"


@implementation HighScoreArray
@synthesize highScores;

- (id) init {
	if (self = [super init]) {
		highScores = [[NSMutableArray alloc] init];
	}
	return self;
}

- (id) initWithCoder: (NSCoder *) decoder {
    if ( self = [super init]) {
        self.highScores = [decoder decodeObjectForKey:@"highScores"];
    }
    return self;
}
- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject: highScores forKey:@"highScores"];    
}

/* Add a quote with the specified data to the quote database.  */
- (void) addScore:(int) newScore
		 withName:(NSString*) newName {
	HighScore *tscore = [[HighScore alloc] initWithName:newName andScore:newScore];
	[self.highScores addObject:tscore];
	[tscore release];
	
	/* We choose to maintain the list in sorted order (as opposed to
	 sorting it on demand for print operations).  So, we have to 
	 sort after every addition.  */
	[self.highScores sortUsingSelector:@selector(compareByScore:)];
	if ([self.highScores count]>kNumHighScores)
		[self removeLowestScore];
}

- (void) addScore:(HighScore *)newScore {
	[self.highScores addObject:newScore];
	
	/* We choose to maintain the list in sorted order (as opposed to
	 sorting it on demand for print operations).  So, we have to 
	 sort after every addition.  */
	[self.highScores sortUsingSelector:@selector(compareByScore:)];
	if ([self.highScores count]>kNumHighScores)
		[self removeLowestScore];

}

// We are keeping the array ordered, so just look at the last element
- (BOOL) isHighScore: (int) newScore {
	if ([self.highScores count]<kNumHighScores)
		return YES;
	if ([[self.highScores lastObject] score] > newScore) {
		return NO;
	}
	return YES;
}
- (int) numPlayers {
	return [self.highScores count];
}
// The last object will always be the lowest score cause we insert sorted
- (void) removeLowestScore {
	[self.highScores removeLastObject];
}

@end
