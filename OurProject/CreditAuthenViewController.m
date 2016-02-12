//
//  CreditAuthenViewController.m
//  OurProject
//
//  Created by StephenHe on 10/9/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "CreditAuthenViewController.h"
#import "QRCodeGenerator.h"
#import "UMSocialSnsService.h"
#import "CommFunc.h"
#import "CustomHttpRequest.h"
@interface CreditAuthenViewController ()<UIAlertViewDelegate>

@end

@implementation CreditAuthenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"二维码";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //创建放置二维码的View
    UIImageView * CodeView=[[UIImageView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-self.view.bounds.size.width/1.5)/2, self.view.bounds.size.height/7, self.view.bounds.size.width/1.5, self.view.bounds.size.width/1.5)];
     [self.view addSubview:CodeView];
    //创建分享二维码的按钮
    UIButton *shareCode_btn=[UIButton buttonWithType:UIButtonTypeSystem];
    [shareCode_btn setFrame:CGRectMake(self.view.bounds.size.width/2-60, self.view.bounds.size.height/7+self.view.bounds.size.width+20, 120, 30)];
    [shareCode_btn setTitle:@"分享我的二维码" forState:UIControlStateNormal];
    [shareCode_btn addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareCode_btn];
    //获取登录数据
    self.loginDic = [CommFunc readUserLogin];
     NSLog(@"78797%@",self.loginDic);
    NSString * serverUrl = @"Store/userStore";
    NSString * paramUrl = [NSString stringWithFormat:@"{\"token\":\"%@\",\"uid\":\"%@\"}",self.loginDic[@"data"][@"token"],self.loginDic[@"data"][@"users_id"]];
     CustomHttpRequest * customRequest = [[CustomHttpRequest alloc]init];
    [customRequest fetchResponseByPost:serverUrl WithParameter:paramUrl WithResponse:^(NSDictionary *info) {
        NSDictionary * infoDic = [NSDictionary dictionaryWithDictionary:info];
        NSLog(@"7454%@",infoDic);
        
        if(![infoDic[@"data"] isEqual:@""])
        {
            CodeView.image=[QRCodeGenerator qrImageForString:[NSString stringWithFormat:@"%@/index.php?s=/Mobile1/Index/index.html&StoreID=%@",@"http://112.74.105.205/zhizu",infoDic[@"id"]] imageSize:self.view.bounds.size.width];
            [self.view addSubview:CodeView];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请开店之后再来查看二维码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
            
        }
        
        
        
        
    }];
    
   


    //创建分享二维码的按钮
    UIButton * button=[UIButton buttonWithType:UIButtonTypeSystem];
    [button setFrame:CGRectMake(self.view.bounds.size.width/2-60, self.view.bounds.size.height/7+self.view.bounds.size.width+20, 120, 30)];
    [button setTitle:@"分享我的二维码" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareCode_btn];
    
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)add:(id)sender
{
    NSString *shareText = @"友盟社会化组件可以让移动应用快速具备社会化分享、登录、评论、喜欢等功能，并提供实时、全面的社会化数据统计分析服务。 http://www.umeng.com/social";             //分享内嵌文字
    UIImage *shareImage = [UIImage imageNamed:@"UMS_social_demo"];          //分享内嵌图片
    
    //调用快速分享接口
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"53290df956240b6b4a0084b3"
                                      shareText:shareText
                                     shareImage:shareImage
                                shareToSnsNames:nil
                                       delegate:self];

    
    
    
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
