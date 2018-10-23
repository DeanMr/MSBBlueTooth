//
//  CBPeripheral+Property.m
//  MSBBlueTooth
//
//  Created by Dean on 2018/10/23.
//  Copyright © 2018 卢志卫. All rights reserved.
//

#import "CBPeripheral+Property.h"
#import <objc/message.h>

static const char *key = "advertisementData";

@implementation CBPeripheral (Property)

- (void)setAdvertisementData:(NSDictionary *)advertisementData
{
    objc_setAssociatedObject(self, key, advertisementData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)advertisementData
{
    return objc_getAssociatedObject(self, key);
}
@end
