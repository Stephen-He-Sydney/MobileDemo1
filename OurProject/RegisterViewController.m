//
//  RegisterViewController.m
//  ZhiZuTeamWorkProject
//
//  Created by StephenHe on 10/8/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"注册";

    if (self.isPushFromLogin == NO)
    {
        self.navigationController.navigationBar.topItem.title = @"";
        self.navigationController.navigationBar.hidden = NO;
    }
 
    [self createInputTextField];
    
    [self createNextStepButton];
  
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (id)init
{
    if (self = [super init])
    {
        self.isPushFromLogin = NO;
    }
    return self;
}

-(void)createInputTextField
{
    inputMobileNo = [[UITextField alloc]initWithFrame:CGRectMake(30, CURRSIZE.height/4, CURRSIZE.width-60, 40)];
    [inputMobileNo setPlaceholder:@"请输入手机号"];
    [inputMobileNo setClearButtonMode:UITextFieldViewModeWhileEditing];
    [inputMobileNo setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [inputMobileNo setFont:[UIFont systemFontOfSize:20]];
    [self.view addSubview:inputMobileNo];
    
    UIView* inputLine = [[UIView alloc]initWithFrame:CGRectMake(30, inputMobileNo.frame.origin.y + inputMobileNo.frame.size.height, inputMobileNo.frame.size.width, 1)];
    //[inputLine setBackgroundColor:[UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1]];
    [inputLine setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:inputLine];
    
    inputMobileNo.delegate = self;
}

-(void)createNextStepButton
{
    UIButton* nextStepBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [nextStepBtn setFrame:CGRectMake(30, CURRSIZE.height/5*2, CURRSIZE.width-60, 40)];
    [nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextStepBtn setBackgroundColor:[CommonViewController getCurrRedColor]];
    [nextStepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextStepBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    
    [nextStepBtn addTarget:self action:@selector(nextStepBtnResponse:) forControlEvents:UIControlEventTouchUpInside];
    //registerBtn.layer.cornerRadius = 6;
    
    [self.view addSubview:nextStepBtn];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (self.isPushFromLogin == NO)
    {
        self.navigationController.navigationBar.hidden = YES;
    }
}

-(void)nextStepBtnResponse:(id)sender
{
    if ([self verifyMobileNo:[CommFunc trimString:inputMobileNo.text]] == YES)
    {
       
       NextViewController* nextViewCtrl = [[NextViewController alloc]init];
       nextViewCtrl.mobileNo = [CommFunc trimString:inputMobileNo.text];
       
       CustomHttpRequest* httpRequest = [[CustomHttpRequest alloc]init];
       
       NSString* serverUrl = @"Public/checkMobile";
       NSString* paramUrl = [NSString stringWithFormat:@"{\"mobile\":\"%@\",\"oswer_apply\":1}",nextViewCtrl.mobileNo];
    
        [httpRequest fetchLoginRegisterResponse:serverUrl WithParameter:paramUrl WithResponse:^(NSDictionary *info) {
            if ([info objectForKey:@"fail"])
            {
                [self promptSingleButtonWarningDialog:@"网络不给力，请稍候重试!"];
            }
        }];

        [self.navigationController pushViewController:nextViewCtrl animated:YES];
    }
    
//    NextViewController* nextViewCtrl = [[NextViewController alloc]init];
//    [self.navigationController pushViewController:nextViewCtrl animated:YES];
}

-(BOOL)verifyMobileNo:(NSString*)input
{
    if (input && input.length == 11)
    {
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        for (int i = 0; i < [input length]; i++) {
            unichar c = [input characterAtIndex:i];
            if (![myCharSet characterIsMember:c]) {
                [self promptSingleButtonWarningDialog:@"必须为11位手机号!"];
                return NO;
            }
        }
        return YES;
    }
    else
    {
        [self promptSingleButtonWarningDialog:@"未输入手机号或手机号位数有错!"];
        return NO;
    }
}

-(void)promptSingleButtonWarningDialog:(NSString*)msg
{
    UIAlertView* warnAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    //warnAlert.tag = 1;
    [warnAlert show];
}

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
