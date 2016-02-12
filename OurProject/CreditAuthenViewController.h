//
//  CreditAuthenViewController.h
//  OurProject
//
//  Created by StephenHe on 10/9/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialControllerService.h"
@interface CreditAuthenViewController : UIViewController<UMSocialUIDelegate>

@property(strong,nonatomic)NSDictionary * loginDic;
@end
