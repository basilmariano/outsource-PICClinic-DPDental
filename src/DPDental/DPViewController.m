//
//  DPViewController.m
//  DPDental
//
//  Created by Wong Johnson on 9/4/13.
//  Copyright (c) 2013 Panfilo Mariano. All rights reserved.
//

#import "DPViewController.h"
#import "XCDeviceManager.h"
#import "DPTestViewController.h"
#import "DPNavigationController.h"


@interface DPViewController ()

@property (nonatomic, retain) UIPanGestureRecognizer *panGesture;
@property (nonatomic, retain) IBOutlet UIView *slidingView;
@property (nonatomic, retain) IBOutlet UIImageView *arrowSlideIndicator;
@property (nonatomic, retain) IBOutlet UIButton *buttonWeCare;
@property (nonatomic, retain) IBOutlet UIButton *buttonWeBelieve;
@property (nonatomic, retain) IBOutlet UIButton *buttonWeAre;
@property (nonatomic, retain) IBOutlet UIButton *buttonContactUs;

- (IBAction)onWeCareClick:(id)sender;
- (IBAction)onWeBelieveClick:(id)sender;
- (IBAction)onWeAre:(id)sender;
- (IBAction)onContactUsClick:(id)sender;

@end

@implementation DPViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *nibName = [[XCDeviceManager sharedInstance] xibNameForDevice:@"DPViewController"];
    self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationItem setHidesBackButton:YES];
    
    self.panGesture = [[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureHandle:)] autorelease];
    [self.slidingView addGestureRecognizer:self.panGesture];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [_panGesture release];
    [_slidingView release];
    [_arrowSlideIndicator release];
    [_buttonWeCare release];
    [_buttonWeBelieve release];
    [_buttonWeAre release];
    [_buttonContactUs release];
    
    [super dealloc];
}

#pragma mark IBActions
- (IBAction)onWeCareClick:(id)sender
{
    [[self navigationController]popViewControllerAnimated:YES];
}

- (IBAction)onWeBelieveClick:(id)sender
{
    [[self navigationController] popToRootViewControllerAnimated:YES];
   // [self showTabBarViewController:sender];
}

- (IBAction)onWeAre:(id)sender
{
    [self showTabBarViewController:sender];
}

- (IBAction)onContactUsClick:(id)sender
{
    [self showTabBarViewController:sender];
}

#pragma  mark Selectors
- (void)panGestureHandle:(UIPanGestureRecognizer *)gestureRecognizer
{
     UIView *piece = self.slidingView;
    switch (gestureRecognizer.state) {
 
        case UIGestureRecognizerStateChanged:
        {
            float frameEnd = 0.0f;
            float center = 0.0f;
            
            if ([XCDeviceManager sharedInstance].deviceType == iPad_Device) {
                frameEnd = -768.0f;
                center = -384.0f;
            } else {
                frameEnd = -254.0f;
                center = -160.0f;
            }
            
            if (piece.frame.origin.x <= 0 && piece.frame.origin.x >= frameEnd) {

                CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
                [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y)];
                [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
                
                if (piece.frame.origin.x > 0) {
                    [piece setFrame:CGRectMake(0.0f, 0.0f, piece.frame.size.width, piece.frame.size.height)];
                }
                    
                    if (piece.frame.origin.x < frameEnd) {
                        [piece setFrame:CGRectMake(frameEnd, 0.0f, piece.frame.size.width, piece.frame.size.height)];
                    }
                    
                    if (piece.frame.origin.x > center) {
                        [self.arrowSlideIndicator setTransform:CGAffineTransformMakeRotation(0)];
                    } else if (piece.frame.origin.x > frameEnd) {
                        [self.arrowSlideIndicator setTransform:CGAffineTransformMakeRotation(3.14)];
                    }
                
            }
            break;

        }
        case UIGestureRecognizerStateEnded:
        {
            float center = 0.0f;
            float left = 0.0f;
            
            if ([XCDeviceManager sharedInstance].deviceType == iPad_Device) {
                center = -384.0f;
                left = -628.0f;
            } else {
                center = -160.0f;
                left = -254.0f;
            }
          
            if (piece.frame.origin.x > center) {
                    
                [UIView animateWithDuration:0.2
                                    delay:0.0
                                    options: nil
                                animations:^{
                                         CGRect targetRect =  CGRectMake(0.0f, 0.0f,  piece.frame.size.width, piece.frame.size.height);
                                         piece.frame =  targetRect;
                                     }
                                     completion:^(BOOL finished){
                                         //[self.arrowSlideIndicator setTransform:CGAffineTransformMakeRotation(0)];
                                     }];
            } else if (piece.frame.origin.x > left){
                [UIView animateWithDuration:0.2
                                        delay:0.0
                                    options: nil
                                    animations:^{
                                        CGRect targetRect =  CGRectMake(left, 0.0f,  piece.frame.size.width, piece.frame.size.height);
                                        piece.frame =  targetRect;
                                    }
                                    completion:^(BOOL finished){
                                         // [self.arrowSlideIndicator setTransform:CGAffineTransformMakeRotation(3.14)];
                                    }];
                }
            
            break;
        }
 
    }
    
}

#pragma mark Private Functions
- (void) showTabBarViewController: (id) sender
{
    UIButton *buttonClicked = (UIButton *) sender;
    if (buttonClicked.tag == 0) {
        
    } else if (buttonClicked.tag == 1) {
        
    } else if (buttonClicked.tag == 2) {
        
    } else {
        
    }

}

@end
