//
//  DPAppDelegate.h
//  DPDental
//
//  Created by Wong Johnson on 9/4/13.
//  Copyright (c) 2013 Panfilo Mariano. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DPViewController;

@interface DPAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) DPViewController *viewController;

@end
