//
//  UUIDManager.m
//  V1_BaseProject
//
//  Created by Mr.Han on 2018/4/16.
//  Copyright © 2018年 adinnet. All rights reserved.
//

#import "UUIDManager.h"
#import "KeychainTool.h"

@implementation UUIDManager

+ (UUIDManager *)shareUUIDManager {
    
    static id distance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
            distance = [[UUIDManager alloc] init];
    });
    
    return distance;
}

- (NSString *)deviceUUID {
    NSString *bundleid = [[NSBundle mainBundle] bundleIdentifier];
    NSString *uuid = [KeychainTool readKeychainValue:bundleid];
    return uuid;
}

- (void)setDeviceUUID:(NSString *)deviceUUID {
    NSString *bundleid = [[NSBundle mainBundle] bundleIdentifier];
    // 设置uuid到设备中
    [KeychainTool saveKeychainValue:deviceUUID key:bundleid];
    
}

- (void)deleteOnlyUUID {
    NSString *bundleid = [[NSBundle mainBundle] bundleIdentifier];
    [KeychainTool deleteKeychainKey:bundleid];
}

@end
