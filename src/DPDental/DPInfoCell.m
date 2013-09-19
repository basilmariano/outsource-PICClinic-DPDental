//
//  DPInfoCell.m
//  DPDental
//
//  Created by Basil Mariano on 9/18/13.
//  Copyright (c) 2013 Panfilo Mariano. All rights reserved.
//

#import "DPInfoCell.h"

@implementation DPInfoCell

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
