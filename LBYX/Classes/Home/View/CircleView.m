//
//  CircleView.m
//  LBYX
//
//  Created by john on 2019/6/5.
//  Copyright © 2019 qt. All rights reserved.
//

#import "CircleView.h"

static CGFloat  lineWidth = 15.0f;

@interface CircleView()
{
    //  扇环形进度条 背景
    CGContextRef    contextBack;
    UIBezierPath    *bezierPathBack;
    
    //  扇环形进度条 前景
    CGContextRef    contextFore;
    UIBezierPath    *bezierPathFore;
}
@end
@implementation CircleView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (!self) {
        self = nil;
    }
    self = [super initWithFrame:frame];
    return self;
}

- (void)drawRect:(CGRect)rect
{
    contextBack = UIGraphicsGetCurrentContext();
    contextFore = UIGraphicsGetCurrentContext();
    
//    [self drawFan:contextBack
//       bezierPath:bezierPathBack
//        knobAngle:-(180+startAngleValue)
//      strokeColor:[UIColor colorWithRed:47/255.0 green:72/255.0 blue:135/255.0 alpha:1.0f] flag:NO];
//
//    [self drawFan:contextFore
//       bezierPath:bezierPathFore
//        knobAngle:_knobValue
//      strokeColor: KRGBColorA(25, 207, 240, 0.62) flag:YES];
    [self drawOurSetWithRect:rect color:[UIColor colorWithRed:47/255.0 green:72/255.0 blue:135/255.0 alpha:1.0f] context:contextBack isGradientStyle:NO progress:1.0f];
    [self drawOurSetWithRect:rect color:nil context:contextFore isGradientStyle:YES progress:_progress];
}
/***********************
 角度说明
 
 90度
 |
 |
 |
 |
 0度  ----------------  180度
 |
 －30或者330  |
 |
 |
 270 度
 
 **************************/

//  绘制扇形
- (void)drawFan:(CGContextRef)context bezierPath:(UIBezierPath *)bezierPath knobAngle:(CGFloat)knobAngle strokeColor:(UIColor *)strokeColor flag:(BOOL)flag
{
//    NSLog(@"当前滑动的角度：%f",knobAngle);
    CGRect          frame           = self.frame;
    CGFloat         radius          = (CGRectGetWidth(frame) - lineWidth) / 2;
    CGFloat         angleForOne     = M_PI / 180.0f;
    CGFloat         circleLength    = radius * 2 * M_PI;
    int             gapCount        = KIsIPhone_5 ? (fanShowCount5 -1) : (fanShowCount - 1);                         //间隙个数
    CGFloat         gapWidth        = 3.5;                                        //间隙距离
    //  计算需要绘制的角度（角度制）
    CGFloat knobA = knobAngle;

    knobA = knobAngle >  startAngleValue ? knobAngle  :  startAngleValue;
    knobA = knobAngle < -(180 + endAngleValue) ? -(180 + endAngleValue) : knobAngle;
    bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame)/2) radius:(CGRectGetWidth(frame) - lineWidth)/2.0 startAngle:angleForOne * -90 endAngle:angleForOne * (flag ? -(180 - knobA) : (180 - knobA)) clockwise:YES];
    CGContextAddPath(context, bezierPath.CGPath);
    //  设置线的颜色，线宽，接头样式
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetLineCap(context, kCGLineCapButt);
    if (flag) {
        UIColor * currentColor;
        //获取当前渐变色
        currentColor = [self getGradientColor:fabs(knobA/gapCount)-0.8];
        NSLog(@"%f",fabs(knobAngle/gapCount));
        //设置线条颜色
        CGContextSetStrokeColorWithColor(context, currentColor.CGColor);
    }else{
        CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    }
    //  绘制虚线
    CGFloat drawLineLength = circleLength * (1- (startAngleValue + endAngleValue)/fullAngleValue);
    CGFloat showLineLengthPer = (drawLineLength - gapWidth * gapCount)/(KIsIPhone_5 ? (fanShowCount5 -1) : (fanShowCount - 1));
//
    CGFloat lengths[2] = {showLineLengthPer,gapWidth};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextDrawPath(context, kCGPathEOFillStroke);//最后一个参数是填充类型
    if (!self.blockViewArray) {
        self.blockViewArray = [[NSMutableArray alloc] init];
    } 
}
//画图
- (void)drawOurSetWithRect:(CGRect)rect color:(UIColor *)strokeColor context:(CGContextRef)ctx isGradientStyle:(BOOL)isGradientStyle progress:(float)progress{
    
#pragma mark 按制作由简到繁的顺序，标注了需要用到的属性
#pragma mark 1 初步制作，如果你没有动画，颜色渐变等要求的画，看这一部分就够了。
    //获取上下文，相当于画布
    CGRect          frame           = self.frame;
    CGFloat         radius          = (CGRectGetWidth(frame) - lineWidth) / 2;
    CGFloat         circleLength    = radius * 2 * M_PI;
    int             gapCount        = KIsIPhone_5 ? (fanShowCount5 ) : (fanShowCount);                         //间隙个数
    CGFloat         gapWidth        = 3.5;
    //环形进度条的中心点
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    //画扇形
    //设置线条宽度
    CGContextSetLineWidth(ctx, lineWidth);
    //设置中心填充颜色
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    if (!isGradientStyle) {//不使用渐变色
        //设置线条颜色
        CGContextSetStrokeColorWithColor(ctx, strokeColor.CGColor);
    }
    NSInteger count = gapCount;
    if (isGradientStyle) {
        progress = progress;
        count = gapCount * progress;
    }
    //每一小块的角度（弧度值）
    float perAngle = M_PI*2*progress/count;
    //当前开始角度
    float currentStartAngle;
    //当前结束角度
    float currentOverAngle;
    //当前颜色
    UIColor *currentColor;
    NSLog(@"当前个数为：%ld",(long)count);
    for (NSInteger i = 0; i<count; i++) {
        if (isGradientStyle) {
            //获取当前渐变色
            currentColor = [self getGradientColor:i*1.0/gapCount];
            //设置线条颜色
            CGContextSetStrokeColorWithColor(ctx, currentColor.CGColor);
        }
        //当前开始角度
        currentStartAngle = degreesToRadian(-startAngleValue) + perAngle * i;
        //当前结束角度
        currentOverAngle  = currentStartAngle + perAngle;
        CGFloat radious    = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame))/2.0;
        UIBezierPath *  bezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:radious-lineWidth/2.0 startAngle:currentStartAngle endAngle:currentOverAngle clockwise:YES];
        CGContextAddPath(ctx, bezierPath.CGPath);
        //  设置线的颜色，线宽，接头样式
        CGContextSetLineWidth(ctx, lineWidth);
        CGContextSetLineCap(ctx, kCGLineCapButt);
        
        
        //  绘制虚线
        CGFloat drawLineLength = circleLength * (1- (startAngleValue + endAngleValue)/fullAngleValue);
        CGFloat showLineLengthPer;
        showLineLengthPer = (drawLineLength - gapWidth * (gapCount))/(gapCount);
        CGFloat lengths[2] = {showLineLengthPer,gapWidth};
        CGContextSetLineDash(ctx, 0, lengths, 2);
        CGContextDrawPath(ctx, kCGPathEOFillStroke);//最后一个参数是填充类型
    }
}
//获取当前颜色
- (UIColor *)getGradientColor:(CGFloat)current{
    /*
     此处讲解一下，线性颜色获取原理
     一个颜色是由R\G\B\A四个要素组成，即由红、绿、蓝、透明度四个元素组成，掌控了这4个要素，你就掌控了这个颜色，所以定义2个float型的4位数组c1,c2用来存储这2个颜色的4个要素。
     然后该如何获取开始与结束颜色的这4个要素呢，不用急，系统已经给我们准备好了方法：
     - (BOOL)getRed:(nullable CGFloat *)red green:(nullable CGFloat *)green blue:(nullable CGFloat *)blue alpha:(nullable CGFloat *)alpha NS_AVAILABLE_IOS(5_0);
     用这个方法就能获取一个颜色的4个要素。也就是下方的1，2步。
     等你获取了开始，结束颜色的这4个要素后，我们就可以进行第3步，用系统的方法：
     + (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
     制造一个在当前进度的开始结束之间的相应颜色出来。哦，什么是当前进度啊，就是方法参数current（0～1）之间。为0时是开始颜色，为1时是结束颜色。
     */

    //1
    CGFloat c1[4];
    CGFloat c2[4];
    //2
    UIColor * startC = KRGBColorA(25, 245, 234, 1);
    UIColor * endC = KRGBColorA(25, 207, 240, 0.62);
    [endC getRed:&c1[0] green:&c1[1] blue:&c1[2] alpha:&c1[3]];
    [startC getRed:&c2[0] green:&c2[1] blue:&c2[2] alpha:&c2[3]];

    //3
    return [UIColor colorWithRed:current*c2[0]+(1-current)*c1[0] green:current*c2[1]+(1-current)*c1[1] blue:current*c2[2]+(1-current)*c1[2] alpha:current*c2[3]+(1-current)*c1[3]];
}

//根据某个锚点旋转
CGAffineTransform GetCGAffineTransformRotateAroundPoint1(float centerX, float centerY, float x ,float y ,float angle)
{
    x = x - centerX; //计算(x,y)从(0,0)为原点的坐标系变换到(CenterX ，CenterY)为原点的坐标系下的坐标
    y = y - centerY; //(0，0)坐标系的右横轴、下竖轴是正轴,(CenterX,CenterY)坐标系的正轴也一样
    CGAffineTransform  trans = CGAffineTransformMakeTranslation(x, y);
    trans = CGAffineTransformRotate(trans,angle);
    trans = CGAffineTransformTranslate(trans,-x, -y);
    return trans;
}

@synthesize knobValue = _knobValue;
- (void)setKnobValue:(CGFloat)knobValue
{
    _knobValue = knobValue;
    [self setNeedsDisplay];
}

@synthesize progress = _progress;
-(void)setProgress:(float)progress{
    _progress = progress;
    [self setNeedsDisplay];
}
@end
