//
//  HeadView.m
//  LBYX
//
//  Created by john on 2019/5/31.
//  Copyright © 2019 qt. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self addSubview:self.headImage];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.headImage.frame = CGRectMake(self.centerX-55, self.centerY-55, 110, 110);
}
-(UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo"]];
    }
    return _headImage;
}
@end
