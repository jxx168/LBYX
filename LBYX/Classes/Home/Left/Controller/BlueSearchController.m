//
//  BlueSearchController.m
//  LBYX
//
//  Created by john on 2019/6/19.
//  Copyright © 2019 qt. All rights reserved.
//

#import "BlueSearchController.h"
#import "LeftCell.h"
@interface BlueSearchController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tab_bottom;
//中心管理者
@property (nonatomic,strong) BluetoothTool * API;
@property (nonatomic,strong) NSMutableArray * arr_data;
@property (nonatomic,strong) NSTimer * timer1;
@property (nonatomic,assign) NSInteger Times;//发送获取设备信息的次数
@end

@implementation BlueSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arr_data = [NSMutableArray array];
    [self initApi];
 }
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)initApi{
    self.title = @"蓝牙搜索";
    self.API = [[BluetoothTool shareBlueTooth] init];
    [self.API startScan];
    [self setDelegate1];
    //刷新
    WeakSelf
    self.tab_bottom.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.tab_bottom.userInteractionEnabled = NO;
        [weakSelf.arr_data removeAllObjects];
        [weakSelf.tab_bottom reloadData];
        [weakSelf.tab_bottom.mj_header endRefreshing];
//        [weakSelf.api startScan];
        [weakSelf.API startScan];
        weakSelf.tab_bottom.userInteractionEnabled = YES;
    }];
    self.tab_bottom.mj_header.automaticallyChangeAlpha = YES;
    // 设置代理
    [self loadBluTooth];
    [self.tab_bottom reloadData];
}
//搜索蓝牙外设
-(void)loadBluTooth{
    // 判断蓝牙是否打开
    WeakSelf
    [self.API setBlePeripheralFound:^(CBCentralManager * _Nonnull central, CBPeripheral * _Nonnull peripheral, NSDictionary * _Nonnull advertisementData, NSNumber * _Nonnull RSSI) {
        if (![weakSelf.arr_data containsObject:peripheral]) {
             [weakSelf insertTableView:peripheral advertisementData:advertisementData RSSI:RSSI];
        }
    }];
    //    链接成功
    [self.API setBlePeripheralConnected:^(CBCentralManager * _Nonnull central, CBPeripheral * _Nonnull peripheral) {
        //        [BluetoothTool shareBlueTooth].discoveredPeripheral = peripheral;
        [YTAlertUtil hideHUD];
        [YTAlertUtil showTempInfo:LocalizedStaing(@"连接成功")];
        [YTAlertUtil showHUDWithTitle:LocalizedStaing(@"获取设备信息中...")];
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf PDVersionType];
            });
        });
        //      [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}
//判断设备类型
-(void)PDVersionType{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.timer1 = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(timerMethod1) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer1 forMode:NSRunLoopCommonModes];
    [self.timer1 fire];
}
-(void)timerMethod1{
    WeakSelf
    //    判断设备支持类型
    //    NSString * dataStrW = @"AA000100000000";//外部设备
    //    NSString * dataStrN = @"AA000200000000";//内部设备 aa00020101000000
    NSString * dataStrHX = @"AA000300000000";//混响设备
    weakSelf.Times++;
    NSLog(@"当前搜索的次数：%ld",(long)weakSelf.Times);
    [BApi writeChar:[dataStrHX hexToData] response:YES];
    if (weakSelf.Times>=5) {
        [YTAlertUtil hideHUD];
        [weakSelf.timer1 invalidate];
        weakSelf.timer1 = nil;
        [YTAlertUtil showTempInfo:LocalizedStaing(@"设备连接错误,请重新连接")];
    }
}
-(void)setDelegate1{
    //    指令接受到的回调
    WeakSelf
    [BApi setPacketReceived:^(CBPeripheral * _Nonnull peripheral, NSData * _Nonnull data, NSError * _Nonnull error) {
        [YTAlertUtil hideHUD];
        //        [YTAlertUtil showTempInfo:@"设备信息获取成功"];
        NSString * blutoothdataStr = [NSString fan_dataToHexString:data];
        if ([blutoothdataStr containsString:@"aa"]&&blutoothdataStr.length>=16) {
            NSString * status = [blutoothdataStr substringWithRange:NSMakeRange(8, 2)];
            if ([status isEqualToString:@"01"]||[status isEqualToString:@"02"]||[status isEqualToString:@"03"]) {
                NSLog(@"接收的数据%@",status);
                [weakSelf.timer1 invalidate];
                [kNotificationCenter postNotificationName:KNotiVersionStatus object:@{@"status":status}];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [kNotificationCenter postNotificationName:KNotiVersionStatus object:@{@"status":@""}];
        }
    }];
}
//插入table数据
-(void)insertTableView:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    if ([RSSI integerValue]<-100 && [RSSI integerValue]>0) return;
    if(![self.arr_data containsObject:peripheral]) {
        if (!self.tableView.isDragging && !self.tableView.isTracking && !self.tableView.isDecelerating) {
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.arr_data.count inSection:0];
            [indexPaths addObject:indexPath];
            [self.arr_data addObject:peripheral];
            [self.tab_bottom insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.arr_data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeftCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LeftCell1"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"LeftCell" owner:nil options:nil][1];
    }
    CBPeripheral * per = self.arr_data[indexPath.row];
    cell.lab_lbuName.text = per.name;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [YTAlertUtil showHUDWithTitle:@"设备链接中..."];
    [self.API connectBlueToothWithPeripheral:self.arr_data[indexPath.row]];
} 
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.API stopScan];
    if (self.arr_data) {
        [self.arr_data removeAllObjects];
    }
}
@end
