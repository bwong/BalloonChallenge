//
//  HighScore.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 3/21/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HighScore : NSObject <NSCoding> {
	NSString *name;
	NSInteger score;
}

@property (nonatomic,retain) NSString *name;
@property (nonatomic) NSInteger score;

- (id) initWithName: (NSString *) newName
		   andScore: (int) newScore;
- (NSComparisonResult) compareByScore: (HighScore *) otherScore;

@end
