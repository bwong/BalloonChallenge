//
//  GroupFactory.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GroupFactory.h"

@implementation GroupFactory

static NSMutableDictionary *challenges;

static NSMutableArray *games;
static NSMutableArray *progressions;
static NSMutableArray *challengesOandE;
static NSMutableArray *challengesMultiple;
static NSMutableArray *challengesFactor;
static NSMutableArray *challengesAddition;
static NSMutableArray *challengesSubtraction;
//static NSMutableArray *challengesMultiplication;
//static NSMutableArray *challengesDivision;
static NSMutableArray *challengesColor;

static NSMutableArray *mathgroups;
static NSMutableArray *challengesSimple;
static NSMutableArray *challengesThrees;
static NSMutableArray *challengeMultiply;
static NSMutableArray *challengeFactoring;
static NSMutableArray *challengeAdd;
static NSMutableArray *challengeSubtract;
static NSMutableArray *challengeHard;

//Needs to be released by the caller
+ (NSMutableDictionary *) challenges {
	if (nil == challenges) {
		challenges = [[NSMutableDictionary allocWithZone:[self zone]] init];
		int gcount = [[GroupFactory games] count];
		for (int i=0; i<gcount; i++) {
			ChallengeGroup *g = [games objectAtIndex:i];
			int pcount = [[g subgroups] count];
			for (int j=0; j<pcount; j++) {
				ChallengeGroup *p = [[g subgroups] objectAtIndex:j];
				int ccount = [[p subgroups] count];
				for (int k=0; k<ccount; k++) {
					[challenges setObject:[[[p subgroups] objectAtIndex:k] name]
								   forKey:[Level levelWithGame:i 
											   withProgression:j 
												 withChallenge:k]];
				}
			}
		}
	}
	return challenges;
}

+ (NSMutableArray *) games {
	if (nil == games)
		games = [[NSMutableArray allocWithZone:[self zone]] 
				 initWithObjects: [ChallengeGroup groupWithName:@"Practice Makes Perfect!" 
													   withType:e_Game
													  withGroup:self.progressions],
				 [ChallengeGroup groupWithName:@"Math Challenge!" 
									  withType:e_Game
									 withGroup:self.mathgroups],
				 nil];
	
	return games;
}

+(NSMutableArray *) mathgroups {
	if (nil == mathgroups)
		mathgroups = [[NSMutableArray allocWithZone:[self zone]] 
						initWithObjects: 
						[ChallengeGroup groupWithName:@"Start Simple" 
											 withType:e_Progression
											withGroup:self.challengesSimple],
						[ChallengeGroup groupWithName:@"All About 3s" 
											 withType:e_Progression
											withGroup:self.challengesThrees],
						[ChallengeGroup groupWithName:@"Let's Add Sum!" 
										   withType:e_Progression
										  withGroup:self.challengeAdd],
						[ChallengeGroup groupWithName:@"Multiples And More!" 
										   withType:e_Progression
										  withGroup:self.challengeMultiply],
						[ChallengeGroup groupWithName:@"Factoring Rules!" 
											 withType:e_Progression
											withGroup:self.challengeFactoring],
						[ChallengeGroup groupWithName:@"Subtraction Distraction!" 
											 withType:e_Progression
											withGroup:self.challengeSubtract],
						[ChallengeGroup groupWithName:@"Hardy Hard!" 
											 withType:e_Progression
											withGroup:self.challengeHard],
						
						nil];
	return mathgroups;
}

//Needs to be released by the caller
+ (NSMutableArray *) challengesSimple {
	if (nil == challengesSimple)
		challengesSimple = [[NSMutableArray allocWithZone:[self zone]] 
						   initWithObjects: 
						   [ChallengeGroup groupWithName:@"Odd Numbers" 
												withType:e_Challenge],
						   [ChallengeGroup groupWithName:@"Even Numbers" 
												withType:e_Challenge],
						   [ChallengeGroup groupWithName:@"Yellow Balloons" 
												withType:e_Challenge],
						   nil];
	return challengesSimple;
}	

+ (NSMutableArray *) challengesThrees {
	if (nil == challengesThrees)
		challengesThrees = [[NSMutableArray allocWithZone:[self zone]] 
							  initWithObjects: 
							  [ChallengeGroup groupWithName:@"Multiples of 3" 
												   withType:e_Challenge],
							  [ChallengeGroup groupWithName:@"Multiples of 6" 
												   withType:e_Challenge],
							  [ChallengeGroup groupWithName:@"Multiples of 9" 
												   withType:e_Challenge],
							  [ChallengeGroup groupWithName:@"Green Balloons" 
												 withType:e_Challenge],
							  nil];
	return challengesThrees;
}


+(NSMutableArray *) challengeAdd {
	if (nil == challengeAdd)
		challengeAdd = [[NSMutableArray allocWithZone:[self zone]] 
						initWithObjects: 
						[ChallengeGroup groupWithName:@"Addition (10-20)" 
											 withType:e_Challenge],
						[ChallengeGroup groupWithName:@"Addition (20-30)" 
											 withType:e_Challenge],
						[ChallengeGroup groupWithName:@"Addition (30-40)" 
											 withType:e_Challenge],
						[ChallengeGroup groupWithName:@"Addition (40-50)" 
											 withType:e_Challenge],
						[ChallengeGroup groupWithName:@"Addition (50-60)" 
											 withType:e_Challenge],
						[ChallengeGroup groupWithName:@"Addition (60-70)" 
											 withType:e_Challenge],
						[ChallengeGroup groupWithName:@"Addition (70-80)" 
											 withType:e_Challenge],
						[ChallengeGroup groupWithName:@"Addition (80-90)" 
											 withType:e_Challenge],
						[ChallengeGroup groupWithName:@"Addition (90-100)" 
											 withType:e_Challenge],
						[ChallengeGroup groupWithName:@"Blue Balloons" 
											 withType:e_Challenge],
						nil];
	return challengeAdd;
}


+(NSMutableArray *) challengeMultiply {
	if (nil == challengeMultiply)
		challengeMultiply = [[NSMutableArray allocWithZone:[self zone]] 
							 initWithObjects: 
							 [ChallengeGroup groupWithName:@"Multiples of 5" 
												  withType:e_Challenge],
							 [ChallengeGroup groupWithName:@"Multiples of 7" 
												  withType:e_Challenge],
							 [ChallengeGroup groupWithName:@"Multiples of 8" 
												  withType:e_Challenge],
							 [ChallengeGroup groupWithName:@"Random Multiple (3-9)" 
												  withType:e_Challenge],
							 [ChallengeGroup groupWithName:@"Random Multiple (10-15)" 
												  withType:e_Challenge],
							 [ChallengeGroup groupWithName:@"Red Balloons" 
												  withType:e_Challenge],
							 
							 nil];
	return challengeMultiply;
}

+ (NSMutableArray *) challengeFactoring {
	if (nil == challengeFactoring)
		challengeFactoring = [[NSMutableArray allocWithZone:[self zone]] 
							initWithObjects: 
							[ChallengeGroup groupWithName:@"Factors of 24" 
												 withType:e_Challenge],
							[ChallengeGroup groupWithName:@"Factors of 32" 
												 withType:e_Challenge],
							[ChallengeGroup groupWithName:@"Factors of 40" 
												 withType:e_Challenge],
							[ChallengeGroup groupWithName:@"Factors of 52" 
												 withType:e_Challenge],
							[ChallengeGroup groupWithName:@"Factors of 64" 
												 withType:e_Challenge],
							[ChallengeGroup groupWithName:@"Factors of 112" 
												   withType:e_Challenge],
							[ChallengeGroup groupWithName:@"Random Factor (20-60)" 
												 withType:e_Challenge],
							[ChallengeGroup groupWithName:@"Random Factor (40-80)" 
												 withType:e_Challenge],
							[ChallengeGroup groupWithName:@"Random Factor (64-128)" 
												 withType:e_Challenge],
							[ChallengeGroup groupWithName:@"Yellow Balloons" 
												 withType:e_Challenge],
							nil];
	return challengeFactoring;
}

+(NSMutableArray *) challengeSubtract {
	if (nil == challengeSubtract)
		challengeSubtract = [[NSMutableArray allocWithZone:[self zone]] 
							 initWithObjects: 
							 [ChallengeGroup groupWithName:@"Subtraction (10-20)" 
												  withType:e_Challenge],
							 [ChallengeGroup groupWithName:@"Subtraction (20-30)" 
												  withType:e_Challenge],
							 [ChallengeGroup groupWithName:@"Subtraction (30-40)" 
												  withType:e_Challenge],
							 [ChallengeGroup groupWithName:@"Subtraction (40-50)" 
												  withType:e_Challenge],
							 [ChallengeGroup groupWithName:@"Subtraction (50-60)" 
												  withType:e_Challenge],
							 [ChallengeGroup groupWithName:@"Subtraction (60-70)" 
												  withType:e_Challenge],
							 [ChallengeGroup groupWithName:@"Subtraction (70-80)" 
												  withType:e_Challenge],
							 [ChallengeGroup groupWithName:@"Subtraction (80-90)" 
												  withType:e_Challenge],
							 [ChallengeGroup groupWithName:@"Subtraction (90-100)" 
												  withType:e_Challenge],
							 [ChallengeGroup groupWithName:@"Green Balloons" 
												  withType:e_Challenge],
							 nil];
	return challengeSubtract;
}

+ (NSMutableArray *) challengeHard {
	if (nil == challengeHard)
		challengeHard = [[NSMutableArray allocWithZone:[self zone]] 
						 initWithObjects: 
						 [ChallengeGroup groupWithName:@"Multiples of 4" 
											  withType:e_Challenge],
						 [ChallengeGroup groupWithName:@"Multiples of 7" 
											  withType:e_Challenge],
						 [ChallengeGroup groupWithName:@"Multiples of 8" 
											  withType:e_Challenge],
						 [ChallengeGroup groupWithName:@"Random Factor (24-64)" 
											  withType:e_Challenge],
						 [ChallengeGroup groupWithName:@"Random Factor (64-128)" 
											  withType:e_Challenge],
						 [ChallengeGroup groupWithName:@"Random Multiple (3-9)" 
											  withType:e_Challenge],
						 [ChallengeGroup groupWithName:@"Random Multiple (10-15)" 
											  withType:e_Challenge],
						 [ChallengeGroup groupWithName:@"Addition (60-70)" 
											  withType:e_Challenge],
						 [ChallengeGroup groupWithName:@"Addition (70-80)" 
											  withType:e_Challenge],
						 [ChallengeGroup groupWithName:@"Addition (80-90)" 
											  withType:e_Challenge],
						 [ChallengeGroup groupWithName:@"Addition (90-100)" 
											  withType:e_Challenge],
						 [ChallengeGroup groupWithName:@"Subtraction (80-90)" 
											  withType:e_Challenge],
						 [ChallengeGroup groupWithName:@"Subtraction (90-100)" 
											  withType:e_Challenge],
						 [ChallengeGroup groupWithName:@"Red Balloons" 
											  withType:e_Challenge],
						 nil];
	return challengeHard;
}


+(NSMutableArray *) progressions {
	if (nil == progressions)
		progressions = [[NSMutableArray allocWithZone:[self zone]] 
						initWithObjects: 
						[ChallengeGroup groupWithName:@"Colors" 
											 withType:e_Progression
											withGroup:self.challengesColor],
						[ChallengeGroup groupWithName:@"Odds and Evens" 
											 withType:e_Progression
											withGroup:self.challengesOandE],
						[ChallengeGroup groupWithName:@"Addition" 
											 withType:e_Progression
											withGroup:self.challengesAddition],
						[ChallengeGroup groupWithName:@"Subtraction" 
											 withType:e_Progression
											withGroup:self.challengesSubtraction],
						[ChallengeGroup groupWithName:@"Multiplication" 
											 withType:e_Progression
											withGroup:nil],
						[ChallengeGroup groupWithName:@"Division" 
											 withType:e_Progression
											withGroup:nil],
						[ChallengeGroup groupWithName:@"Multiples" 
											 withType:e_Progression
											withGroup:self.challengesMultiple],
						[ChallengeGroup groupWithName:@"Factors" 
											 withType:e_Progression
											withGroup:self.challengesFactor],

						nil];
	return progressions;
}

//Needs to be released by the caller
+ (NSMutableArray *) challengesOandE {
	if (nil == challengesOandE)
		challengesOandE = [[NSMutableArray allocWithZone:[self zone]] 
						   initWithObjects: 
						   [ChallengeGroup groupWithName:@"Odd Numbers" 
												withType:e_Challenge],
						   [ChallengeGroup groupWithName:@"Even Numbers" 
												withType:e_Challenge],
						   nil];
	return challengesOandE;
}	
+ (NSMutableArray *) challengesColor {
	if (nil == challengesColor)
		challengesColor = [[NSMutableArray allocWithZone:[self zone]] 
						   initWithObjects: 
						   [ChallengeGroup groupWithName:@"Yellow Balloons" 
												withType:e_Challenge],
						   [ChallengeGroup groupWithName:@"Green Balloons" 
												withType:e_Challenge],
						   [ChallengeGroup groupWithName:@"Blue Balloons" 
												withType:e_Challenge],
						   [ChallengeGroup groupWithName:@"Red Balloons" 
												withType:e_Challenge],
						   nil];
	return challengesColor;
}	

+ (NSMutableArray *) challengesMultiple {
	if (nil == challengesMultiple)
		challengesMultiple = [[NSMutableArray allocWithZone:[self zone]] 
							  initWithObjects: 
							  [ChallengeGroup groupWithName:@"Multiples of 3" 
												   withType:e_Challenge],
							  [ChallengeGroup groupWithName:@"Multiples of 4" 
												   withType:e_Challenge],
							  [ChallengeGroup groupWithName:@"Multiples of 5" 
												   withType:e_Challenge],
							  [ChallengeGroup groupWithName:@"Multiples of 6" 
												   withType:e_Challenge],
							  [ChallengeGroup groupWithName:@"Multiples of 7" 
												   withType:e_Challenge],
							  [ChallengeGroup groupWithName:@"Multiples of 8" 
												   withType:e_Challenge],
							  [ChallengeGroup groupWithName:@"Multiples of 9" 
												   withType:e_Challenge],
							  [ChallengeGroup groupWithName:@"Random Multiple (3-9)" 
												   withType:e_Challenge],
							  [ChallengeGroup groupWithName:@"Random Multiple (10-15)" 
												   withType:e_Challenge],
							  nil];
	return challengesMultiple;
}

+ (NSMutableArray *) challengesAddition {
	if (nil == challengesAddition)
		challengesAddition = [[NSMutableArray allocWithZone:[self zone]] 
							  initWithObjects: 
							  [ChallengeGroup groupWithName:@"Addition (10-20)" 
												   withType:e_Challenge],
							  [ChallengeGroup groupWithName:@"Addition (20-30)" 
												   withType:e_Challenge],
							  [ChallengeGroup groupWithName:@"Addition (30-40)" 
												   withType:e_Challenge],
							  [ChallengeGroup groupWithName:@"Addition (40-50)" 
												   withType:e_Challenge],
							  [ChallengeGroup groupWithName:@"Addition (50-60)" 
												   withType:e_Challenge],
							  [ChallengeGroup groupWithName:@"Addition (60-70)" 
												   withType:e_Challenge],
							  [ChallengeGroup groupWithName:@"Addition (70-80)" 
												   withType:e_Challenge],
							  [ChallengeGroup groupWithName:@"Addition (80-90)" 
												   withType:e_Challenge],
							  [ChallengeGroup groupWithName:@"Addition (90-100)" 
												   withType:e_Challenge],
							  nil];
	return challengesAddition;
}

+ (NSMutableArray *) challengesSubtraction {
	if (nil == challengesSubtraction)
		challengesSubtraction = [[NSMutableArray allocWithZone:[self zone]] 
								 initWithObjects: 
								 [ChallengeGroup groupWithName:@"Subtraction (10-20)" 
													  withType:e_Challenge],
								 [ChallengeGroup groupWithName:@"Subtraction (20-30)" 
													  withType:e_Challenge],
								 [ChallengeGroup groupWithName:@"Subtraction (30-40)" 
													  withType:e_Challenge],
								 [ChallengeGroup groupWithName:@"Subtraction (40-50)" 
													  withType:e_Challenge],
								 [ChallengeGroup groupWithName:@"Subtraction (50-60)" 
													  withType:e_Challenge],
								 [ChallengeGroup groupWithName:@"Subtraction (60-70)" 
													  withType:e_Challenge],
								 [ChallengeGroup groupWithName:@"Subtraction (70-80)" 
													  withType:e_Challenge],
								 [ChallengeGroup groupWithName:@"Subtraction (80-90)" 
													  withType:e_Challenge],
								 [ChallengeGroup groupWithName:@"Subtraction (90-100)" 
													  withType:e_Challenge],
								 nil];
	return challengesSubtraction;
}
/*
+ (NSMutableArray *) challengesMultiplication {
	if (nil == challengesMultiplication)
		challengesMultiplication = [[NSMutableArray allocWithZone:[self zone]] 
								 initWithObjects: 
								 [ChallengeGroup groupWithName:@"Multiplication Easy" 
													  withType:e_Challenge],
								 [ChallengeGroup groupWithName:@"Multiplication Normal" 
													  withType:e_Challenge],
								 [ChallengeGroup groupWithName:@"Multiplication Hard" 
													  withType:e_Challenge],
								 nil];
	return challengesMultiplication;
}

+ (NSMutableArray *) challengesDivision {
	if (nil == challengesDivision)
		challengesDivision = [[NSMutableArray allocWithZone:[self zone]] 
								 initWithObjects: 
								 [ChallengeGroup groupWithName:@"Division Easy" 
													  withType:e_Challenge],
								 [ChallengeGroup groupWithName:@"Division Normal" 
													  withType:e_Challenge],
								 [ChallengeGroup groupWithName:@"Division Hard" 
													  withType:e_Challenge],
								 nil];
	return challengesDivision;
}*/

+ (NSMutableArray *) challengesFactor {
	if (nil == challengesFactor)
		challengesFactor = [[NSMutableArray allocWithZone:[self zone]] 
							initWithObjects: 
							[ChallengeGroup groupWithName:@"Factors of 24" 
												 withType:e_Challenge],
							[ChallengeGroup groupWithName:@"Factors of 32" 
												 withType:e_Challenge],
							[ChallengeGroup groupWithName:@"Factors of 40" 
												 withType:e_Challenge],
							[ChallengeGroup groupWithName:@"Factors of 52" 
												 withType:e_Challenge],
							[ChallengeGroup groupWithName:@"Factors of 64" 
												 withType:e_Challenge],
							[ChallengeGroup groupWithName:@"Factors of 112" 
												 withType:e_Challenge],
							[ChallengeGroup groupWithName:@"Random Factor (24-64)" 
												 withType:e_Challenge],
							[ChallengeGroup groupWithName:@"Random Factor (64-128)" 
												 withType:e_Challenge],
							nil];
	return challengesFactor;
}




@end
