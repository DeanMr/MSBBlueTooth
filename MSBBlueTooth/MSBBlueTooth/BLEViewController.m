//
//  BLEViewController.m
//  MSBBlueTooth
//
//  Created by 卢志卫 on 2018/9/7.
//  Copyright © 2018年 卢志卫. All rights reserved.
//

#import "BLEViewController.h"
#import "MSBBlueTooth.h"
@interface BLEViewController ()

@property (nonatomic, strong)MSBBlueTooth *blueTooth;
@end

@implementation BLEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     
     options: 添加key：CBCentralManagerOptionRestoreIdentifierKey是为恢复标识符的字典key
     */
    
    self.blueTooth = [[MSBBlueTooth alloc]initWithQueue:nil options:@{CBCentralManagerOptionRestoreIdentifierKey:@"centralManagerIdentifier"}];
    
}
- (IBAction)scan:(id)sender {
    
    //扫描并回调发现的每一台设备
    [self.blueTooth scanscanDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        
        [self.tableView reloadData];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.blueTooth.peripherals.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"blueToo" forIndexPath:indexPath];
    
    // 将蓝牙外设对象接出，取出name，显示
    //蓝牙对象在下面环节会查找出来，被放进BleViewPerArr数组里面，是CBPeripheral对象
    CBPeripheral *per=(CBPeripheral *)self.blueTooth.peripherals[indexPath.row];
    cell.textLabel.text = per.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",per.identifier];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row < self.blueTooth.peripherals.count) {
        //连接设备
        [self.blueTooth connectPeripheral:self.blueTooth.peripherals[indexPath.row]];
    }
}

@end
