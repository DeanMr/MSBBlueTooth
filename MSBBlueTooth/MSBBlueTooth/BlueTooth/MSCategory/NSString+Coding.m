//
//  NSString+Coding.m
//  蓝牙Demo
//
//  Created by 卢志卫 on 2018/9/7.
//  Copyright © 2018年 Dean_. All rights reserved.
//

#import "NSString+Coding.h"

@implementation NSString (Coding)


#pragma mark --- 字典转JsonString
+ (NSString*)convertToJSONData:(id)infoDict
{
    
    NSString *jsonString;
    for (NSString *key in infoDict) {
        id info = infoDict[key];
        if ([info isKindOfClass:[NSDictionary class]]) {
            NSString *json = nil;
            for (NSString *akey in info) {
                if (json) {
                    json = [NSString stringWithFormat:@"%@,\"%@\":\"%@\"",json,akey,info[akey]];
                }
                else
                    json = [NSString stringWithFormat:@"\"%@\":\"%@\"",akey,info[akey]];
            }
            json = [NSString stringWithFormat:@"{%@}",json];
            
            if (jsonString) {
                jsonString = [NSString stringWithFormat:@"%@,\"%@\":%@",jsonString,key,json];
            }
            else
                jsonString = [NSString stringWithFormat:@"\"%@\":%@",key,json];
        }
        else
        {
            if (jsonString) {
                jsonString = [NSString stringWithFormat:@"%@,\"%@\":\"%@\"",jsonString,key,info];
            }
            else
                jsonString = [NSString stringWithFormat:@"\"%@\":\"%@\"",key,info];
        }
        
        
        
        
    }
    jsonString = [NSString stringWithFormat:@"{%@}",jsonString];
    
    
    return jsonString;
}

#pragma mark -- JsonString转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString *)arrayToJsonString:(NSArray *)arr{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
@end
