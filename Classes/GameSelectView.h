//
//  GameSelectView.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 4/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GameSelectViewDelegate;

@interface GameSelectView : UIImageView {
	id gameSelectDelegate;
	UIView *continueView;
	UIImageView *startOverView;
}

@property (retain) id gameSelectDelegate;


@property (retain,nonatomic) IBOutlet UIView *continueView;
//@property (retain,nonatomic) IBOutlet UILabel *label;
@property (retain,nonatomic) IBOutlet UIImageView *startOverView;

- (IBAction) continueViewClick;
- (void) wobbleView;

@end

@protocol GameSelectViewDelegate
@required
-(void) gameSelected: (NSNumber *) level;


@end
