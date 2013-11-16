//
//  MathChallenge.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 3/1/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "MathChallenge.h"



@implementation MathChallenge
@synthesize given, given2, challengeAnswers;
@synthesize ansRange, velRange;
@synthesize challengeDifficulty, challengeType;
@synthesize seconds, numCorrect, ptsCorrect, ptsIncorrect;
@synthesize releaseSpeed,percentCorrect;
@synthesize gameImage;
@synthesize challengeName, challengeText;

- (id) init {
	if (self = [super init]) {
		currentChallenge = @selector(number:isMultipleOf:);
		ansRange = [[MyRange alloc] init];
		velRange = [[MyRange alloc] init];
		given = [[NSNumber alloc] initWithInt:2];
		challengeAnswers = [[NSMutableArray alloc] init];
		gameImage = [[UIImage alloc] initWithContentsOfFile:@"game_bg.png"];
		challengeText = [[NSMutableString alloc] initWithCapacity:1000];
		challengeName = [[NSMutableString alloc] initWithCapacity:30];
	}
	return self;
}

//randomly return NSOrderedAscending, NSOrderedSame, NSOrderedDecending
int randomSort(id obj1, id obj2, void *context ) {
	// returns random number -1 0 1 or NSOrderedAscending, NSOrderedSame, NSOrderedDecending
	return (random()%3 - 1);	
}

- (void)randomize:(NSMutableArray*) array {
	// call custom sort function
	[array sortUsingFunction:randomSort context:nil];
}

- (NSString*) getChallengeString {
	switch (self.challengeType) {
		case ChallengeRandomFactor:
			return [NSString stringWithFormat:@"Factors Of %d!",[self.given intValue]];
		case ChallengeRandomMultiple:
			return [NSString stringWithFormat:@"Multiples Of %d!",[self.given intValue]];
		case ChallengeAddition:
			return [NSString stringWithFormat:@"A + B = %d!",[self.given intValue]];
		case ChallengeSubtraction:
			return [NSString stringWithFormat:@"A - B = %d!",[self.given intValue]];
		case ChallengeMultiplication:
			return [NSString stringWithFormat:@"%d x %d = ?",[self.given intValue],[self.given2 intValue]];
		case ChallengeDivision:
			return [NSString stringWithFormat:@"%d ÷ %d = ?",[self.given intValue],[self.given2 intValue]];
            
        default:
            break;
	}
	return self.challengeName;
}

- (void) setChallenge:(ChallengeType) newType withGiven:(NSNumber*) aGiven {
	self.challengeType = newType;
	self.given = aGiven;
	switch (newType) {
		case ChallengeRandomFactor:
		case ChallengeFactors:
			currentChallenge = @selector(isFactor:);
			[self.challengeName setString:[NSMutableString stringWithFormat:@"Factors of %d",[aGiven intValue]]];
			break;
		case ChallengeEvens:
			currentChallenge = @selector(isMultiple:);
			self.challengeName = [NSMutableString stringWithString:@"Even Numbers"];
			break;
		case ChallengeOdds:
			currentChallenge = @selector(isNotMultiple:);
			self.challengeName = [NSMutableString stringWithString:@"Odd Numbers"];
			break;
		case ChallengeRandomMultiple:
		case ChallengeMultiple:
			currentChallenge = @selector(isMultiple:);
			self.challengeName = [NSMutableString stringWithFormat:@"Multiples of %d",[aGiven intValue]];
			break;
		case ChallengeColor:
			currentChallenge = @selector(isColor:);
			BalloonColor bc = (BalloonColor) [aGiven intValue];
			switch (bc) {
				case kColorRed:
					self.challengeName = [NSMutableString stringWithString:@"Red Balloons"];
					break;
				case kColorBlue:
					self.challengeName = [NSMutableString stringWithString:@"Blue Balloons"];
					break;
				case kColorGreen:
					self.challengeName = [NSMutableString stringWithString:@"Green Balloons"];
					break;
				case kColorYellow:
					self.challengeName = [NSMutableString stringWithString:@"Yellow Balloons"];
					break;
				default:
					self.challengeName = [NSMutableString stringWithString:@"Yellow Balloons"];
					break;
			}
			break;
		case ChallengeAddition:
			currentChallenge = @selector(isEqualAddition:);
			self.challengeName = [NSMutableString stringWithFormat:@"A + B = %d",[aGiven intValue]];
			break;
		case ChallengeSubtraction:
			currentChallenge = @selector(isEqualSubtraction:);
			self.challengeName = [NSMutableString stringWithFormat:@"A - B = %d",[aGiven intValue]];
			break;
        default:
            break;
	}
}

- (void) setChallenge:(ChallengeType) newType withGiven:(NSNumber*) aGiven withGiven:(NSNumber *) bGiven {
	self.challengeType = newType;
	self.given = aGiven;
	self.given2 = bGiven;
	switch (newType) {
		case ChallengeMultiplication:
			currentChallenge = @selector(isEqualMultiplication:);
			self.challengeName = [NSMutableString stringWithFormat:@"%d x %d = ?",[given intValue], [given2 intValue]];
			break;
		case ChallengeDivision:
			currentChallenge = @selector(isEqualDivision:);
			self.challengeName = [NSMutableString stringWithFormat:@"%d / %d = ?",[given intValue], [given2 intValue]];
			break;
            
        default:
            break;
	}

	
}
- (int) getBalloonSpeed {
	int diff = velRange.max - velRange.min;
	return (random()%(diff + 1) + velRange.min );	
}

- (NSArray*) splitString: (NSString *) ansStr {
	return [ansStr componentsSeparatedByCharactersInSet:
			[NSCharacterSet characterSetWithCharactersInString:@" +-"]];
}

- (BOOL) isCorrectAnswer: (NSString *) ansStr {
	BOOL iscorrect = NO;
	if (challengeType == ChallengeAddition || challengeType == ChallengeSubtraction) {
		iscorrect = ([self performSelector:currentChallenge 
								withObject:[self splitString:ansStr]] == NSOrderedSame ) ? YES: NO;
	} 
	else {
		NSNumber *num = [NSNumber numberWithInt:[ansStr intValue]];
		iscorrect = ([self performSelector:currentChallenge 
								withObject:num] == NSOrderedSame ) ? YES: NO;
	}

	return iscorrect;
}

-(NSString*) generateCorrectEquationStringForAnswer: (int) answer {
	NSString *temp = [NSString string];
//	int diff = ansRange.max - ansRange.min;
//	NSNumber* randomNum = [NSNumber numberWithInt:((random()%diff) + ansRange.min)];
	NSNumber* var1;
	int variable = 0;
	switch (challengeType) {
		case ChallengeAddition:
			var1 = [NSNumber numberWithInt:(random()%(answer+1))];
			variable = answer - [var1 intValue];
			temp = [NSString stringWithFormat:@"%d + %d", variable, [var1 intValue]];
			break;
		case ChallengeSubtraction:
			var1 = [NSNumber numberWithInt:((random()%(answer+1)) + answer)];
			variable = [var1 intValue] - answer; 
			temp = [NSString stringWithFormat:@"%d - %d", [var1 intValue], variable];
			break;
			
		default:
			break;
	}
	return temp;
}

-(void) generateNumAnswers:(int) total {
	[challengeAnswers removeAllObjects];
	
	int correct = numCorrect;
	int numIncorrect = total-numCorrect;
	BOOL isFirst = YES;
	int correctAnswer = 0;
	if (challengeType == ChallengeMultiplication) {
		correctAnswer = [given intValue] * [given2 intValue];
	} else if (challengeType == ChallengeDivision) {
		correctAnswer = [given intValue] / [given2 intValue];
	}
	//keep generating answers until numCorrect count is reached
	while (1) {
		int diff = ansRange.max - ansRange.min;
		NSString *randomObj;
		BOOL iscorrect = NO;
		if (challengeType == ChallengeAddition  || challengeType==ChallengeSubtraction) {
			int randomNearAnswer = (random()%8 - 4) + [given intValue];
			randomObj = [self generateCorrectEquationStringForAnswer: randomNearAnswer];
			
		} else if (challengeType == ChallengeMultiplication || challengeType == ChallengeDivision) {
			if (isFirst) {
				randomObj = [NSString stringWithFormat:@"%d",correctAnswer]; 
				isFirst = NO;
			} else {
				int randomNearAnswer = (random()%20 - 10) + correctAnswer;
				if (randomNearAnswer<0) {
					randomNearAnswer*=-1;
				}
				randomObj = [NSString stringWithFormat:@"%d",randomNearAnswer];
			}
		}  else {
			int randomNumberInRange = (random()%diff) + ansRange.min;
			randomObj = [NSString stringWithFormat:@"%d",randomNumberInRange];
		}
		iscorrect = [self isCorrectAnswer:randomObj];

		// first add only correct answers
		if (iscorrect && correct != 0)	{
			[challengeAnswers addObject:randomObj];
			correct--;
		} 
		// next add incorrect answers until challengeAnswers count == total
		if ( !iscorrect && numIncorrect != 0){
			[challengeAnswers addObject:randomObj];
			numIncorrect--;
		}
		// break if we have a full answer array
		if ( [challengeAnswers count] == total ) {
			break;
		}
		//randomint = nil;
	}
	[self randomize:challengeAnswers];
}

- (NSComparisonResult) isEqualAddition: (NSObject*) testArray {
	NSArray *arr = (NSArray*) testArray;
	int sum = 0;
	for (NSString *str in arr) {
		sum += [str intValue];
	}
	return ([given intValue]==sum) ? NSOrderedSame : NSOrderedAscending;
}
- (NSComparisonResult) isEqualSubtraction: (NSObject*) testArray {
	NSArray *arr = (NSArray*) testArray;
	int sum = [[arr objectAtIndex:0] intValue];
	for (int i=1; i<[arr count]; i++) {
		sum -= [[arr objectAtIndex:i] intValue];
	}
	return ([given intValue]==sum) ? NSOrderedSame : NSOrderedAscending;
}
- (NSComparisonResult) isEqualMultiplication: (NSObject*) testnum {
	return (([self.given intValue]*[self.given2 intValue]) == [(NSNumber*)testnum intValue]) ? NSOrderedSame : NSOrderedAscending;
}
- (NSComparisonResult) isEqualDivision: (NSObject*) testnum {
	return (([self.given intValue]/[self.given2 intValue]) == [(NSNumber*)testnum intValue]) ? NSOrderedSame : NSOrderedAscending;
}
- (NSComparisonResult) isFactor: (NSObject*) testnum {
	return ([self.given intValue]%[(NSNumber*)testnum intValue] == 0) ? NSOrderedSame : NSOrderedAscending;
}

- (NSComparisonResult) isMultiple: (NSObject*) testnum {
	return ([(NSNumber*)testnum intValue]%[self.given intValue] == 0) ? NSOrderedSame : NSOrderedAscending;
}

- (NSComparisonResult) isNotMultiple: (NSObject*) testnum {
	return ([(NSNumber*)testnum intValue]%[self.given intValue] != 0) ? NSOrderedSame : NSOrderedAscending;
}

- (NSComparisonResult) isColor: (NSObject*) testnum {
	return ([(NSNumber*)testnum intValue] == [self.given intValue]) ? NSOrderedSame : NSOrderedAscending;
}

// O(num)
+ (BOOL) isPrime: (unsigned int) num {
	int i=2;
	while (num%i!=0 && i<=num) {
		i++;
	}
	if (i>=num)
		return YES;
	return NO;
}

//- (NSComparisonResult) isPrimeFactor: (int) testnum {
//	
//}

- (void) dealloc {
	[challengeName release];
	[challengeText release];
	[ansRange release];
	[velRange release];
	[challengeAnswers release];
	[given release];
	[given2 release];
	[gameImage release];
	[super dealloc];
}


@end
