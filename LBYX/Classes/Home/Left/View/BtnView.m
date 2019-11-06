//
//  BtnView.m
//  LBYX
//
//  Created by john on 2019/7/3.
//  Copyright © 2019 qt. All rights reserved.
//

#import "BtnView.h"
static NSArray * imgArr;
static NSArray * bgArr;
@interface BtnView()
@property (weak, nonatomic) IBOutlet UILabel *lab_Max;
@property (weak, nonatomic) IBOutlet UIImageView *image_Max;
@property (weak, nonatomic) IBOutlet UILabel *lab_Engine;
@property (weak, nonatomic) IBOutlet UIImageView *image_Engine;
@property (weak, nonatomic) IBOutlet UILabel *lab_volume;
@property (weak, nonatomic) IBOutlet UIImageView *iamge_volume;
@property (weak, nonatomic) IBOutlet UIButton *btn_Max;
@property (weak, nonatomic) IBOutlet UIButton *btn_Engine;
@property (weak, nonatomic) IBOutlet UIButton *btn_volume;
@property (nonatomic,copy) NSArray * btnArr;
@property (nonatomic,strong) UIColor * enableColor;
@end
@implementation BtnView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.btnArr = @[self.btn_Engine,self.btn_volume,self.btn_Max];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.frame = CGRectMake(0, 0, kScreenWidth, self.height+10);
}
-(void)setVersionStatus:(NSString *)versionStatus{
    _versionStatus = versionStatus;
    if ([versionStatus isEqualToString:@"01"]) {//外部设备
        [self.btn_volume setBackgroundImage:[UIImage imageNamed:@"bg_no"] forState:UIControlStateNormal];
        self.iamge_volume.image = [UIImage imageNamed:@"icon_Volume_no"];
        self.btn_volume.userInteractionEnabled = NO;
        self.lab_volume.textColor = KHexColor(@"#7B91C1");
    }else if ([versionStatus isEqualToString:@"02"]){//内部设备
        [self.btn_Engine setBackgroundImage:[UIImage imageNamed:@"bg_no"] forState:UIControlStateNormal];
        [self.btn_Max setBackgroundImage:[UIImage imageNamed:@"bg_no"] forState:UIControlStateNormal];
        self.image_Max.image = [UIImage imageNamed:@"icon_Max Sound_no"];
        self.image_Engine.image = [UIImage imageNamed:@"icon_Engine Sound_no"];
        self.btn_Engine.userInteractionEnabled  =self.btn_Max.userInteractionEnabled = NO;
        self.lab_Engine.textColor = self.lab_Max.textColor = KHexColor(@"#7B91C1");
    }else if ([versionStatus isEqualToString:@"07"] || [versionStatus isEqualToString:@"06"]||[versionStatus isEqualToString:@"08"]){
        for (UIButton * btn in self.btnArr) {
            if (btn.tag == [versionStatus intValue]+494) {
                btn.selected = YES;
            }else
                btn.selected = NO;
        }
    }
}
- (IBAction)btnClick:(UIButton *)sender {
    if (self.Bdelegate && [self.Bdelegate respondsToSelector:@selector(btnClickDelegate:)]) {
        [self.Bdelegate btnClickDelegate:sender.tag];
    }
}
@end
