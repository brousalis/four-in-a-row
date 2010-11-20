//
//  FourInARowGameTests.m
//  FourInARowSolution
//
//  Created by David Fisher on 9/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FourInARowGameTests.h"

#define gameStateKey @"GameState"
#define gameBoardKey @"GameBoard"

@implementation FourInARowGameTests

- (NSString *) _gameStateAsString:(enFourInARowGameState_t) gameStateEnum
{
	switch (gameStateEnum) {
		case GAME_STATE_RED_TURN:
			return @"GAME_STATE_RED_TURN";
			break;
		case GAME_STATE_BLACK_TURN:
			return @"GAME_STATE_BLACK_TURN";
			break;
		case GAME_STATE_RED_WON:
			return @"GAME_STATE_RED_WON";
			break;
		case GAME_STATE_BLACK_WON:
			return @"GAME_STATE_BLACK_WON";
			break;
		case GAME_STATE_TIE:
			return @"GAME_STATE_TIE";
			break;
		default:
			return @"Invalid game state";
			break;
	}
}
- (NSString *) _markTypeAsString:(enFourInARowMark_t) markTypeEnum
{
	switch (markTypeEnum) {
		case MARK_NONE:
			return @"MARK_NONE";
			break;
		case MARK_RED:
			return @"MARK_RED";
			break;
		case MARK_BLACK:
			return @"MARK_BLACK";
			break;
		case MARK_RED_USED_IN_WIN:
			return @"MARK_RED_USED_IN_WIN";
			break;
		case MARK_BLACK_USED_IN_WIN:
			return @"MARK_BLACK_USED_IN_WIN";
			break;
		default:
			return @"Invalid mark type";
			break;
	}
}

- (void) setUp
{
	game = [[FourInARowGame alloc] init];
}
- (void) tearDown
{
	[game release];
}
- (void) testRunningTests
{
	//STFail(@"Test are running");
}

- (void) testManualTests
{
	STAssertEquals(game.gameState, GAME_STATE_RED_TURN, @"Wrong ending state");
	STAssertEquals([game getLowestEmptyRowInColumn:2], (NSInteger) 0, @"Lowest row wrong");
	[game playerPressedColumn:2];
	STAssertEquals(game.gameState, GAME_STATE_BLACK_TURN, @"Wrong ending state");
	STAssertEquals([game getLowestEmptyRowInColumn:2], (NSInteger) 1, @"Lowest row wrong");
}

- (void) testPropertyListBoards
{
	NSDictionary * gameBoardsDict;

	//Seems like this should've worked just fine, but the gameBoardPath was nil.  So I made the more robust bundle searcher approach below to get the plist.
	//	NSString * gameBoardsPath = [[NSBundle mainBundle] pathForResource:@"FourInARowTestBoards" ofType:@"plist"];
	//	NSLog(@"Path = %@",gameBoardsPath);
	//	gameBoardsDict = [[NSDictionary alloc] initWithContentsOfFile:gameBoardsPath];
	//	NSLog(@"Dictionary = %@", gameBoardsDict);
	
	for (NSBundle *bundle in [NSBundle allBundles]) {  // Search all bundles for the resource (I had trouble with just using mainBundle)
		NSString * gameBoardsPath = [bundle pathForResource:@"FourInARowTestBoards" ofType:@"plist"];
		if (gameBoardsPath) {
			NSLog(@"Got the %@ plist", gameBoardsPath);
			gameBoardsDict = [[NSDictionary alloc] initWithContentsOfFile:gameBoardsPath];
			break;
		}
	}
	
	for (NSString * key in [gameBoardsDict allKeys]) {
		NSLog(@"Checking game %@",key);
		[game resetBoard];  // Prepare for the new game
		NSDictionary * fourInARowGame = [gameBoardsDict objectForKey:key];  // Grab the new game from the plist
		enFourInARowGameState_t expectedEndState = [[fourInARowGame objectForKey:gameStateKey] intValue];
		NSArray * gameBoardPieces = [fourInARowGame objectForKey:gameBoardKey];    // Build the board from the pieces
		
		// Place the pieces
		for (NSArray * aPiece in gameBoardPieces) {
			NSInteger column = [[aPiece objectAtIndex:1] intValue];
			[game playerPressedColumn:column];
		}
		
		// Check the game state
		STAssertEquals(game.gameState, expectedEndState, @"Wrong ending state for %@ (was %@, should be %@)", key, [self _gameStateAsString:game.gameState], [self _gameStateAsString:expectedEndState]);
		
		// Check all the pieces
		for (NSArray * aPiece in gameBoardPieces) {
			NSInteger row = [[aPiece objectAtIndex:0] intValue];
			NSInteger column = [[aPiece objectAtIndex:1] intValue];
			enFourInARowMark_t markType = (enFourInARowMark_t) [[aPiece objectAtIndex:2] intValue];
			NSLog(@"Check Piece:  Game %@ - Row %d Column %d Mark %d",key,row,column,markType);
			STAssertEquals([game getMarkInRow:row column:column], markType, @"Game %@ - Row %d Column %d was not %@", key, row, column, [self  _markTypeAsString:markType]);
		}
	}
}

@end
