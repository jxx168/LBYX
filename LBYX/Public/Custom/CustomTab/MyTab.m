//
//  MyTab.m
//  emTab
//
//  Created by qt on 2018/7/26.
//  Copyright © 2018年 qt. All rights reserved.
//

#import "MyTab.h"
#import <MJRefresh.h>
@implementation MyTab
-(void)awakeFromNib{
    [super awakeFromNib];
    [self Mydelegate];
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self Mydelegate];
    }
    return self;
}
-(void)Mydelegate{
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0; 
}
-(void)setName:(NSString *)name{
    _name = name;
}
-(void)setImgName:(NSString *)imgName{
    _imgName = imgName;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:self.imgName?self.imgName:@"暂无课程"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = self.name?self.name:@"暂无课程";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:KRGBColor(143, 154, 166)
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
} 
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}
- (BOOL) emptyDataSetShouldAllowImageViewAnimate:(UIScrollView *)scrollView
{
    return YES;
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return self.tableHeaderView.frame.size.height/2.0f-50;
}
@end
