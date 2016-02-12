//
//  CustomHttpRequest.h
//  MyProjectOne
//
//  Created by StephenHe on 9/10/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

typedef void(^serverInfo)(NSDictionary* info);

typedef void(^imageInfo)(NSData* info);

@interface CustomHttpRequest : NSObject
{
    Reachability* reachability;
    
    NetworkStatus currStatus;
    
    NSString* interfaceAddress;
    
    NSString* imageAddress;
    
    BOOL isLoginOrRegister;
}

-(bool)IsCurrentWIFIReached;

-(bool)IsCurrentInternentReached;

-(void)fetchResponseByPost:(NSString*)serverUrl WithParameter:(NSString*)param WithResponse:(serverInfo)info;

-(void)fetchLoginRegisterResponse:(NSString*)serverUrl WithParameter:(NSString*)param WithResponse:(serverInfo)info;

-(void)fetchImageDataAsync:(NSString*)imageUrl WithResponse:(imageInfo)info;

-(NSData*)fetchImageData:(NSString*)imageUrl;

@end
