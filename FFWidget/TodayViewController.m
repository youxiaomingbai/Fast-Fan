//
//  TodayViewController.m
//  FFWidget
//
//  Created by Eric on 2017/2/24.
//  Copyright © 2017年 Doflamingo. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>



@interface TodayViewController () <NCWidgetProviding>
@property (nonatomic ,strong)UIButton *deletephoto;
@property (nonatomic ,strong)UIButton *search;
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
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    [self checkDicwithStr:@"good"];
}

-(void)deletelastphoto{
    
}
// If implemented, called when the active display mode changes.
// The widget may wish to change its preferredContentSize to better accommodate the new display mode.
- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 110);
        [self.deletephoto setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 60, [UIScreen mainScreen].bounds.size.width/2, 50)];
        [self.search setFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width/2, 50)];
    } else {
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 300);
        [self.deletephoto setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 250, [UIScreen mainScreen].bounds.size.width/2, 50)];
        [self.search setFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width/2, 50)];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSURLResponse *response = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];
    
    if (data) {
        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSLog(@"%@", result);
//            youdaoModel *model = [youdaoModel objectWithKeyValues:result];
//            NSLog(@"%@", model);
//            NSArray *translation = [NSArray array];
//            if (model.basic == nil ) {
//                youdaoWebModel *webmodel = model.web[1];
//                translation = webmodel.value;
//            }else{
//    
//                translation = model.basic.explains;
//            }
//            NSLog(@"%@" ,[translation componentsJoinedByString:@"|"]);

        }
    }
    
}
@end