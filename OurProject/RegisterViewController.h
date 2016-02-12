//
//  RegisterViewController.h
//  ZhiZuTeamWorkProject
//
//  Created by StephenHe on 10/8/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalConstants.h"
#import "NextViewController.h"
#import "CommFunc.h"
#import "CustomHttpRequest.h"
#import "CommonViewController.h"

@interface RegisterViewController : UIViewController<UITextFieldDelegate>
{
    UITextField* inputMobileNo;
}
@property(nonatomic,assign)BOOL isPushFromLogin;

@end
