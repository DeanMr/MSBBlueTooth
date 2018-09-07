//
//  MSBBlueTooth.m
//  蓝牙Demo
//
//  Created by 卢志卫 on 2018/9/6.
//  Copyright © 2018年 Dean_. All rights reserved.
//

#import "MSBBlueTooth.h"
#import "MSBBlueTooth+State.h"
#import "NSString+Coding.h"

#define SERVICE_UUID @"CDD1"
#define CHARACTERISTIC_UUID @"CDD2"

@interface MSBBlueTooth ()<CBPeripheralDelegate,CBCentralManagerDelegate>

@property (nonatomic,strong) CBCentralManager *centerManager;   //中心管理器
@property (strong , nonatomic) CBPeripheral * discoveredPeripheral;//周边设备
@property (strong , nonatomic) CBCharacteristic *characteristic1;//周边设备服务特性


//扫描结果回调
@property (nonatomic, copy) void (^didDiscoverPeripheralBlock)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI);
@end

@implementation MSBBlueTooth

- (instancetype)initWithQueue:(nullable dispatch_queue_t)queue
                      options:(nullable NSDictionary<NSString *, id> *)options
{
    self = [super init];
    if (self) {
        
        self.centerManager = [[CBCentralManager alloc]initWithDelegate:self queue:queue options:options];
        self.peripherals = [NSMutableArray arrayWithCapacity:1];
        
        NSLog(@"%s",__func__);
    }
    
    return self;
}

#pragma mark -- 开始扫描
- (void)scanscanDiscoverToPeripherals:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block
{
    if ([self isStateOn:self.centerManager.state]) {
        
        _didDiscoverPeripheralBlock = block;
        
        //判断状态开始扫瞄周围设备 第一个参数为空则会扫瞄所有的可连接设备  你可以指定一个CBUUID对象 从而只扫瞄注册用指定服务的设备
        [self.centerManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:SERVICE_UUID]] options:@{ CBConnectPeripheralOptionNotifyOnConnectionKey: @YES}];
        //清空数组的所有外设元素
        [self.peripherals removeAllObjects];
    }
}

#pragma mark -- 通过之前连接过的周边设备的ID进行连接
- (void)retrievePeripherals
{
//    NSUUID *uuid = [[NSUUID alloc]initWithUUIDString:@"0848406E-667F-43F5-B79F-59D61E0CC4C9"];
//    NSArray *peripherals = [self.centerManager retrievePeripheralsWithIdentifiers:@[uuid]];
//
//    for (CBPeripheral *peripheral in peripherals ) {
//        NSLog(@"开始连接");
//        _discoveredPeripheral = peripheral;
//        _discoveredPeripheral.delegate = self;
//
//        [_centerManager cancelPeripheralConnection:_discoveredPeripheral];
//        //连接设备
//        [_centerManager connectPeripheral:_discoveredPeripheral options:@{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES}];
//    }
}


#pragma mark -- 连接指定周边设备
- (void)connectPeripheral:(CBPeripheral *)peripheral
{
    _discoveredPeripheral = peripheral;
    _discoveredPeripheral.delegate = self;
    //连接设备
    [_centerManager connectPeripheral:_discoveredPeripheral options:@{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES}];
}

#pragma mark -- 向连接的外围设备写入数据
- (void)writeData
{
    static NSInteger msg = 0;
    msg++;
    
    NSString *msgStr = [NSString stringWithFormat:@"%ld",msg];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:msgStr,@"msg",@"ack",@"type", nil];
    // 用NSData类型来写入
    NSData *data = [[NSString convertToJSONData:dic] dataUsingEncoding:NSUTF8StringEncoding];
    // 根据上面的特征self.characteristic来写入数据
    [self.discoveredPeripheral writeValue:data forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithResponse];
}

#pragma mark -- CBCentralManagerDelegate   coreBlueTooth实现检测蓝牙状态并通过代理返回结果
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    //判断蓝牙是否开启
    NSLog(@"%s",__func__);
    if ([self isStateOn:central.state]) {
        //程序回复后将状态保存的设备进行重连
        for (CBPeripheral *peripheral in self.peripherals) {
            [self connectPeripheral:peripheral];
        }
    }
}

#pragma mark -- 对于选择状态保存和恢复的应用程序，这是重新启动应用程序时调用的第一个方法
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict
{
    NSLog(@"%s",__func__);
    NSArray *peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey];
    //讲状态保存的设备加入列表，在蓝牙检测状态的回调里实现重连
    self.peripherals = [NSMutableArray arrayWithArray:peripherals];
    
}

#pragma mark -- 扫描发现到任何一台设备都会通过这个代理方法回调
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    //过滤掉无效的结果
    if (peripheral == nil||peripheral.identifier == nil/*||peripheral.name == nil*/)
    {
        return;
    }
    
    NSString *pername =[NSString stringWithFormat:@"%@",peripheral.name];
    NSLog(@"所有服务****：%@",peripheral.services);

    NSLog(@"蓝牙名字：%@  信号强弱：%@",pername,RSSI);
    [self connectPeripheral:peripheral];
    //将搜索到的设备添加到列表中
    [self.peripherals addObject:peripheral];
    
    if (_didDiscoverPeripheralBlock) {
        _didDiscoverPeripheralBlock(central,peripheral,advertisementData,RSSI);
    }
}


#pragma mark -- 连接成功、获取当前设备的服务和特征 并停止扫描
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"%@",peripheral);
    
    // 设置设备代理
    [peripheral setDelegate:self];
    // 大概获取服务和特征
    [peripheral discoverServices:@[[CBUUID UUIDWithString:SERVICE_UUID]]];
    
    NSLog(@"Peripheral Connected");
    
    if (_centerManager.isScanning) {
        [_centerManager stopScan];
    }

    NSLog(@"Scanning stopped");
    
}

#pragma mark -- 连接失败的回调
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"连接失败");
}

#pragma mark -- 断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    NSLog(@"断开连接");
    // 断开连接可以设置重新连接
//        [central connectPeripheral:peripheral options:nil];
    
    //重新扫描
    [self scanscanDiscoverToPeripherals:nil];
    
    //清空所有外设数组
    [self.peripherals removeAllObjects];
}



#pragma mark -- CBPeripheralDelegate

#pragma mark -- 获取当前设备服务services
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering services: %@", [error localizedDescription]);
        return;
    }
    
    NSLog(@"所有的servicesUUID%@",peripheral.services);
    
    //遍历所有service
    for (CBService *service in peripheral.services)
    {
        
        NSLog(@"服务%@",service.UUID);
        
        //找到你需要的servicesuuid
        if ([[NSString stringWithFormat:@"%@",service.UUID] isEqualToString:SERVICE_UUID])
        {
        
            // 根据UUID寻找服务中的特征
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:CHARACTERISTIC_UUID]] forService:service];
        }
    }
    NSLog(@"此时链接的peripheral：%@",peripheral);
    
}
#pragma mark --  发现特征回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    // 遍历出所需要的特征
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"所有特征：%@", characteristic);
        // 从外设开发人员那里拿到不同特征的UUID，不同特征做不同事情，比如有读取数据的特征，也有写入数据的特征
    }
    
    // 这里只获取一个特征，写入数据的时候需要用到这个特征
    self.characteristic1 = service.characteristics.lastObject;
    
    // 直接读取这个特征数据，会调用didUpdateValueForCharacteristic
    [peripheral readValueForCharacteristic:self.characteristic1];
    
    // 订阅通知
    [self.discoveredPeripheral setNotifyValue:YES forCharacteristic:self.characteristic1];
}


#pragma mark -- 订阅状态的改变
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"订阅失败");
        NSLog(@"%@",error);
    }
    if (characteristic.isNotifying) {
        NSLog(@"订阅成功");
    } else {
        NSLog(@"取消订阅");
    }
}

#pragma mark -- 接收到数据回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    // 拿到外设发送过来的数据
    
    NSData *data = characteristic.value;
    NSString *value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (value) {
        NSLog(@"接收到数据：%@ characteristic：%@",value , characteristic.UUID);
        [self writeData];
    }
    
}

#pragma mark -- 写入数据回调
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error {
    NSLog(@"写入成功");
}


#pragma mark -- 调用readRSSI 之后的读取结果通过此代理方法回调
- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error
{
    NSInteger Rss = [RSSI integerValue];
    NSLog(@"更新后的信号强度：%ld",Rss+100);
}



@end
