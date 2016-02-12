//
//  LoginViewController.m
//  ZhiZuTeamWorkProject
//
//  Created by StephenHe on 10/8/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    
    if (self.isHiddenBackBtn == YES)
    {
        self.navigationItem.leftBarButtonItem=nil;
        self.navigationItem.hidesBackButton=YES;
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithCustomView:[self reflectNavigationBarRightBtn]];
    }
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"登录";
    self.navigationController.navigationBar.topItem.title = @"";
    
    [self createInputTextField];
    [self createLoginButton];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

-(UIButton*)reflectNavigationBarRightBtn
{
    UIButton* registerButton = [CommonViewController setNavigationRightButton:self.navigationController];
    
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    
    [registerButton addTarget:self action:@selector(goToRegister:) forControlEvents:UIControlEventTouchUpInside];

    return registerButton;
}

-(void)goToRegister:(id)sender
{
    RegisterViewController* registerCtrl = [[RegisterViewController alloc]init];
    registerCtrl.isPushFromLogin = YES;
    
    [self.navigationController pushViewController:registerCtrl animated:YES];
}

- (id)init
{
    if (self = [super init])
    {
        self.isHiddenBackBtn = NO;
    }
    return self;
}

-(void)createInputTextField
{
    self.accountNo = [[UITextField alloc]initWithFrame:CGRectMake(30, CURRSIZE.height/4, CURRSIZE.width-60-40, 40)];
    [self.accountNo setPlaceholder:@"请输入账号"];
    [self.accountNo setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.accountNo setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.accountNo setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:self.accountNo];
    
    UIView* inputLine = [[UIView alloc]initWithFrame:CGRectMake(30, self.accountNo.frame.origin.y + self.accountNo.frame.size.height, CURRSIZE.width-60, 1)];
    [inputLine setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:inputLine];
    
    self.password = [[UITextField alloc]initWithFrame:CGRectMake(30, inputLine.frame.origin.y+inputLine.frame.size.height+20, CURRSIZE.width-60-40, 40)];
    [self.password setPlaceholder:@"请输入密码"];
    [self.password setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.password setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.password setFont:[UIFont systemFontOfSize:15]];
    [self.password setSecureTextEntry:YES];
    [self.view addSubview:self.password];
    
    secondLine = [[UIView alloc]initWithFrame:CGRectMake(30, self.password.frame.origin.y + self.password.frame.size.height, CURRSIZE.width-60, 1)];
    [secondLine setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:secondLine];
    
    self.accountNo.delegate = self;
    self.password.delegate = self;
}

-(void)createLoginButton
{
    UIButton* loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [loginBtn setFrame:CGRectMake(10, CURRSIZE.height/2, CURRSIZE.width-20, 40)];
    [loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:[CommonViewController getCurrRedColor]];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    
    [loginBtn addTarget:self action:@selector(LoginResponse:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.layer.cornerRadius = 6;
    
    [self.view addSubview:loginBtn];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (self.isHiddenBackBtn == NO)
    {
        self.navigationController.navigationBar.hidden = YES;
    }
}

-(void)LoginResponse:(UIButton*)response
{
    if (self.accountNo.text && [CommFunc trimString:self.accountNo.text].length > 0
        && self.password.text && [CommFunc trimString:self.password.text].length > 0)
    {
        NSDictionary* loginInfo = @{@"mobile":[CommFunc trimString:self.accountNo.text],@"password":[CommFunc trimString:self.password.text]};
        
        NSString* serverUrl = @"Index/login";
        NSString* paramUrl = [NSString stringWithFormat:@"{\"moblie\":\"%@\",\"password\":\"%@\",\"oswer_status\":2}",[CommFunc trimString:self.accountNo.text],[CommFunc trimString:self.password.text]];
       
        CommonViewController* comm = [[CommonViewController alloc]init];
        [comm autoLogin:serverUrl WithParamUrl:paramUrl WithLoginInfo:loginInfo];
        
        comm.isReady = ^(UITabBarController* appTabCtrl)
        {
            [self presentViewController:appTabCtrl animated:YES completion:nil];
        };
    }
    else
    {
        [self promptSingleButtonWarningDialog:@"账号或密码不能为空!"];
    }
}

-(void)promptSingleButtonWarningDialog:(NSString*)msg
{
    UIAlertView* warnAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    warnAlert.tag = 1;
    [warnAlert show];
}

//这个方法也行
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if ([string isEqualToString:@"\n"]) {
//        [textField resignFirstResponder];
//        return  NO;
//    }
//    return  YES;
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
