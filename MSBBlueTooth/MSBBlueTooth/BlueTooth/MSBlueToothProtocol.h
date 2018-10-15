//
//  MSBlueToothProtocol.h
//  MSBBlueTooth
//
//  Created by 卢志卫 on 2018/9/14.
//  Copyright © 2018年 卢志卫. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MSBlueToothProtocol <NSObject>

/**
 发现的任何设备都会调用此代理

 @param central 中心设备
 @param peripheral 发现的外设
 @param advertisementData 设备属性
 @param RSSI 信号强弱
 */
- (void)ms_centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI;


/**
 检查蓝牙状态

 @param central <#central description#>
 */
- (void)ms_centralManagerDidUpdateState:(CBCentralManager *)central;
/**
 连接成功调用此代理

 @param central 中央设备
 @param peripheral 外围设备
 */
- (void)ms_centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(NSData *)data;
@end
