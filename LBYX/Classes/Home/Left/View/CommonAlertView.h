//
//  CommonAlertView.h
//  lessonTeacher
//
//  Created by john on 2019/4/26.
//  Copyright © 2019 qt. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CommAlertSureHandle)(NSString * _Nonnull Name,NSString * _Nonnull Pin);
typedef void(^CommAlertHandle)(void);
NS_ASSUME_NONNULL_BEGIN
@interface CommonAlertView : UIView
@property (weak, nonatomic) IBOutlet CustomTxt *txt_Name;
@property (nonatomic,copy)CommAlertHandle alertHAndle;
@property (nonatomic,copy)CommAlertSureHandle alertSureHandle;
@property (weak, nonatomic) IBOutlet CustomTxt *txt_Pin;
+ (void)alertCommonSignalTitle:(UIViewController *)controll Handler:(CommAlertSureHandle)cancelHandler;
+ (void)alertCommonHandler:(CommAlertHandle)cancelHandler;
@end

NS_ASSUME_NONNULL_END
