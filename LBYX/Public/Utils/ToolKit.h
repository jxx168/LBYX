//
//  ToolKit.h
//  HealthyDocks
//
//  Created by mahaitao on 2017/8/1.
//  Copyright © 2017年 summer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MKButtonEdgeInsetsStyle) {
    MKButtonEdgeInsetsStyleTop, // image在上，label在下
    MKButtonEdgeInsetsStyleLeft, // image在左，label在右
    MKButtonEdgeInsetsStyleBottom, // image在下，label在上
    MKButtonEdgeInsetsStyleRight // image在右，label在左
};

@interface ToolKit : NSObject

///创建有文字和图片的按钮
+(UIButton*)createButtonWithFrame:(CGRect)frame target:(id)target Action:(SEL)action Title:(NSString*)title fontSize:(int)fontSize;

//时间戳转换
+ (NSString *)getTimeStr:(NSString *)timestamp style:(NSString *)style isSystemTime:(BOOL)isSystemTime;
//时间字符串转换时间戳
+ (NSString*)timeStingTotimestamp:(NSString *)timeSting;
//时间列表转换时间戳
+ (NSString *)timeStr:(NSString *)timestamp;

+ (NSString *)timeHourStr:(long )timestamp timeMap:(NSString *)map;
//获取当前时间戳  （以毫秒为单位）
+(NSString *)getNowTimeTimestamp;
//根据日期获取当前星期
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;
//判断输入的字符串是不是手机号码
+ (BOOL)isValidateMobile:(NSString *)mobile;
//验证邮箱
+ (BOOL)isValidateEmail:(NSString *)email;
//处理分割线边缘有间隙问题和多余的cell问题
+ (void)setLastCellSeperatorToLeft:(UITableViewCell *)cell;
+ (void)setOtherCellSeperatorToLeft:(UITableViewCell *) cell leftSpace:(NSInteger)leftSpace;
//设置不同字体颜色
+ (void)styleLabel:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor;
//颜色转图片
+(UIImage *)createImageWithColor:(UIColor *)color;
//颜色转图片
+(UIImage *)createImageWithColor:(UIColor *)color withSize:(CGSize)size;
//检测字符串是否包含特殊字符和emoji
+(BOOL)isIncludeSpecialCharact: (NSString *)str;
//检测字符串是否包含汉字
+(BOOL)hasChinese:(NSString *)str;

#pragma mark - 存入本地信息: Object
+(void)storageObject:(id)myMessage Key:(NSString*)mykey;

#pragma mark - 读取一个本地信息: Object
+(id)getStorageObjectWithKey:(NSString *)mykey;

//创建按钮title
+ (UIButton *)createButtonWithFrame:(CGRect)frame Target:(id)target Action:(SEL)action Title:(NSString*)title NormalImg:(NSString *)normalImg HightedImg:(NSString *)hightedImg FontSize:(int)fontSize Textcolor:(UIColor *)textcolor;
//设置 NSString 的样式(带有行间距的情况)
+ (void)getSpaceLabelStr:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width withLineSpace:(CGFloat)lineSpaceH withKernAttribute:(NSNumber*)kernW withLabel:(UILabel *)label alignment:(NSTextAlignment)alignment;
// 获取内容size
+ (CGSize)getSizeWithStr:(NSString *)string
                    font:(UIFont *)font
                    size:(CGSize)size;
//计算 NSString 的高度(带有行间距的情况)
+ (CGFloat)getSpaceLabelStr:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width withLineSpace:(CGFloat)lineSpaceH withKernAttribute:(NSNumber*)kernW alignment:(NSTextAlignment)alignment;
/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
+ (void)layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space withButton:(UIButton*)sender;

// 签名参数
+ (NSString *)signSortedDictionary:(NSDictionary *)dict name:(NSString *)intefaceName timeInterval:(NSTimeInterval)timer;

// md5加密
+ (NSString *)returnMD5Hash:(NSString*)concat;

// - 验证码倒计时
+ (void)specialStartTimeWithBtn:(UIButton *)btn btnTFont:(UIFont *)btnTFont;

// 计算刚刚2分钟前1小时前等
+ (NSString *)formateDate:(NSString *)dateString withFormate:(NSString *)formate;

//获取服务器时间 保存到沙盒
+ (void)dateResponseFromNSString:(NSString *)str;

//设置获得服务器时间 -- 要设置需要的样式
+ (NSString *)getResponseFormatter:(NSString *)formatterStr;

//将后台传的秒数转换为日期格式
+ (NSString *)returndate:(NSString *)secondStr;

/* 根据 dWidth dHeight 返回一个新的image**/
+ (UIImage *)drawWithWithImage:(UIImage *)imageCope width:(CGFloat)dWidth height:(CGFloat)dHeight;

// 压缩图片到指定大小
+  (void)compressedImageFiles:(UIImage *)image
                      imageKB:(CGFloat)fImageKBytes
                   imageBlock:(void(^)(UIImage *image))block;

// 图片压缩
+ (UIImage *)scaleFromImage:(UIImage *)image;

//按照图片大小设置
+ (CGSize)adaptationSizeWithOriginalSize:(CGSize)originalSize;
/**
 *  @param font     字符串样式
 *  @param maxWidth 指定字符串长度
 */
+ (CGFloat)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth text:(NSString *)text;
/**
 计算字符长度
 
 @param fontSize 字体大小
 @param text 文字内容
 @return 字符串的长度
 */
+ (CGFloat)sizeWithFontSize:(CGFloat)fontSize text:(NSString *)text;
/**
 生成二维码
 
 @param codeStr 二维码地址
 @param centerImage 中心图片
 */
+ (UIImage *)createCoreImage:(NSString *)codeStr  centerImage:(UIImage *)centerImage;
/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

/**
 拨打电话

电话号码
 */
+(void)DaDianHua:(NSString *)phone;

+ (NSArray *)weeks;
+(NSString*)ChatingTime:( long )timestamp;

#pragma mark 判断对象是否为空
+ (BOOL)dx_isNullOrNilWithObject:(id)object; 
@end
