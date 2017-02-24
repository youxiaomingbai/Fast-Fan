//
//  youdaoModel.h
//  Fast&Fan
//
//  Created by Eric on 2017/2/22.
//  Copyright © 2017年 Doflamingo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "youdaoWebModel.h"
#import "youdaoBasicModel.h"

@interface youdaoModel : NSObject
@property (nonatomic, strong) NSString* translation;
@property (nonatomic, strong) youdaoBasicModel *basic;
@property (nonatomic, strong) NSArray* web;

@end
