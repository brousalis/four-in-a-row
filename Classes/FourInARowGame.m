//
//  FourInARowGame.m
//  Four in a Row
//
//  Created by Timothy Wentz on 10/3/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

// New

#import "FourInARowGame.h"

@interface FourInARowGame()
- (void) _checkForWinner;
- (BOOL) _didMarkWin:(enFourInARowMark_t) markType;
- (BOOL) _isBoardFull;
@end

@implementation FourInARowGame

@synthesize gameState;

- (void)playSound:(NSString *) name withType:(NSString *) type {
    SystemSoundID soundID; 
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:filePath], &soundID);
    AudioServicesPlaySystemSound(soundID);
}

- (enFourInARowMark_t) getMarkInRow:(NSInteger)aRow column:(NSInteger)aColumn {
    if (aRow >= NUM_ROWS || aColumn >= NUM_COLS || aRow < 0 || aColumn < 0) {
        return 0;
    }
    return gameBoard[aRow][aColumn];
}

- (void) playerPressedColumn:(NSInteger)aColumn {
    NSLog(@"Player pressed column=%d",(int)aColumn);
    if (aColumn >= NUM_COLS || aColumn < 0) {
        return;
    }
    if (gameBoard[NUM_ROWS - 1][aColumn] != MARK_NONE) {
        return;
    }
    if (self.gameState == GAME_STATE_BLACK_TURN) {
        gameBoard[[self getLowestEmptyRowInColumn:aColumn]][aColumn] = MARK_BLACK;
        gameState = GAME_STATE_RED_TURN;
    }
    else if (self.gameState == GAME_STATE_RED_TURN) {
        gameBoard[[self getLowestEmptyRowInColumn:aColumn]][aColumn] = MARK_RED;
        gameState = GAME_STATE_BLACK_TURN;
    }
    [self playSound:@"chipDrop" withType:@"wav"];
    [self _checkForWinner];
}

- (void) resetBoard {
	int row,col;
	for (row=0; row < NUM_ROWS; row++) {
		for (col=0; col < NUM_COLS; col++) {
			gameBoard[row][col] = MARK_NONE;
		}
	}
	gameState = GAME_STATE_RED_TURN;
    [self playSound:@"resetSound" withType:@"aif"];
}

- (NSInteger) getLowestEmptyRowInColumn:(NSInteger)aColumn {
    for(int i = 0; i < NUM_ROWS; i++) {
        if (gameBoard[i][aColumn] == MARK_NONE) {
            return i;
        }
    }
    return -1;
}

- (void) _checkForWinner {
    if ([self _didMarkWin:MARK_RED]) {
		//NSLog(@"RED won the game");
		gameState = GAME_STATE_RED_WON;
        [self playSound:@"win" withType:@"wav"];
	}
	else if ([self _didMarkWin:MARK_BLACK]) {
		//NSLog(@"BLACK won the game");
		gameState = GAME_STATE_BLACK_WON;
        [self playSound:@"win" withType:@"wav"];
	}
	else if ([self _isBoardFull]) {
		//NSLog(@"Cat");
		gameState = GAME_STATE_TIE;
	}
}

- (BOOL) _didMarkWin:(enFourInARowMark_t)markType {
    BOOL marksMatchType;
	int row, col, num, diag;

	// Check all the rows
	for ( row = 0; row < NUM_ROWS; row++ ) {
		for ( col = 0; col < NUM_COLS - 3; col++ ) {
            marksMatchType = YES;
            
            // Check 4 in a row
            for ( num = col; num < col + 4; num++ ) {
                if (markType != gameBoard[row][num])
                    marksMatchType = NO;
            }
            // If we found a match
            if (marksMatchType) {
                // Highlight the winning match
                for ( num = col; num < col + 4; num++ ) {
                    if (markType == MARK_RED)
                        gameBoard[row][num] = MARK_RED_USED_IN_WIN;
                    else
                        gameBoard[row][num] = MARK_BLACK_USED_IN_WIN;
                }
                return YES;
            }
		}
	}
	
	// Check all the columns
	for ( col = 0; col < NUM_COLS; col++ ) {
		for ( row = 0; row < NUM_ROWS - 3; row++ ) {
            marksMatchType = YES;
            
            // Check 4 in a row
            for ( num = row; num < row + 4; num++ ) {
                if (markType != gameBoard[num][col])
                    marksMatchType = NO;
            }
            // If we found a match
            if (marksMatchType) {
                // Highlight the winning match
                for ( num = row; num < row + 4; num++ ) {
                    if (markType == MARK_RED)
                        gameBoard[num][col] = MARK_RED_USED_IN_WIN;
                    else
                        gameBoard[num][col] = MARK_BLACK_USED_IN_WIN;
                }
                return YES;
            }
		}
	}
	
	// Check the down diagonal
	for ( row = 3; row < NUM_ROWS; row++ ) {
		for ( col = 0; col < NUM_COLS - 3; col++ ) {
            marksMatchType = YES;
            
            // Check for 4 in a row
            diag = 0;
            for ( num = col; num < col + 4; num++ ) {
                if (markType != gameBoard[row - diag++][num])
                    marksMatchType = NO;
            }
            // If we found a match
            if (marksMatchType) {
                // Highlight the winning match
                diag = 0;
                for ( num = col; num < col + 4; num++ ) {
                    if (markType == MARK_RED)
                        gameBoard[row - diag++][num] = MARK_RED_USED_IN_WIN;
                    else
                        gameBoard[row - diag++][num] = MARK_BLACK_USED_IN_WIN;
                }
                return YES;
            }
		}
	}
    
	// Check the up diagonal
	for ( row = 0; row < NUM_ROWS - 3; row++ ) {
		for ( col = 0; col < NUM_COLS - 3; col++ ) {
            marksMatchType = YES;
            
            // Check for 4 in a row
            diag = 0;
            for ( num = col; num < col + 4; num++ ) {
                if (markType != gameBoard[row + diag++][num])
                    marksMatchType = NO;
            }
            // If we found a match
            if (marksMatchType) {
                // Highlight the winning match
                diag = 0;
                for ( num = col; num < col + 4; num++ ) {
                    if (markType == MARK_RED)
                        gameBoard[row + diag++][num] = MARK_RED_USED_IN_WIN;
                    else
                        gameBoard[row + diag++][num] = MARK_BLACK_USED_IN_WIN;
                }
                return YES;
            }
		}
	}
	
	return NO; // No winner.  Checked all possible wins.
}

- (BOOL) _isBoardFull {
	int i,j;
	//NSLog(@"is board full");
	for ( i = 0; i<NUM_ROWS; i++) {
		for ( j = 0; j<NUM_COLS; j++) {
			if (gameBoard[i][j] == MARK_NONE) {
				//NSLog(@"Found a blank at %d %d", i,j);
				return NO;
			}
		}
	}
	//NSLog(@"Tie game");
	return YES; // No blanks found.  The board is full.
}
@end