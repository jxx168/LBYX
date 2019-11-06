//
//  ChangLanguage.m
//  LBYX
//
//  Created by john on 2019/5/31.
//  Copyright © 2019 qt. All rights reserved.
//

#import "ChangLanguage.h"

@implementation ChangLanguage
static NSBundle *bundle = nil;
+ (NSBundle *)bundle {
    return bundle;
}

//首次加载时检测语言是否存在
+ (void)initUserLanguage {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *currLanguage = [def valueForKey:@"LocalLanguageKey"];
    if (!currLanguage) {
        NSArray *preferredLanguages = [NSLocale preferredLanguages];
        currLanguage = preferredLanguages[0];
        if ([currLanguage hasPrefix:@"en"]) {
            currLanguage = @"en";
        }else if ([currLanguage hasPrefix:@"zh-Hans"]) {
            currLanguage = @"zh-Hans";
        }else if ([currLanguage hasPrefix:@"zh-HK"] || [currLanguage hasPrefix:@"zh-Hant"]) {
            currLanguage = @"zh-Hant";
        }else {
            currLanguage = @"zh-Hant";
        }
        [def setValue:@"en" forKey:@"LocalLanguageKey"];
        [def synchronize];
    }
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];//生成bundle
}

//获取当前语言
+ (NSString *)userLanguage {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *language = [def valueForKey:@"LocalLanguageKey"];
    return language;
}

//设置语言
+ (void)setUserLanguage:(NSString *)language {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *currLanguage = [userDefaults valueForKey:@"LocalLanguageKey"];
//    if ([currLanguage isEqualToString:language]) {
//        return;
//    }
    [userDefaults setValue:language forKey:@"LocalLanguageKey"];
    [userDefaults synchronize];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];
}
@end
