//
//  CustomScro.h
//  ConnectionCity
//
//  Created by umbrella on 2018/6/29.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomScroDelegate <NSObject>
@optional
- (void)CustomScroBtnClick:(UIButton *)tag; //声明协议方法
@end

@interface CustomScro : UIView<UIScrollViewDelegate>
@property (nonatomic,assign) BOOL isShowLine;//是否显示底部的滑动条
@property (nonatomic,assign)id<CustomScroDelegate>delegate;
@property (nonatomic,strong)UIColor * titleSelectColor;//标题选中颜色
@property (nonatomic,strong)UIColor * titleUnSelectColor;//标题未选中颜色
@property (nonatomic,strong)UIColor * lineColor;//滑动条颜色
-(instancetype)initWithFrame:(CGRect)frame arr:(NSArray *)arr;
@end
