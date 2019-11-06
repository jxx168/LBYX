//
//  AppDelegate.m
//  LBYX
//
//  Created by john on 2019/5/31.
//  Copyright © 2019 qt. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+LifeCycle.h"
#import "BluetoothTool.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [ChangLanguage initUserLanguage];
    [ChangLanguage setUserLanguage:[ChangLanguage userLanguage]];
    [self registerRootControoler:launchOptions];//设置跟试图
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [BlueApi disconnect];
//    [BlueApi stopScan];
//    [BlueApi clearCache];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self TanBlueNoOpen];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)TanBlueNoOpen{
    if (![[BluetoothTool shareBlueTooth] blueToothPoweredOn]) {
        [YTAlertUtil alertSingleWithTitle:LocalizedStaing(@"提示信息") message:LocalizedStaing(@"蓝牙未开启,请先开启蓝牙") defaultTitle:LocalizedStaing(@"去开启") defaultHandler:^(UIAlertAction *action) {
            NSURL *url = [NSURL URLWithString:@"App-Prefs:root=Bluetooth"];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
        } completion:nil];
    }else{
        [kNotificationCenter postNotificationName:KNotiChaneLanguage object:nil];
    }
}
@end
