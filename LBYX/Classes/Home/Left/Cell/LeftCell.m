//
//  LeftCell.m
//  LBYX
//
//  Created by john on 2019/5/31.
//  Copyright © 2019 qt. All rights reserved.
//

#import "LeftCell.h"
static NSArray * dataArr;
static NSArray * dataArrS;
@implementation LeftCell

- (void)awakeFromNib {
    [super awakeFromNib];
     dataArr = @[@{@"image":@"icon_home1",@"name":LocalizedStaing(@"主页")},@{@"image":@"icon_Language",@"name":LocalizedStaing(@"语言选择")},@{@"image":@"icon_Bluetooth",@"name":LocalizedStaing(@"蓝牙")},@{@"image":@"icon_Wipe Data",@"name":LocalizedStaing(@"恢复出厂设置")},@{@"image":@"icon_Customer service",@"name":LocalizedStaing(@"客户服务")}];
    dataArrS = @[@"icon_home",@"icon_Language1",@"icon_Bluetooth1",@"icon_Wipe Data1",@"icon_Customer service"];
}
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath{
    LeftCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LeftCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"LeftCell" owner:nil options:nil][0];
    }
    NSInteger selct = [[kUserDefaults objectForKey:@"SELECTROW"] integerValue];
    if (selct == indexPath.row) {
        cell.iamge_head.image = [UIImage imageNamed:dataArrS[selct]];
        cell.lab_title.textColor = [UIColor colorWithWhite:1 alpha:1];
    }else{
        cell.iamge_head.image = [UIImage imageNamed:dataArr[indexPath.row][@"image"]];
        cell.lab_title.textColor = [UIColor colorWithWhite:1 alpha:0.5];
    }
    cell.lab_title.text = dataArr[indexPath.row][@"name"];
    return cell;
}
@end
