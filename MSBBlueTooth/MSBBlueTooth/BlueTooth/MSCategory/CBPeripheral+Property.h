//
//  CBPeripheral+Property.h
//  MSBBlueTooth
//
//  Created by Dean on 2018/10/23.
//  Copyright © 2018 卢志卫. All rights reserved.
//
/*
 将广播的数据添加到外围设备属性
 
 */

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheral (Property)
@property (nonatomic ,copy) NSDictionary *advertisementData;
@end

NS_ASSUME_NONNULL_END
