//
//  Balloon.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Balloon.h"
#import "GameViewController.h"

@implementation Balloon
@synthesize yVelocity;
@synthesize currentPoint;
@synthesize label;
@synthesize isPopped, canbetouched;
@synthesize balloonDelegate;
@synthesize popSound;
@synthesize score;
@synthesize isCorrectAnswer;

- (id) init {
    self = [super init];
	if (self) {
		self.label = [[UILabel alloc] initWithFrame:self.frame];
		[self addSubview:label];
		//CGRect fr;
		//fr.origin= [[[balloonDelegate gv] frame]origin];
		// (CGRect) [balloonDelegate performSelector:@selector(getGameViewFrame)];
		self.yVelocity = 0;
		self.label.text = @"0";
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			self.label.font = [UIFont fontWithName:@"Marker Felt" size:30.0];

		} else {
			self.label.font = [UIFont fontWithName:@"Marker Felt" size:22.0];

		}
		self.score=0;
		self.isCorrectAnswer=NO;
		self.isPopped = NO;
		self.canbetouched = YES;
		[self setUserInteractionEnabled:YES];
	}
	//[self wobbleView];

	return self;
}

- (void) setX:(CGFloat) xinit 
	  velocity:(CGFloat) vel 
		 text: (NSString *) newText
		 image:(UIImage*) img 
		score: (int) vscore {
	//Upon initialization, if the balloon has positive score, it is a correct answer
	if (vscore>0) {
		self.isCorrectAnswer=YES;
	}
	self.score = vscore;
	self.yVelocity = vel;
	self.center = self.currentPoint;
	self.image = img;
	self.label.frame = self.bounds;
	self.label.text = newText;
	self.label.adjustsFontSizeToFitWidth = YES;
	self.label.backgroundColor = [UIColor clearColor];
	self.label.textAlignment = UITextAlignmentCenter;

}
- (void) touchesBegan: (NSSet *) touches 
			withEvent: (UIEvent *) event {
	[self popTimer];
}

//this will only update when the main thread loops, not immediately
- (void) popTimer {
	if (!canbetouched) {
		return;
	}
	canbetouched = NO;

	//set y velocity to 0
	self.yVelocity = 0;
	if ((self.frame.origin.y + self.frame.size.height) < 0 && score <= 0 ) {
		self.image = nil;
		self.currentPoint = CGPointMake(currentPoint.x, currentPoint.y+(self.frame.size.height)-10);
		self.center = currentPoint;
	} 
	[self popBalloonAnimation];
	
	if (self.score > 1) {
		self.label.textColor = UIColor.greenColor;
		self.label.shadowColor = UIColor.grayColor;
		[self.label setShadowOffset:CGSizeMake(1, 1)];
		self.label.text = [NSString stringWithFormat:@"+%d",score];
		popSound = e_Pop1;
	} else if (self.score < 0){
		self.label.text = [NSString stringWithFormat:@"%d",score];
		self.label.shadowColor = UIColor.grayColor;
		[self.label setShadowOffset:CGSizeMake(1, 1)];

		self.label.textColor = UIColor.redColor;
		popSound = e_Pop2;
	} else if (self.score == 1) {
		// this is for time challenge correct	
		self.label.textColor = UIColor.greenColor;
		self.label.shadowColor = UIColor.grayColor;
		[self.label setShadowOffset:CGSizeMake(1, 1)];
		self.label.text = @"Great!";
		popSound = e_Pop1;
	} else if (self.score == 0) {
		self.label.shadowColor = UIColor.grayColor;
		[self.label setShadowOffset:CGSizeMake(1, 1)];
		// this is for time challenge incorrect pop
		self.label.textColor = UIColor.redColor;
		popSound = e_Pop2;
		self.label.text = @"Woops!";
	}
}

- (void) popBalloonAnimation {
	CGAffineTransform balloonBig = CGAffineTransformScale(CGAffineTransformIdentity, 1.5f, 1.5f);
	[UIView beginAnimations:@"grow" context:self];
	[UIView setAnimationRepeatCount:1];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(popEnded:finished:context:)];
	self.transform = balloonBig;
	[UIView commitAnimations];
}

- (void) playPopSound {
	BalloonChallengeAppDelegate *appDelegate = 
	(BalloonChallengeAppDelegate*)[[UIApplication sharedApplication] delegate];
	[appDelegate playPopSound:popSound];
}

- (void) popEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	if ([finished boolValue]) {
		[self playPopSound];
		//clear the image
		self.image = nil;
		//finally, signal that I am popped, and ready to be removed by main thread
		isPopped = YES;
	}
	if(self.balloonDelegate != nil) {
		if([balloonDelegate respondsToSelector:@selector(balloonPopped:)]) {
			[balloonDelegate performSelector:@selector(balloonPopped:) withObject:self];
			[self setUserInteractionEnabled:NO];
			self.label.hidden = NO;
		}
	}
}

- (void) wobbleView {
	
	CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-7.0));
	CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(7.0));
	
	self.transform = leftWobble;  // starting point
	
	[UIView beginAnimations:@"wobble" context:self];
	[UIView setAnimationRepeatAutoreverses:YES]; // important
	//wobble indefinitely
	[UIView setAnimationRepeatCount:100000];
	[UIView setAnimationDuration:0.9];
	self.transform = rightWobble; // end here & auto-reverse
	[UIView commitAnimations];
	
}

- (void) move {
	//start wobbling on first move
//	if (self.currentPoint.y >= (460+self.bounds.size.height/2))
	
	self.currentPoint = CGPointMake(currentPoint.x, currentPoint.y-yVelocity);
	self.center = currentPoint;
}

- (void) dealloc {
	[label release];
	[super dealloc];
}

@end
