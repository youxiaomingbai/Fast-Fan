//
//  TodayViewController.m
//  FFWidget
//
//  Created by Eric on 2017/2/24.
//  Copyright © 2017年 Doflamingo. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import <Photos/Photos.h>
#import "WidgetTableViewCell.h"
#define khiscount  10



@interface TodayViewController () <NCWidgetProviding,UITableViewDelegate,UITableViewDataSource,WidgetTableViewCellDelegate>
@property (nonatomic ,strong)UIButton *deletephoto;
@property (nonatomic ,strong)UIButton *search;
@property (nonatomic ,strong)NSArray *transArr;
@property (nonatomic, strong) NSMutableArray *historyArr;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;

@property (weak, nonatomic) IBOutlet UILabel *transformLabel;
@property (nonatomic, strong)UITableView *tableview;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.deletephoto =[UIButton buttonWithType:UIButtonTypeSystem];
    [_deletephoto setTitle:@"删除图片" forState:UIControlStateNormal];
    [self.deletephoto addTarget:self action:@selector(deletelastphoto) forControlEvents:UIControlEventTouchUpInside];
    [self.deletephoto setTintColor:[UIColor blackColor]];
    [self.view addSubview:self.deletephoto];
    self.search =[UIButton buttonWithType:UIButtonTypeSystem];
    [_search setTitle:@"搜索" forState:UIControlStateNormal];
    [self.search addTarget:self action:@selector(deletelastphoto) forControlEvents:UIControlEventTouchUpInside];
    [self.search setTintColor:[UIColor blackColor]];
    [self.view addSubview:self.search];
    
    NSUserDefaults *defaults =[[NSUserDefaults alloc] initWithSuiteName:@"group.com.ff"];
    self.historyArr  =[[defaults arrayForKey:@"cliphistory"]mutableCopy];
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, 1)];
    self.tableview =[[UITableView alloc]initWithFrame:CGRectMake(0, 65, [UIScreen mainScreen].bounds.size.width, 190) style:UITableViewStylePlain];
    [self.view addSubview:self.tableview];
    [self.tableview addSubview:line];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [line setAlpha:0.6];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"WidgetTableViewCell" bundle:nil] forCellReuseIdentifier:@"WidgetTableViewCell"];
    [self.tableview setDelegate:self];
    [self.tableview setDataSource:self];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    [self translation];
}

-(void)deletelastphoto{
    PHFetchResult *collectonResuts = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:[PHFetchOptions new]] ;
    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection *assetCollection = obj;
        if ([assetCollection.localizedTitle isEqualToString:@"Camera Roll"])  {
            PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:[PHFetchOptions new]];
            [assetResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    //获取相册的最后一张照片
                    if (idx == [assetResult count] - 1) {
                        [PHAssetChangeRequest deleteAssets:@[obj]];
                    }
                } completionHandler:^(BOOL success, NSError *error) {
                    NSLog(@"Error: %@", error);
                }];
            }];
        }
    }];
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 110);
        [self.deletephoto setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 65, [UIScreen mainScreen].bounds.size.width/2, 45)];
        [self.search setFrame:CGRectMake(0, 65, [UIScreen mainScreen].bounds.size.width/2, 45)];
        [self.tableview setHidden:YES];
    } else {
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 300);
        [self.deletephoto setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 255, [UIScreen mainScreen].bounds.size.width/2, 45)];
        [self.search setFrame:CGRectMake(0, 255, [UIScreen mainScreen].bounds.size.width/2, 45)];
        [self.tableview setHidden:NO];
    }
}
//删除当前内容 清空剪切板
- (IBAction)deletebtn:(UIButton *)sender {
    NSLog(@"click");
    if (self.historyArr.count!=0) {
        
    
    [self.historyArr removeObjectAtIndex:0];
    
    [self.tableview reloadData];
    }
    
    if (self.historyArr.count ==0) {
        NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.ff"];
        [defaults setObject:[NSArray array] forKey:@"cliphistory"];
    }else{
        
        NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.ff"];
        [defaults setObject:self.historyArr forKey:@"cliphistory"];
    }
    [self.mainLabel setText:@"Fast&Fan"];
    [self.transformLabel setText:@""];
     UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.items = [NSArray array];
}


- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}
-(void)checkDicwithStr:(NSString *)str
{
    
    NSString *dicstr = [NSString stringWithFormat:@"http://fanyi.youdao.com/openapi.do?keyfrom=FastFan&key=587506935&type=data&doctype=json&version=1.1&q=%@",str];
    
    
    dicstr = [dicstr stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<>+"].invertedSet];
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dicstr]];
    [request setHTTPMethod:@"GET"];
    
//    NSURLResponse *response = nil;
//    
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];
//    
//     if (data) {
//        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
//        if ([result isKindOfClass:[NSDictionary class]]) {
//            if (result[@"basic"]!=nil) {
//                self.transArr =result[@"basic"][@"explains"];
//            }else if (result[@"web"]!=nil){
//                self.transArr =result[@"basic"][0][@"value"];
//            }else{
//                
//            }
//            NSLog(@"%@",self.transArr);
//            
//            [self.transformLabel setText:[self.transArr componentsJoinedByString:@"."]];
//        }
//    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    // 由于要先对request先行处理,我们通过request初始化task
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            if (data != nil) {
                                                
                                            
                                            NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
                                                  id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
                                                  if ([result isKindOfClass:[NSDictionary class]]) {
                                                      
                                                      
                                                      if (result[@"basic"]!=nil) {
                                                          self.transArr =result[@"basic"][@"explains"];
                                                      }else if (result[@"web"]!=nil){
                                                          self.transArr =result[@"basic"][0][@"value"];
                                                      }else{
                                                          
                                                      }
                                                      NSLog(@"%@",self.transArr);
                                                      if (self.transArr.count !=0) {
                                                          
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              
                                                              [self.transformLabel setText:[self.transArr componentsJoinedByString:@"."]];
                                                          });
                                                      }
                                                  }
                                            }
                                        
                                        }];
    [task resume];
    
}
//翻译主函数
-(void)translation{
    NSString *newstr= [UIPasteboard generalPasteboard].string;
    if (newstr != nil) {
        [self checkoutClipboard];
        [self.transformLabel setText:@"loading..."];
        [self checkDicwithStr:newstr];
    }
}
//更新剪切板
-(void)checkoutClipboard{
    NSString *newstr= [UIPasteboard generalPasteboard].string;
    
//    MBGLog(@"%@", newstr);
    if (newstr != nil) {
        [self.mainLabel setText:newstr];
    
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
    //    MBGLog(@"%@",self.historyArr);
        NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.ff"];
        [defaults setObject:self.historyArr forKey:@"cliphistory"];
    }
    [self.tableview reloadData];
}
#pragma mark -tableview 
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WidgetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WidgetTableViewCell"];
    cell.delegate  = self;
    [cell.titleLabel setText:self.historyArr[indexPath.row]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.indexpath = indexPath;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.historyArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 38;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = self.historyArr[indexPath.row];
    [self translation];
}
-(void)Celldidclickdeletebtn:(WidgetTableViewCell *)cell{
    [self.historyArr removeObjectAtIndex:cell.indexpath.row];
    
    [self.tableview reloadData];
    
    
    if (self.historyArr.count ==0) {
        NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.ff"];
        [defaults setObject:[NSArray array] forKey:@"cliphistory"];
    }else{
        
        NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.ff"];
        [defaults setObject:self.historyArr forKey:@"cliphistory"];
    }
}
@end
