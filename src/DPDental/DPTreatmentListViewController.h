//
//  DPTreatmentListViewController.h
//  DPDental
//
//  Created by Wong Johnson on 9/11/13.
//  Copyright (c) 2013 Panfilo Mariano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPTreatmentListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableview;

@end
