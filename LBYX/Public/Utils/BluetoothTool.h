//
//  BluetoothTool.h
//  LBYX
//
//  Created by john on 2019/6/5.
//  Copyright © 2019 qt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
//查询蓝牙
typedef void(^blePeripheralFound)(CBCentralManager * _Nonnull central,CBPeripheral * _Nonnull peripheral,NSDictionary * _Nonnull advertisementData, NSNumber * _Nonnull RSSI);
//链接蓝牙
typedef void(^blePeripheralConnected)(CBCentralManager * _Nonnull central,CBPeripheral * _Nonnull peripheral);

//蓝牙断开连接
typedef void(^blePeripheralDisonnected)(CBCentralManager * _Nonnull central,CBPeripheral * _Nonnull peripheral,NSError * _Nonnull error);

//发送成功的回调
typedef void(^sendCompleted)(CBCharacteristic * _Nonnull characteristic,NSData * _Nonnull data,NSError * _Nonnull error);

//指令处理回调
typedef void(^packetReceived)(CBPeripheral * _Nonnull peripheral,NSData * _Nonnull data,NSError * _Nonnull error);

//手机蓝牙断开
typedef void(^blueStatus)(CBCentralManager * center);


NS_ASSUME_NONNULL_BEGIN
@class YSBlutoothPeripheral;
@interface BluetoothTool : NSObject
/** 中心管理者 */
@property(nonatomic,strong)CBCentralManager* centralMgr;
/** 蓝牙名称 */
@property (nonatomic,strong)NSString *deviceName;
/** 用户的蓝牙是否开启 */
@property (nonatomic, assign) BOOL blueToothPoweredOn;
/** 连接到的外设 */
@property (nonatomic, strong) CBPeripheral *discoveredPeripheral;
/** 连接到的外设数组 */
@property (nonatomic, strong) NSMutableArray *array_peripheral;
/** 外设服务特征 */
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;


/** 扫描成功的回调 */
@property (nonatomic,copy)blePeripheralFound blePeripheralFound;
/** 链接成功的回调 */
@property (nonatomic,copy)blePeripheralConnected blePeripheralConnected;
/** 链接已断开监听 */
@property (nonatomic,copy)blePeripheralDisonnected blePeripheralDisonnected;
/** 指令发送成功的回调 */
@property (nonatomic,copy)sendCompleted sendCompleted;
/** 指令处理成功的回调 */
@property (nonatomic,copy)packetReceived packetReceived;
/** 蓝牙状态回调 */
@property (nonatomic,copy)blueStatus blueStatus;


/** 中心管理者 */
+ (instancetype)shareBlueTooth;
/** 开始扫描 */
- (void)startScan;
/** 停止扫描 */
- (void)stopScan;
/** 连接蓝牙 */
- (void)connectBlueToothWithPeripheral:(CBPeripheral *)peripheral;
/** 断开蓝牙 */
- (void)cancelBlueTooth;
/** 写入数据 */
- (void)writeChar:(NSData *)data response:(BOOL)response;


@end

NS_ASSUME_NONNULL_END
