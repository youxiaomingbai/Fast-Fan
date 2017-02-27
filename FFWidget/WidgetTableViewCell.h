//
//  WidgetTableViewCell.h
//  Fast&Fan
//
//  Created by Eric on 2017/2/27.
//  Copyright © 2017年 Doflamingo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  WidgetTableViewCell;
@protocol WidgetTableViewCellDelegate <NSObject>

@optional
-(void)Celldidclickdeletebtn:(WidgetTableViewCell *)cell;

@end
@interface WidgetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) id<WidgetTableViewCellDelegate> delegate;
@property (strong,nonatomic) NSIndexPath *indexpath;
- (IBAction)deletebtnclick:(UIButton *)sender;

@end
