//
//  CustomtextView.h
//  ConnectionCity
//
//  Created by umbrella on 2018/5/13.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomTextviewDelegate <NSObject>
@optional
-(void)stringShow:(NSString *)txt;
@end
@interface CustomtextView : UITextView

/**
 最大字数
 */
@property (nonatomic,assign)NSInteger maxNum;
/** 占位文字 */
@property (nonatomic, copy)IBInspectable  NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic, strong)IBInspectable  UIColor *placeholderColor;
@property (nonatomic,assign)id <CustomTextviewDelegate>cusdelegate;
@end
