//
//  CustomtextView.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/13.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "CustomtextView.h"
 

@implementation CustomtextView
-(void)awakeFromNib{
    [super awakeFromNib];
    // 设置默认字体
    self.font = [UIFont systemFontOfSize:15];
    // 设置默认颜色
    self.placeholderColor = [UIColor grayColor];
    // 使用通知监听文字改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    [self CInit];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 设置默认字体
        self.font = [UIFont systemFontOfSize:15];
        // 设置默认颜色
        self.placeholderColor = [UIColor grayColor];
        // 使用通知监听文字改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self]; 
        [self CInit];
    }
    return self;
}
-(void)CInit{
     self.maxNum = 300;
}
- (void)textDidChange:(NSNotification *)note
{
    // 会重新调用drawRect:方法
    [self setNeedsDisplay];
//    //首行缩进
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 3;    //行间距
//    //    paragraphStyle.maximumLineHeight = 60;   /**最大行高*/
//    paragraphStyle.firstLineHeadIndent = 20.f;    /**首行缩进宽度*/
//    paragraphStyle.alignment = NSTextAlignmentJustified;
//    NSDictionary *attributes = @{
//                                 NSFontAttributeName:[UIFont systemFontOfSize:13],
//                                 NSParagraphStyleAttributeName:paragraphStyle
//                                 ,NSForegroundColorAttributeName:[UIColor hexColorWithString:@"#bbbbbb"]};
//    self.attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];
    NSInteger maxFontNum = self.maxNum;//最大输入限制
    NSString *toBeString = self.text;
    // 获取键盘输入模式
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { // zh-Hans代表简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > maxFontNum) {
                self.text = [toBeString substringToIndex:maxFontNum];//超出限制则截取最大限制的文本
                if (self.cusdelegate&&[self.cusdelegate respondsToSelector:@selector(stringShow:)]) {
                    [self.cusdelegate stringShow:[NSString stringWithFormat:@"%ld/%ld",(long)maxFontNum,(long)maxFontNum]];
                }
            } else {
                if (self.cusdelegate&&[self.cusdelegate respondsToSelector:@selector(stringShow:)]) {
                    [self.cusdelegate stringShow:[NSString stringWithFormat:@"%lu/%ld",(unsigned long)toBeString.length,(long)maxFontNum]];
                }
            }
        }
    } else {// 中文输入法以外的直接统计
        if (toBeString.length > maxFontNum) {
            self.text = [toBeString substringToIndex:maxFontNum];
            if (self.cusdelegate&&[self.cusdelegate respondsToSelector:@selector(stringShow:)]) {
                [self.cusdelegate stringShow:[NSString stringWithFormat:@"%ld/%ld",(long)maxFontNum,(long)maxFontNum]];
            }
        } else {
            if (self.cusdelegate&&[self.cusdelegate respondsToSelector:@selector(stringShow:)]) {
                [self.cusdelegate stringShow:[NSString stringWithFormat:@"%ld/%ld",toBeString.length,maxFontNum]];
            }
        }
    }
}
/**
 * 每次调用drawRect:方法，都会将以前画的东西清除掉
 */
- (void)drawRect:(CGRect)rect
{
    // 如果有文字，就直接返回，不需要画占位文字
    if (self.hasText) return;
    
    // 属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor;
    
    
    // 画文字
    rect.origin.x = 5;
    rect.origin.y = 8;
    rect.size.width -= 2 * rect.origin.x;
    [self.placeholder drawInRect:rect withAttributes:attrs];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setNeedsDisplay];
}

#pragma mark - setter
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    [self setNeedsDisplay];
}
-(void)setMaxNum:(NSInteger)maxNum{
    _maxNum = maxNum;
    [self setNeedsDisplay];
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];
}
- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self setNeedsDisplay];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
