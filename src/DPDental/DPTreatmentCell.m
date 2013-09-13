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

   /* UIImageView *selBGView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BrownCellBG.png"]] autorelease];
    self.selectedBackgroundView = selBGView;
    */
    // Configure the view for the selected state
}

@end
