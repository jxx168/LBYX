//
//  ToolKit.m
//  HealthyDocks
//
//  Created by mahaitao on 2017/8/1.
//  Copyright © 2017年 summer. All rights reserved.
//

#import "ToolKit.h"
#import <CommonCrypto/CommonDigest.h>

static int const TimeOut = 60;

@implementation ToolKit


+ (UIButton*)createButtonWithFrame:(CGRect)frame target:(id)target Action:(SEL)action Title:(NSString*)title fontSize:(int)fontSize {
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame=frame;
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    return button;
}


#pragma mark - 时间戳转换
+ (NSString *)getTimeStr:(NSString *)timestamp style:(NSString *)style isSystemTime:(BOOL)isSystemTime
{
    long long tempTime = [timestamp longLongValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:style];//设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSString *str = nil;
    if (isSystemTime) {
        str = [formatter stringFromDate:[NSDate date]];
    }else{
        str = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:tempTime/1000]];
    }
    return str;
}
#pragma mark - 时间列表转换时间戳
+ (NSString *)timeStr:(NSString *)timestamp{
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[timestamp doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd"];
    NSString *dateString       = [formatter stringFromDate: date];
    
    return dateString;
}

/**
 时间戳转换为指定的日期格式

 @param timestamp 时间戳
 @param map 格式
 @return 返回字符
 */
//yyyy-MM-dd HH:mm:ss
+ (NSString *)timeHourStr:(long )timestamp timeMap:(NSString *)map{
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =timestamp / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:map];
    NSString *dateString       = [formatter stringFromDate: date];
    
    return dateString;
}


//时间字符串转换时间戳
+ (NSString*)timeStingTotimestamp:(NSString *)timeSting {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设置源时间字符串的格式
//    [formatter setDateFormat:@"MM/dd"];//设置源时间字符串的格式
    NSDate* date = [formatter dateFromString:timeSting];
    NSTimeInterval a=[date timeIntervalSince1970]; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
    return timestamp;
}

//获取当前时间戳  （以毫秒为单位）

+(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
    
}
/**
 根据日期获取当前星期

 @param inputDate 日期
 @return 星期
 */
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    NSArray *weekdays =
    [NSArray arrayWithObjects:
     [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三",@"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar1 setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar1 components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
    
}
#pragma mark - 判断输入的字符串是不是手机号码
+ (BOOL)isValidateMobile:(NSString *)mobile{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}
#pragma mark - 邮箱地址的正则表达式
+ (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
#pragma mark - 处理分割线边缘有间隙问题和多余的cell问题

//设置最后一行
+ (void)setLastCellSeperatorToLeft:(UITableViewCell *)cell
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}
//设置其他行
+ (void)setOtherCellSeperatorToLeft:(UITableViewCell *) cell leftSpace:(NSInteger)leftSpace{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsMake(0, leftSpace, 0, 0);
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

//设置不同字体颜色
+ (void)styleLabel:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
    
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    
    labell.attributedText = str;
}
//颜色转图片
+(UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//颜色转图片
+(UIImage *)createImageWithColor:(UIColor *)color withSize:(CGSize)size
{
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(BOOL)isIncludeSpecialCharact: (NSString *)str {
    
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€,.!?，。！？
    
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€,.!?，。！？"]];
    
    if (urgentRange.location == NSNotFound)
    {
        //判断空格
        NSRange range = [str rangeOfString:@" "];
        if (range.location == NSNotFound) {
            //判断emoji
            if (![ToolKit stringContainsEmoji:str]) {
                return NO;
            }
            return YES;
        }
        return YES;
    }
    return YES;
}
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
     
                               options:NSStringEnumerationByComposedCharacterSequences
     
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                
                                const unichar hs = [substring characterAtIndex:0];
                                
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    
                                    if (substring.length > 1) {
                                        
                                        const unichar ls = [substring characterAtIndex:1];
                                        
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            
                                            returnValue = YES;
                                            
                                        }
                                        
                                    }
                                    
                                } else if (substring.length > 1) {
                                    
                                    const unichar ls = [substring characterAtIndex:1];
                                    
                                    if (ls == 0x20e3) {
                                        
                                        returnValue = YES;
                                        
                                    }
                                    
                                } else {
                                    
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        
                                        returnValue = YES;
                                        
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        
                                        returnValue = YES;
                                        
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        
                                        returnValue = YES;
                                        
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        
                                        returnValue = YES;
                                        
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        
                                        returnValue = YES;
                                        
                                    }
                                    
                                }
                            }];
    
    return returnValue;
}


#pragma mark - 存入本地信息: Object
+(void)storageObject:(id)myMessage Key:(NSString*)mykey
{
    //同步读取数据：
    NSUserDefaults *userDefaluts=[NSUserDefaults standardUserDefaults];
    NSString *oldMessage=[userDefaluts objectForKey:mykey];
    //如果存在: 删除旧的，保存新的
    if (oldMessage!=nil)
    {
        [userDefaluts removeObjectForKey:mykey];
    }
    [userDefaluts setObject:myMessage forKey:mykey];
    [userDefaluts synchronize];//同步保存数据
}

#pragma mark - 读取一个本地信息: Object
+(id)getStorageObjectWithKey:(NSString *)mykey
{
    if (mykey.length>0 && mykey!=nil)
    {
        NSUserDefaults *userDefaults= [NSUserDefaults standardUserDefaults];
        id myMessage=[userDefaults objectForKey:mykey];
        if (myMessage!=nil){
            return myMessage;
        }
    }
    return nil;
}
+(BOOL)hasChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
        
    }
    return NO;
    
}
//创建按钮title --- image
+ (UIButton *)createButtonWithFrame:(CGRect)frame Target:(id)target Action:(SEL)action Title:(NSString*)title NormalImg:(NSString *)normalImg HightedImg:(NSString *)hightedImg FontSize:(int)fontSize Textcolor:(UIColor *)textcolor
{
    UIColor *textColor = textcolor?textcolor:[UIColor blackColor];
    int font = fontSize!=0?fontSize:14;
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=frame;
    if(title){
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:textColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:font];
    }else{
        [button setImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"normal"] forState:UIControlStateHighlighted];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

// 获取内容size
+ (CGSize)getSizeWithStr:(NSString *)string
                    font:(UIFont *)font
                    size:(CGSize)size
{
    
    @try {
        // CGSize size = CGSizeMake(320.0f, MAXFLOAT);//FLT_MAX
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle};
        
        //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle};
        
        CGRect size_ios7 = [string boundingRectWithSize:size  //NSStringDrawingUsesLineFragmentOrigin
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:attributes
                                                context:nil];
        return size_ios7.size;
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

//设置 NSString 的样式(带有行间距的情况)
+ (void)getSpaceLabelStr:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width withLineSpace:(CGFloat)lineSpaceH withKernAttribute:(NSNumber*)kernW withLabel:(UILabel *)label alignment:(NSTextAlignment)alignment {
    
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paraStyle.alignment = alignment;
    paraStyle.lineSpacing = lineSpaceH; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:kernW
                          };
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}

//计算 NSString 的高度(带有行间距的情况)
+ (CGFloat)getSpaceLabelStr:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width withLineSpace:(CGFloat)lineSpaceH withKernAttribute:(NSNumber*)kernW alignment:(NSTextAlignment)alignment {
    
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = alignment;
    paraStyle.lineSpacing = lineSpaceH; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:kernW
                          };
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

+ (void)layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space withButton:(UIButton*)sender
{
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = sender.imageView.frame.size.width;
    CGFloat imageHeight = sender.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = sender.titleLabel.intrinsicContentSize.width;
        labelHeight = sender.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = sender.titleLabel.frame.size.width;
        labelHeight = sender.titleLabel.frame.size.height;
    }
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (style) {
        case MKButtonEdgeInsetsStyleTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }
            break;
        case MKButtonEdgeInsetsStyleLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case MKButtonEdgeInsetsStyleBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case MKButtonEdgeInsetsStyleRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
        default:
            break;
    }
    // 4. 赋值
    sender.titleEdgeInsets = labelEdgeInsets;
    sender.imageEdgeInsets = imageEdgeInsets;
}

/**
<<<<<<< HEAD
 对字典(Key-Value)排序 区分大小写
 
 @param dict 要排序的字典
 */
+ (NSString *)signSortedDictionary:(NSDictionary *)dict name:(NSString *)intefaceName timeInterval:(NSTimeInterval)timer{
    
    //将所有的key放进数组
    NSArray *allKeyArray = [dict allKeys];
    //序列化器对数组进行排序的block 返回值为排序后的数组
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id _Nonnull obj2) {
        /**
         In the compare: methods, the range argument specifies the
         subrange, rather than the whole, of the receiver to use in the
         comparison. The range is not applied to the search string.  For
         example, [@"AB" compare:@"ABC" options:0 range:NSMakeRange(0,1)]
         compares "A" to "ABC", not "A" to "A", and will return
         NSOrderedAscending. It is an error to specify a range that is
         outside of the receiver's bounds, and an exception may be raised.
         
         - (NSComparisonResult)compare:(NSString *)string;
         
         compare方法的比较原理为,依次比较当前字符串的第一个字母:
         如果不同,按照输出排序结果
         如果相同,依次比较当前字符串的下一个字母(这里是第二个)
         以此类推
         
         排序结果
         NSComparisonResult resuest = [obj1 compare:obj2];为从小到大,即升序;
         NSComparisonResult resuest = [obj2 compare:obj1];为从大到小,即降序;
         
         注意:compare方法是区分大小写的,即按照ASCII排序
         */
        //排序操作
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];
//    NSLog(@"afterSortKeyArray:%@",afterSortKeyArray);
    
    //通过排列的key值获取value
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortsing in afterSortKeyArray) {
        NSString *valueString = [dict objectForKey:sortsing];
        [valueArray addObject:valueString];
    }
//    NSLog(@"valueArray:%@",valueArray);
    
    timer = timer + 300;
    NSString *timestamp = [NSString stringWithFormat:@"%.0f",timer];
//    timestamp = [timestamp substringToIndex:10];
    NSString * resultStr = @"";
    for (int i = 0; i<afterSortKeyArray.count; i++) {
        resultStr = [NSString stringWithFormat:@"%@%@%@",resultStr,afterSortKeyArray[i],valueArray[i]];
    }
    
    resultStr = [NSString stringWithFormat:@"%@%@dd4669c9cd4ac9ac4b2738c19bbd9646",resultStr,[intefaceName uppercaseString]];
    
    NSString *md5str = [ToolKit returnMD5Hash:resultStr];
    
    resultStr = [NSString stringWithFormat:@"%@%@",md5str,timestamp];
    resultStr = [ToolKit returnMD5Hash:resultStr];
    
    return resultStr;
}

//获取字符串的MD5加密字符串
+ (NSString *)returnMD5Hash:(NSString*)concat {
    const char *concat_str = [concat UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, (CC_LONG)strlen(concat_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
    
}


 /*
 *btn       倒计时Button
 *btnTColor 倒计时的文字颜色
 *btnTFont  倒计时的文字大小
 *
 **/

// - 验证码倒计时
+ (void)specialStartTimeWithBtn:(UIButton *)btn btnTFont:(UIFont *)btnTFont
{
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    
    NSString *beBtnStr = btn.titleLabel.text;
    UIFont *beBtnFont = btn.titleLabel.font;
    UIColor *beBtnTColor = btn.titleLabel.textColor;
    
    __block int timeout = TimeOut;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer_t = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer_t,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer_t, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(timer_t);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [btn setTitle:beBtnStr forState:UIControlStateNormal];
                [btn setTitleColor:beBtnTColor forState:UIControlStateNormal];
                btn.titleLabel.font = beBtnFont;
                btn.userInteractionEnabled = YES;
            });
        }else{
            // int minutes = timeout / TimeOut;
            int seconds = timeout % TimeOut;
            if(seconds == 0)
            {
                seconds = TimeOut;
            }
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [btn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                [btn setTitleColor:beBtnTColor forState:UIControlStateNormal];
                btn.titleLabel.font = btnTFont;
                btn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(timer_t);
}

#pragma mark - 刚刚 10分钟前 1小时前等等
+ (NSString *)formateDate:(NSString *)dateString withFormate:(NSString *)formate
{
    @try {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        /// 必须设置这一句话，解决晚了8小时问题
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:formate];
        NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
        
        // NSDate *date = [NSDate date]; 这样写会晚8个小时
        // 解决东八区的问题
        NSDate * nowDate = [NSDate dateWithTimeIntervalSinceNow:8 * 60 * 60];;
        
        
        NSTimeInterval secondsPerDay = 24 * 60 * 60;
        NSTimeInterval beforeDay = 48*60*60;
        NSDate *tomorrow, *yesterday, *beforeYesterday;
        
        tomorrow = [nowDate dateByAddingTimeInterval: secondsPerDay];
        yesterday = [nowDate dateByAddingTimeInterval: -secondsPerDay];
        beforeYesterday = [nowDate dateByAddingTimeInterval:-beforeDay];
        
        // 10 first characters of description is the calendar date:
//        NSString * todayString = [[nowDate description] substringToIndex:10];
        NSString * yesterdayString = [[yesterday description] substringToIndex:10];
        NSString * beforeDayString = [[beforeYesterday description] substringToIndex:10];
        NSString * timeString = [[needFormatDate description] substringToIndex:10];
        
        if ([timeString isEqualToString:yesterdayString])
        {
            return @"昨天";
        }
        
        if ([timeString isEqualToString:beforeDayString])
        {
            return @"前天";
        }
        
        
        
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        
        //// 再然后，把间隔的秒数折算成天数和小时数：
        NSString *dateStr = @"";
        
        if (time<=60) {  // 1分钟以内的
            
            dateStr = @"刚刚";
            
        }else if(time<=60*60){  //  一个小时以内
            dateStr = @"10分钟前";
            
        }else if(time<=60*60*24){ // 今天多少小时前
            int mins = time/3600;
            dateStr = [NSString stringWithFormat:@"%d小时前",mins];
            
        }else if(time<=60*60*48){   // 在两天内的
                dateStr = @"昨天";
        }else if(time <= 60*60*72){

            dateStr = @"前天";
        }else {
            
                [dateFormatter setDateFormat:@"yyyy/MM/dd MM:dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
        }
        
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
    
    
}

//获取服务器时间 保存到沙盒
+ (void)dateResponseFromNSString:(NSString *)str{
    //Tue, 30 Jun 2015 03:55:54 GMT
    //30 Jun 2015 03:55:54
    NSString *timeStr = str.length > 25 ? [str substringWithRange:NSMakeRange(5, 20)] : @"";//截取字符串
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSLocale *local=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"];
    [formatter setLocale:local];//需要配置区域，不然会造成模拟器正常，真机日期为null的情况
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];//设置源时间字符串的格式
    NSDate* date = [formatter dateFromString:timeStr];//将源时间字符串转化为NSDate
    //    //上面是源，下面是目标
    //    NSDateFormatter* toformatter = [[NSDateFormatter alloc] init];
    //    [toformatter setDateStyle:NSDateFormatterMediumStyle];
    //    [toformatter setTimeStyle:NSDateFormatterShortStyle];
    //    [toformatter setDateFormat:@"yyyy-MM-dd"];//设置目标时间字符串的格式
    //    NSString *targetTime = [toformatter stringFromDate:date];//将时间转化成目标时间字符串
    //    NSDate* toDate = [toformatter dateFromString:targetTime];//将源时间字符串转化为NSDate
    
    [[NSUserDefaults standardUserDefaults] setValue:date forKey:@"responseDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//设置获得服务器时间 -- 要设置需要的样式
+ (NSString *)getResponseFormatter:(NSString *)formatterStr {
    
    NSDate *responseDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"responseDate"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatterStr];
    return [dateFormatter stringFromDate:responseDate];
}

//将后台传的秒数转换为日期格式
+ (NSString *)returndate:(NSString *)secondStr {
    
    int totalSeconds = [secondStr intValue];
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    
}


// 压缩图片到指定大小
+  (void)compressedImageFiles:(UIImage *)image
                     imageKB:(CGFloat)fImageKBytes
                  imageBlock:(void(^)(UIImage *image))block {
    
    __block UIImage *imageCope = image;
    CGFloat fImageBytes = fImageKBytes * 1024;//需要压缩的字节Byte
    
    __block NSData *uploadImageData = nil;
    
    uploadImageData = UIImagePNGRepresentation(imageCope);
    NSLog(@"图片压前缩成 %fKB",uploadImageData.length/1024.0);
    CGSize size = imageCope.size;
    CGFloat imageWidth = size.width;
    CGFloat imageHeight = size.height;
    
    if (uploadImageData.length > fImageBytes && fImageBytes >0) {
        
        dispatch_async(dispatch_queue_create("CompressedImage", DISPATCH_QUEUE_SERIAL), ^{
            
            /* 宽高的比例 **/
            CGFloat ratioOfWH = imageWidth/imageHeight;
            /* 压缩率 **/
            CGFloat compressionRatio = fImageBytes/uploadImageData.length;
            /* 宽度或者高度的压缩率 **/
            CGFloat widthOrHeightCompressionRatio = sqrt(compressionRatio);
            
            CGFloat dWidth   = imageWidth *widthOrHeightCompressionRatio;
            CGFloat dHeight  = imageHeight*widthOrHeightCompressionRatio;
            if (ratioOfWH >0) { /* 宽 > 高,说明宽度的压缩相对来说更大些 **/
                dHeight = dWidth/ratioOfWH;
            }else {
                dWidth  = dHeight*ratioOfWH;
            }
            
            imageCope = [ToolKit drawWithWithImage:imageCope width:dWidth height:dHeight];
            uploadImageData = UIImagePNGRepresentation(imageCope);
            
            NSLog(@"当前的图片已经压缩成 %fKB",uploadImageData.length/1024.0);
            //微调
            NSInteger compressCount = 0;
            /* 控制在 1M 以内**/
            while (fabs(uploadImageData.length - fImageBytes) > 1024) {
                /* 再次压缩的比例**/
                CGFloat nextCompressionRatio = 0.9;
                
                if (uploadImageData.length > fImageBytes) {
                    dWidth = dWidth*nextCompressionRatio;
                    dHeight= dHeight*nextCompressionRatio;
                }else {
                    dWidth = dWidth/nextCompressionRatio;
                    dHeight= dHeight/nextCompressionRatio;
                }
                
                imageCope = [ToolKit drawWithWithImage:imageCope width:dWidth height:dHeight];
                uploadImageData = UIImagePNGRepresentation(imageCope);
                
                /*防止进入死循环**/
                compressCount ++;
                if (compressCount == 10) {
                    break;
                }
                
            }
            
            NSLog(@"图片已经压缩成 %fKB",uploadImageData.length/1024.0);
            imageCope = [[UIImage alloc] initWithData:uploadImageData];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                block(imageCope);
            });
        });
    }
    else
    {
        block(imageCope);
    }
}

/* 根据 dWidth dHeight 返回一个新的image**/
+ (UIImage *)drawWithWithImage:(UIImage *)imageCope width:(CGFloat)dWidth height:(CGFloat)dHeight{
    
    UIGraphicsBeginImageContext(CGSizeMake(dWidth, dHeight));
    [imageCope drawInRect:CGRectMake(0, 0, dWidth, dHeight)];
    imageCope = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCope;
    
}

#pragma mark - 根据比例压缩图片
+ (UIImage *)scaleFromImage:(UIImage *)image
{
    if (!image)
    {
        return nil;
    }
    NSData *data =UIImageJPEGRepresentation(image, 1);
    CGFloat dataSize = data.length/1024;
    CGFloat width  = image.size.width;
    CGFloat height = image.size.height;
    CGSize size;
    
    if (dataSize<=50)//小于50k
    {
        return image;
    }
    else if (dataSize<=100)//小于100k
    {
        return image;
    }
    else if (dataSize<=200)//小于200k
    {
        size = CGSizeMake(width/1.5f, height/1.5f);
    }
    else if (dataSize < 300)
    {
        size = CGSizeMake(width/1.5f, height/1.5f);
    }
    else if (dataSize<=500)//小于500k
    {
        size = CGSizeMake(width/2.f, height/2.f);
    }
    else if (dataSize<=1000)//小于1M
    {
        size = CGSizeMake(width/3.f, height/3.f);
    }
    else if (dataSize<=2000)//小于2M
    {
        size = CGSizeMake(width/3.f, height/3.f);
    }
    else//大于2M
    {
        size = CGSizeMake(width/4.f, height/4.f);
    }
    NSLog(@"%f,%f",size.width,size.height);
//    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, YES, [[UIScreen mainScreen] scale]);
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (!newImage)
    {
        return image;
    }
    return newImage;
}

//按照图片大小设置
+ (CGSize)adaptationSizeWithOriginalSize:(CGSize)originalSize {
    
    if (originalSize.width == 0) {
        return originalSize;
    }
    
    if (originalSize.width) {
        CGFloat imgViewWidth = 0;
        CGFloat imgViewHeight = 0;

        CGFloat tImgWidth = originalSize.width;
        CGFloat tImgHeight = originalSize.height;
        
        if (tImgWidth >= tImgHeight) {//1/2
            imgViewWidth = kScreenWidth/2;
            imgViewHeight = tImgHeight/tImgWidth *imgViewWidth;
        }else{//2/5
            imgViewWidth = kScreenWidth/5*2;
            imgViewHeight = tImgHeight/tImgWidth *imgViewWidth;
        }
        
        return CGSizeMake(imgViewWidth, imgViewHeight);
    }else{
        
        //这个值可以根据自己设置默认的
        return CGSizeMake(kScreenWidth/2, 40);
    }
    
}

/**
 *  @param font     字符串样式
 *  @param maxWidth 指定字符串长度
 */
+ (CGFloat)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth text:(NSString *)text
{
    // 获取文字样式
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    
    // 根据文字样式计算文字所占大小
    // 文本最大宽度
    CGSize maxSize = CGSizeMake(maxWidth, MAXFLOAT);
    
    CGSize textSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
    CGFloat textWidth = textSize.height;
    // NSStringDrawingUsesLineFragmentOrigin -> 从头开始
    return textWidth;
}


/**
 计算字符长度

 @param fontSize 字体大小
 @param text 文字内容
 @return 字符串的长度
 */
+ (CGFloat)sizeWithFontSize:(CGFloat)fontSize text:(NSString *)text
{
    NSInteger length = [text lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    length -= (length - text.length) / 2;
    length = (length +1) / 2;
//    NSLog(@"%ld", (long)length);
    return (length+1)*fontSize;
}

/**
 生成二维码

 @param codeStr 二维码地址
 @param centerImage 中心图片
 */
+ (UIImage *)createCoreImage:(NSString *)codeStr  centerImage:(UIImage *)centerImage{
    //1.生成coreImage框架中的滤镜来生产二维码
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    [filter setValue:[[NSString stringWithFormat:@"%@",codeStr] dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    //4.获取生成的图片
    CIImage *ciImg=filter.outputImage;
    //放大ciImg,默认生产的图片很小
    
    //5.设置二维码的前景色和背景颜色
    CIFilter *colorFilter=[CIFilter filterWithName:@"CIFalseColor"];
    //5.1设置默认值
    [colorFilter setDefaults];
    [colorFilter setValue:ciImg forKey:@"inputImage"];
    [colorFilter setValue:[CIColor colorWithRed:0 green:0 blue:0] forKey:@"inputColor0"];
    [colorFilter setValue:[CIColor colorWithRed:1 green:1 blue:1] forKey:@"inputColor1"];
    //5.3获取生存的图片
    ciImg=colorFilter.outputImage;
    
    CGAffineTransform scale=CGAffineTransformMakeScale(10, 10);
    ciImg=[ciImg imageByApplyingTransform:scale];
    
    //    self.imgView.image=[UIImage imageWithCIImage:ciImg];
    
    //6.在中心增加一张图片
    UIImage *img=[UIImage imageWithCIImage:ciImg];
    //7.生存图片
    //7.1开启图形上下文
    UIGraphicsBeginImageContext(img.size);
    //7.2将二维码的图片画入
    //BSXPCMessage received error for message: Connection interrupted   why??
    //    [img drawInRect:CGRectMake(10, 10, img.size.width-20, img.size.height-20)];
    [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
    //7.3在中心划入其他图片
    
    UIImage *centerImg=centerImage;
    
    CGFloat centerW=50;
    CGFloat centerH=50;
    CGFloat centerX=(img.size.width-50)*0.5;
    CGFloat centerY=(img.size.height -50)*0.5;
    
    [centerImg drawInRect:CGRectMake(centerX, centerY, centerW, centerH)];
    //7.4获取绘制好的图片
    UIImage *finalImg=UIGraphicsGetImageFromCurrentImageContext();
    
    //7.5关闭图像上下文
    UIGraphicsEndImageContext();
    return finalImg;
}

/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) , CGRectGetHeight(lineView.frame)/ 2)];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}
#pragma mark 打电话
+(void)DaDianHua:(NSString *)phone {
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phone]]];
}
+ (NSArray *)weeks{
    return @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
}

+(NSString*)ChatingTime:(long )timestamp{

    // 创建日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 获取当前时间
    NSDate *currentDate = [NSDate date];
    
    // 获取当前时间的年、月、日。利用日历
    NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
//    NSInteger currentYear = components.year;
//    NSInteger currentMonth = components.month;
//    NSInteger currentDay = components.day;
    
    // 获取消息发送时间的年、月、日
    NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:msgDate];
//    CGFloat msgYear = components.year;
//    CGFloat msgMonth = components.month;
//    CGFloat msgDay = components.day;
    CGFloat msghours = components.hour;
    // 进行判断
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    if (msghours<12) {
        dateFmt.dateFormat = @"上午";
    }else{
        dateFmt.dateFormat = @"下午";
    }
    /*
    if (currentYear == msgYear && currentMonth == msgMonth && currentDay == msgDay) {
        //今天
        if (msghours<12) {
            dateFmt.dateFormat = @"上午 hh:mm";
        }else{
            dateFmt.dateFormat = @"下午 hh:mm";
        }
        
    }else if (currentYear == msgYear && currentMonth == msgMonth && currentDay-1 == msgDay ){
        //昨天
        dateFmt.dateFormat = @"昨天 HH:mm";
    }else{
        //昨天以前
        dateFmt.dateFormat = @"MM-dd HH:mm";
    }
     */
    
    
    // 返回处理后的结果
    return [dateFmt stringFromDate:msgDate];
    
}
#pragma mark 判断对象是否为空
+ (BOOL)dx_isNullOrNilWithObject:(id)object {
    if (object == nil || [object isEqual:[NSNull null]]) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@""]) {
            return YES;
        } else {
            return NO;
        }
    } else if ([object isKindOfClass:[NSNumber class]]) {
        /*
         if ([object isEqualToNumber:@0]) {
         return YES;
         } else {
         return NO;
         }
         */
    }
    return NO;
}
 
@end
