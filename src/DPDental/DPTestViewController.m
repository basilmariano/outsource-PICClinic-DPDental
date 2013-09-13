//
//  DPTestViewController.m
//  DPDental
//
//  Created by Wong Johnson on 9/9/13.
//  Copyright (c) 2013 Panfilo Mariano. All rights reserved.
//

#import "DPTestViewController.h"
#import "DPViewController.h"
#import "DPTabBarController.h"
#import "DPNavigationController.h"
#import "XCDeviceManager.h"

@interface DPTestViewController ()

@property (nonatomic, retain) UIButton *backButton;

@end

@implementation DPTestViewController

- (id) initWithText: (NSString *)text
{
    self = [super initWithNibName:@"DPTestViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.text = [[[UILabel alloc] init] autorelease];
        _text.text = text;
        self.navigationItem.title = text;
        
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton addTarget:self action:@selector(onBackButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        if ([XCDeviceManager sharedInstance].deviceType == iPhone4_Device || [XCDeviceManager sharedInstance].deviceType == iPhone5_Device) {
            self.backButton.frame = CGRectMake(0.0f, 0.0f, 43.0f, 28.0f);
            [_backButton setImage:[UIImage imageNamed:@"iphone_Back_btn_s"] forState:UIControlStateNormal];
            [_backButton setImage:[UIImage imageNamed:@"iphone_Back_btn_ss"] forState:UIControlStateHighlighted];
        } else {
            self.backButton.frame = CGRectMake(0.0f, 0.0f, 43.0f, 28.0f);
            [_backButton setImage:[UIImage imageNamed:@"ipadBack_btn_s"] forState:UIControlStateNormal];
            [_backButton setImage:[UIImage imageNamed:@"ipad_Back_btn_ss"] forState:UIControlStateHighlighted];
        }
        
        
        UIBarButtonItem *buttonItemLeft = [[[UIBarButtonItem alloc] initWithCustomView:self.backButton] autorelease];
      
        self.navigationItem.leftBarButtonItem  = buttonItemLeft;
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc
{
    [_backButton release];
    [_text release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    DPTabBarController *tabBar = (DPTabBarController *) self.tabBarController;
    [tabBar showTabBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DPTabBarController *tabBar = (DPTabBarController *) self.tabBarController;
    DPNavigationController *nav = (DPNavigationController *) [tabBar.viewControllers objectAtIndex:0];
    
    if (self == [nav.viewControllers objectAtIndex:0]) {
            
        [tabBar hideTabBar];
            
        DPViewController *lockViewController = [[[DPViewController alloc] initWithNibName:@"DPViewController" bundle:nil] autorelease];
    
        [[self navigationController] pushViewController:lockViewController animated:YES];
            
    } else {
        
        [tabBar showTabBar];
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onBackButtonClick
{
     DPTabBarController *tabBar = (DPTabBarController *) self.tabBarController;
    [tabBar hideTabBar];
    
    DPViewController *lockViewController = [[[DPViewController alloc] initWithNibName:@"DPViewController" bundle:nil] autorelease];
    [[self navigationController] pushViewController:lockViewController animated:YES];
}

@end
