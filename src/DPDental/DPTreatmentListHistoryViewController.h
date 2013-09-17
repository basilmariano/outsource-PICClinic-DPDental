//
//  DPTreatmentListHistoryViewController.h
//  DPDental
//
//  Created by Basil Mariano on 9/17/13.
//  Copyright (c) 2013 Panfilo Mariano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPTreatmentListHistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableview;

@end
