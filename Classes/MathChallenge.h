//
//  MathChallenge.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 3/1/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyRange.h"

typedef enum  {
	ChallengeEvens,
	ChallengeOdds,
	ChallengeFactors,
	ChallengeRandomFactor,
	ChallengeMultiple,
	ChallengeRandomMultiple,
	ChallengeColor,
	ChallengeAddition,
	ChallengeSubtraction,
	ChallengeMultiplication,
	ChallengeDivision,
	ChallengeCount
} ChallengeType;

typedef enum  {
	e_Colors,
	e_OddsAndEvens,
	e_Addition,
	e_Subtraction,
	e_Multiplication,
	e_Division,
	e_Multiples,
	e_Factors,
	e_ChallengeGroupTypeTotal
} ChallengeGroupType;

typedef enum {
	DifficultyEasy,
	DifficultyNormal,
	DifficultyHard
} ChallengeDifficulty;

typedef enum {
	kColorBlue,
	kColorYellow,
	kColorRed,
	kColorGreen,
	kColorTotal
} BalloonColor;

@interface MathChallenge : NSObject {
	//a number that can be used for the challenge
	NSNumber *given;
	NSNumber *given2;
//	EquationType equationType;
	//total list of answers
	NSMutableArray *challengeAnswers;
	UIImage *gameImage;
	//number of correct answers
	int numCorrect;
	//seconds for challenge
	int seconds;
	//points for correct answer
	int ptsCorrect;
	//points for incorrect answer
	int ptsIncorrect;
	//speed at which balloons are released
	float releaseSpeed;
	//percentage you need to be correct to win
	float percentCorrect;
	//difficulty for this challenge
	ChallengeDifficulty challengeDifficulty;
	//type of challenge
	ChallengeType challengeType;

	//gives a min and max velocity
	MyRange *velRange;
	//gives a min and max answer range
	MyRange *ansRange;
	NSMutableString *challengeName;
	NSMutableString *challengeText;
	BOOL isLocked;
	//current challenge
	SEL currentChallenge;
}

@property (nonatomic,retain) UIImage *gameImage;
@property (nonatomic,retain) NSMutableString *challengeName;
@property (nonatomic,retain) NSMutableString *challengeText;

@property (nonatomic,retain) NSNumber *given;
@property (nonatomic,retain) NSNumber *given2;
@property (nonatomic,retain) NSMutableArray *challengeAnswers;
@property (nonatomic) int seconds;
@property (nonatomic) int numCorrect;
@property (nonatomic) int ptsCorrect;
@property (nonatomic) int ptsIncorrect;
@property (nonatomic) float releaseSpeed;
@property (nonatomic) float percentCorrect;

@property (nonatomic) ChallengeDifficulty challengeDifficulty;
@property (nonatomic,retain) MyRange *velRange;
@property (nonatomic,retain) MyRange *ansRange;
@property (nonatomic) ChallengeType challengeType;

- (int) getBalloonSpeed;

- (void) setChallenge:(ChallengeType) newType withGiven:(NSNumber*) aGiven;
- (void) setChallenge:(ChallengeType) newType withGiven:(NSNumber*) aGiven withGiven:(NSNumber *) bGiven;

- (NSString*) getChallengeString;

- (void) generateNumAnswers:(int) total;

- (BOOL) isCorrectAnswer: (NSString*) number;

- (NSComparisonResult) isFactor: (NSObject*) testnum;

- (NSComparisonResult) isMultiple: (NSObject*) testnum;

- (NSComparisonResult) isNotMultiple: (NSObject*) testnum;

- (NSComparisonResult) isColor: (NSObject*) testnum;

+ (BOOL) isPrime: (unsigned int) num;

//- (NSComparisonResult) isPrimeFactor: (int) testnum;

@end
