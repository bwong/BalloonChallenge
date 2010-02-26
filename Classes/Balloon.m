//
//  Balloon.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Balloon.h"


@implementation Balloon
@synthesize yVelocity;
@synthesize currentPoint, previousPoint;
@synthesize label;

- (id) init {
	if (self = [super init]) {
		self.label = [[UILabel alloc] initWithFrame:self.frame];
		[self addSubview:label];
		self.currentPoint = CGPointMake(160, 500);
		self.center = currentPoint;
		self.yVelocity = 2;
		self.label.text = @"0";
		self.bounds = CGRectMake(0, 0, 42, 68);
	}
	return self;
}

//- (id) initWithCoder:(NSCoder *)aDecoder{
//	if (self = [super initWithCoder:aDecoder]) {
//		self.contentMode = UIViewContentModeScaleToFill;
//		self.label = [[UILabel alloc] initWithFrame:self.frame];
//
//		[self addSubview:label];
//		[self setX:160 
//			 velocity:1.0f 
//				 text:@"0" 
//				image:[UIImage imageNamed:@"blue_balloon.png"]];
//	}
//	return self;
//}


- (void) setX:(CGFloat) xinit 
	  velocity:(CGFloat) vel 
		  text:(NSString*) thetext
		 image:(UIImage*) img {
	self.yVelocity = vel;
	self.currentPoint =CGPointMake(xinit, 480);
	self.image = img;
	self.label.text = thetext;
	self.label.frame = self.bounds;
	self.label.adjustsFontSizeToFitWidth = YES;
	self.label.backgroundColor = [UIColor clearColor];
	self.label.textAlignment = UITextAlignmentCenter;

}

- (void) move {
	self.previousPoint = currentPoint;
	self.currentPoint = CGPointMake(currentPoint.x, currentPoint.y-yVelocity);
	self.center = currentPoint;
}

@end
