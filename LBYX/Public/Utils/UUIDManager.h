//
//  UUIDManager.h
//  V1_BaseProject
//
//  Created by Mr.Han on 2018/4/16.
//  Copyright © 2018年 adinnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUIDManager : NSObject
+ (UUIDManager *)shareUUIDManager;

@property (nonatomic, copy) NSString *deviceUUID;


- (void)deleteOnlyUUID;

@end
