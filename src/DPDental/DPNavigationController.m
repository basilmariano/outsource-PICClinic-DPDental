//
//  DPNavigationController.m
//  DPDental
//
//  Created by Wong Johnson on 9/9/13.
//  Copyright (c) 2013 Panfilo Mariano. All rights reserved.
//

#import "DPNavigationController.h"
#import "DPTabBarController.h"
#import "DPTabBarItem.h"
#import "XCDeviceManager.h"

@interface DPNavigationController ()

@property (nonatomic, retain) UIView *dummyView;

@end

@implementation DPNavigationController

@synthesize navigationTitle = _navigationTitle;

- (UINavigationBar *)navigationBar
{
    UINavigationBar *navBar = [super navigationBar];
    if (!self.backgroundImageView) {
        if ([navBar.subviews count]) {
            [[navBar.subviews objectAtIndex:0] removeFromSuperview];
        }
        
        self.backgroundImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iphone_DP-Dental_HeaderTab.jpg"]] autorelease];
        [navBar addSubview:_backgroundImageView];
    }
    [navBar addSubview:self.navigationTitle];
    [navBar sendSubviewToBack:_navigationTitle];
    [navBar sendSubviewToBack:_backgroundImageView];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        _backgroundImageView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 45.0f);
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _backgroundImageView.frame = CGRectMake(0.0f, 0.0f, 768.0f, 80.0f);
    }
    return navBar;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_backgroundImageView release];
    [_navigationTitle release];
    [_dummyView release];
    [super dealloc];
}

#pragma  mark View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Overrides

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([viewController isKindOfClass:[DPTabBarController class]]) {
        DPTabBarController *tabBarController = (DPTabBarController *)viewController;
        tabBarController.navController = self;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (UILabel *)navigationTitle {
    
    if (!_navigationTitle) {
        
        _navigationTitle = [[UILabel alloc] init];
        _navigationTitle.textAlignment = UITextAlignmentCenter;
        _navigationTitle.textColor = [UIColor whiteColor];
        _navigationTitle.backgroundColor = [UIColor clearColor];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            _navigationTitle.frame = CGRectMake(60, 10, 200, 25);
            [_navigationTitle setFont:[UIFont fontWithName:@"Helvetica" size:20.0f]];
            _navigationTitle.font = [UIFont boldSystemFontOfSize:20.0f];
        } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            _navigationTitle.frame = CGRectMake(140, 18, 480, 45);
            [_navigationTitle setFont:[UIFont fontWithName:@"Helvetica" size:35.0f]];
            _navigationTitle.font = [UIFont boldSystemFontOfSize:35.0f];
        }
    }
    
    return _navigationTitle;
}

#pragma mark UINavigationBarDelegate

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item {
    if (!_dummyView) {
        _dummyView = [[UIView alloc] init];
    }
    item.titleView = _dummyView;
    _navigationTitle.text = item.title;
    return TRUE;
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    _navigationTitle.text = [[navigationBar.items objectAtIndex:navigationBar.items.count - 2] title];
    return TRUE;
}

@end
