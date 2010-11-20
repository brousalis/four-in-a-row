//
//  FourViewController.m
//  Four
//
//  Created by pete on 10/18/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "FourViewController.h"
#import "FourInARowGame.h"
#import "ChipView.h"

@implementation FourViewController
@synthesize gameStatusLabel = _gameStatusLabel;
@synthesize game = _game;
@synthesize gameReset = _gameReset;
@synthesize angles = _angles;

- (NSString *) _gameStateAsString
{
	switch (self.game.gameState) {
		case GAME_STATE_RED_TURN:
			return @"Red's Turn";
			break;
		case GAME_STATE_BLACK_TURN:
			return @"Black's Turn";
			break;
		case GAME_STATE_RED_WON:
			return @"Red Won";
			break;
		case GAME_STATE_BLACK_WON:
			return @"Black Won";
			break;
		case GAME_STATE_TIE:
			return @"It's a Tie";
			break;
		default:
			return @"Error";
			break;
	}
}

- (void)updateGame {
    self.gameStatusLabel.text = [self _gameStateAsString];
    UIImageView *icon = nil;
    NSInteger tag = nil;
    for (int row=0; row < NUM_ROWS; row++) {
		for (int col=0; col < NUM_COLS; col++) {
            enFourInARowMark_t mark = [self.game getMarkInRow:row column:col];
            NSInteger tag = (row + 1) * 100 + col + 1;
            icon = (UIImageView*)[self.view viewWithTag:tag];            
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0];
            icon.transform = CGAffineTransformRotate(icon.transform, [[self.angles objectForKey:[NSNumber numberWithInt:tag]] floatValue]);
            [UIView commitAnimations];

            if (mark == MARK_BLACK) {
                [icon setImage:[UIImage imageNamed:@"GrayChip_40.png"]];
            }
            else if (mark == MARK_RED) {
                [icon setImage:[UIImage imageNamed:@"RedChip_40.png"]];
            }
            else if (mark == MARK_RED_USED_IN_WIN ) {
                icon.animationImages = [NSArray arrayWithObjects:    
                                                [UIImage imageNamed:@"YellowChip_40.png"],
                                                [UIImage imageNamed:@"RedChip_40.png"], nil];
                icon.animationDuration = 1.75;
                icon.animationRepeatCount = 0;
                [icon startAnimating];
            }
            else if (mark == MARK_BLACK_USED_IN_WIN) {
                icon.animationImages = [NSArray arrayWithObjects:    
                                        [UIImage imageNamed:@"YellowChip_40.png"],
                                        [UIImage imageNamed:@"GrayChip_40.png"], nil];
                icon.animationDuration = 1.75;
                icon.animationRepeatCount = 0;
                [icon startAnimating];                
            }

		}
	}
 
    [self.view setNeedsDisplay];
}

- (void) addAngle:(float)angle withTag:(NSInteger)tag {
    self.angles = [NSMutableDictionary dictionary];
    [self.angles setObject:[NSNumber numberWithFloat:angle]
                    forKey:[NSNumber numberWithInt:tag]];
    NSLog(@"TAG: %d and ANGLE: %0.2f", tag, angle);
}

- (IBAction) resetGame:(id)sender {
    for (int row=0; row < NUM_ROWS; row++) {
		for (int col=0; col < NUM_COLS; col++) {
            enFourInARowMark_t mark = [self.game getMarkInRow:row column:col];
            if(mark == MARK_RED || 
               mark == MARK_BLACK || 
               mark == MARK_BLACK_USED_IN_WIN || 
               mark == MARK_RED_USED_IN_WIN ) {
                NSInteger tag = (row + 1) * 100 + col + 1;
                UIImageView *icon = (UIImageView *)[self.view viewWithTag:tag];
                CGPoint old = icon.center;
                [UIView animateWithDuration:0.8 
                                      delay:0.0 
                                    options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear 
                                 animations:^ {
                                     CGPoint center = icon.center;
                                     center.y = (CGFloat)(icon.center.y + 1000);
                                     icon.center = center;
                                 }
                                 completion:^(BOOL finished) {
                                    [icon setImage:[UIImage imageNamed:@""]];
                                    icon.center = old; 
                                 }];
            }
		}
	}
    [self.game resetBoard];
    ChipView *theChip = (ChipView*)[self.view viewWithTag:777];
    [theChip setImage:[UIImage imageNamed:@"RedChip_40.png"]];
    self.gameStatusLabel.text = [self _gameStateAsString];
}

- (void)viewDidLoad {
    self.game = [[FourInARowGame alloc] init];
    
    ChipView * newChip = [[ChipView alloc] initWithFrame:CGRectMake(30.0f, 30.0f, 40.0f, 40.0f)];
    newChip.game = self.game;
    newChip.tag = 777;
    newChip.controller = self;
    [self.view addSubview:newChip];
    newChip.center = CGPointMake(160.0f, 70.0f);
    [self updateGame];
    
    UIView *boardView = [self.view viewWithTag:888];
    [self.view bringSubviewToFront:boardView];
    
    self.angles = [NSMutableDictionary dictionary];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    self.gameStatusLabel = nil;
    self.game = nil;
    self.gameReset = nil;
    self.angles = nil;
}

- (void)dealloc {
    [super dealloc];
    [_gameStatusLabel release];
    [_game release];
    [_gameReset release];
    [_angles release];
}

@end
