//
//  BalloonFactory.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 2/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BalloonFactory.h"

static int ballcount = 0;

@implementation BalloonFactory

+ (Balloon *) createRandomBalloon {
	ballcount += 1;
	Balloon *b = [[Balloon alloc] init];
	[b setX:((117*ballcount) % 320)
   velocity:(((3*ballcount) % 7) +1) 
	   text:[NSString stringWithFormat:@"%d",ballcount] 
	  image:[UIImage imageNamed:@"blue_balloon.png"]];
	return b;
}
@end
