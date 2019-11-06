//
//  BaseViewController.h
//  Dumbbell
//
//  Created by JYS on 16/1/19.
//  Copyright © 2016年 JYS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,assign) BOOL isNeedMJRefresh;//是否刷新
@property (nonatomic,strong) UIImageView * image_Bottom;
@property (nonatomic,assign) BOOL isShowPic;//是否显示底图
/** 获取文件路径 */
- (NSString *)getFilePathWithName:(NSString *)name;
//类名转换类
-(UIViewController *)rotateClass:(NSString *)name;
- (void)initBarItem:(UIView*)view withType:(int)type;
-(void)TanBlueNoOpen;//去蓝牙打开设置页
@end
