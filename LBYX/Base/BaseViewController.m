//
//  BaseViewController.m
//  Dumbbell
//
//  Created by JYS on 16/1/19.
//  Copyright © 2016年 JYS. All rights reserved.
//

#import "BaseViewController.h" 
#import <AdSupport/AdSupport.h>
#import "BlueSearchController.h"
#import "BluetoothTool.h"
@interface BaseViewController ()
@property (nonatomic, strong) UIImageView *navBarHairlineImageView;
@property (nonatomic, assign) BOOL isNeedUpdate;
@property (assign, nonatomic)BOOL isTap;
@end

@implementation BaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置导航背景颜色
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //设置导航标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:
     [UIImage imageNamed:@"Rectangle"] forBarMetrics:UIBarMetricsDefault];
    self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    self.navBarHairlineImageView.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.view.backgroundColor = [UIColor whiteColor];
    self.isNeedUpdate = YES;
    if ([[BluetoothTool shareBlueTooth]blueToothPoweredOn]) {
        [self setDelegate];
    }
}
-(void)setDelegate{
    
    WeakSelf
     // 断开连接的回调函数
    [BApi setBlePeripheralDisonnected:^(CBCentralManager * _Nonnull central, CBPeripheral * _Nonnull peripheral, NSError * _Nonnull error) {
        [YTAlertUtil hideHUD];
        BApi.discoveredPeripheral = nil;
        [YTAlertUtil alertSingleWithTitle:LocalizedStaing(@"提示") message:LocalizedStaing(@"设备已断开,请重新连接") defaultTitle:LocalizedStaing(@"确定") defaultHandler:^(UIAlertAction *action) {
            [kNotificationCenter postNotificationName:KNotiVersionClose object:nil];
        } completion:nil];
    }];
//    指令发送成功
    [BApi setSendCompleted:^(CBCharacteristic * _Nonnull characteristic, NSData * _Nonnull data, NSError * _Nonnull error) {
        if (error == nil) {
            NSLog(@"发送成功%@",data);
            dispatch_async(dispatch_get_main_queue(), ^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(9.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf hidHud];
                });
            });
        }else{
            
        }
    }];
//    指令接受到的回调
    [BApi setPacketReceived:^(CBPeripheral * _Nonnull peripheral, NSData * _Nonnull data, NSError * _Nonnull error) {
        [YTAlertUtil hideHUD];
        [YTAlertUtil showTempInfo:LocalizedStaing(@"指令处理成功")];
        [kNotificationCenter postNotificationName:KNotiBluSuccess object:nil];
        //判断返回数据是否是0d0a结尾
        NSString * blutoothdataStr = [NSString fan_dataToHexString:data];
        [kNotificationCenter postNotificationName:KNotiSetVolum object:@{@"type":[blutoothdataStr substringToIndex:2]}];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        NSLog(@"接收的数据%@",[NSString fan_dataToHexString:data]);
    }];
    [self TanBlueNoOpen];
}
-(void)hidHud{
    [YTAlertUtil hideHUD];
    [YTAlertUtil showTempInfo:LocalizedStaing(@"指令处理超时")];
} 
-(void)back{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}
//0:leftBarButtonItems,1:rightBarButtonItems
- (void)initBarItem:(UIView*)view withType:(int)type{
    UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    //解决按钮不靠左 靠右的问题.iOS 11系统需要单独处理
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -16;//这个值可以根据自己需要自己调整
    switch (type) {
        case 0:
            if (!IS_IOS_VERSION_11) {
                self.navigationItem.leftBarButtonItems =@[spaceItem,buttonItem];
            }else{
                self.navigationItem.leftBarButtonItems =@[buttonItem];
            }
            break;
        case 1:
            if (!IS_IOS_VERSION_11) {
                self.navigationItem.rightBarButtonItems =@[spaceItem,buttonItem];
            }else{
                self.navigationItem.rightBarButtonItems =@[buttonItem];
            }
            break;
            
        default:
            break;
    }
}
#pragma mark - 滑动返回上一个界面
// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
// 作用：拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.isTap) {
        return NO;
    }
    
    [self.view endEditing:YES];
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if (self.navigationController.childViewControllers.count <= 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint point = [pan translationInView:self.view];
    if (point.x<0) {
        return NO;
    }
    
    return YES;
}

//设置状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
//隐藏导航条下方黑线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
//取消键盘响应
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
//获取文件路径
- (NSString *)getFilePathWithName:(NSString *)name {
    //首先取出Documents路径 然后在路径后追加文件名 此方法会自动添加斜杠
    return [[self getDocumentsPath] stringByAppendingPathComponent:name];
}
///获取Documents路径
- (NSString *)getDocumentsPath {
    NSString *documnetsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *userPath = [documnetsPath stringByAppendingPathComponent:@"UserNameJYS"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:userPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return userPath;
}
/**
 类名转换类
 
 @param name 类名
 */
-(UIViewController *)rotateClass:(NSString *)name{
    Class c = NSClassFromString(name);
    UIViewController * controller;
#if __has_feature(objc_arc)
    controller = [[c alloc] init];
#else
    controller = [[[c alloc] init] autorelease];
#endif
    return controller;
} 
/**
 *  懒加载UITableView
 *
 *  @return UITableView
 */
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, kScreenHeight - kTopHeight) style:UITableViewStylePlain];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.estimatedRowHeight = 50;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.backgroundColor = [UIColor clearColor];
        //头部刷新
        
        
        if (self.isNeedMJRefresh) {
            
            MJRefreshNormalHeader *header;
            MJRefreshAutoNormalFooter *footer;
            header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
            footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
            header.automaticallyChangeAlpha = YES;
            header.lastUpdatedTimeLabel.hidden = NO;
            
            // 设置文字
            [footer setTitle:@"" forState:MJRefreshStateIdle];
            
            _tableView.mj_header = header;
            _tableView.mj_footer = footer;
        }
        _tableView.scrollsToTop = YES;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}
-(void)headerRereshing{
    
}

-(void)footerRereshing{
    
}
-(void)setIsShowPic:(BOOL)isShowPic{
    _isShowPic = isShowPic;
    if (isShowPic) {
        [self.view addSubview:self.image_Bottom];
        [self.image_Bottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self.view);
            if (@available(iOS 11.0, *)) {
                make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.mas_equalTo(@(0));
            }
        }];
    }
}
-(UIImageView *)image_Bottom{
    if (!_image_Bottom) {
        _image_Bottom = [[UIImageView alloc] initWithFrame:CGRectZero];
        _image_Bottom.image = [UIImage imageNamed:@"BG"];
    }
    return _image_Bottom;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isNeedUpdate) {
        [self.view setNeedsLayout];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isNeedUpdate=YES;
}

- (void)viewDidAppear:(BOOL)animated{
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self updateNavLayout];
}

- (void)updateNavLayout{
    if (!IS_IOS_VERSION_11||!self.isNeedUpdate) {
        return;
    }
    self.isNeedUpdate=NO;
    UINavigationItem * item=self.navigationItem;
    NSArray * array=item.leftBarButtonItems;
    if (array&&array.count!=0){
        UIBarButtonItem * buttonItem=array[0];
        UIView * view =[[[buttonItem.customView superview] superview] superview];
        NSArray * arrayConstraint=view.constraints;
        for (NSLayoutConstraint * constant in arrayConstraint) {  //由于各个系统、手机类型（iPhoneX）的间距不一样，这里要根据不同的情况来做判断m，不一定是等于16的
            if (fabs(constant.constant)==20||fabs(constant.constant)==16) {
                constant.constant=0;
            }
//            NSLog(@"%f",constant.constant);
        }
    }
}
- (void)dealloc
{
    [kNotificationCenter removeObserver:self];
}
-(void)TanBlueNoOpen{
    //    判断蓝牙状态
    [BApi setBlueStatus:^(CBCentralManager *center) {
        if (center.state == 4) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [YTAlertUtil alertSingleWithTitle:LocalizedStaing(@"提示信息") message:LocalizedStaing(@"蓝牙未开启,请先开启蓝牙") defaultTitle:LocalizedStaing(@"去开启") defaultHandler:^(UIAlertAction *action) {
                    NSURL *url = [NSURL URLWithString:@"App-Prefs:root=Bluetooth"];
                    if ([[UIApplication sharedApplication]canOpenURL:url]) {
                        [[UIApplication sharedApplication]openURL:url];
                    }
                } completion:nil];
            });
        }
    }]; 
}
@end

