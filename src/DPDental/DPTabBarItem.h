//
//  DPTabBarItem.h
//  DPDental
//
//  Created by Wong Johnson on 9/9/13.
//  Copyright (c) 2013 Panfilo Mariano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPTabBarItem : UITabBarItem

@property (nonatomic, retain) UIButton *tabButton;

+ (DPTabBarItem *)tabBarItemWithButton:(UIButton *)tabButton;

@end
