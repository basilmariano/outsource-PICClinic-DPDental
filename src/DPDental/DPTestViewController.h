//
//  DPTestViewController.h
//  DPDental
//
//  Created by Wong Johnson on 9/9/13.
//  Copyright (c) 2013 Panfilo Mariano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPTestViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *text;

- (id) initWithText: (NSString *)text;

@end
