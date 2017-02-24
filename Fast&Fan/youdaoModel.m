//
//  youdaoModel.m
//  Fast&Fan
//
//  Created by Eric on 2017/2/22.
//  Copyright © 2017年 Doflamingo. All rights reserved.
//

#import "youdaoModel.h"

@implementation youdaoModel

-(void)setWeb:(NSArray *)web{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in web) {
        youdaoWebModel *webmodel = [youdaoWebModel objectWithKeyValues:dic];
        [arr addObject:webmodel];
    }
    _web = arr;
}
@end
