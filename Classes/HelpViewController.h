//
//  HelpViewController.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 4/23/10.
//  Copyright 2010 klivin.com. All rights reserved.
//


@class PageViewController;

@interface HelpViewController : UIViewController {
    // Button to take us back to Main Menu
    UIButton *mainMenuButton;
	
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIPageControl *pageControl;
	PageViewController *currentPage;
	PageViewController *nextPage;

}

@property (nonatomic, retain) IBOutlet UIButton *mainMenuButton;

// User pressed main menu button 
- (IBAction) mainMenuButtonPressed: (id) sender;
- (IBAction)changePage:(id)sender;

- (void)applyNewIndex:(NSInteger)newIndex pageController:(PageViewController *)pageController;


@end
