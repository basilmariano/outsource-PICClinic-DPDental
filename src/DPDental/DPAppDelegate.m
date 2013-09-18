//
//  DPAppDelegate.m
//  DPDental
//
//  Created by Wong Johnson on 9/4/13.
//  Copyright (c) 2013 Panfilo Mariano. All rights reserved.
//

#import "DPAppDelegate.h"

#import "DPViewController.h"
#import "DPNavigationController.h"
#import "DPTestViewController.h"
#import "DPTabBarItem.h"
#import "DPTabBarController.h"
#import "DPTreatmentListViewController.h"
#import "Reachability.h"
#import "DPTreatmentListHistoryViewController.h"
#import "DPInfoTableViewController.h"

@implementation DPAppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.s
    
    UIImage *homeImageNormal = [UIImage imageNamed:@"iphone_DP_HomeTab_s.jpg"];
    UIImage *homeImageSelected = [UIImage imageNamed:@"iphone_DP_HomeTab_ss.jpg"];
    UIImage *treatmentImageNormal = [UIImage imageNamed:@"iphone_DP_TreatmentTab_s.jpg"];
    UIImage *treatmentImageSelected = [UIImage imageNamed:@"iphone_DP_TreatmentTab_ss.jpg"];
    UIImage *historyImageNormal = [UIImage imageNamed:@"iphone_DP_HistoryTab_s.jpg"];
    UIImage *historyImageSelected = [UIImage imageNamed:@"iphone_DP_HistoryTab_ss.jpg"];
    UIImage *infoImageNormal = [UIImage imageNamed:@"iphone_DP_InfoTab_s.jpg"];
    UIImage *infoImageSelected = [UIImage imageNamed:@"iphone_DP_InfoTab_ss.jpg"];

    CGRect homeTabButtonFrame = CGRectMake(0, 429.8, 81, 50);
    CGRect treatmentTabButtonFrame = CGRectMake(80, 429.8, 81, 50);
    CGRect historyTabButtonFrame = CGRectMake(160, 429.8, 81, 50);
    CGRect infoTabButtonFrame = CGRectMake(240, 429.8, 81, 50);

    NSString *splashImageName = nil;
    NSString *navigationBackgroundName = nil;
    
    if ([XCDeviceManager sharedInstance].deviceType == iPhone4_Device) {
        
        splashImageName = @"Default.png";
        navigationBackgroundName = @"iphone_DP-Dental_HeaderTab.jpg";
        
    }else if ([XCDeviceManager sharedInstance].deviceType == iPhone5_Device) {
        
        splashImageName = @"Default-568h.png";
        navigationBackgroundName = @"iphone_DP-Dental_HeaderTab.jpg";
        
        homeTabButtonFrame = CGRectMake(0, 517.8, 81, 50);
        treatmentTabButtonFrame = CGRectMake(80, 517.8, 81, 50);
        historyTabButtonFrame = CGRectMake(160, 517.8, 81, 50);
        infoTabButtonFrame = CGRectMake(240, 517.8, 81, 50);
        
    } else if ([XCDeviceManager sharedInstance].deviceType == iPad_Device) {
        
        homeImageNormal = [UIImage imageNamed:@"ipad_DP_HomeTab_s.jpg"];
        homeImageSelected = [UIImage imageNamed:@"ipad_DP_HomeTab_ss.jpg"];
        treatmentImageNormal = [UIImage imageNamed:@"ipad_DP_TreatmentTab_s.jpg"];
        treatmentImageSelected = [UIImage imageNamed:@"ipad_DP_TreatmentTab_ss.jpg"];
        historyImageNormal = [UIImage imageNamed:@"ipad_DP_HistoryTab_s.jpg"];
        historyImageSelected = [UIImage imageNamed:@"ipad_DP_HistoryTab_ss.jpg"];
        infoImageNormal = [UIImage imageNamed:@"ipad_DP_InfoTab_s.jpg"];
        infoImageSelected = [UIImage imageNamed:@"ipad_DP_InfoTab_ss.jpg"];
        
        splashImageName = @"Default-Portrait~ipad.png";
        navigationBackgroundName = @"ipad_DP-Dental_HeaderTab.jpg";
        
        homeTabButtonFrame = CGRectMake(0, 923.5f, 192.0f, 100.0f);
        treatmentTabButtonFrame = CGRectMake(192.0f, 923.5f, 192.0f, 100.0f);
        historyTabButtonFrame = CGRectMake(384.0f, 923.5f, 192.0f, 100.0f);
        infoTabButtonFrame = CGRectMake(576.0f, 923.5f, 192.0f, 100.0f);
        
    }
    
    UIButton *homeTabButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeTabButton setFrame:homeTabButtonFrame];
    [homeTabButton setImage:homeImageNormal forState:UIControlStateNormal];
    [homeTabButton setImage:homeImageSelected forState:UIControlStateSelected];
    
    UIButton *treatmentTabButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [treatmentTabButton setFrame:treatmentTabButtonFrame];
    [treatmentTabButton setImage:treatmentImageNormal forState:UIControlStateNormal];
    [treatmentTabButton setImage:treatmentImageSelected forState:UIControlStateSelected];
    
    UIButton *historyTabButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [historyTabButton setFrame:historyTabButtonFrame];
    [historyTabButton setImage:historyImageNormal forState:UIControlStateNormal];
    [historyTabButton setImage:historyImageSelected forState:UIControlStateSelected];
    
    UIButton *infoTabButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoTabButton setFrame:infoTabButtonFrame];
    [infoTabButton setImage:infoImageNormal forState:UIControlStateNormal];
    [infoTabButton setImage:infoImageSelected forState:UIControlStateSelected];
    
    DPViewController *lockViewController = [[[DPViewController alloc] initWithNibName:@"DPViewController" bundle:nil] autorelease];
    DPTreatmentListViewController *treatments = [[[DPTreatmentListViewController alloc] initWithNibName:@"DPTreatmentListViewController" bundle:nil] autorelease];

    DPTreatmentListHistoryViewController *history = [[[DPTreatmentListHistoryViewController alloc] initWithNibName:@"DPTreatmentListHistoryViewController" bundle:nil] autorelease];
    
    DPInfoTableViewController *infoList = [[[DPInfoTableViewController alloc] initWithNibName:@"DPInfoTableViewController" bundle:nil] autorelease];

    PCNavigationController *nav1 = [[[PCNavigationController alloc] initWithRootViewController:lockViewController] autorelease];
    nav1.backgroundImageView.image = [UIImage imageNamed:navigationBackgroundName];
    nav1.tabBarItem = [PCTabBarItem tabBarItemWithButton:homeTabButton];
    
    PCNavigationController *nav2 = [[[PCNavigationController alloc] initWithRootViewController:treatments] autorelease];
    nav2.backgroundImageView.image = [UIImage imageNamed:navigationBackgroundName];
    nav2.tabBarItem = [PCTabBarItem tabBarItemWithButton:treatmentTabButton];
    
    PCNavigationController *nav3 = [[[PCNavigationController alloc] initWithRootViewController:history] autorelease];
    nav3.backgroundImageView.image = [UIImage imageNamed:navigationBackgroundName];
    nav3.tabBarItem = [PCTabBarItem tabBarItemWithButton:historyTabButton];
    
    PCNavigationController *nav4 = [[[PCNavigationController alloc] initWithRootViewController:infoList] autorelease];
    nav4.backgroundImageView.image = [UIImage imageNamed:navigationBackgroundName];
    nav4.tabBarItem = [PCTabBarItem tabBarItemWithButton:infoTabButton];
    
    PCTabBarController *tabBarController = [[[PCTabBarController alloc] init] autorelease];
    tabBarController.viewControllers = [NSArray arrayWithObjects:nav1, nav2, nav3, nav4, nil];
    tabBarController.selectedIndex = 0;
    tabBarController.delegate = self;
    
    UIImage *splashImage = [UIImage imageNamed:splashImageName];
    
    UIImageView *splashImageView = [[UIImageView alloc]initWithImage: splashImage];
	splashImageView.userInteractionEnabled = FALSE;
    
    self.window.rootViewController = tabBarController;
	[tabBarController.view addSubview:splashImageView];
    
    [self performSelector:@selector(removeSplashImageView:) withObject:splashImageView afterDelay:3];
    
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
    } else {
        
        NSLog(@"There IS internet connection");
        
        
    }        
    
    [[PCRequestHandler sharedInstance] requestVersionCheck:@"9"];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)removeSplashImageView:(UIImageView *)splashImageView
{
    [splashImageView removeFromSuperview];
    [splashImageView release];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
