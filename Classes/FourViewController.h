//
//  FourViewController.h
//  Four
//
//  Created by pete on 10/18/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FourInARowGame;

@interface FourViewController : UIViewController {
    UILabel *_gameStatusLabel;
    FourInARowGame *_game;
    UIButton *_gameReset;
    NSMutableDictionary *_angles;
}

@property (nonatomic, retain) IBOutlet UILabel *gameStatusLabel;
@property (nonatomic, retain) IBOutlet UIButton *gameReset;
@property (nonatomic, retain) FourInARowGame *game;
@property (nonatomic, retain) NSMutableDictionary *angles;

- (void) addAngle:(CGFloat)angle withTag:(NSInteger)tag;
- (void)updateGame;
- (IBAction) resetGame:(id)sender;

@end
