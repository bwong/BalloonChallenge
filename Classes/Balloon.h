//
//  Balloon.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Balloon : UIImageView {
	CGPoint currentPoint;
	CGPoint previousPoint;
	CGFloat yVelocity;
	UILabel *label;

}

@property CGPoint currentPoint;
@property CGPoint previousPoint;
@property CGFloat yVelocity;
@property (nonatomic,retain) IBOutlet UILabel *label;

- (void) move;


- (void) setX:(CGFloat) xinit 
   velocity:(CGFloat) vel 
	   text:(NSString*) thetext
	  image:(UIImage*) img;

@end
