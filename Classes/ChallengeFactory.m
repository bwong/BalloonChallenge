//
//  ChallengeFactory.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 3/29/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "ChallengeFactory.h"
#import "GroupFactory.h"
#import "BalloonFactory.h"

@implementation ChallengeFactory

+ (id) createColorChallenge: (ChallengeDifficulty) difficulty {
	MathChallenge *mc = [[MathChallenge alloc] init];	
	//[mc autorelease];
	return mc;
}

//this is just to initialize the first time for a challenge by time level
+ (id) timeChallengeWithType: (ChallengeGroupType) challengeType {
	
	MathChallenge *mc = [[MathChallenge alloc] init];	
	mc.seconds = 20;
	mc.ptsCorrect = 1;
	mc.ptsIncorrect = 0;
	switch (challengeType) {
		case e_OddsAndEvens:
		{
			mc.gameImage = [UIImage imageNamed:@"bg_butterfly.png"];
			// randomly select odds or evens
			[mc setChallenge:((random()%2) ? ChallengeOdds : ChallengeEvens) 
				   withGiven:[NSNumber numberWithInt:2]]; 

			mc.releaseSpeed = 1.40f;
			mc.velRange.min = 2;
			mc.velRange.max = 5;
			mc.ansRange.min = 1;
			mc.ansRange.max = 100;
			[mc.challengeText setString:@"In the Odds and Evens time challenge, "
			 "pop odd numbered balloons if you see the words, \"Odd Numbers\" and "
			 "pop even numbered balloons if you see \"Even Numbers.\"\n\n"
			 "If you miss a balloon or pop a wrong one, that counts as a mistake. "
			 "If you mess up five times, the game ends.\n\nTry to rack up large combos for a higher score!"];
		}
			break;
		case e_Colors:
		{
			mc.gameImage = [UIImage imageNamed:@"bg_space.png"];
			[mc setChallenge:ChallengeColor				   
				   withGiven:[NSNumber numberWithInt:random()%kColorTotal]]; 	
			mc.releaseSpeed = 1.0f;
			mc.velRange.min = 3;
			mc.velRange.max = 10;
			mc.ansRange.min = 0;
			mc.ansRange.max = 4;
			[mc.challengeText setString:@"In the Colors time challenge, "
			 "Pop balloons of the given Color.\n\n"
			 "If you miss a balloon or pop a wrong one, that counts as a mistake. "
			 "If you mess up five times, the game ends.\n\nTry to rack up large combos for a higher score!"];
		}
			break;
		case e_Addition:
		{
			// This only to set the initial given, given recalculated by the time challenge view controller

			[mc setChallenge:ChallengeAddition
				   withGiven:[ChallengeFactory randomWithMin:10 andMax:20]];
			mc.seconds = 30;

			mc.gameImage = [UIImage imageNamed:@"bg_butterfly.png"];
			mc.releaseSpeed = 1.85f;
			mc.velRange.min = 1;
			mc.velRange.max = 4;
			mc.ansRange.min = 1;
			//TODO add negatives
			BOOL negatives = NO;
			if (negatives) {
				mc.ansRange.max = [mc.given intValue] +5;
			} else {
				//this means we won't deal with negatives (on normal mode)
				mc.ansRange.max = [mc.given intValue];
			}
			[mc.challengeText setString:@"In the Addition time challenge, "
			 "pop the balloons that add up to the answer on the screen.\n\n"
			 "If you miss a balloon or pop a wrong one, that counts as a mistake. "
			 "If you mess up five times, the game ends.\n\nTry to rack up large combos for a higher score!"];
		}
			break;
		case e_Subtraction:
		{
			[mc setChallenge:ChallengeSubtraction
				   withGiven:[ChallengeFactory randomWithMin:10 andMax:20]];
			mc.seconds = 30;

			mc.gameImage = [UIImage imageNamed:@"bg_dock_1024.png"];
			mc.releaseSpeed = 1.85f;
			mc.velRange.min = 1;
			mc.velRange.max = 4;
			mc.ansRange.max = [mc.given intValue]*2;
			
			//TODO add negatives
			BOOL negatives = NO;
			if (negatives) {
				mc.ansRange.min = [mc.given intValue] - 5;
			} else {
				//this means we won't deal with negatives (on normal mode)
				mc.ansRange.min = [mc.given intValue];
				
			}
			[mc.challengeText setString:@"In the Subtraction time challenge, "
			 "pop the balloons that solve the subtraction problem on the screen.\n\n"
			 "If you miss a balloon or pop a wrong one, that counts as a mistake. "
			 "If you mess up five times, the game ends.\n\nTry to rack up large combos for a higher score!"];			
		}
			break;
		case e_Multiplication:
		{
			[mc setChallenge:ChallengeMultiplication
				   withGiven:[ChallengeFactory randomWithMin:0 andMax:10]
				   withGiven:[ChallengeFactory randomWithMin:0 andMax:10]];
			mc.gameImage = [UIImage imageNamed:@"bg_dock_1024.png"];
			mc.seconds = 30;
			mc.releaseSpeed = 1.60f;
			mc.velRange.min = 1;
			mc.velRange.max = 3;
			mc.ansRange.min = 1;
			mc.ansRange.max = 100;
			[mc.challengeText setString:@"In the multiplication time challenge, "
			 "pop the balloon that is the solution to the multiplication problem on the screen.\n\n"
			 "If you miss a balloon or pop a wrong one, that counts as a mistake. "
			 "If you mess up five times, the game ends.\n"];
		}
			break;
		case e_Division:
		{
			NSNumber* testFactor1 = [ChallengeFactory randomWithMin:1 andMax:10];
			NSNumber* testFactor2 = [ChallengeFactory randomWithMin:1 andMax:10];
			
			NSNumber *result = [NSNumber numberWithInt:([testFactor1 intValue]*[testFactor2 intValue])];
			[mc setChallenge:ChallengeDivision
				   withGiven:result
				   withGiven:testFactor1];
			mc.gameImage = [UIImage imageNamed:@"bg_dock_1024.png"];
			mc.seconds = 30;
			mc.releaseSpeed = 1.60f;
			mc.velRange.min = 1;
			mc.velRange.max = 3;
			mc.ansRange.min = 1;
			mc.ansRange.max = 100;
			[mc.challengeText setString:@"In the division time challenge, "
			 "pop the balloon that is the solution to the division problem on the screen.\n\n"
			 "If you miss a balloon or pop a wrong one, that counts as a mistake. "
			 "If you mess up five times, the game ends.\n"];
		}
			break;
		case e_Multiples:
		{
			[mc setChallenge:ChallengeMultiple
				   withGiven:[ChallengeFactory randomWithMin:3 andMax:5]];
			mc.gameImage = [UIImage imageNamed:@"bg_dock_1024.png"];
			mc.seconds = 30;
			mc.releaseSpeed = 1.60f;
			mc.velRange.min = 1;
			mc.velRange.max = 3;
			mc.ansRange.min = 1;
			mc.ansRange.max = 80;
			[mc.challengeText setString:@"In the Multiples time challenge, "
			 "pop the balloons that are multiples of the given number on the screen.\n\n"
			 "If you miss a balloon or pop a wrong one, that counts as a mistake. "
			 "If you mess up five times, the game ends.\n\nTry to rack up large combos for a higher score!"];
		}
			break;
		case e_Factors:
		{
			mc.seconds = 30;

			NSNumber* testFactor = [ChallengeFactory randomWithMin:24 andMax:36];
			int failcount = 0;
			
			while ([MathChallenge isPrime:[testFactor intValue]]) {
				testFactor = [ChallengeFactory randomWithMin:24 andMax:36];
				failcount++;
				if (failcount>50) {
					testFactor = [NSNumber numberWithInt:24];
				}
			}
			[mc setChallenge:ChallengeFactors
				   withGiven:testFactor];
			mc.gameImage = [UIImage imageNamed:@"bg_clouds.png"];	
			mc.releaseSpeed = 1.8f;
			mc.velRange.min = 1;
			mc.velRange.max = 4;
			mc.ansRange.min = 1;
			mc.ansRange.max = [testFactor floatValue]*1.1f;
			[mc.challengeText setString:@"In the Factors time challenge, "
			 "pop the balloons that are factors of the given number on the screen.\n\n"
			 "If you miss a balloon or pop a wrong one, that counts as a mistake. "
			 "If you mess up five times, the game ends.\n\nTry to rack up large combos for a higher score!"];
		}
			break;
		default:
			break;
	}
	mc.numCorrect = (mc.seconds/mc.releaseSpeed)/2;
	if (challengeType==e_Multiplication || challengeType == e_Division) {
		mc.numCorrect=1;
	}
	return mc;
}



+ (id) createChallengeByLevel: (Level*) level
				andDifficulty: (ChallengeDifficulty) difficulty	{
	MathChallenge *mc = [[MathChallenge alloc] init];	
	//[mc autorelease];
	mc.gameImage = [UIImage imageNamed:@"bg_butterfly.png"];	
	mc.seconds = 45;
	mc.ptsCorrect = 10;
	mc.ptsIncorrect = -5;
	mc.challengeDifficulty = difficulty;
	mc.percentCorrect = .7f;
	//[mc.challengeName setString:
	NSString *levelChallengeName = [level getChallengeName];
	
	if ([levelChallengeName isEqualToString:@"Odd Numbers"]) {
		[mc setChallenge:ChallengeOdds
			   withGiven:[NSNumber numberWithInt:2]]; 
		mc.releaseSpeed = 1.40f;
		mc.velRange.min = 2;
		mc.velRange.max = 5;
		mc.ansRange.min = 1;
		mc.ansRange.max = 100;
		[mc.challengeText setString:@"In this level, pop the balloons with ODD numbers on them!\n\n"
		 "Odd numbers are not divisible by 2.\n\n"
		 "Hint: Odd numbers will always end in 1, 3, 5, 7, or 9."];
	} else if ([levelChallengeName isEqualToString:@"Even Numbers"]) {
		[mc setChallenge:ChallengeEvens
			   withGiven:[NSNumber numberWithInt:2]]; 
		mc.releaseSpeed = 1.40f;
		mc.velRange.min = 2;
		mc.velRange.max = 5;
		mc.ansRange.min = 1;
		mc.ansRange.max = 100;
		[mc.challengeText setString:@"In this level, pop the balloons with EVEN numbers on them!\n\n"
		 "Even numbers are divisible by 2.\n\n"
		 "Hint: Even numbers will always end in 0, 2, 4, 6, or 8."];
	} else if ([levelChallengeName isEqualToString:@"Multiples of 3"]) {
		[mc setChallenge:ChallengeMultiple				   
			   withGiven:[NSNumber numberWithInt:3]]; 

		mc.releaseSpeed = 1.6f;
		mc.velRange.min = 1;
		mc.velRange.max = 3;
		mc.ansRange.min = 1;
		mc.ansRange.max = 60;
		mc.gameImage = [UIImage imageNamed:@"bg_dock_1024.png"];
		[mc.challengeText setString:@"In this level, pop all the balloons that are divisible by 3.\n\n"
		 "Hint: Add the digits in a number.  If the sum of the digits is divisible "
		 "by 3, the whole number is divisible by 3."];
		
	} else if ([levelChallengeName isEqualToString:@"Multiples of 4"]) {
		[mc setChallenge:ChallengeMultiple				  
			   withGiven:[NSNumber numberWithInt:4]]; 

		mc.releaseSpeed = 1.60f;
		mc.velRange.min = 1;
		mc.velRange.max = 3;
		mc.ansRange.min = 1;
		mc.ansRange.max = 80;
		mc.gameImage = [UIImage imageNamed:@"bg_dock_1024.png"];
		[mc.challengeText setString:@"In this level, pop all the balloons that are divisible by 4.\n\n"
		 "Hint: Whole numbers are divisible by 4 if the number formed by the last "
		 "two individual digits is evenly divisible by 4.\n\nFor example, the number "
		 "formed by the last two digits of the number 3628 is 28, which is evenly "
		 "divisible by 4 so the number 3628 is evenly divisible by 4."];
		
	} else if ([levelChallengeName isEqualToString:@"Multiples of 5"]) {
		[mc setChallenge:ChallengeMultiple				  
			   withGiven:[NSNumber numberWithInt:5]]; 

		mc.releaseSpeed = 1.55f;
		mc.velRange.min = 2;
		mc.velRange.max = 5;
		mc.ansRange.min = 1;
		mc.ansRange.max = 100;
		mc.gameImage = [UIImage imageNamed:@"bg_dock_1024.png"];
		[mc.challengeText setString:@"In this level, pop all the balloons that are divisible by 5.\n\n"
		 "Hint: Numbers are multiples of five if they end in a 5 or a 0!"];
	} else if ([levelChallengeName isEqualToString:@"Multiples of 6"]) {
		[mc setChallenge:ChallengeMultiple
			   withGiven:[NSNumber numberWithInt:6]]; 
		mc.releaseSpeed = 1.90f;
		mc.velRange.min = 1;
		mc.velRange.max = 4;
		mc.ansRange.min = 1;
		mc.ansRange.max = 80;
		mc.gameImage = [UIImage imageNamed:@"bg_dock_1024.png"];
		[mc.challengeText setString: @"In this level, pop all the balloons that are divisible by 6.\n\n"
		 "Hint: Numbers are evenly divisible by 6 if they are evenly divisible "
		 "by both 2 AND 3. Even numbers are always evenly divisible by 2. Numbers "
		 "are evenly divisible by 3 if the sum of all the individual digits is "
		 "evenly divisible by 3.\n\nFor example, the sum of the digits for the "
		 "number 3627 is 18, which is evenly divisible by 3 but 3627 is not even, "
		 "so the number 3627 is not evenly divisible by 6."];
		
	} else if ([levelChallengeName isEqualToString:@"Multiples of 7"]) {
		[mc setChallenge:ChallengeMultiple
		 withGiven:[NSNumber numberWithInt:7]]; 
		mc.releaseSpeed = 1.90f;
		mc.velRange.min = 1;
		mc.velRange.max = 3;
		mc.ansRange.min = 1;
		mc.ansRange.max = 77;
		mc.gameImage = [UIImage imageNamed:@"bg_dock_1024.png"];
		[mc.challengeText setString: @"In this level, pop all the balloons that are divisible by 7.\n\n"
		 "Hint: To determine if a number is divisible by 7, take the last "
		 "digit off the number, double it and subtract the doubled number "
		 "from the remaining number. If the result is evenly divisible by 7 "
		 "(e.g. 14, 7, 0, -7, etc.), then the number is divisible by seven. "
		 "This may need to be repeated several times.\n\nExample: Is 14 "
		 "evenly divisible by 7?\n\nTake the 2nd digit, 4, double it to "
		 "get 8, and subtract the first digit, 1, to get 7.  Wahlah! 7 is "
		 "divisible by 7!"];
		
	} else if ([levelChallengeName isEqualToString:@"Multiples of 8"]) {
		[mc setChallenge:ChallengeMultiple
		 withGiven:[NSNumber numberWithInt:8]]; 
		mc.releaseSpeed = 1.90f;
		mc.velRange.min = 1;
		mc.velRange.max = 3;
		mc.ansRange.min = 1;
		mc.ansRange.max = 88;
		mc.gameImage = [UIImage imageNamed:@"bg_dock_1024.png"];
		[mc.challengeText setString: @"In this level, pop all the balloons that are divisible by 8!\n\n"
		 "Hint: One fancy trick to determine if large numbers are multiples of 8:\n"
		 "Check if the last 3 digits are multiples of 8, if they are, that number is "
		 "a multiple of 8!"];
		
	} else if ([levelChallengeName isEqualToString:@"Multiples of 9"]) {
		[mc setChallenge:ChallengeMultiple
			   withGiven:[NSNumber numberWithInt:9]]; 
		mc.releaseSpeed = 1.90f;
		mc.velRange.min = 1;
		mc.velRange.max = 3;
		mc.ansRange.min = 1;
		mc.ansRange.max = 100;
		mc.gameImage = [UIImage imageNamed:@"bg_dock_1024.png"];
		[mc.challengeText setString: @"In this level, pop all the balloons that are divisible by 9!\n\n"
		 "Hint: Remember the rule for multiples of 3?  The rule for 9s is very similar: "
		 "Add up the digits in the number.  If the result is a multiple of 9, "
		 "then so is the number!"];
		
	} else if ([levelChallengeName rangeOfString:@"Random Multiple"].location!=NSNotFound) {
		[mc setChallenge:ChallengeRandomMultiple
			   withGiven:[self getGivenFromString:levelChallengeName withLocation:3]]; 
		mc.releaseSpeed = 1.8f;
		mc.velRange.min = 1;
		mc.velRange.max = 3;
		mc.ansRange.min = 1;
		mc.ansRange.max = 100;
		mc.gameImage = [UIImage imageNamed:@"bg_dock_1024.png"];
		[mc.challengeText setString:@"In this level, look at the random number given above.\n\n"
		 "Pop the balloons that are multiples of this number..."];
	} else if ([levelChallengeName rangeOfString:@"Factors of"].location!=NSNotFound) {
		[mc setChallenge:ChallengeFactors
			   withGiven:[self getGivenFromString:levelChallengeName withLocation:3]]; 
		mc.releaseSpeed = 1.8f;
		mc.velRange.min = 1;
		mc.velRange.max = 4;
		mc.ansRange.min = 1;
		mc.ansRange.max = [mc.given intValue] + 10;
		mc.gameImage = [UIImage imageNamed:@"bg_butterfly.png"];
		NSString *str = [NSString stringWithFormat: @"In this level, pop all the balloons that are "
						 "factors of %d.\n\nA factor is a number that divides exactly into a larger "
						 "number.\n\nFor example, the factors of 24 are 1, 2, 3, 4, 6, 8, 12, and "
						 "24!", [mc.given intValue]];
		[mc.challengeText setString: str];
		
	} else if ([levelChallengeName rangeOfString:@"Random Factor"].location!=NSNotFound) {
		
		NSNumber* testFactor = [self getGivenFromString:levelChallengeName withLocation:3];
		int failcount = 0;

		while ([MathChallenge isPrime:[testFactor intValue]]) {
			testFactor = [self getGivenFromString:levelChallengeName withLocation:3];
			failcount++;
			if (failcount>100) {
				testFactor = [NSNumber numberWithInt:112];
			}
		}
		[mc setChallenge:ChallengeRandomFactor
			   withGiven:testFactor];

		mc.releaseSpeed = 1.85f;
		mc.velRange.min = 1;
		mc.velRange.max = 4;
		mc.ansRange.min = 1;
		mc.ansRange.max = 120;
		mc.gameImage = [UIImage imageNamed:@"bg_butterfly.png"];
		[mc.challengeText setString: @"In this level, look at the random number given aboce!\n\n"
		 "Pop the balloons that are factors of this number..."];
		
	} else if ([levelChallengeName rangeOfString:@"Addition"].location!=NSNotFound) {
		[mc setChallenge:ChallengeAddition
			   withGiven: [self getGivenFromString:levelChallengeName withLocation:2]];
		mc.gameImage = [UIImage imageNamed:@"bg_clouds.png"];	
		mc.releaseSpeed = 1.85f;
		mc.velRange.min = 1;
		mc.velRange.max = 4;
		mc.ansRange.min = 1;
		//TODO add negatives
		BOOL negatives = NO;
		if (negatives) {
			mc.ansRange.max = [mc.given intValue] +5;
		} else {
			//this means we won't deal with negatives (on normal mode)
			mc.ansRange.max = [mc.given intValue];
		}
		[mc.challengeText setString: [NSString stringWithFormat:@"In this level, you will see balloons with "
									  "addition problems. Get ready to pop all the balloons where the answer to "
									  "the addition problem equals %d", [mc.given intValue]]];
		
	} else if ([levelChallengeName rangeOfString:@"Subtraction"].location!=NSNotFound) {
		[mc setChallenge:ChallengeSubtraction
			   withGiven: [self getGivenFromString:levelChallengeName withLocation:2]];
		mc.gameImage = [UIImage imageNamed:@"bg_clouds.png"];	
		mc.releaseSpeed = 1.85f;
		mc.velRange.min = 1;
		mc.velRange.max = 4;
		mc.ansRange.max = [mc.given intValue]*2;
		
		//TODO add negatives
		BOOL negatives = NO;
		if (negatives) {
			mc.ansRange.min = [mc.given intValue] - 5;
		} else {
			//this means we won't deal with negatives (on normal mode)
			mc.ansRange.min = [mc.given intValue];
			
		}
		[mc.challengeText setString: [NSString stringWithFormat:@"In this level, you will see balloons with "
									  "subtraction problems. Get ready to pop all the balloons where the answer to "
									  "the subtraction problem equals %d", [mc.given intValue]]];
		
	} else if ([levelChallengeName isEqualToString:@"Red Balloons"]) {
		[mc setChallenge:ChallengeColor
			   withGiven:[NSNumber numberWithInt:kColorRed]];
		mc.ptsCorrect = 5;
		mc.releaseSpeed = .50f;
		mc.percentCorrect = 0.0f;
		mc.velRange.min = 6;
		mc.velRange.max = 11;
		mc.ansRange.min = 0;
		mc.ansRange.max = 4;
		mc.gameImage = [UIImage imageNamed:@"bg_space.png"];
		[mc.challengeText setString:@"Popping colors!\n\n"
		 "In this level, pop all the RED balloons. Watch out, even though red means stop, "
		 "these balloons go, go, go!"];
		
	} else if ([levelChallengeName isEqualToString:@"Yellow Balloons"]) {
		[mc setChallenge:ChallengeColor
			   withGiven:[NSNumber numberWithInt:kColorYellow]];
		mc.ptsCorrect = 5;
		mc.releaseSpeed = .9f;
		mc.percentCorrect = 0.0f;
		mc.velRange.min = 4;
		mc.velRange.max = 10;
		mc.ansRange.min = 0;
		mc.ansRange.max = 4;
		mc.gameImage = [UIImage imageNamed:@"bg_space.png"];
		[mc.challengeText setString:@"It's time to pop some balloons!\n\n"
		 "In this level, pop all the YELLOW balloons. Go bananas, and pop only the yellow balloons!"];
	} else if ([levelChallengeName isEqualToString:@"Blue Balloons"]) {
		[mc setChallenge:ChallengeColor
			   withGiven:[NSNumber numberWithInt:kColorBlue]];
		mc.ptsCorrect = 5;
		mc.releaseSpeed = .8f;
		mc.percentCorrect = 0.0f;
		mc.velRange.min = 4;
		mc.velRange.max = 10;
		mc.ansRange.min = 0;
		mc.ansRange.max = 4;
		mc.gameImage = [UIImage imageNamed:@"bg_space.png"];
		[mc.challengeText setString:@"Popping colors!\n\n"
		 "In this level, pop all the BLUE balloons. Blue balloons may be blue, "
		 "bot not to worry, these aren't water balloons!"];
	} else if ([levelChallengeName isEqualToString:@"Green Balloons"]) {
		[mc setChallenge:ChallengeColor
			   withGiven:[NSNumber numberWithInt:kColorGreen]];
		mc.ptsCorrect = 5;
		mc.releaseSpeed = .9f;
		mc.percentCorrect = 0.0f;
		mc.velRange.min = 4;
		mc.velRange.max = 10;
		mc.ansRange.min = 0;
		mc.ansRange.max = 4;
		mc.gameImage = [UIImage imageNamed:@"bg_space.png"];
		[mc.challengeText setString:@"Popping colors!\n\n"
		 "In this level, pop all the GREEN balloons. Don't get sick popping the green balloons!"];
	} 
	mc.numCorrect = (mc.seconds/mc.releaseSpeed)/2;
	
	
	if (difficulty==DifficultyEasy) {
		//mc.seconds -= 5;
		if (mc.velRange.min > 1)
			mc.velRange.min -= 1;
		if (mc.velRange.max	>1)
			mc.velRange.max -= 1;
		
		mc.releaseSpeed += .5f;
		//if (mc.percentCorrect > .1f)
		//			mc.percentCorrect -= .1f;
		mc.ptsCorrect -= 2;
		mc.ptsIncorrect -= 1;
		
	} else if (difficulty == DifficultyHard) {
		mc.seconds += 5;
		mc.velRange.min += 1;
		mc.velRange.max += 1;
		mc.releaseSpeed -=.25f;
		//mc.percentCorrect += .1f;
		mc.ptsCorrect += 2;
		mc.ptsIncorrect -= 1;
		if (mc.challengeType != ChallengeColor)
			mc.ansRange.max*=2;
	}
	[mc generateNumAnswers:((float)mc.seconds/mc.releaseSpeed)+1];
	return mc;
}
+ (NSNumber *) randomWithMin: (int) min andMax: (int) max {
	return [NSNumber numberWithInt:random()%(max-min) + min];
}

+ (NSNumber *) getGivenFromString: (NSString*) str 
					 withLocation: (int)loc {
	NSArray *arr = [str componentsSeparatedByCharactersInSet:
					[NSCharacterSet characterSetWithCharactersInString:@" (-)"]];
	if ([arr count]<=loc) {
		return [NSNumber numberWithInt:[[arr objectAtIndex:loc-1] intValue]];
	}

	return [ChallengeFactory randomWithMin:[[arr objectAtIndex:loc] intValue] 
							 andMax:[[arr objectAtIndex:loc+1] intValue]];
}
@end
