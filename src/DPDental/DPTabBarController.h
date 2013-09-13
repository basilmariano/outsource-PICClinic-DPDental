//
//  DPTabBarController.h
//  DPDental
//
//  Created by Wong Johnson on 9/9/13.
//  Copyright (c) 2013 Panfilo Mariano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPTabBarController : UITabBarController

@property (nonatomic, assign) UINavigationController *navController;
@property (nonatomic, retain) UIImageView *tabBarBackgroundImageView;
@property (nonatomic, retain) NSArray *utilityViews;

- (id)initWithTabBarBackgroundImage:(UIImage *)backgroundImage;
- (id)initWithScrollViewTabImage: (UIImage *) backgroundImage withScrollViewContentSize: (CGSize)scrollContentSize
          andScrollViewPositionY: (float) scrollPositionY
             andScrollViewHeight: (float) scrollViewHeight;

- (void)hideTabBar;
- (void)showTabBar;

@end
