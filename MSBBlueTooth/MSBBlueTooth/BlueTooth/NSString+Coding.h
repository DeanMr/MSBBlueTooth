//
//  NSString+Coding.h
//  蓝牙Demo
//
//  Created by 卢志卫 on 2018/9/7.
//  Copyright © 2018年 Dean_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Coding)
/*
 * 字典转字符串
 *
 */
+ (NSString*)convertToJSONData:(id)infoDict;

/**
 字符串转字典
 
 @param jsonString jsonString
 @return dic
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


+ (NSString *)arrayToJsonString:(NSArray *)arr;
@end
