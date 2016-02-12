//
//  CommFunc.h
//  OurProject
//
//  Created by StephenHe on 10/13/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommFunc : NSObject

+(NSString*)trimString:(NSString*)inputStr;

+(void)markSuccessfulLogin:(NSString*)accountNo WithPassword:(NSString*)password WithData:(NSDictionary*)responseData;

+(NSDictionary*)readUserLogin;

+(NSString *)tranfromTime:(long long)ts;

@end
