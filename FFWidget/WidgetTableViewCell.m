//
//  WidgetTableViewCell.m
//  Fast&Fan
//
//  Created by Eric on 2017/2/27.
//  Copyright © 2017年 Doflamingo. All rights reserved.
//

#import "WidgetTableViewCell.h"

@implementation WidgetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deletebtnclick:(UIButton *)sender {
    [_delegate Celldidclickdeletebtn:self];
}
@end
