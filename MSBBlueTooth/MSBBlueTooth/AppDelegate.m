//
//  AppDelegate.m
//  MSBBlueTooth
//
//  Created by 卢志卫 on 2018/9/7.
//  Copyright © 2018年 卢志卫. All rights reserved.
//

#import "AppDelegate.h"
#import "MSBBlueTooth.h"
@interface AppDelegate ()
@property (nonatomic, strong) MSBBlueTooth *bluetooth;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSArray *centralManagerIdentifiers =
    launchOptions[UIApplicationLaunchOptionsBluetoothCentralsKey];
    
    if (centralManagerIdentifiers.count) {
        for (NSString *identifier in centralManagerIdentifiers) {
            NSLog(@"系统启动项目");
            //在这里创建的蓝牙实例一定要被当前类持有，不然出了这个函数就被销毁了，蓝牙检测会出现“XPC connection invalid”
            self.bluetooth = [[MSBBlueTooth alloc]initWithQueue:nil mode:MSCBManagerDefaultMode setDelegate:nil options:@{CBCentralManagerOptionRestoreIdentifierKey : identifier}];
            NSLog(@"");
        }
    }
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
