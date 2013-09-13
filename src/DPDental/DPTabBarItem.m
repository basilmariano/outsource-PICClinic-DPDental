//
//  DPTabBarItem.m
//  DPDental
//
//  Created by Wong Johnson on 9/9/13.
//  Copyright (c) 2013 Panfilo Mariano. All rights reserved.
//

#import "DPTabBarItem.h"

@implementation DPTabBarItem

- (void)dealloc
{
    [_tabButton release];
    [super dealloc];
}

+ (DPTabBarItem *)tabBarItemWithButton:(UIButton *)tabButton
{
    DPTabBarItem *item = [[DPTabBarItem alloc] init];
    item.tabButton = tabButton;
    return [item autorelease];
}

@end
