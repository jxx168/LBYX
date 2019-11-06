//
//  define.h
//  MiAiApp
//
//  Created by Ant on 2019/1/18.
//  Copyright © 2019年 Ant. All rights reserved.
//

// 全局工具类宏定义

#ifndef define_h
#define define_h

// 关闭内存泄漏提示
//#define MEMORY_LEAKS_FINDER_ENABLED 0
//#define MEMORY_LEAKS_FINDER_RETAIN_CYCLE_ENABLED 0

//获取系统对象
#define kApplication        [UIApplication sharedApplication]
#define kAppWindow          [UIApplication sharedApplication].delegate.window
#define kAppDelegate        (AppDelegate *)[UIApplication sharedApplication].delegate
#define kRootViewController [UIApplication sharedApplication].delegate.window.rootViewController
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

#define kIsIphoneX (([[UIApplication sharedApplication] statusBarFrame].size.height == 44.0f) ? (YES):(NO))
#define KIsIPhone_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) 
#define kStatusBarHeight (kIsIphoneX ? 44 : 20)
#define kIndicatorHeight (kIsIphoneX ? 34 : 0)
#define kNavBarHeight 44.0
#define kTabBarHeight (kIsIphoneX ? 83 : 49)
#define kTopHeight (kIsIphoneX ? 88 : 64) // 这个高度根据是否是iPhone X系列手机, 来设置导航条高度, 不能使用 [[UIApplication sharedApplication] statusBarFrame].size.height 动态获取, 定位/拨打电话/共享热点会导致页面布局错落

//获取屏幕宽高
#define kScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreen_Bounds [UIScreen mainScreen].bounds

#define kIphone6ScaleWidth kScreenWidth/375.0
#define kIphone6ScaleHeight kScreenHeight/667.0
//根据ip6的屏幕来拉伸
#define kRealWidth(width) width * kIphone6ScaleWidth
#define kRealHeight(height) height * kIphone6ScaleHeight

//强弱引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type
#define kStrongSelf(type) __strong typeof(type) type = weak##type

//View 圆角和加边框
#define kViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define kViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

#define WeakSelf          __weak typeof(self) weakSelf = self;

//property 属性快速声明 别用宏定义了，使用代码块+快捷键实现吧

///IOS 版本判断
#define IOSAVAILABLEVERSION(version) ([[UIDevice currentDevice] availableVersion:version] < 0)
///IOS 版本是否大于11
#define IS_IOS_VERSION_11 (([[[UIDevice currentDevice]systemVersion]floatValue] >= 11.0)? (YES):(NO))

// 当前系统版本
#define CurrentSystemVersion [[UIDevice currentDevice].systemVersion doubleValue]
//语言
#define LocalizedStaing(A) NSLocalizedStringFromTableInBundle(A, @"Language", [ChangLanguage bundle], nil)
//当前语言
//#define CurrentLanguage (［NSLocale preferredLanguages] objectAtIndex:0])

//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
//#ifdef DEBUG
//#define NSLog(...) printf("[%s] %s [第%d行]: %s\n", __TIME__ ,__PRETTY_FUNCTION__ ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
//#else
//#define NSLog(...)
//#endif


//拼接字符串
#define kNSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

#define kURL(urlString) [NSURL URLWithString:urlString]
//颜色
#define KHexColor(color) [UIColor hexColorWithString:color]
#define KClearColor [UIColor clearColor]
#define KWhiteColor [UIColor whiteColor]
#define KBlackColor [UIColor blackColor]
#define KGrayColor [UIColor grayColor]
#define KGray2Color [UIColor lightGrayColor]
#define KBlueColor [UIColor blueColor]
#define KRedColor [UIColor redColor]
#define KRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define KRGBColorA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define kRandomColor    [UIColor colorWithHue: (arc4random() % 256 / 256.0) saturation:((arc4random()% 128 / 256.0 ) + 0.5) brightness:(( arc4random() % 128 / 256.0 ) + 0.5) alpha:1]        //随机色生成

//字体
#define kBoldSystemFont(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define kSystemFont(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define kFont(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]


// NSInteger 转为字符串
#define kIntegerToString(Integer) [NSString stringWithFormat:@"%ld",Integer]

// 拼接完整路径url
#define kImgNetUrl(url) [NSString stringWithFormat:@"%@%@", kBasePicUrl, url]

//定义UIImage对象
#define kImageWithFile(_pointer) [UIImage imageWithContentsOfFile:([[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@%dx", _pointer, (int)[UIScreen mainScreen].nativeScale] ofType:@"png"])]
#define kImage_Named(name) [UIImage imageNamed:name]

/// 头像占位图
#define kPortraitPlaceholder kImage_Named(@"portrait_placeholder")


//数据验证
#define kStrValid(f) (f!=nil && [f isKindOfClass:[NSString class]] && ![f isEqualToString:@""])
#define kSafeStr(f) (kStrValid(f) ? f:@"")
#define kHasString(str,key) ([str rangeOfString:key].location!=NSNotFound)

#define kValidStr(f) kStrValid(f)
#define kValidDict(f) (f!=nil && [f isKindOfClass:[NSDictionary class]])
#define kValidArray(f) (f!=nil && [f isKindOfClass:[NSArray class]])
#define kValidNum(f) (f!=nil && [f isKindOfClass:[NSNumber class]])
#define kValidClass(f,cls) (f!=nil && [f isKindOfClass:[cls class]])
#define kValidData(f) (f!=nil && [f isKindOfClass:[NSData class]])

//获取一段时间间隔
#define kStartTime CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define kEndTime  NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start)
//打印当前方法名
#define kITTDPRINTMETHODNAME() ITTDPRINT(@"%s", __PRETTY_FUNCTION__)

// 是否是中文环境下
#define kIsChinese [[[COSLocalizedHelper shareLocalizedHelper] currentLanguage] isEqualToString:@"zh-Hans"]

// 沙盒 Caches 目录
#define kCachesDirectory [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject]


//发送通知
#define kPostNotification(name,obj) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];

// block安全传值
#define SAFE_BLOCK_CALL_NO_P(b) (b == nil ?: b())
#define SAFE_BLOCK_CALL(b, p) (b == nil ? : b(p) )
#define SAFE_BLOCK_CALL_2_P(b, p1, p2) (b == nil ? : b(p1, p2))

//单例化一个类
#define SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

//判断蓝牙是否连接
#define ISSearchController \
\
if (BApi.discoveredPeripheral==nil) {\
BlueSearchController * blue = [BlueSearchController new];\
[self.navigationController pushViewController:blue animated:YES];\
return;\
}

// 页面条数
#define kPageSize 20

//中文
#define ZHHANS @"zh-Hans"
//英文
#define EN @"en"

//获取蓝牙单例
#define BlueApi [FscBleCentralApi defaultFscBleCentralApi]
//获取蓝牙单例
#define BApi [BluetoothTool shareBlueTooth]

#endif /* define_h */

