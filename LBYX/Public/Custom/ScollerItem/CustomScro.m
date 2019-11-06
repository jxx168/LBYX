//  CustomScro.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/29.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
#import "CustomScro.h"
#import "UIView+Extension.h"
@interface CustomScro()
@property (nonatomic,strong)UIView * viewLine;
@property (nonatomic,strong)UIButton * btn_last;
 @end
@implementation CustomScro
-(instancetype)initWithFrame:(CGRect)frame arr:(NSArray *)arr{
    if (self = [super initWithFrame:frame]) {
         [self defultColor];
         [self creatBtnLine:arr];
    }
    return self;
}

-(void)defultColor{
    self.titleSelectColor = KRGBColor(51, 65, 71);
    self.titleUnSelectColor =KRGBColor(107, 111, 121);
    self.lineColor = KRGBColor(29, 169, 255);
    self.isShowLine = NO;
}

-(void)creatBtnLine:(NSArray *)arr{
    float w = 0;
    for (int i=0; i<arr.count; i++) {
        float width = 0.0f;
        width = [ToolKit sizeWithFontSize:17 text:arr[i]];
        NSLog(@"====%f------%@",width,arr[i]);
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(w, 0, width, 38)];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize: 17];
        [btn setTitleColor:self.titleUnSelectColor forState:UIControlStateNormal];
        [btn setTitleColor:self.titleSelectColor forState:UIControlStateSelected];
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        w = self.size.width-width;
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i+1;
        [self addSubview:btn];
        if (i==0) {
            UIView * view= [[UIView alloc] initWithFrame:CGRectMake(btn.centerX-9, btn.height-5, 18, 3)];
            view.backgroundColor = self.lineColor;
            view.layer.cornerRadius = 1.5;
            view.layer.masksToBounds = YES;
            self.viewLine = view;
            btn.selected = YES;
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
            _btn_last = btn;
        }
    }
}
-(void)setTitleSelectColor:(UIColor *)titleSelectColor{
    _titleSelectColor = titleSelectColor;
    for (UIButton * btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn setTitleColor:titleSelectColor forState:UIControlStateSelected];
        }
    }
}
-(void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    self.viewLine.backgroundColor = lineColor;
}
-(void)setTitleUnSelectColor:(UIColor *)titleUnSelectColor{
    _titleUnSelectColor = titleUnSelectColor;
    for (UIButton * btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn setTitleColor:titleUnSelectColor forState:UIControlStateNormal];
        }
    }
}
//滑动按钮点击方法
-(void)btnClick:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(CustomScroBtnClick:)]) {
        [self.delegate CustomScroBtnClick:btn];
    }
    if (self.viewLine) {
        if (_btn_last == btn) {
            return;
        }
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        btn.selected = !btn.selected;
        _btn_last.selected = NO;
        _btn_last.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        _btn_last = btn;
        [UIView animateWithDuration:0.3 animations:^{
            self.viewLine.frame = CGRectMake(btn.centerX-9, btn.height-5, 18, 3);
        }];
    }
}
//是否显示滑动的view
-(void)setIsShowLine:(BOOL)isShowLine{
    _isShowLine = isShowLine;
    if (isShowLine) {
        [self addSubview:self.viewLine];
    }
}
@end
