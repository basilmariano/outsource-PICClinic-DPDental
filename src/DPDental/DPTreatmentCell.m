//
//  DPTreatmentCell.m
//  DPDental
//
//  Created by Wong Johnson on 9/11/13.
//  Copyright (c) 2013 Panfilo Mariano. All rights reserved.
//

#import "DPTreatmentCell.h"

@implementation DPTreatmentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    NSString *imageName = @"PICClinicModel.bundle/iphone_DP-Dental_ListView3_640x90.jpg";
  
    UIImageView *celBG = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]] autorelease];
    self.backgroundView = celBG;
}

@end
