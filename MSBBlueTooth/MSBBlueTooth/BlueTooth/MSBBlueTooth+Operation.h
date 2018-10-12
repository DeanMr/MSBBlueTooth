//
//  MSBBlueTooth+Operation.h
//  MSBBlueTooth
//
//  Created by 卢志卫 on 2018/9/14.
//  Copyright © 2018年 卢志卫. All rights reserved.
//

#import "MSBBlueTooth.h"

@interface MSBBlueTooth (Operation)

/**
 握手
 */
- (void)shakeHands;

/**
 获取设备信息
 */
- (void)getDeviceInfo;

/**
 获取锁的系统时间
 */
- (void)getLockTime;

/**
 获取MAC地址
 */
- (void)getMacAddress;

/**
 进入DFU模式
 */
- (void)toDUFMode;
@end
