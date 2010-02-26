//
//  BalloonFactory.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 2/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Balloon.h"


@interface BalloonFactory : NSObject {
	
}

+ (Balloon *) createRandomBalloon;

@end
