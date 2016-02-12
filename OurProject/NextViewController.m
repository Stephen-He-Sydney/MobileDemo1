//
//  NextViewController.m
//  OurProject
//
//  Created by StephenHe on 10/10/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "NextViewController.h"

@interface NextViewController ()

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    totalSeconds = 60;
    
    self.navigationItem.title = @"注册";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self createInputTextField];
    
    [self createRegisterButton];
    
    [self startCountDown];
}

-(void)startCountDown
{
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

-(void)timerFired
{
    if (totalSeconds > 0)
    {
        totalSeconds--;
        countDownSeconds.text =[NSString stringWithFormat:@"%d",totalSeconds];
    }
    else
    {
        [countDownTimer invalidate];
        countDownTimer = nil;
    }
}

-(void)createInputTextField
{
    verifyCode = [[UITextField alloc]initWithFrame:CGRectMake(30, CURRSIZE.height/4, CURRSIZE.width-60-40, 40)];
    [verifyCode setPlaceholder:@"输入验证码"];
    [verifyCode setClearButtonMode:UITextFieldViewModeWhileEditing];
    [verifyCode setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [verifyCode setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:verifyCode];
    
    UILabel* leftBracket = [[UILabel alloc]initWithFrame:CGRectMake(verifyCode.frame.size.width+verifyCode.frame.origin.x, CURRSIZE.height/4, 5, 40)];
    leftBracket.text = @"(";
    
    countDownSeconds = [[UILabel alloc]initWithFrame:CGRectMake(leftBracket.frame.size.width+leftBracket.frame.origin.x, CURRSIZE.height/4, 20, 40)];
    countDownSeconds.text = @"60";
    
    UILabel* rightBracket = [[UILabel alloc]initWithFrame:CGRectMake(countDownSeconds.frame.size.width+countDownSeconds.frame.origin.x, CURRSIZE.height/4, 15, 40)];
    rightBracket.text = @"s)";
    
    [self.view addSubview:leftBracket];
    [self.view addSubview:countDownSeconds];
    [self.view addSubview:rightBracket];
    
    UIView* inputLine = [[UIView alloc]initWithFrame:CGRectMake(30, verifyCode.frame.origin.y + verifyCode.frame.size.height, CURRSIZE.width-60, 1)];
    [inputLine setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:inputLine];
    
    password = [[UITextField alloc]initWithFrame:CGRectMake(30, inputLine.frame.origin.y+inputLine.frame.size.height+20, CURRSIZE.width-60-40, 40)];
    [password setPlaceholder:@"设置6~20位密码.仅限字母和数字"];
    [password setClearButtonMode:UITextFieldViewModeWhileEditing];
    [password setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [password setFont:[UIFont systemFontOfSize:15]];
    [password setSecureTextEntry:YES];
    [self.view addSubview:password];
    
    secondLine = [[UIView alloc]initWithFrame:CGRectMake(30, password.frame.origin.y + password.frame.size.height, CURRSIZE.width-60, 1)];
    [secondLine setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:secondLine];
    
    verifyCode.delegate = self;
    password.delegate = self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)createRegisterButton
{
    UIButton* registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [registerBtn setFrame:CGRectMake(30, secondLine.frame.size.height+secondLine.frame.origin.y+40, CURRSIZE.width-60, 40)];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setBackgroundColor:[CommonViewController getCurrRedColor]];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    
    [registerBtn addTarget:self action:@selector(registerResponse:) forControlEvents:UIControlEventTouchUpInside];
    //registerBtn.layer.cornerRadius = 6;
    
    [self.view addSubview:registerBtn];
}

-(void)registerResponse:(id)sender
{
    if ([self verifyPassword:password.text] == YES)
    {
        CustomHttpRequest* httpRequest = [[CustomHttpRequest alloc]init];
        NSString* serverUrl = @"Index/register";
        //NSString* paramUrl = [NSString stringWithFormat:@"{\"proving\":%@,\"mobile\":\"%@\",\"password\":\"%@\",\"oswer_apply\":1, \"u_mobile\":\"%@\"}",verifyCode.text,self.mobileNo,password.text,@""];
        
        NSString* paramUrl = [NSString stringWithFormat:@"{\"mobile\":\"%@\",\"password\":\"%@\",\"oswer_apply\":1, \"u_mobile\":\"%@\"}",self.mobileNo,password.text,@""];
        
        [httpRequest fetchLoginRegisterResponse:serverUrl WithParameter:paramUrl WithResponse:^(NSDictionary *info) {
            if ([info objectForKey:@"fail"])
            {
                [self promptSingleButtonWarningDialog:@"网络不给力，请稍候重试!"];
            }
            else
            {
                NSString* response = info[@"info"];
                [self promptDoubleButtonDialog:response];
            }
        }];
        
    }
    else
    {
        [self promptSingleButtonWarningDialog:@"密码设置不符合要求!"];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2)
    {
        if (buttonIndex == 0)
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
}

-(BOOL)verifyPassword:(NSString*)input
{
    if (input && input.length >= 6 && input.length <= 20)
    {
        NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:input];
        NSCharacterSet *alphanumericSet = [NSCharacterSet alphanumericCharacterSet];
        
        return [alphanumericSet isSupersetOfSet:stringSet];
    }
    else
    {
        return NO;
    }
}

-(void)promptDoubleButtonDialog:(NSString*)msg
{
    UIAlertView* warnAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"去登录" otherButtonTitles:@"重新注册",nil];
    
    warnAlert.tag = 2;
    
    [warnAlert show];
}

-(void)promptSingleButtonWarningDialog:(NSString*)msg
{
    UIAlertView* warnAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    warnAlert.tag = 1;
    [warnAlert show];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
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
