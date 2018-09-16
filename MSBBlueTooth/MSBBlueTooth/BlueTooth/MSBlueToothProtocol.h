//
//  MSBlueToothProtocol.h
//  MSBBlueTooth
//
//  Created by 卢志卫 on 2018/9/14.
//  Copyright © 2018年 卢志卫. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MSBlueToothProtocol <NSObject>

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(NSData *)data;
@end
