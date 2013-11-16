//
//  GroupFactory.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChallengeGroup.h"

@interface GroupFactory : NSObject {
}

+ (NSMutableArray *) games;
+ (NSMutableArray *) progressions;
+ (NSMutableArray *) challengesOandE;
+ (NSMutableArray *) challengesMultiple;
+ (NSMutableArray *) challengesFactor;
+ (NSMutableArray *) challengesAddition;
+ (NSMutableArray *) challengesSubtraction;
//+ (NSMutableArray *) challengesMultiplication;
//+ (NSMutableArray *) challengesDivision;
+ (NSMutableArray *) challengesColor;

//key - level
//value - levelname
+ (NSMutableDictionary *) challenges;

+ (NSMutableArray *) mathgroups;
+ (NSMutableArray *) challengesSimple;
+ (NSMutableArray *) challengesThrees;
+ (NSMutableArray *) challengeMultiply;
+ (NSMutableArray *) challengeFactoring;
+ (NSMutableArray *) challengeAdd;
+ (NSMutableArray *) challengeSubtract;
+ (NSMutableArray *) challengeHard;


@end
