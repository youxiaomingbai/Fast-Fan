//
//  Common.h
//  HotDeals
//
//  Created by Horex on 15/3/26.
//  Copyright (c) 2015年 mega. All rights reserved.
//

#ifndef HotDeals_Common_h
#define HotDeals_Common_h

//// GA
//#import "GAI.h"
//#import "GAIFields.h"
//#import "GAITracker.h"
//#import "GAIDictionaryBuilder.h"
//#import "MBGChooseStypeTool.h"



// SCREEN_NAME
#define     HOME                      @"home"
#define     DETAIL                     @"product_"
#define     FAV                         @"like"
#define     SEARCH                      @"search"
#define     SEARCHRESULT                @"searchresult"
#define     SHOP                        @"shop_"
#define     USER                        @"user"
#define     THEME                        @"theme_list"

#define     VERSIONSTR                        @"3.1.2" //当前版本 校验是否显示welcome界面使用  上传时一定要修改为当前
#define     VIDEOTITLEPLACESTR                @"Please enter the video title"//上传视频的title placeholder
#define     PROFILEINTRODUCEPLACESTR                @"Please enter the Introduce"//个人详情更改的introduce placeholder

// EXTENSION

#import "MJExtension.h"
//#import "MBGNetWorkTool.h"
#import "SwpNetworking.h"
//#import "UILabel+VerticalAlign.h"
//#import "NSString+Time.h"
//#import "SVProgressHUD.h"
//#import "MBProgressHUD.h"
//#import "NSString+Number.h"
//#import "UIImageView+WebCache.h"
//#import "UIView+Extension.h"
//#import "MBGTrackTool.h"
//#import "NSAttributedString+match.h"




#define             DOCUMENT        NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).lastObject

#define             WINDOW_HIGHT     [[UIScreen mainScreen] bounds].size.height

#define             WINDOW_WIDTH     [[UIScreen mainScreen] bounds].size.width
#define         SELF_VIEW_HIGHT                  self.view.frame.size.height
#define         SELF_VIEW_WIDTH                  self.view.frame.size.width

#define         RIDO                    [[UIScreen mainScreen] bounds].size.width / 375.0

#define         RIDO_TO_5S              [[UIScreen mainScreen] bounds].size.width / 320.0

// 1.判断是否为iOS7
#define     iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

// 2.获得RGB颜色
#define     MBGColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define     MBGFont(fontSize) [UIFont fontWithName:@"AGaramondPro-Regular" size:(fontSize)]
//#define     MBGFont(fontSize) [UIFont systemFontOfSize:(fontSize)]
#define     MBGTitleFont(fontSize) [UIFont fontWithName:@"OpenSans-Semibold" size:(fontSize)]

#define     MBGTimeFont(fontSize) [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:(fontSize)]
#define     MBGBrandFont(fontSize) [UIFont fontWithName:@"grtmrvsi" size:(fontSize)]
#define     MBGTimeNormalFont(fontSize) [UIFont fontWithName:@"times" size:(fontSize)]
#define     MBGBFont(fontSize) [UIFont fontWithName:@"OpenSans-Regular" size:(fontSize)]
#define     MBGHFont(fontSize) [UIFont fontWithName:@"HelveticaNeue-Light" size:(fontSize)]
#define     MBGOpenSansFont(fontSize) [UIFont fontWithName:@"opensans" size:(fontSize)]
#define     MBGCampton_LightDEMOfontFont(fontSize) [UIFont fontWithName:@"Campton-LightDEMO" size:(fontSize)]
#define     MBGFuturaFont(fontSize) [UIFont fontWithName:@"Futura LT Light" size:(fontSize)] 
#define     MBGCopperplateGothicLightFont(fontSize) [UIFont fontWithName:@"CopperplateGothicLight" size:(fontSize)]
//weakself 防止block里循环嵌套

#ifndef weakify_self
#if __has_feature(objc_arc)
#define weakify_self autoreleasepool{} __weak __typeof__(self) weakSelf = self;
#else
#define weakify_self autoreleasepool{} __block __typeof__(self) blockSelf = self;
#endif
#endif
#ifndef strongify_self
#if __has_feature(objc_arc)
#define strongify_self try{} @finally{} __typeof__(weakSelf) self = weakSelf;
#else
#define strongify_self try{} @finally{} __typeof__(blockSelf) self = blockSelf;
#endif
#endif


/*** 强弱引用转换，用于解决代码块（block）与强引用对象之间的循环引用问题
 * 调用方式: `@weakify(object)`实现弱引用转换，`@strongify(object)`实现强引用转换** 
 示例：
 * @weakify(object)
 * [obj block:^{
 * @strongify(object)
 * strong_object = something;
 * }];
 */
#ifndef weakify
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#endif
#ifndef strongify
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) strong##_##object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) strong##_##object = block##_##object;
#endif
#endif


//debug 打印
/**
 *  Debug模式下面输出
 */
#if DEBUG
#ifndef MBGLog
#define MBGLog(format, args...) \
NSLog(@"[%s %d]: " format "\n", strrchr(__FILE__, '/') + 1, __LINE__, ## args);
//          NSLog(@"%s %s, line %d: " format "\n",  strrchr(__FILE__, '/') + 1, __func__, __LINE__, ## args);
#endif
#else
#ifndef MBGLog
#define MBGLog(format, args...) do {} while(0)
#endif
#endif


#define fourInch ([UIScreen mainScreen].bounds.size.height == 568)


//判断iPhone版本
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


//判断当前版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]  

//#define             APP_VERSON                      @"app_verson"
//#define             USER_LONGITIDE                  @"longitude"
//#define             USER_LATITUDE                   @"latitude"


// 背景颜色
#define BGColor MBGColor(244, 244, 244)



#endif
