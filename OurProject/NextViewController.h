//
//  NextViewController.h
//  OurProject
//
//  Created by StephenHe on 10/10/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalConstants.h" 
#import "CommFunc.h"
#import "CustomHttpRequest.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "CommonViewController.h"

@interface NextViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>
{
    UITextField* verifyCode;
    UITextField* password;
    UIView* secondLine;
    
    UILabel* countDownSeconds;
    int totalSeconds;
    NSTimer* countDownTimer;
}

@property(nonatomic,strong)NSString* mobileNo;
@end
