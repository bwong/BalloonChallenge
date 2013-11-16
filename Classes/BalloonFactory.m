//
//  BalloonFactory.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 2/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BalloonFactory.h"


@implementation BalloonFactory

+ (BalloonColor) randomBalloonPicker {
	BalloonColor bc = random()%kColorTotal;
	return bc;
}

+ (int) balloonHeight {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return random()%20+125;
	} else {
		return random()%20+90;
	}
}

+ (int) balloonWidth {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return random()%20+105;
	} else {
		return random()%20+72;
	}
}

+ (NSString *) getRandomBalloonName {
	BalloonColor bc = [BalloonFactory randomBalloonPicker];
	switch (bc) {
		case kColorRed:
			return @"balloon_red.png";
		case kColorBlue:
			return @"balloon_blue.png";
		case kColorYellow:
			return @"balloon_yellow.png";
		case kColorGreen:
			return @"balloon_green.png";
        default:
            break;
	}
	return nil;
}
+ (id) createBalloonWithColor: (BalloonColor) color
					 andText: (NSString*) newText
					  inFrame: (CGRect) parentFrame
					withScore: (int) vscore {
	NSString *imageName = [NSString string];
	switch (color) {
		case kColorRed:
			imageName = @"balloon_red.png";
			break;
		case kColorBlue:
			imageName =  @"balloon_blue.png";
			break;
		case kColorYellow:
			imageName = @"balloon_yellow.png";
			break;
		case kColorGreen:
			imageName = @"balloon_green.png";
			break;
        default:
            break;
	}
	Balloon *b = [[Balloon alloc] init];
	b.bounds = CGRectMake(0, 0, [BalloonFactory balloonWidth], [BalloonFactory balloonHeight]);
	


	int xwidthPossible = parentFrame.size.width - b.bounds.size.width;
	b.currentPoint = CGPointMake(((random() % xwidthPossible) + b.bounds.size.width/2), 
								 (parentFrame.size.height+b.bounds.size.height));
	[b setX:0
   velocity:0
	   text:newText
	  image:[UIImage imageNamed:imageName]
	  score:vscore];
	b.label.hidden = YES;
	return b;
}

//Caller is responsible for releasing
+ (id) createBalloonWithText: (NSString *) newText
					 inFrame: (CGRect) parentFrame
				   withScore: (int) vscore {
	Balloon *b = [[Balloon alloc] init];
	b.bounds = CGRectMake(0, 0, [BalloonFactory balloonWidth], [BalloonFactory balloonHeight]);
	int xwidthPossible = parentFrame.size.width - b.bounds.size.width;
	b.currentPoint = CGPointMake(((random() % xwidthPossible) + b.bounds.size.width/2), 
								 (parentFrame.size.height+b.bounds.size.height));
	[b setX:0
   velocity:0
	   text:newText
	  image:[UIImage imageNamed:[self getRandomBalloonName]]
	  score:vscore];
	return b;
}

//+ (Balloon *) createRandomBalloon {
//	Balloon *b = [[Balloon alloc] init];
//	b.bounds = CGRectMake(0, 0, [BalloonFactory balloonWidth], [BalloonFactory balloonHeight]);
//	int xwidthPossible = [BalloonFactory getScreenWidth] - b.bounds.size.width;
//	[b setX:((random() % xwidthPossible) + b.bounds.size.width/2)
//   velocity:0
//	   text:@""
//	  image:[UIImage imageNamed:[self getRandomBalloonName]]];
//	return b;
//}
@end
