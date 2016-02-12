//
//  CreateStoreViewController.m
//  OurProject
//
//  Created by ibokan on 15/10/17.
//  Copyright (c) 2015年 StephenHe. All rights reserved.
//

#import "CreateStoreViewController.h"
#import "CustomHttpRequest.h"
#import "CommFunc.h"
#import "StoreViewController.h"
#import "CommonViewController.h"

@interface CreateStoreViewController ()<UIAlertViewDelegate>

@property(strong,nonatomic)UITextField *storeNameText;
@property(strong,nonatomic)UITextField *storeInfoText;
@property(strong,nonatomic)NSDictionary *loginInfo;

@end

@implementation CreateStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"创建店铺"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.loginInfo = [CommFunc readUserLogin];//获取登录信息
    NSLog(@"%@",self.loginInfo[@"data"][@"users_id"]);
    
    UIImageView *storeNameView = [[UIImageView alloc]initWithFrame:CGRectMake(20, self.view.bounds.size.height/20, self.view.bounds.size.width - 40, self.view.bounds.size.height/10)];
    [storeNameView setUserInteractionEnabled:YES];
    [self.view addSubview:storeNameView];
    UIImageView *storeNameImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, storeNameView.bounds.size.width/5, storeNameView.bounds.size.height-5)];
    [storeNameImage setImage:[UIImage imageNamed:@"wd_icon_6"]];
    [storeNameImage setContentMode:UIViewContentModeScaleAspectFit];
    [storeNameView addSubview:storeNameImage];
    UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, storeNameView.bounds.size.height-2, storeNameView.bounds.size.width, 1)];
    [lineImage setBackgroundColor:[UIColor blackColor]];
    [storeNameView addSubview:lineImage];
    
    _storeNameText = [[UITextField alloc]initWithFrame:CGRectMake(storeNameView.bounds.size.width/4.5, storeNameView.bounds.size.height/4, storeNameView.bounds.size.width/1.5, storeNameView.bounds.size.height/2)];
    [_storeNameText setPlaceholder:@"店铺名称"];
    [storeNameView addSubview:_storeNameText];
    
    UIImageView *storeInfoView = [[UIImageView alloc]initWithFrame:CGRectMake(20, self.view.bounds.size.height/6, self.view.bounds.size.width - 40, self.view.bounds.size.height/10)];
    //    [storeNameView setBackgroundColor:[UIColor grayColor]];
    [storeInfoView setUserInteractionEnabled:YES];
    [self.view addSubview:storeInfoView];
    UIImageView *storeInfoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, storeInfoView.bounds.size.width/5, storeInfoView.bounds.size.height-5)];
    [storeInfoImage setImage:[UIImage imageNamed:@"qd_zc"]];
    [storeInfoImage setContentMode:UIViewContentModeScaleAspectFit];
    [storeInfoView addSubview:storeInfoImage];
    UIImageView *lineImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, storeInfoView.bounds.size.height-2, storeInfoView.bounds.size.width, 1)];
    [lineImg setBackgroundColor:[UIColor blackColor]];
    [storeInfoView addSubview:lineImg];
    
    _storeInfoText = [[UITextField alloc]initWithFrame:CGRectMake(storeInfoView.bounds.size.width/4.5, storeInfoView.bounds.size.height/4, storeInfoView.bounds.size.width/1.5, storeInfoView.bounds.size.height/2)];
    [_storeInfoText setPlaceholder:@"店铺描述"];
    [storeInfoView addSubview:_storeInfoText];

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];//initWithTarget:self action:@selector(byDataAction)];
    [button setFrame:CGRectMake(self.view.bounds.size.width/4, self.view.bounds.size.height/3, self.view.bounds.size.width/2, 25)];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(byDataAction) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor redColor]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
}
-(void)byDataAction
{
    [self creatStoreDataRequest];
}
#pragma mark - 开通店铺的数据请求
-(void)creatStoreDataRequest
{
//    CustomHttpRequest* httpRequest = [[CustomHttpRequest alloc]init];
    NSString* serverUrl = @"Store/createStore";
    NSString* paramUrl = [NSString stringWithFormat:@"{\"token\":\"%@\",\"uid\":\"%@\",\"name\":\"%@\"}",self.loginInfo[@"data"][@"token"],self.loginInfo[@"data"][@"users_id"],_storeInfoText.text];
    
    CommonViewController* commCtrl = [[CommonViewController alloc]init];
    [commCtrl handleServerSideInfo:serverUrl WithParamUrl:paramUrl];
    
    commCtrl.jsonData = ^(NSDictionary* info)
    {
        UIAlertView *toolTip = [[UIAlertView alloc]initWithTitle:@"提示" message:info[@"info"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
       [toolTip show];
    };

}
-(void)blockValue:(byTureBlock)value
{
    self.blockValue = value;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
