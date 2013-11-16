//
//  DataSource.m
//  PagingScrollView
//
//  Created by Matt Gallagher on 24/01/09.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "DataSource.h"
#import "SynthesizeSingleton.h"

@implementation DataSource

SYNTHESIZE_SINGLETON_FOR_CLASS(DataSource);

//
// init
//
// Init method for the object.
//
- (id)init
{
	self = [super init];
	if (self != nil)
	{
		dataPages = [[NSArray alloc] initWithObjects:
			[NSDictionary dictionaryWithObjectsAndKeys:
				@"How to play:", @"pageName",
				@"For \"Learn\" Game Mode:\n"
				"1.  Touch \"Learn\" in Main Menu. From the game select menu, you can touch \"Practice\" to practice any level.\n\n"
				"2.  If this is your first time to play, touch the balloon that says \"Start New Game\" "
				"Otherwise you can continue the game at the highest level achieved.  You can also play "
				"any completed level by selecting that level.\n\n"
				"3. Instruction for playing the current level is shown on the next screen with helpful hints on how to win "
				"the level\n\n"
				"4. Pop as many balloons as you can with the right answers before time runs out!\n\n"
				"5. Once you finish a level successfully, you can go back to that level any time in the Level "
				"Select View. Your high score for that level will show in the level select screen.\n"
				"A - 90% and up\n"
				"B - 80% - 89%\n"
				"C - 70% - 79%\n"
				"X - Below 70% or Incomplete\n\n"
				"6.  Difficulty can be changed in the options page. We recommend:\n"
				"Easy - Kinder - 3rd Grade\n"
				"Normal - 4th - 6th Grade\n"
				"Hard - 7th Grade and up!\n\n"
				"For additional help or feedback! Contact us at support@klivin.com", 
				@"pageText",
				nil],
			[NSDictionary dictionaryWithObjectsAndKeys:
				@"Special Thanks...", @"pageName",
				@"To my wonderful, supportive wife, thanks for everything!\n\n"
				 "Thanks to all the wonderful teachers out there who gave input!\n\n"
				 "All Credit for music goes to Royalty Free Music by DanoSongs.com, Thanks!\n\n"
				 "Another BIG thanks to Jeri Ingalls for her fonts at http://littlehouse.homestead.com\n\n"
				 "Last but certainly not least, thanks to Brian Wong for helping us get this app going.", 
				@"pageText",
				nil],
		
			nil];
	}
	return self;
}

- (NSInteger)numDataPages
{
	return [dataPages count];
}

- (NSDictionary *)dataForPage:(NSInteger)pageIndex
{
	return [dataPages objectAtIndex:pageIndex];
}

@end
