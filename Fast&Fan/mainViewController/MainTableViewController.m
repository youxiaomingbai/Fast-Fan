//
//  MainTableViewController.m
//  Fast&Fan
//
//  Created by Eric on 2017/2/22.
//  Copyright © 2017年 Doflamingo. All rights reserved.
//

#import "MainTableViewController.h"
#import "youdaoModel.h"
#import "MainTableViewCell.h"
#import "ClipBoardViewController.h"
@interface MainTableViewController ()

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkDicwithStr:@"好"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"MainTableViewCell"];
    [self.tableView setBackgroundColor:BGColor];
    [self setupNavBar];
    
    [self.navigationController.navigationBar setTintColor:[UIColor redColor]];
    
}
- (void)setupNavBar
{
    
    
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 50)];
    titleLable.textColor = [UIColor blackColor];
    titleLable.font =[UIFont systemFontOfSize:18];
    [titleLable setTextColor:[UIColor redColor]];
    titleLable.text = @"FAST&FAN";
    titleLable.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = titleLable;
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                [cell.titleLabel setText:@"字典"];
            }else{
                
                [cell.titleLabel setText:@"剪贴板"];
                [cell.line setHidden:YES];
            }
        }
            break;
        case 1:
        {
            
        }
            break;
        default:{
            
        }
            break;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1 ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 30)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
    [label setFont:[UIFont systemFontOfSize:13]];
    [label setTextColor:[UIColor lightGrayColor]];
    [header addSubview:label];
    switch (section) {
        case 0:{
            [label setText:@"function"];
        }
            break;
        case 1:
        {
            [label setText:@"setting"];
        }
            break;
        default:{
            
        }
            break;
    }
    return header;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0&& indexPath.row == 1) {
        ClipBoardViewController *clip = [[ClipBoardViewController alloc]initWithNibName:@"ClipBoardViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:clip animated:YES];
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)checkDicwithStr:(NSString *)str
{
    NSString *dicstr = [NSString stringWithFormat:@"http://fanyi.youdao.com/openapi.do?keyfrom=FastFan&key=587506935&type=data&doctype=json&version=1.1&q=%@",str];
    
    
    dicstr = [dicstr stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<>+"].invertedSet];
    [SwpNetworking swpPOST:dicstr parameters:nil swpNetworkingSuccess:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *dic) {
        MBGLog(@"%@", dic);
        youdaoModel *model = [youdaoModel objectWithKeyValues:dic];
        MBGLog(@"%@", model);
        NSArray *translation = [NSArray array];
        if (model.basic == nil ) {
            youdaoWebModel *webmodel = model.web[1];
            translation = webmodel.value;
        }else{
            
            translation = model.basic.explains;
        }
        MBGLog(@"%@" ,[translation componentsJoinedByString:@"|"]);
    } swpNetworkingError:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, NSString * _Nonnull errorMessage) {
        
    }];
    
}
@end
