//
//  MSBBlueTooth+Operation.m
//  MSBBlueTooth
//
//  Created by 卢志卫 on 2018/9/14.
//  Copyright © 2018年 卢志卫. All rights reserved.
//

#import "MSBBlueTooth+Operation.h"

@implementation MSBBlueTooth (Operation)
- (void)getDeviceInfo
{
    
    char ms_byte[2];
    ms_byte[0] = 0x02;
    ms_byte[1] = 0x01;
    
    NSData *data = [NSData dataWithBytes:ms_byte length:strlen(ms_byte)];
    
    [self writeData:data UUIDString:WRITE_UUID_1];
}

- (void)getLockTime
{
    char ms_byte[2];
    ms_byte[0] = 0x02;
    ms_byte[1] = 0x03;
    
    NSData *data = [NSData dataWithBytes:ms_byte length:strlen(ms_byte)];
    
    [self writeData:data UUIDString:WRITE_UUID_1];
}
- (void)getMacAddress
{
    char ms_byte[2];
    ms_byte[0] = 0x02;
    ms_byte[1] = 0x04;
    
    NSData *data = [NSData dataWithBytes:ms_byte length:strlen(ms_byte)];
    
    [self writeData:data UUIDString:WRITE_UUID_1];
}



#pragma mark -- 向连接的外围设备写入数据
- (void)writeData:(NSData *)data UUIDString:(NSString *)UUIDString
{
    // 根据上面的特征self.characteristic来写入数据
    for (CBCharacteristic *charact in self.characteristics) {
        if ([[NSString stringWithFormat:@"%@",charact.UUID] isEqualToString:UUIDString]) {
            [self.discoveredPeripheral writeValue:data forCharacteristic:charact type:CBCharacteristicWriteWithResponse];
        }
    }
    
}

@end
