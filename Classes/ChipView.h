//
//  ChipView.h
//  Four
//
//  Created by Timothy Wentz on 10/18/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FourInARowGame;
@class FourViewController;

@interface ChipView : UIImageView {
    FourInARowGame *_game;
    NSInteger _snappedCol;
    float _angle;
    FourViewController *_controller;
}
@property (nonatomic, retain) FourInARowGame *game;
@property (nonatomic) NSInteger snappedCol;
@property (nonatomic) float angle;
@property (nonatomic, retain) FourViewController *controller;

@end
