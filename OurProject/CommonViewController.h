//
//  CommonViewController.h
//  OurProject
//
//  Created by StephenHe on 10/15/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomHttpRequest.h"
#import "AppTabBarController.h"
#import "CommFunc.h"
#import "LoginViewController.h"
#import "CustomHttpRequest.h"
#import "MBProgressHUD.h"

typedef void(^isPageReady)(UITabBarController* appTabCtrl);
typedef void(^fetchJsonInfo)(NSDictionary* jsonData);

@interface CommonViewController : UIViewController
<UIAlertViewDelegate>

@property(strong,nonatomic)isPageReady isReady;
@property(strong,nonatomic)fetchJsonInfo jsonData;

+(UIColor*)getCurrRedColor;

-(void)promptDoubleButtonRedirectDialog:(NSString*)msg;

-(void)promptSingleButtonWarningDialog:(NSString*)msg;

-(void)autoLogin:(NSString*)serverUrl WithParamUrl:(NSString*)paramUrl WithLoginInfo:(NSDictionary*)loginInfo;

-(void)handleServerSideInfo:(NSString*)serverUrl WithParamUrl:(NSString*)paramUrl;

-(void)addloadingMark:(UIView*)currRootView;

-(void)removeAllSubViews:(UIView*)CurrentContainer;

+(UIButton*)setNavigationRightButton:(UINavigationController*)navigationController;

@end
