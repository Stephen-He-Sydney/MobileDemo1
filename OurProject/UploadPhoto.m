//
//  UploadPhoto.m
//  OurProject
//
//  Created by ibokan on 15/10/16.
//  Copyright (c) 2015年 StephenHe. All rights reserved.
//

#import "UploadPhoto.h"

@implementation UploadPhoto

+(void) upLoadImage:(UIImage *) image completionHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError)) handle
{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@index/uploadPicture" ,@"http://112.74.105.205/zhizu/api/"];  //拼接session
    //    urlStr = [NSString stringWithFormat:@"%@%@%@",urlStr ,@";jsessionid=",sessionID()];
    //
    //
    //    NSString *path1 = [NSString stringWithFormat:@"%@;%@",URL_UPLOAD,[NSString stringWithFormat:@"%@=%@",@"jsessionid",sessionID()]];
    //    NSLog(@"上传路径：%@",path1);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSData *imgdata = UIImagePNGRepresentation(image);
    
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"boris.png\"\r\n"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:imgdata];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"IOS" forHTTPHeaderField:@"userAgentType"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            handle(response,data,connectionError);
        });
    }];
}

@end
