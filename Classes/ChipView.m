//
//  ChipView.m
//  Four
//
//  Created by Timothy Wentz on 10/18/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "ChipView.h"
#import "FourInARowGame.h"
#import "FourViewController.h"

@implementation ChipView
@synthesize game = _game;
@synthesize snappedCol = _snappedCol;
@synthesize controller = _controller;
@synthesize angle = _angle;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        [self setImage: [UIImage imageNamed:@"RedChip_40.png"]];
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

#pragma mark -
#pragma mark Touches

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([[event allTouches] count] == 1) {
		UITouch * anyTouch = [touches anyObject];
		CGPoint locationInSuperview = [anyTouch locationInView:self.superview];
        // 91 is the top of the board
        if (locationInSuperview.y + self.bounds.size.height / 2 >= 100) {
            locationInSuperview.y = self.center.y;
            
            // Cols = 7
            CGFloat min_dist = 10000.0f;
            CGFloat goto_x = 0;
            for (int i = 1; i < 8; i++) {
                NSInteger tag = 600 + i;
                UIView *icon = [self.superview viewWithTag:tag];
                CGFloat xDist = (locationInSuperview.x - icon.frame.origin.x);
                CGFloat yDist = (locationInSuperview.y - icon.frame.origin.y);
                CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
                
                if ( distance < min_dist ) {
                    min_dist = distance;
                    self.snappedCol = tag % 100;
                    goto_x = icon.center.x;
                }
            }
            locationInSuperview.x = goto_x;
        }
        if (locationInSuperview.x - self.bounds.size.width / 2 < 0 || locationInSuperview.x + self.bounds.size.width / 2 > 320) {
            locationInSuperview.x = self.center.x;
        }
        self.center = locationInSuperview;
	}	
}


- (void) toggleIcon {
    if (self.game.gameState == GAME_STATE_BLACK_TURN) {
        [self setImage:[UIImage imageNamed:@"GrayChip_40.png"]];
    }
    else if(self.game.gameState == GAME_STATE_RED_TURN) {
        [self setImage:[UIImage imageNamed:@"RedChip_40.png"]];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch * anyTouch = [touches anyObject];
    CGPoint locationInSuperview = [anyTouch locationInView:self.superview];

    if (locationInSuperview.y + self.bounds.size.height / 2 >= 100) {
        
        [UIView animateWithDuration:1.0 
                              delay:0.0 
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear 
                         animations:^ {
                             NSInteger row = [self.game getLowestEmptyRowInColumn:(self.snappedCol - 1)];
                             if (row >= 0) {
                                 NSInteger tag = (row + 1) * 100 + self.snappedCol;
                                 UIView *icon = [self.superview viewWithTag:tag];
                                 self.center = icon.center;
                                 srandom(time(NULL));
                                 self.angle = (uint64_t) random() * 360 / RAND_MAX;
                                 [self.controller addAngle:self.angle withTag:tag];
                                 self.transform = CGAffineTransformRotate(self.transform, self.angle);
                             }
                         }
                         completion:^(BOOL finished) {
                             [self.game playerPressedColumn:(self.snappedCol - 1)];                             
                             self.center = CGPointMake(160.0f, 70.0f);
                             [self toggleIcon];
                             [self.controller updateGame];
                         }];
    }
    else {
        self.center = CGPointMake(160.0f, 70.0f);
    }
    [self.game playSound:@"chipDrop" withType:@"wav"];
}
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)dealloc {
    [super dealloc];
    [_game release];
    [_controller release];
}


@end
