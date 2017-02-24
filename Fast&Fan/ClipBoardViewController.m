//
//  ClipBoardViewController.m
//  Fast&Fan
//
//  Created by Eric on 2017/2/23.
//  Copyright © 2017年 Doflamingo. All rights reserved.
//

#import "ClipBoardViewController.h"
#import "ClipCell.h"
#define khiscount  10
@interface ClipBoardViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *historyArr;
@property (weak, nonatomic) IBOutlet UITextField *textfeild;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation ClipBoardViewController
- (IBAction)addbtndidclick:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (![self.textfeild.text isEqualToString:@""]) {
        
        pasteboard.string = self.textfeild.text;
    }
    [self.textfeild endEditing:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults =[[NSUserDefaults alloc] initWithSuiteName:@"group.com.ff"];
    self.historyArr  =[[defaults arrayForKey:@"cliphistory"]mutableCopy];
    MBGLog(@"%@",self.historyArr);
    self.view.backgroundColor = BGColor;
    self.tableview.backgroundColor = BGColor;
    [self.tableview registerNib:[UINib nibWithNibName:@"ClipCell" bundle:nil] forCellReuseIdentifier:@"ClipCell"];
    [self setupNavBar];
    [self.tableview reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkoutClipboard) name:UIPasteboardChangedNotification object:nil];

}
- (void)setupNavBar
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 44)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:18];
    label.text = @"ClipBoard";
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    [label setTextColor:[UIColor redColor]];
    
    
    UIButton *goBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goBackBtn.frame = CGRectMake(0, 0, 40, 40);
    goBackBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [goBackBtn setImage:[UIImage imageNamed:@"go_back"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:goBackBtn];
    [goBackBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    [goBackBtn setTintColor:[UIColor redColor]];
    negativeSpacer.width = -15;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,backBarBtn];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
}
-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
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
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.ff"];
    [defaults setObject:self.historyArr forKey:@"cliphistory"];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.historyArr.count;
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ClipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClipCell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell.textLabel setText:self.historyArr[indexPath.row]];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = self.historyArr[indexPath.row];
//    [self checkoutClipboard];
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return YES;
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.historyArr removeObjectAtIndex:indexPath.row];
        
        [self.tableview reloadData];
        
        
        if (self.historyArr.count ==0) {
            NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.ff"];
            [defaults setObject:[NSArray array] forKey:@"cliphistory"];
        }else{
            
            NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.ff"];
            [defaults setObject:self.historyArr forKey:@"cliphistory"];
        }
        
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.textfeild resignFirstResponder];

}
-(void)checkoutClipboard{
    NSString *newstr= [UIPasteboard generalPasteboard].string;
    
    MBGLog(@"%@", newstr);
    
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
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.ff"];
    [defaults setObject:self.historyArr forKey:@"cliphistory"];
    [self.tableview reloadData];
}
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    [self.textfeild resignFirstResponder];
//}
@end
