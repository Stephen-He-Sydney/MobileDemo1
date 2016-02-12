//
//  StartAppViewController.m
//  OurProject
//
//  Created by StephenHe on 10/9/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "StartAppViewController.h"

@interface StartAppViewController ()

@end

@implementation StartAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView* bgImg = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgImg.image = [UIImage imageNamed:@"qd_bg"];
    
    UILabel* title = [[UILabel alloc]initWithFrame:CGRectMake(CURRSIZE.width/2-70, CURRSIZE.height/4-20, 150, 60)];
    title.text = @"知足万校";
    [title setTextColor:[UIColor blackColor]];
    [title setFont:[UIFont boldSystemFontOfSize:34]];
    //[title setBackgroundColor:[UIColor redColor]];
    
    [self.view addSubview:bgImg];
    [self.view addSubview:title];
    
    NSArray* imgBtns = @[@"qd_dl",@"qd_zc"];
    NSArray* txtBtns = @[@"登录",@"注册"];
    for (int i = 0; i < 2; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(CURRSIZE.width*0.22+CURRSIZE.width*0.37*i,CURRSIZE.height/2,60,60)];
        [btn setBackgroundImage:[UIImage imageNamed:[imgBtns objectAtIndex:i]] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(clickResponse:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel* btnTxt = [[UILabel alloc]initWithFrame:CGRectMake(CURRSIZE.width*0.245+CURRSIZE.width*0.37*i,CURRSIZE.height/2+50,60,60)];
        btnTxt.text = txtBtns[i];
        [btnTxt setTextColor:[UIColor blackColor]];
        [btnTxt setFont:[UIFont boldSystemFontOfSize:20]];
        
        [self.view addSubview:btn];
        [self.view addSubview:btnTxt];
    }
    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isLogined"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)clickResponse:(UIButton*)response
{
    if (response.tag == 0)
    {
        LoginViewController* loginCtrl = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginCtrl animated:YES];
    }
    else
    {
        RegisterViewController* registerCtrl = [[RegisterViewController alloc]init];
        [self.navigationController pushViewController:registerCtrl animated:YES];
    }
}

-(void)promptSingleButtonWarningDialog:(NSString*)msg
{
    UIAlertView* warnAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    warnAlert.tag = 1;
    [warnAlert show];
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
