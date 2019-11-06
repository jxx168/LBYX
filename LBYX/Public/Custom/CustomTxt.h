//
//  CustomTxt.h
//  LBYX
//
//  Created by john on 2019/6/3.
//  Copyright © 2019 qt. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, LimitedTextFieldType) {
    
    LimitedTextFieldTypeNomal = 0,
    LimitedTextFieldTypeNumber,           //数字
    LimitedTextFieldTypeNumberOrLetter,   //数字和字母
    LimitedTextFieldTypeEmail,            //数字 字母 和 特定字符( '.'  '@')
    LimitedTextFieldTypePassword,         //数字 字母 下划线
};

NS_ASSUME_NONNULL_BEGIN
@class CustomTxt;

@protocol LimitedTextFieldDelegate <NSObject>

//为了防止 self.delegate = self 然后外部有重写了这个delegate方法导致代理失效的问题，这里重写一遍系统的代理方法
//在使用LimitedTextField的使用请不要使用UITextField本身代理方法
@optional     //   ----这里只是拓展了textField的部分代理，如果有需要还可以自己实现在这里添加

/**
 键盘return键点击调用
 
 @param textField LimitedTextField
 */
-(BOOL)limitedTextFieldShouldReturn:(UITextField *)textField;

/**
 输入结束调用
 
 @param textField LimitedTextField
 */
-(void)limitedTextFieldDidEndEditing:(UITextField *)textField;

/**
 输入开始
 
 @param textField LimitedTextField
 */
-(void)limitedTextFieldDidBeginEditing:(UITextField *)textField;

/**
 输入内容改变调用(实时变化)
 
 @param textField LimitedTextField
 */
-(void)limitedTextFieldDidChange:(UITextField *)textField;

/**
 输入开始启动的时候调用
 
 @param textField LimitedTextField
 @return 是否允许编辑
 */
-(BOOL)limitedTextFieldShouldBeginEditing:(UITextField *)textField;

@end
@interface CustomTxt : UITextField
/**
 代理方法 尽量使用这个代理而不是用textfield的代理
 */
@property (nonatomic,weak) id<LimitedTextFieldDelegate> realDelegate;

/**
 LimitedTextFieldType 根据type值不同 给出不同limited 默认TYLimitedTextFieldTypeNomal
 */
@property (nonatomic,assign) LimitedTextFieldType limitedType;

/**
 TYTextField内容发生改变block回调
 */
@property (nonatomic, copy) void (^textFieldDidChange)(NSString *text);

/**
 textField允许输入的最大长度 默认 0不限制
 */
@property (nonatomic,assign) NSInteger maxLength;

/**
 距离左边的间距  默认10
 */
@property (nonatomic,assign) CGFloat leftPadding;

/**
 距离右边的间距 默认 10
 */
@property (nonatomic,assign) CGFloat rightPadding;

/**
 给placeHolder设置颜色
 */
@property (nonatomic,strong) UIColor *placeholderColor;

/**
 textField -> leftView
 */
@property (nonatomic,strong) UIView *customLeftView;

/**
 textField -> rightView
 */
@property (nonatomic,strong) UIView *customRightView;
@end

NS_ASSUME_NONNULL_END
