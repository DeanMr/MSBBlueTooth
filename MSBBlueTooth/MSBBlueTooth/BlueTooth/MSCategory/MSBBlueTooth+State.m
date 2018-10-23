//
//  MSBBlueTooth+State.m
//  蓝牙Demo
//
//  Created by 卢志卫 on 2018/9/6.
//  Copyright © 2018年 Dean_. All rights reserved.
//

#import "MSBBlueTooth+State.h"

@implementation MSBBlueTooth (State)

- (BOOL)isStateOn:(CBManagerState)state
{
    switch (state) {
        case CBManagerStatePoweredOn:
            NSLog(@"蓝牙已开启");
            return YES;
            break;
        case CBManagerStatePoweredOff:
            NSLog(@"蓝牙未开启");
            
            break;
        case CBManagerStateUnknown:
            NSLog(@"未知原因");
            break;
        case CBManagerStateUnsupported:
            NSLog(@"此设备不支持蓝牙");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"没有使用蓝牙的权限");
            break;
        case CBManagerStateResetting:
            NSLog(@"蓝牙状态重置");
            break;
        default:
            break;
    }
    return NO;
}
@end
