//
//  AuTuView.m
//  LBYX
//
//  Created by john on 2019/6/6.
//  Copyright © 2019 qt. All rights reserved.
//

#import "AuTuView.h"

@implementation AuTuView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor clearColor];
    }
    return self;
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //设置背景颜色
    [[UIColor clearColor]set];
    UIRectFill(self.bounds);
    //拿到当前视图准备好的画板
    CGContextRef context = UIGraphicsGetCurrentContext();
    //利用path进行不规则图形
    CGContextBeginPath(context);//标记
    CGContextMoveToPoint(context, 0, 0);//设置起点
    CGContextAddLineToPoint(context, 0, self.height);//第一条竖线
    CGContextAddLineToPoint(context, self.width, self.height);//底部横线
    CGContextAddLineToPoint(context, self.height, 0);//侧边竖线
    CGContextAddLineToPoint(context, self.width-30, 0);//凹行有边
    CGContextAddLineToPoint(context, self.width-60, 40);//凹行右边斜
    CGContextAddLineToPoint(context, self.width-140, 40);//凹行底
    CGContextAddLineToPoint(context, 30, 0); 
    CGContextClosePath(context);//路径结束标志，不写默认封闭
//    [[UIColor whiteColor] setFill]; //设置填充色
    [[UIColor whiteColor] setStroke]; //设置边框颜色
    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path
    //加入矩形边框并调用CGContextEOClip函数
    CGContextAddRect(context, CGContextGetClipBoundingBox(context));
    CGContextClip(context);
}
@end
