//
//  GameView.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 2/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Balloon.h"


@interface GameView : UIView{
	UITextView *textView;
	UIImageView *textBackground;

	id gameDelegate;
	UIImageView *backgroundImg;
}
@property (nonatomic,retain) id gameDelegate;

@property (nonatomic,retain) IBOutlet UIImageView *backgroundImg;
@property (nonatomic,retain) IBOutlet UIImageView *textBackground;
@property (nonatomic,retain) IBOutlet UITextView *textView;

@end
