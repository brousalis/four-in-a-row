//
//  FourAppDelegate.h
//  Four
//
//  Created by pete on 10/18/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FourViewController;

@interface FourAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    FourViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet FourViewController *viewController;

@end
