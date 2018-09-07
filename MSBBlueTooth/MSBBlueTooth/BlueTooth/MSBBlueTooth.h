//
//  MSBBlueTooth.h
//  蓝牙Demo
//
//  Created by 卢志卫 on 2018/9/6.
//  Copyright © 2018年 Dean_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


@interface MSBBlueTooth : NSObject
@property (strong , nonatomic) NSMutableArray *peripherals;       //扫描的所有设备



/**
 创建一个蓝牙中心管理器实例 ，

 @param queue 将在其上调度事件的调度队列
 @param options 指定管理器选项的可选字典。
 @return 返回蓝牙类实例
 */
- (instancetype)initWithQueue:(nullable dispatch_queue_t)queue
                      options:(nullable NSDictionary<NSString *, id> *)options;

/**
 扫描周边设备

 @param block 将有效设备回调
 */
- (void)scanscanDiscoverToPeripherals:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block;


/**
 连接某一台设备

 @param peripheral 周边设备对象
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral;

/**
 通过外围设备的唯一标示连接
 */
- (void)retrievePeripherals;
@end
