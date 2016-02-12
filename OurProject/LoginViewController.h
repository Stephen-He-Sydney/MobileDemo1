//
//  LoginViewController.h
//  ZhiZuTeamWorkProject
//
//  Created by StephenHe on 10/8/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalConstants.h"
#import "AppTabBarController.h"
#import "CommFunc.h"
#import "CustomHttpRequest.h"
#import "CommonViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController : UIViewController<UIAlertViewDelegate, UITextFieldDelegate>
{
    UIView* secondLine;
}
@property(nonatomic,strong)UITextField* accountNo;
@property(nonatomic,strong)UITextField* password;
@property(nonatomic,assign)BOOL isHiddenBackBtn;

@end
