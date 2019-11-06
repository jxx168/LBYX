//
//  Api.h
//  V1_BaseProject
//
//  Created by Mr.Han on 2018/2/28.
//  Copyright © 2018年 adinnet. All rights reserved.
//

#ifndef Api_h
#define Api_h
#import <UIKit/UIKit.h>
#ifdef DEBUG
    #define BaseUrl   @"http://10.40.254.78:9527/api/v1/"
#else
    #define BaseUrl           @"http://10.40.254.78:9527/api/v1/"
#endif 
#define IMGUrl              @"http://10.40.254.78:9527"

#define KeFuPhone @"400-1111111"

//通知
#define KNotiChaneLanguage @"KNotiChaneLanguage"
#define KNotiBluSuccess @"KNotiBluSuccess"
#define BlueName @"BlueName" //链接的蓝牙名称
#define KNotiSetVolum @"KNotiSetVolum" // 设置的是哪个声道
#define KNotiVersionClose @"KNotiVersionClose" //设备已断开 
#define KNotiVersionStatus @"KNotiVersionStatus" //设备支持哪种类型
//APP更新链接
//itms-apps://itunes.apple.com/cn/app/id1329918420?mt=8
//static NSString * const v1CheckVersionUrl = @"https://itunes.apple.com/lookup?id=1446531753";
//
//static NSString * const v1CheckUpdateUrl = @"itms-apps://itunes.apple.com/cn/app/id1329918420?mt=8";
//
//#pragma mark -----公共-------
////上传多个文件
//static NSString * const uploadManyFile = @"upload/uploadManyFile";

#endif /* Api_h */
