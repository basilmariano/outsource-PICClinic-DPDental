//
//  DPInfoTableViewController.h
//  DPDental
//
//  Created by Basil Mariano on 9/18/13.
//  Copyright (c) 2013 Panfilo Mariano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPInfoTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (id)initWithJournals;

@end
