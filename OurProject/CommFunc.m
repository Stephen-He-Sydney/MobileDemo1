
//
//  CommFunc.m
//  OurProject
//
//  Created by StephenHe on 10/13/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "CommFunc.h"

@implementation CommFunc

#pragma mark - 去除字符串前后空格
+(NSString*)trimString:(NSString*)inputStr
{
    return [inputStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark - 持久化登录信息
+(void)markSuccessfulLogin:(NSString*)accountNo WithPassword:(NSString*)password WithData:(NSDictionary*)responseData
{
    NSUserDefaults* userLogin = [NSUserDefaults standardUserDefaults];
    NSDictionary* userInfo = @{@"mobile":accountNo,@"password":password,@"data":responseData};
    
    [userLogin setObject:userInfo forKey:@"isLogined"];
}

#pragma mark - 获取每次本地持久化登录信息
+(NSDictionary*)readUserLogin
{
    NSUserDefaults* userInfo = [NSUserDefaults standardUserDefaults];
    return [userInfo objectForKey:@"isLogined"];
}

#pragma mark - 转换时间
+(NSString *)tranfromTime:(long long)ts
{
    NSDate *date=[[NSDate alloc]initWithTimeIntervalSince1970:ts];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];

    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strTime=[formatter stringFromDate:date];
    return strTime;
}

@end
