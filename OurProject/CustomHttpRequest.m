//
//  CustomHttpRequest.m
//  MyProjectOne
//
//  Created by StephenHe on 9/10/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "CustomHttpRequest.h"

@implementation CustomHttpRequest

- (id)init
{
    if (self = [super init])
    {
        //http://192.168.10.252/
//        interfaceAddress = @"http://192.168.10.252/zhizu/api/";
//        imageAddress = @"http://192.168.10.252/zhizu";
        
        //旧的
        interfaceAddress = @"http://112.74.105.205/zhizu/api/";
        
        imageAddress = @"http://112.74.105.205/zhizu";
        
        isLoginOrRegister = NO;
    }
    return self;
}

-(void)setCurrentInternetStatus
{
    reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isCurrentStatusChanged:) name:kReachabilityChangedNotification object:nil];
    
    reachability = [Reachability reachabilityForInternetConnection];
    
    [reachability startNotifier];
    
    currStatus = [reachability currentReachabilityStatus];
}

-(void)isCurrentStatusChanged:(NSNotification*) notify
{
    currStatus = [reachability currentReachabilityStatus];
}

#pragma mark - 判断当前网络是否是WIFI
-(bool)IsCurrentWIFIReached
{
    [self setCurrentInternetStatus];
    
    if (currStatus == ReachableViaWiFi)
    {
        return YES;
    }
    return NO;
}

#pragma mark - 判断当前网络是否连接
-(bool)IsCurrentInternentReached
{
    [self setCurrentInternetStatus];
    
    if (currStatus == ReachableViaWiFi||currStatus == ReachableViaWWAN)
    {
        return YES;
    }
    return NO;
}

#pragma mark - 异步获取注册登录返回值
-(void)fetchLoginRegisterResponse:(NSString*)serverUrl WithParameter:(NSString*)param WithResponse:(serverInfo)info
{
    isLoginOrRegister = YES;
    [self implementAsyncLogic:serverUrl WithParameter:param WithResponse:^(NSDictionary *jsonData) {
        info(jsonData);
    }];
}

#pragma mark - 异步获取请求JSON信息(不含注册登录使用)
-(void)fetchResponseByPost:(NSString*)serverUrl WithParameter:(NSString*)param WithResponse:(serverInfo)info
{
    [self implementAsyncLogic:serverUrl WithParameter:param WithResponse:^(NSDictionary *jsonData) {
        info(jsonData);
    }];
}

-(void)implementAsyncLogic:(NSString*)serverUrl WithParameter:(NSString*)param WithResponse:(serverInfo)info
{
    serverUrl = [NSString stringWithFormat:@"%@%@",interfaceAddress,serverUrl];
    NSString* encrptParamUrl = [self encrptParameterUrl:param];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverUrl]];
    
    [request setHTTPMethod:@"POST"];
    
    if (isLoginOrRegister == YES)
    {
        [request setTimeoutInterval:3];//3秒没有回复就终止请求，弹出对话框告知网络问题
    }
    else
    {
        [request setTimeoutInterval:15];//十五秒没有回复就终止请求，弹出对话框告知网络问题
    }
   
    [request setHTTPBody:[encrptParamUrl dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]  completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary* jsonData = [[NSDictionary alloc]init];
        if ([data length] > 0)
        {
            jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        }
        else
        {
            jsonData = @{@"fail":connectionError};
        }
        info(jsonData);
    }];

}

#pragma mark - 同步获取图片信息
-(NSData*)fetchImageData:(NSString*)imageUrl
{
    imageUrl = [NSString stringWithFormat:@"%@%@",imageAddress,imageUrl];
 
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
    [request setHTTPMethod:@"POST"];
    
    return [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
}

#pragma mark - 异步获取获取图片信息(只用于单个图片)
-(void)fetchImageDataAsync:(NSString*)imageUrl WithResponse:(imageInfo)info
{
    imageUrl = [NSString stringWithFormat:@"%@%@",imageAddress,imageUrl];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]  completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        if ([data length] > 0)
        {
            info(data);
        }
        else
        {
            info(nil);
        }
    }];
}

#pragma mark - 加密参数URL
-(NSString *)encrptParameterUrl:(NSString*)paramUrl
{
    //将参数中得中文进行转码，生成服务器可识别的通配符
    paramUrl = [paramUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSData * encodingData = [paramUrl dataUsingEncoding:NSUTF8StringEncoding];
    //Encrpt data
    NSString * encrptStr = [[NSString alloc]initWithString:[encodingData base64EncodedStringWithOptions:4]];
    //Hardcode based on server-side requirement
    encrptStr = [NSString stringWithFormat:@"data=%@",encrptStr];

    return encrptStr;
}

@end
