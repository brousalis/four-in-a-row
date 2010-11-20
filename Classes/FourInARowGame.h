//
//  FourInARowGame.h
//  Four in a Row
//
//  Created by Timothy Wentz on 10/3/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#define NUM_ROWS 6
#define NUM_COLS 7
#define CONSECUTIVE_MARKS_NEEDED_TO_WIN 4

typedef enum {
	MARK_NONE,
	MARK_RED,
	MARK_BLACK,
	MARK_RED_USED_IN_WIN,
	MARK_BLACK_USED_IN_WIN
} enFourInARowMark_t;

typedef enum {
	GAME_STATE_RED_TURN,
	GAME_STATE_BLACK_TURN,
	GAME_STATE_RED_WON,
	GAME_STATE_BLACK_WON,
	GAME_STATE_TIE
} enFourInARowGameState_t;

@interface FourInARowGame : NSObject {
	enFourInARowGameState_t gameState;
	enFourInARowMark_t gameBoard[NUM_ROWS][NUM_COLS];
}
@property (readonly) enFourInARowGameState_t gameState;
- (enFourInARowMark_t) getMarkInRow:(NSInteger) aRow column:(NSInteger) aColumn;
- (NSInteger) getLowestEmptyRowInColumn:(NSInteger) aColumn;
- (void) playerPressedColumn:(NSInteger) aColumn;
- (void)playSound:(NSString *) name withType:(NSString *) type;
- (void) resetBoard;
@end