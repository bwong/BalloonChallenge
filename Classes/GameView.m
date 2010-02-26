//
//  GameView.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 2/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameView.h"


@implementation GameView
@synthesize backgroundImg,drawImage;
- (id) initWithCoder:(NSCoder *)aDecoder{
	if (self = [super initWithCoder:aDecoder]) {
		self.drawImage = [UIImage imageNamed:@"game_bg.png"];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
	}
    return self;
}


- (void)drawRect:(CGRect)rect {
	//gets the current context you are drawing into
//	CGContextRef context = UIGraphicsGetCurrentContext();
	//[self.drawImage drawAtPoint:CGPointMake(0, 0)];
	//[self.b.x =  drawAtPoint:self.b.currentPoint];

//	//drawing rectangle
//	CGContextAddRect(context,CGRectMake(0, 0, 50, 50));
//	CGContextAddEllipseInRect(context, CGRectMake(50, 50, 100, 120));
//	CGContextSetRGBStrokeColor(context, .5, 0, 0, 1);
//	// this line actually draws the path
//	CGContextDrawPath(context, kCGPathStroke);
}


- (void)dealloc {
	[backgroundImg release];
    [super dealloc];
}


@end
