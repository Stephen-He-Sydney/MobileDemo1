//
//  ChangeNickNameViewController.m
//  OurProject
//
//  Created by StephenHe on 10/9/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "ChangeNickNameViewController.h"
#import "GlobalConstants.h"
#import "CustomHttpRequest.h"
#import "CommFunc.h"
#import "UploadPhoto.h"
@interface ChangeNickNameViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSDictionary * infoDic;
    UITextField * nameField;
    
    UIImageView * headView;
    UITextField * passWordField;
    NSString * str;
}
@end

@implementation ChangeNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"信息修改";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.tabBarController.tabBar setHidden:YES];
    
    headView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 10, 50,50 )];
    [headView setUserInteractionEnabled:YES];
    [headView setImage:[UIImage imageNamed:@"xx_list_icon_2"]];
    [self.view addSubview:headView];
    //添加手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [headView addGestureRecognizer:tap];
    
    //用户名
    nameField = [[UITextField alloc]initWithFrame:CGRectMake(30, 70, CURRSIZE.width-60, 30)];
    nameField.delegate =self;
    [nameField setFont:[UIFont systemFontOfSize:15]];
    [nameField setPlaceholder:@"请输入用户名"];
    [nameField setReturnKeyType:UIReturnKeyDone];
    [nameField setClearsOnBeginEditing:YES];
    [self.view addSubview:nameField];
    UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 100, CURRSIZE.width-60, 1)];
    [lineView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:lineView];
    //密码
     passWordField = [[UITextField alloc]initWithFrame:CGRectMake(30, 110, CURRSIZE.width-60, 30)];
    [passWordField setFont:[UIFont systemFontOfSize:15]];
    //[passWordField setPlaceholder:@"请输入密码"];
    [self.view addSubview:passWordField];
    UIImageView * passWordLine = [[UIImageView alloc]initWithFrame:CGRectMake(30, 140, CURRSIZE.width-60, 1)];
    [passWordLine setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:passWordLine];
    //提交button
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [submitBtn setFrame:CGRectMake(40, 160, CURRSIZE.width-80, 30)];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [submitBtn setTintColor:[UIColor whiteColor]];
    [submitBtn setBackgroundColor:[UIColor redColor]];
    submitBtn.layer.cornerRadius = 5;
    //添加事件
    [submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
}

-(void)promptSingleButtonWarningDialog:(NSString*)msg
{
    UIAlertView* warnAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    warnAlert.tag = 1;
    [warnAlert show];
}
#pragma mark - 提交按钮方法实现
-(void)submitBtnAction:(id)sender
{
    self.loginDic = [CommFunc readUserLogin];
    NSLog(@"%@",self.loginDic);
    
    [UploadPhoto upLoadImage:headView.image completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"%@",headView.image);
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dic);
       if ([dic[@"status"]intValue]==1) {
            str = dic[@"data"][@"file"][@"path"];
           NSLog(@"上传的图片为%@",str);
           
           CustomHttpRequest * customRequest = [[CustomHttpRequest alloc]init];
           NSString * serverUrl = @"store/editStore";
           NSString * paramUrl = [NSString stringWithFormat:@"{\"token\":\"%@\",\"id\":\"%@\",\"name\":\"%@\",\"description\":\"%@\",\"users_id\":\"%@\"}",self.loginDic[@"data"][@"token"],self.loginDic[@"data"][@"Store"][0][@"id"],nameField.text,passWordField.text,self.loginDic[@"data"][@"users_id"]];
           
           [customRequest fetchResponseByPost:serverUrl WithParameter:paramUrl WithResponse:^(NSDictionary *info) {
               if ([info objectForKey:@"fail"])
               {
                   [self promptSingleButtonWarningDialog:@"网络不给力，请稍候"];
               } else
               {
                   if (info[@"data"]!= (id)[NSNull null])
                   {

                       
                       
                       if(([info[@"data"] isKindOfClass:[NSArray class]]||[info[@"data"] isKindOfClass:[NSDictionary class]])&& [info[@"data"] count] > 0)
                       {
                           
                       }
                   }
               }
            
           }];
  
       }else if (connectionError)
       {
           //NSLog(@"%@",connectionError.userInfo);
       }
        

        CustomHttpRequest * customRequest1 = [[CustomHttpRequest alloc]init];
        NSString * serverUrl = @"users/editUser";
        NSString * paramUrl = [NSString stringWithFormat:@"{\"token\":\"%@\",\"uid\":\"%@\",\"headPic\":\"%@\",\"nickname\":\"%@\"}",self.loginDic[@"data"][@"token"],self.loginDic[@"data"][@"users_id"],[NSString stringWithFormat:@"%@%@",@"http://112.74.105.205/zhizu",str],nameField.text];
        [customRequest1 fetchResponseByPost:serverUrl WithParameter:paramUrl WithResponse:^(NSDictionary *info) {
            
            if ([info objectForKey:@"fail"])
            {
                [self promptSingleButtonWarningDialog:@"网络不给力,请稍候"];
                
            }
            else
                
            {
                if (info[@"data"]!= (id)[NSNull null])
                {
                    
                    infoDic = [NSDictionary dictionaryWithDictionary:info];
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:infoDic[@"info"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                    [alert show];
                    alert.tag =100;
                    
                    if(([info[@"data"] isKindOfClass:[NSArray class]]||[info[@"data"] isKindOfClass:[NSDictionary class]])&& [info[@"data"] count] > 0)
                    {
                        
                    }
                }
            }
            // NSLog(@"%@",getInfo);
            
        }];
        
   }];
    
    
    
    


    
    
   
}

#pragma mark -实现textField的代理方法
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([string isEqualToString:@"\n"]) {
        
        [textField resignFirstResponder];
        
        return NO;
    }
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    //NSLog(@"%@",textField.text);
    return YES;
}

#pragma mark -手势方法
-(void)tapAction:(id)sender
{

    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"选择上传方式" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"相册", nil];
    alertView.tag=101;
    [alertView show];
}

#pragma mark - 选中alert button 执行的方法
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100) {
        if (buttonIndex==0) {
           
            [self.navigationController popViewControllerAnimated:YES];
            
            
            
        }
        
        
    }else if (alertView.tag==101)
    {
        if (buttonIndex ==0) {
            NSLog(@"确定");
        }else if (buttonIndex==1)
        {
            NSLog(@"拍照");
            //判断是否可以打开照相机
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController * picker = [[UIImagePickerController alloc]init];
                picker.delegate = self;
                //指定调用资源为摄像头
                [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
                [self presentViewController:picker animated:YES completion:nil];
            }
            
        }else if (buttonIndex==2)
        {
            NSLog(@"相册");
            
            //判断当前App是否可以使用相册
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                UIImagePickerController * picker = [[UIImagePickerController alloc]init];
                picker.delegate = self;
                picker.allowsEditing=YES;
                //指定picker调用资源为当前设备相册
                [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                [self presentViewController:picker animated:YES completion:nil];
            }
        }
    
    
    }
    
    

}
#pragma mark - 选择完毕
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获取照相拍摄的图片
    UIImage * PhoneImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    [headView setImage:PhoneImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
