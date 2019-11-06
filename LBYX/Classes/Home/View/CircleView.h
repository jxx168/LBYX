//
//  CircleView.h
//  LBYX
//
//  Created by john on 2019/6/5.
//  Copyright © 2019 qt. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define        fullAngleValue  360.0
#define        fanCount        100                           //扇页总数
#define        fanShowCount   100                            //显示的扇页个数

#define        fanCount5        72                           //扇页总数
#define        fanShowCount5    72                           //显示的扇页个数

#define        angleForFan     fullAngleValue / fanCount    //每个扇页夹脚
#define        startAngleValue (90 - (fullAngleValue - fanShowCount*angleForFan)/2)
#define        endAngleValue   startAngleValue
//  角度转弧度
#define degreesToRadian(x) (M_PI * x / 180.0)

//  弧度转角度
#define radiansToDegrees(x) (180.0 * x / M_PI)
@interface CircleView : UIView
@property (nonatomic, assign) CGFloat   knobValue;
@property (nonatomic, assign) BOOL isSHowShadow;//是否显示阴影默认是NO
@property (nonatomic, assign) CGPoint   lightSource_InWindow;
//  小方格view的数组
@property (nonatomic, strong) NSMutableArray  *blockViewArray;
@property (nonatomic, assign) float progress;
@end

NS_ASSUME_NONNULL_END
