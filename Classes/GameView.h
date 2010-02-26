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
	UIImageView *backgroundImg;
	UIImage *drawImage;
}
@property (nonatomic,retain) IBOutlet UIImageView *backgroundImg;
@property (nonatomic,retain) IBOutlet UIImage *drawImage;
@end
