//
//  PLView.h
//  lessonstudents
//
//  Created by john on 2019/3/27.
//  Copyright © 2019 adinnet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PJClickDelagate <NSObject>
@optional
-(void)PJTJ;//评价提交按钮
@optional

@end
@interface PLView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *image_code;
@property (weak, nonatomic) IBOutlet UILabel *lab_Title;
@property (weak, nonatomic) IBOutlet UIView *xx_view;
@property (nonatomic,copy) NSString * labTitle;
@property (nonatomic,weak) id<PJClickDelagate>delegate;
@end

NS_ASSUME_NONNULL_END
