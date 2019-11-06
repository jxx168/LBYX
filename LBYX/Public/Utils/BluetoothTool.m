//
//  BluetoothTool.m
//  LBYX
//
//  Created by john on 2019/6/5.
//  Copyright © 2019 qt. All rights reserved.
//

#import "BluetoothTool.h"
// FFF0 FE59
#define kServiceUUID @"FFF0"
/** 写特征的UUID */
#define kWriteCharacteristicUUID  @"FFF2"
/** 通知的UUID */
#define kNotifyCharacteristicUUID @"FFF1"
@interface BluetoothTool()<CBCentralManagerDelegate,CBPeripheralDelegate>

@end
@implementation BluetoothTool
/** 中心管理者 */
+ (instancetype)shareBlueTooth {
    static dispatch_once_t once;
    static BluetoothTool *blueTooth = nil;
    dispatch_once(&once, ^{
        blueTooth = [[self alloc] init];
    });
    return blueTooth;
}
/** 初始化中心管理者 */
- (instancetype)init {
    self = [super init];
    if (self) {
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], CBCentralManagerOptionShowPowerAlertKey, nil];
        self.centralMgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:options];
        self.array_peripheral = [[NSMutableArray alloc]init];
    }
    return self;
}
/** 开始扫描 */
- (void)startScan {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stopScan];
        [self.centralMgr scanForPeripheralsWithServices:nil options:nil];
    });
}
/** 停止扫描 */
- (void)stopScan {
    [self.centralMgr stopScan];
}
/** 连接蓝牙 */
- (void)connectBlueToothWithPeripheral:(CBPeripheral *)peripheral{
    [self cancelBlueTooth];
    NSLog(@"要连接的外设名称:%@",peripheral.name);
    _discoveredPeripheral = peripheral;
    [_centralMgr connectPeripheral:peripheral options:nil];
    [self stopScan];
}
/** 断开蓝牙 */
- (void)cancelBlueTooth {
    if (_discoveredPeripheral != nil) {
        [self.centralMgr cancelPeripheralConnection:_discoveredPeripheral];
    }
}
/** 写入数据 */
- (void)writeChar:(NSData *)data response:(BOOL)response;
 {
    NSLog(@"蓝牙要写入的数据: %@",data);
    // 回调didWriteValueForCharacteristic
    if (_writeCharacteristic == nil) {
        return;
    }
    if (_discoveredPeripheral.state == CBPeripheralStateConnected) {
        [_discoveredPeripheral writeValue:data forCharacteristic:_writeCharacteristic type:response?CBCharacteristicWriteWithResponse:CBCharacteristicWriteWithoutResponse];
    }
}
#pragma mark - CBCentralManagerDelegate
/** 只要中心管理者状态发生变化触发此代理方法 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    /*
     CBCentralManagerStateUnknown = 0,
     CBCentralManagerStateResetting,
     CBCentralManagerStateUnsupported,
     CBCentralManagerStateUnauthorized,
     CBCentralManagerStatePoweredOff,
     CBCentralManagerStatePoweredOn,
     */
    NSLog(@"当前蓝牙状态:%ld",(long)central.state);
    if (central.state == 5) {
        self.blueToothPoweredOn = YES;
    }
    if (self.blueStatus) {
        self.blueStatus(central);
    }
}
/** 发现外设后触发此代理方法 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    if ([RSSI integerValue]<0 && [RSSI integerValue]>-100) {
        if (peripheral.name.length>0) {
            if (self.blePeripheralFound) {
                self.blePeripheralFound(central, peripheral, advertisementData, RSSI);
            }
        } else{
            NSLog(@"无=====名蓝牙");
        }
    }
}
/** 中心管理者连接外设成功 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    //设置外设的代理
    [_discoveredPeripheral setDelegate:self];
    //搜索服务,回调didDiscoverServices
    [_discoveredPeripheral discoverServices:nil];
    //停止扫描
    [self stopScan];
    if (self.blePeripheralConnected) {
        self.blePeripheralConnected(central, peripheral);
    }
}
/** 中心管理者连接外设失败 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    //停止扫描
    [self stopScan];
    //此时连接发生错误
//    [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_CONNECT_FAIL_OR_DISCONNECT_PERIPHERAL object:@{@"central":central,@"peripheral":peripheral}];
}
/** 中心管理者丢失连接 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    if (self.blePeripheralDisonnected) {
        self.blePeripheralDisonnected(central, peripheral, error);
    }
}
#pragma mark - CBPeripheralDelegate
/** 发现外设的服务后调用的方法 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        NSLog(@"发现外设的服务发生错误 : %@", [error localizedDescription]);
        return;
    }
    for (CBService *s in peripheral.services) {
        NSLog(@"服务的UUID : %@", s.UUID);
        if ([s.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]]) {
//            //发现服务后,让设备再发现服务内部的特征们 didDiscoverCharacteristicsForService
            [s.peripheral discoverCharacteristics:nil forService:s];
        }
    }
}
/** 发现外设服务里的特征的时候调用的代理方法 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        NSLog(@"发现外设服务里的特征发生错误: %@", [error localizedDescription]);
        return;
    }
    for (CBCharacteristic *c in service.characteristics) {
        //NSLog(@"发现外设服务里的特征的属性:%lu",(unsigned long)c.properties) ;
        //订阅通知 回调didUpdateValueForCharacteristic:error
        //0xffe1
        NSLog(@"哈哈哈%@",c);
        if ([c.UUID isEqual:[CBUUID UUIDWithString:kNotifyCharacteristicUUID]]) {
            [peripheral setNotifyValue:YES forCharacteristic:c];
        }
        if ([c.UUID isEqual:[CBUUID UUIDWithString:kWriteCharacteristicUUID]]) {
            _writeCharacteristic = c;
//            [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_DISCOVER_PERIPHERAL_SERVICE_CHARACTERISTIC object:@{@"peripheral":peripheral,@"service":service,@"characteristic":c}];
        }
    }
}
/** 向特征值写数据时的回调方法 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (self.sendCompleted) {
        self.sendCompleted(characteristic, characteristic.value, error);
    }
    NSLog(@"%@",error);
}
/** 订阅的特征值有新的数据时回调 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"订阅的特征值发生错误: %@",[error localizedDescription]);
        return;
    }
    /*
     if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kNotifyCharacteristicUUID]]) {
     [peripheral readValueForCharacteristic:characteristic];
     }
     */
}
/** 获取到数据时回调更新特征的value的时候会调用 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
//    [YTAlertUtil showTempInfo:characteristic.UUID];
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kNotifyCharacteristicUUID]]) {
        if(characteristic.value.length!=0) {
            if (self.packetReceived) {
                self.packetReceived(peripheral, characteristic.value, error);
            }
        }else{
            NSLog(@"无数据返回");
        }
    }
}
#pragma mark - 私有方法
// 将data转换为不带<>的字符串
- (NSString *)p_convertToNSStringWithNSData:(NSData *)data {
    NSMutableString *strTemp = [NSMutableString stringWithCapacity:[data length]*2];
    const unsigned char *szBuffer = [data bytes];
    
    for (NSInteger i=0; i < [data length]; ++i) {
        
        [strTemp appendFormat:@"%02lx",(unsigned long)szBuffer[i]];
        
    }
    
    return strTemp;
}
@end
