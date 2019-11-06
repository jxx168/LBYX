//
//  CommonAlertView.m
//  lessonTeacher
//
//  Created by john on 2019/4/26.
//  Copyright © 2019 qt. All rights reserved.
//

#import "CommonAlertView.h"
#import <UIView+TYAlertView.h>
@implementation CommonAlertView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.txt_Name.limitedType = LimitedTextFieldTypeEmail;
    //设置最大长度
    self.txt_Name.maxLength = 12;
}
+ (CommonAlertView *)alertindex:(NSInteger)index{
    return [[NSBundle mainBundle]loadNibNamed:@"CommonAlertView" owner:nil options:nil][index];
}
+ (void)alertCommonHandler:(CommAlertHandle)cancelHandler{
    CommonAlertView * alert = [CommonAlertView alertindex:1];
    alert.alertHAndle = cancelHandler;
    [alert showInWindowWithBackgoundTapDismissEnable:YES];
}
+ (void)alertCommonSignalTitle:(UIViewController *)controll Handler:(CommAlertSureHandle)cancelHandler   {
    CommonAlertView * alert = [CommonAlertView alertindex:2];
    alert.frame = CGRectMake(0, 0, kScreenWidth-40, 205);
    alert.alertSureHandle = cancelHandler;
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alert preferredStyle:TYAlertControllerStyleAlert];
    alertController.backgoundTapDismissEnable = YES;
    [controll presentViewController:alertController animated:YES completion:nil];
}
- (IBAction)btnCluckSignal:(UIButton *)sender {
//    if ([ToolKit dx_isNullOrNilWithObject:self.txt_Name.text]&&[ToolKit dx_isNullOrNilWithObject:self.txt_Pin.text]) {
//        return [YTAlertUtil showTempInfo:LocalizedStaing(@"请输入蓝牙名称或PIN")];
//    }
    if (self.txt_Name.text.length<6) {
        return [YTAlertUtil showTempInfo:LocalizedStaing(@"请输入6-12位英文字母或数字")];
    }
    [self hideView];
    if (self.alertSureHandle)self.alertSureHandle(self.txt_Name.text,self.txt_Pin.text);
}
- (IBAction)btn_sure:(UIButton *)sender {
    [self hideInWindow];
    if (self.alertHAndle)  self.alertHAndle();
}
@end
