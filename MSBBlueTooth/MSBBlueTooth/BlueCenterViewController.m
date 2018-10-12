//
//  BlueCenterViewController.m
//  MSBBlueTooth
//
//  Created by Dean_ on 2018/9/16.
//  Copyright © 2018年 卢志卫. All rights reserved.
//

#import "BlueCenterViewController.h"
#import "BLEViewController.h"
#import "MSBBlueTooth.h"
//#import "iOSDFULibrary-Swift.h"

@interface BlueCenterViewController ()
@property (nonatomic, strong)MSBBlueTooth *blueTooth;

//@property (strong, nonatomic) DFUServiceController *controller;
//@property (strong, nonatomic) DFUFirmware *selectedFirmware;
@end

@implementation BlueCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    /*
     
     options: 添加key：CBCentralManagerOptionRestoreIdentifierKey是为恢复标识符的字典key
     */
    
    self.blueTooth = [[MSBBlueTooth alloc]initWithQueue:nil options:@{CBCentralManagerOptionRestoreIdentifierKey:@"centralManagerIdentifier"}];
    
    
    
}

- (IBAction)scan:(id)sender {
    
    //扫描并回调发现的每一台设备
    
    [self.blueTooth scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:SERVICE_UUID]] handle:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        [self.tableView reloadData];
    } concetState:^{
        
    }];
    
//    [self.blueTooth scanscanDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
//        
//        [self.tableView reloadData];
//    } message:^(NSData *value) {
//        
//    }];
    
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
    
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BLEViewController *BLEView = [secondStoryBoard instantiateViewControllerWithIdentifier:@"blueID"];
    //            vc set
//    [self presentViewController:vc animated:YES completion:nil];
    
//    BLEViewController *BLEView = [[BLEViewController alloc]init];
    BLEView.blueTooth = _blueTooth;
    
    [self.navigationController pushViewController:BLEView animated:YES];
    
}
@end
