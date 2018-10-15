//
//  DUFViewController.m
//  MSBBlueTooth
//
//  Created by Dean on 2018/10/12.
//  Copyright © 2018 卢志卫. All rights reserved.
//

#import "DUFViewController.h"
#import <iOSDFULibrary/iOSDFULibrary-Swift.h>
//#import "DFUFirmwareProvider.swift"
//#import "DFViewController.swift"

@interface DUFViewController ()<LoggerDelegate, DFUServiceDelegate, DFUProgressDelegate,UITableViewDelegate,UITableViewDataSource,MSBlueToothProtocol>
@property (nonatomic, strong)MSBBlueTooth *blueTooth;
@property (strong, nonatomic) DFUServiceController *controller;
@property (strong, nonatomic) DFUFirmware *selectedFirmware;
@property (nonatomic ,strong) UITableView *tableView;
@property (strong , nonatomic) CBPeripheral * selectPeripheral;//周边设备

//subView
@property (nonatomic ,strong) UIView *footerView;
@property (nonatomic ,strong) UIButton *linkButton;
@property (nonatomic ,strong) UIButton *upButton;

@property (nonatomic ,strong) UIProgressView *progressView;
@property (nonatomic ,strong) UILabel *titleLabel;


@end

@implementation DUFViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = self.footerView;
    }
    
    return _tableView;
}

- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
        _linkButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _linkButton.frame = CGRectMake(10, 10, 100, 30);
        [_linkButton setTitle:@"连接" forState:UIControlStateNormal];
        [_linkButton addTarget:self action:@selector(linkClick:) forControlEvents:UIControlEventTouchUpInside];
        _linkButton.enabled = NO;
        [_footerView addSubview:_linkButton];
        
        _upButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _upButton.frame = CGRectMake(self.view.bounds.size.width - 110, 10, 100, 30);
        [_upButton addTarget:self action:@selector(updateClick:) forControlEvents:UIControlEventTouchUpInside];
        _upButton.enabled = NO;
        [_upButton setTitle:@"升级" forState:UIControlStateNormal];
        [_footerView addSubview:_upButton];
        
        _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(10, 75, self.view.bounds.size.width - 130, 30)];
        _progressView.progress = 0;
        [_footerView addSubview:_progressView];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 110, 60, 100, 30)];
        _titleLabel.font = [UIFont systemFontOfSize:17.0];
        
        [_footerView addSubview:_titleLabel];
        
    }
    return _footerView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];

    self.blueTooth = [[MSBBlueTooth alloc]initWithQueue:nil mode:MSCBManagerUpdateMode setDelegate:self options:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}
#pragma mark ----------- 检测蓝牙状态 -------------
- (void)ms_centralManagerDidUpdateState:(CBCentralManager *)central
{
    [self.blueTooth scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:legacyDfuServiceUUID],[CBUUID UUIDWithString:secureDfuServiceUUID],[CBUUID UUIDWithString:deviceInfoServiceUUID]]];
}

#pragma mark ----------- 发现设备 -------------
- (void)ms_centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    [self.tableView reloadData];
}

#pragma mark ----------- 连接成功 -------------
- (void)ms_centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
//    [self toDUF];
    _upButton.enabled = YES;
}

#pragma mark ----------- 连接 -------------
- (void)linkClick:(UIButton *)button
{
    _linkButton.enabled = NO;
    [self.blueTooth connectPeripheral:self.selectPeripheral];
}

#pragma mark ----------- 升级 -------------
- (void)updateClick:(UIButton *)button
{
    [self toDUF];
}
- (void)toDUF
{

    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Custom/cw10c0002ver8-0831-testHR" ofType:@"zip"];
//    NSArray *urls = [[NSBundle mainBundle]URLsForResourcesWithExtension:@"zip" subdirectory:@"Custom"];
    
    DFUServiceInitiator *initiator = [[DFUServiceInitiator alloc] initWithCentralManager:self.blueTooth.centerManager target:self.blueTooth.discoveredPeripheral];
    
    self.selectedFirmware = [[DFUFirmware alloc]  initWithUrlToZipFile:[NSURL fileURLWithPath:filePath]];
    
    initiator = [initiator withFirmware:self.selectedFirmware];
    initiator.forceDfu = YES;
    initiator.logger = self;
    initiator.delegate = self;
    initiator.progressDelegate = self;
    //开始升级
    self.controller = [initiator start];
}

//更新进度
- (void)dfuProgressDidChangeFor:(NSInteger)part outOf:(NSInteger)totalParts to:(NSInteger)progress currentSpeedBytesPerSecond:(double)currentSpeedBytesPerSecond avgSpeedBytesPerSecond:(double)avgSpeedBytesPerSecond{
    
    float currentProgress=((float) progress /totalParts)/100;
    
    _progressView.progress = currentProgress;
    _titleLabel.text = [NSString stringWithFormat:@"%%%.0f",currentProgress*100];
    
    NSLog(@"进度：%%%f",currentProgress*100);
}

#pragma mark ----------- 日志打印 -------------
-(void)logWith:(enum LogLevel)level message:(NSString *)message
{
//    NSLog(@"%logWith ld: %@", (long) level, message);
}

//更新进度状态  升级开始..升级中断..升级完成等状态
- (void)dfuStateDidChangeTo:(enum DFUState)state{
    
    NSLog(@"DFUState state: %ld",state);
    //升级完成
    if (state==DFUStateCompleted) {
        NSLog(@"升级完成");
    }
    
}


//升级error信息
- (void)dfuError:(enum DFUError)error didOccurWithMessage:(NSString * _Nonnull)message{
    
    NSLog(@"Error %ld: %@", (long) error, message);
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.blueTooth.peripherals.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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
    CBPeripheral *per=(CBPeripheral *)self.blueTooth.peripherals[indexPath.section];
    cell.textLabel.text = per.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",per.identifier];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section < self.blueTooth.peripherals.count) {
        
        self.selectPeripheral = self.blueTooth.peripherals[indexPath.section];
        _linkButton.enabled = YES;
        //连接设备
//        [self.blueTooth connectPeripheral:self.blueTooth.peripherals[indexPath.section]];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.footerView;
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}
@end
