//
//  MSBBlueTooth+State.h
//  蓝牙Demo
//
//  Created by 卢志卫 on 2018/9/6.
//  Copyright © 2018年 Dean_. All rights reserved.
//

#import "MSBBlueTooth.h"




@interface MSBBlueTooth (State)
- (BOOL)isStateOn:(CBManagerState)state;
@end
