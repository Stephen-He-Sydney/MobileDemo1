//
//  UploadPhoto.h
//  OurProject
//
//  Created by ibokan on 15/10/16.
//  Copyright (c) 2015年 StephenHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#ifndef FORM_FLE_INPUT
#define FORM_FLE_INPUT @"file" //上传是的文件参数名称
#endif
@interface UploadPhoto : NSObject
+(void) upLoadImage:(UIImage *) image completionHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError)) handler;
@end
