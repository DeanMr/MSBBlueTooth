//
//  DUFViewController.m
//  MSBBlueTooth
//
//  Created by Dean on 2018/10/12.
//  Copyright © 2018 卢志卫. All rights reserved.
//

#import "DUFViewController.h"
#import <iOSDFULibrary/iOSDFULibrary-Swift.h>
@interface DUFViewController ()<LoggerDelegate, DFUServiceDelegate, DFUProgressDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) DFUServiceController *controller;
@property (strong, nonatomic) DFUFirmware *selectedFirmware;
@property (nonatomic ,strong) UITableView *tableView;
@end

@implementation DUFViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
//    self.blueTooth = [[MSBBlueTooth alloc]initWithQueue:nil options:@{CBCentralManagerOptionRestoreIdentifierKey:@"centralManagerIdentifier1"}];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.blueTooth scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:legacyDfuServiceUUID],[CBUUID UUIDWithString:secureDfuServiceUUID],[CBUUID UUIDWithString:deviceInfoServiceUUID]] handle:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        
        [self.tableView reloadData];
        
    } concetState:^{
        [self toDUF];
    }];

}

- (void)toDUF
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cw10c0002ver8-0831-testHR" ofType:@"zip"];
    
    
    DFUServiceInitiator *initiator = [[DFUServiceInitiator alloc] initWithCentralManager:self.blueTooth.centerManager target:self.blueTooth.discoveredPeripheral];
    
    self.selectedFirmware = [[DFUFirmware alloc]  initWithUrlToZipFile:[NSURL fileURLWithPath:filePath]];
    
    [initiator withFirmware:self.selectedFirmware];
    
    initiator.logger = self;
    initiator.delegate = self;
    initiator.progressDelegate = self;
    //开始升级
    self.controller = [initiator start];
}

//更新进度
- (void)dfuProgressDidChangeFor:(NSInteger)part outOf:(NSInteger)totalParts to:(NSInteger)progress currentSpeedBytesPerSecond:(double)currentSpeedBytesPerSecond avgSpeedBytesPerSecond:(double)avgSpeedBytesPerSecond{
    
    float currentProgress=((float) progress /totalParts)/100;
    NSLog(@"%f",currentProgress);
}

#pragma mark ----------- 日志打印 -------------
-(void)logWith:(enum LogLevel)level message:(NSString *)message
{
    NSLog(@"%logWith ld: %@", (long) level, message);
}

//更新进度状态  升级开始..升级中断..升级完成等状态
- (void)dfuStateDidChangeTo:(enum DFUState)state{
    
    NSLog(@"DFUState state: %ld",state);
    //升级完成
    if (state==DFUStateCompleted) {
        
    }
    
}


//升级error信息
- (void)dfuError:(enum DFUError)error didOccurWithMessage:(NSString * _Nonnull)message{
    
    NSLog(@"Error %ld: %@", (long) error, message);
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.blueTooth.peripherals.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"dfuCell";
    // 1.缓存中取
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        cell.backgroundColor = MSBackgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
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
