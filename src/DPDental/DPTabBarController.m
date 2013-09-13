//
//  DPTabBarController.m
//  DPDental
//
//  Created by Wong Johnson on 9/9/13.
//  Copyright (c) 2013 Panfilo Mariano. All rights reserved.
//

#import "DPTabBarController.h"
#import "DPNavigationController.h"
#import "DPTabBarItem.h"
#import "XCDeviceManager.h"

@interface DPTabBarController ()

@property (nonatomic, retain) UINavigationItem *navItem;
@property (nonatomic, retain) UIScrollView *scrollView;

@end

@implementation DPTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTabBarBackgroundImage:(UIImage *)backgroundImage
{
    if ((self = [super init])) {
        
        self.tabBarBackgroundImageView = [[[UIImageView alloc] init] autorelease];
        [_tabBarBackgroundImageView setImage: backgroundImage];
    }
    
    return (self);
}

- (id)initWithScrollViewTabImage: (UIImage *) backgroundImage withScrollViewContentSize: (CGSize)scrollContentSize
          andScrollViewPositionY: (float) scrollPositionY
             andScrollViewHeight: (float) scrollViewHeight
{
    self = [super init];
    
    if(self)
    {
        self.scrollView = [[[UIScrollView alloc] init] autorelease];
        [_scrollView setBackgroundColor:[UIColor clearColor]];
        [_scrollView setFrame:CGRectMake(0.0f, scrollPositionY, self.view.frame.size.width, scrollViewHeight)];
        [_scrollView setContentSize:scrollContentSize];
        [_scrollView setShowsHorizontalScrollIndicator:YES];
        [_scrollView setPagingEnabled:YES];
        
        [self.view addSubview:self.scrollView];
        
        self.tabBarBackgroundImageView = [[[UIImageView alloc] init] autorelease];
        [_tabBarBackgroundImageView setImage: backgroundImage];
    }
    
    return (self);
}

- (void)dealloc
{
    [_scrollView release];
    [_tabBarBackgroundImageView release];
    [_utilityViews release];
    [_navItem release];
    [super dealloc];
}

#pragma  mark View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tabBar.hidden = YES;
    
    CGRect frame = self.view.frame;
    frame.size.height += self.tabBar.frame.size.height;
    self.view.frame = frame;
    [[self.view.subviews objectAtIndex:0] setFrame:frame];
    
  
    if (self.tabBarBackgroundImageView) {
        [self.view addSubview:self.tabBarBackgroundImageView];
    } else {
        self.tabBarBackgroundImageView = [[[UIImageView alloc] init] autorelease];
        [self.view addSubview:_tabBarBackgroundImageView];
    }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UINavigationItem *)navigationItem {
    if (!_navItem) {
        _navItem = [[UINavigationItem alloc] init];
    }
    return _navItem;
}

- (void)setNavController:(UINavigationController *)navController {
    _navController = navController;
    if (navController) {
        if (self.navController && [self.navController isKindOfClass:[DPNavigationController class]]) {
            
            DPNavigationController *navController = (DPNavigationController *)self.navController;
            navController.navigationTitle.text = self.selectedViewController.navigationItem.title;
        }
    }
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    [super setViewControllers:viewControllers];
    for (UIViewController *controller in self.viewControllers) {
        UITabBarItem *item = controller.tabBarItem;
        NSAssert([item isKindOfClass:[DPTabBarItem class]], @"must use DPTabBarItem for tabBarItem");
        DPTabBarItem *tabBarItem = (DPTabBarItem *)item;
        [tabBarItem.tabButton addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.scrollView) {
            [self.scrollView addSubview:tabBarItem.tabButton];
        } else {
            [self.view addSubview:tabBarItem.tabButton];
        }
        
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
    if (selectedIndex < self.viewControllers.count) {
        for (int i = 0; i < self.viewControllers.count; ++i) {
            UIViewController *controller = [self.viewControllers objectAtIndex:i];
            UITabBarItem *item = controller.tabBarItem;
            NSAssert([item isKindOfClass:[DPTabBarItem class]], @"must use DPTabBarItem for tabBarItem");
            DPTabBarItem *tabBarItem = (DPTabBarItem *)item;
            if (selectedIndex == i) {
                _navItem.title = controller.navigationItem.title;
                if (self.navController && [self.navController isKindOfClass:[DPNavigationController class]]) {
                    DPNavigationController *navController = (DPNavigationController *)self.navController;
                    navController.navigationTitle.text = controller.navigationItem.title;
                }
                tabBarItem.tabButton.selected = YES;
            } else {
                tabBarItem.tabButton.selected = NO;
            }
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
        [self.delegate performSelector:@selector(tabBarController:didSelectViewController:) withObject:self withObject:[self.viewControllers objectAtIndex:selectedIndex]];
    }
}

- (void)setUtilityViews:(NSArray *)utilityViews
{
    if (_utilityViews) {
        for (UIView *view in _utilityViews) {
            [view removeFromSuperview];
        }
        [_utilityViews release];
        _utilityViews = nil;
    }
    if (utilityViews) {
        _utilityViews = [utilityViews retain];
        for (UIView *view in _utilityViews) {
            [self.view addSubview:view];
        }
    }
}

- (void)tabButtonClicked:(UIButton *)tabButton
{
    for (int i = 0; i < [self.viewControllers count]; ++i) {
        
        UIViewController *controller = [self.viewControllers objectAtIndex:i];
        UITabBarItem *item = controller.tabBarItem;
        
        NSAssert([item isKindOfClass:[DPTabBarItem class]], @"must use DPTabBarItem for tabBarItem");
        DPTabBarItem *tabBarItem = (DPTabBarItem *)item;
        if (tabButton == tabBarItem.tabButton) {
            tabBarItem.tabButton.selected = YES;
            self.selectedIndex = i;
        } else {
            tabBarItem.tabButton.selected = NO;
        }
    }
    
}

- (void)hideTabBar
{
    for (UIViewController *controller in self.viewControllers) {
        UITabBarItem *item = controller.tabBarItem;
        NSAssert([item isKindOfClass:[DPTabBarItem class]], @"must use DpTabBarItem for tabBarItem");
        DPTabBarItem *tabBarItem = (DPTabBarItem *)item;
        tabBarItem.tabButton.hidden = YES;
    }
    
    self.tabBarBackgroundImageView.hidden = YES;
    
    for (UIView *view in self.utilityViews) {
        view.hidden = YES;
    }
}

- (void)showTabBar
{
    for (UIViewController *controller in self.viewControllers) {
        UITabBarItem *item = controller.tabBarItem;
        NSAssert([item isKindOfClass:[DPTabBarItem class]], @"must use DPTabBarItem for tabBarItem");
        DPTabBarItem *tabBarItem = (DPTabBarItem *)item;
        tabBarItem.tabButton.hidden = NO;
    }
    
    self.tabBarBackgroundImageView.hidden = NO;
    
    for (UIView *view in self.utilityViews) {
        view.hidden = NO;
    }
}

@end
