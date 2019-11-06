//
//  MBProgressHUD+AN.m
//  AN
//
//  Created by AN on 2017/1/17.
//  Copyright © 2017年 Ant. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (AN)



+ (void)an_showTipMessageInWindow:(NSString*)message;
+ (void)an_showTipMessageInView:(NSString*)message;
+ (void)an_showTipMessageInWindow:(NSString*)message timer:(int)aTimer;
+ (void)an_showTipMessageInView:(NSString*)message timer:(int)aTimer;

/**
 默认显示在window上,无文字
 */
+ (void)an_showActivity;
+ (void)an_showActivityMessageInWindow:(NSString*)message;
+ (void)an_showActivityMessageInView:(NSString*)message;
+ (void)an_showActivityMessageInWindow:(NSString*)message timer:(int)aTimer;
+ (void)an_showActivityMessageInView:(NSString*)message timer:(int)aTimer;


+ (void)an_showSuccessMessage:(NSString *)Message;
+ (void)an_showErrorMessage:(NSString *)Message;
+ (void)an_showInfoMessage:(NSString *)Message;
+ (void)an_showWarnMessage:(NSString *)Message;


+ (void)an_showCustomIconInWindow:(NSString *)iconName message:(NSString *)message;
+ (void)an_showCustomIconInView:(NSString *)iconName message:(NSString *)message;


+ (void)an_dismiss;

+(UIViewController *)getCurrentUIVC;


@end
