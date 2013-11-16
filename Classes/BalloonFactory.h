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
//	int level;
}
//@property int level;
+ (id) createBalloonWithText: (NSString *) newText
					 inFrame: (CGRect) parentFrame
				   withScore: (int) score;
+ (id) createBalloonWithColor: (BalloonColor) color
					 andText: (NSString*) newText
					 inFrame: (CGRect) parentFrame
				   withScore: (int) score;

+ (int) balloonHeight;
+ (int) balloonWidth;
@end
