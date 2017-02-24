//
//  ClipBoardViewController.m
//  Fast&Fan
//
//  Created by Eric on 2017/2/23.
//  Copyright © 2017年 Doflamingo. All rights reserved.
//

#import "ClipBoardViewController.h"
#import "ClipCell.h"
#define khiscount  6
@interface ClipBoardViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *historyArr;
@property (weak, nonatomic) IBOutlet UITextField *textfeild;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation ClipBoardViewController
- (IBAction)addbtndidclick:(UIButton *)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.historyArr  =[[defaults arrayForKey:@"cliphistory"]mutableCopy];
    MBGLog(@"%@",self.historyArr);
    self.view.backgroundColor = BGColor;
    self.tableview.backgroundColor = BGColor;
    [self.tableview registerNib:[UINib nibWithNibName:@"ClipCell" bundle:nil] forCellReuseIdentifier:@"ClipCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)updateHistory{
    NSString *newstr = [NSString string];
    if (self.historyArr == nil) {
        self.historyArr =[[NSMutableArray alloc]init];
        [self.historyArr addObject:newstr];
    }else{
        if ([self.historyArr indexOfObject:newstr]!=NSNotFound) {
            int i = (int)[self.historyArr indexOfObject:newstr];
            [self.historyArr exchangeObjectAtIndex:0 withObjectAtIndex:i];
        }else{
            [self.historyArr insertObject:newstr atIndex:0];
        }
    }
    if (self.historyArr.count==khiscount) {
        
        [self.historyArr removeLastObject];
    }
    MBGLog(@"%@",self.historyArr);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.historyArr forKey:@"cliphistory"];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ClipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClipCell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell.textLabel setText:@"111"];
    [cell.textLabel setFont:[UIFont systemFontOfSize:17]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1 ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 30)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, WINDOW_WIDTH, 20)];
    [label setFont:[UIFont systemFontOfSize:13]];
    [label setTextColor:[UIColor lightGrayColor]];
    [header addSubview:label];
    
    [label setText:@"点击复制，滑动删除"];
    return header;
}

@end
