//
//  BLEViewController.m
//  MSBBlueTooth
//
//  Created by 卢志卫 on 2018/9/7.
//  Copyright © 2018年 卢志卫. All rights reserved.
//

#import "BLEViewController.h"
//#import "MSBBlueTooth.h"

@interface BLEViewController ()<MSBlueToothProtocol>

//@property (nonatomic, strong)MSBBlueTooth *blueTooth;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation BLEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.blueTooth.delegate = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.blueTooth.centerManager cancelPeripheralConnection:self.blueTooth.discoveredPeripheral];
}

- (IBAction)scan:(id)sender {
    
    [self.blueTooth.centerManager cancelPeripheralConnection:self.blueTooth.discoveredPeripheral];
    

}
- (IBAction)getDeviceInfo:(id)sender {
    [self.blueTooth getDeviceInfo];
}
- (IBAction)getLockTime:(id)sender {
    [self.blueTooth getLockTime];
}
- (IBAction)getMac:(id)sender {
    [self.blueTooth getMacAddress];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(NSData *)data
{
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    //data转16进制
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    self.textView.text = [_textView.text stringByAppendingString:[NSString stringWithFormat:@"\n\n %@",string]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
