//
//  CommonViewController.m
//  OurProject
//
//  Created by StephenHe on 10/15/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "CommonViewController.h"

@interface CommonViewController ()

@end

@implementation CommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+(UIColor*)getCurrRedColor
{
    return [UIColor colorWithRed:247/255.0 green:68/255.0 blue:48/255.0 alpha:1];
}

-(void)promptSingleButtonErrorDialog:(NSString*)msg
{
    UIAlertView* warnAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    warnAlert.tag = 3;
    [warnAlert show];
}

-(void)promptDoubleButtonRedirectDialog:(NSString*)msg
{
    UIAlertView* warnAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"重新登录" otherButtonTitles:@"知道了",nil];
    
    warnAlert.tag = 2;
    [warnAlert show];
}

-(void)promptSingleButtonWarningDialog:(NSString*)msg
{
    UIAlertView* warnAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    warnAlert.tag = 1;
    [warnAlert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2)
    {
        if (buttonIndex == 0)
        {
            [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
            
            LoginViewController* loginCtrl = [[LoginViewController alloc]init];
            loginCtrl.isHiddenBackBtn = YES;
            
            [self.navigationController pushViewController:loginCtrl animated:YES];
        }
    }
}

-(void)autoLogin:(NSString*)serverUrl WithParamUrl:(NSString*)paramUrl WithLoginInfo:(NSDictionary*)loginInfo
{
    CustomHttpRequest* httpRequest = [[CustomHttpRequest alloc]init];
    
    [httpRequest fetchLoginRegisterResponse:serverUrl WithParameter:paramUrl WithResponse:^(NSDictionary *info) {
        if ([info objectForKey:@"fail"])
        {
            [self promptSingleButtonWarningDialog:@"网络不给力，请稍候重试!"];
        }
        else
        {
            if ((int)[info[@"status"]integerValue] != 1)
            {
                [self promptSingleButtonErrorDialog:info[@"info"]];
            }
            else
            {
                [CommFunc markSuccessfulLogin:loginInfo[@"mobile"] WithPassword:loginInfo[@"password"] WithData:info[@"data"]];
                
                AppTabBarController* appTabCtrl = [[AppTabBarController alloc]init];
                
                UITabBarController* tabBarCtrls = [appTabCtrl LoadTabBarAndNavComponents];
                
                if (self.isReady != nil)
                {
                    self.isReady(tabBarCtrls);
                }
            }
        }
    }];
}

-(void)handleServerSideInfo:(NSString*)serverUrl WithParamUrl:(NSString*)paramUrl
{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    CustomHttpRequest* customRequest = [[CustomHttpRequest alloc]init];
    
    [customRequest fetchResponseByPost:serverUrl WithParameter:paramUrl WithResponse:^(NSDictionary *info) {
        if ([info objectForKey:@"fail"])
        {
            [self promptSingleButtonWarningDialog:@"网络不给力，请稍候重试!"];
        }
        else
        {
            if ((int)[info[@"status"]integerValue] != 1)
            {
                [self promptDoubleButtonRedirectDialog:@"登录超时!"];
            }
            else
            {
                if (info[@"data"]!= (id)[NSNull null])
                {
                    if([info[@"data"] isKindOfClass:[NSDictionary class]]
                       || [info[@"data"] isKindOfClass:[NSArray class]])
                    {
                        if (self.jsonData != nil)//ensure it is assigned with value
                        {
                            self.jsonData(info);
                        }
                    }
                }
                else
                {
                    if (self.jsonData != nil)//ensure it is assigned with value
                    {
                        self.jsonData(nil);
                    }
                }
            }
        }
    }];
}

-(void)addloadingMark:(UIView*)currRootView
{
    //加载大活动指示器，1秒后自动关闭
    MBProgressHUD* progressMark = [[MBProgressHUD alloc]initWithView:self.view];
    
    //[progressMark setDimBackground:YES];
    
    [progressMark show:YES];
    [currRootView addSubview:progressMark];
    
    [progressMark hide:YES afterDelay:1];
}

#pragma mark - 删除当前容器中所有子视图
-(void)removeAllSubViews:(UIView*)CurrentContainer
{
    for (UIView* subView in CurrentContainer.subviews) {
        [subView removeFromSuperview];
    }
}

+(UIButton*)setNavigationRightButton:(UINavigationController*)navigationController
{
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [rightBtn setFrame:CGRectMake(0, 0, navigationController.navigationBar.frame.size.width/5, navigationController.navigationBar.frame.size.height)];
    
    [rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:22]];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    
   // [rightBtn setBackgroundColor:[UIColor redColor]];
    
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
 
    return  rightBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
