//
//  PLView.m
//  lessonstudents
//
//  Created by john on 2019/3/27.
//  Copyright © 2019 adinnet. All rights reserved.
//

#import "PLView.h"

@implementation PLView
- (void)awakeFromNib{
    [super awakeFromNib];
   UIImage * image =  [ToolKit createCoreImage:@"写代码写代码" centerImage:nil];
    self.image_code.image = image;
}
- (IBAction)btnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(PJTJ)]) {
        [self.delegate PJTJ];
    }
}
- (IBAction)CloseAni:(UIButton *)sender {
    [self hideInWindow];
}
-(void)setLabTitle:(NSString *)labTitle{
    _labTitle = labTitle;
    self.lab_Title.text = labTitle;
}
@end
