//
//  BtnView.h
//  LBYX
//
//  Created by john on 2019/7/3.
//  Copyright © 2019 qt. All rights reserved.
//

#import <UIKit/UIKit.h>
//定义枚举类型
typedef enum BtnState {
    BtnStateSelect  = 0,
    BtnStateUnSelect,
   BtnStateUnEnable
} BtnState;

/**
 点击事件代理
 */
@protocol BtnViewDelegate <NSObject>
@optional
-(void)btnClickDelegate:(NSInteger )tag;
@end
NS_ASSUME_NONNULL_BEGIN
@interface BtnView : UIView
@property (nonatomic,assign) BtnState status;
@property (nonatomic,strong)NSString * versionStatus;//设备状态
@property (nonatomic,assign) id<BtnViewDelegate>Bdelegate;
@end
NS_ASSUME_NONNULL_END
