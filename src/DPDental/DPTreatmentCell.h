//
//  DPTreatmentCell.h
//  DPDental
//
//  Created by Wong Johnson on 9/11/13.
//  Copyright (c) 2013 Panfilo Mariano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPTreatmentCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UILabel *treatmentName;
@property (nonatomic, assign) IBOutlet UILabel *doctorName;
@property (nonatomic, assign) IBOutlet UILabel *date;
@property (nonatomic, assign) IBOutlet PCAsyncImageView *image;

@end
