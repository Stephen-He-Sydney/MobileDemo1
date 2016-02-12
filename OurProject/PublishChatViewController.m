//
//  PublishChatViewController.m
//  OurProject
//
//  Created by ibokan on 15/10/14.
//  Copyright (c) 2015年 StephenHe. All rights reserved.
//

#import "PublishChatViewController.h"
#import "GlobalConstants.h"
#import "CustomHttpRequest.h"
#import "CommFunc.h"
#import "UploadPhoto.h"
#import "PublishChatViewController.h"
@interface PublishChatViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView * imageView;
    NSString * str;
    UITextView * textView;
    NSDictionary * infoDic;
}

@end

@implementation PublishChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title =@"发表交流";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //发送
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnAction:)];
    self.navigationItem.rightBarButtonItem = rightBtn ;
    
    //文本输入框
    textView = [[UITextView alloc]initWithFrame:CGRectMake(CURRSIZE.width/20, 10, CURRSIZE.width/20*18, CURRSIZE.width/20*12)];
   
    textView.layer.borderColor =[UIColor lightGrayColor].CGColor;
    textView.layer.borderWidth = 0.5;
    //[textField setBorderStyle:UITextBorderStyleLine];
   // [textField setTextAlignment:NSTextAlignmentLeft];
    textView.layer.cornerRadius = 5;
    [self.view addSubview:textView];
 
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, textView.frame.size.height/3*2, 50, 50)];
    [imageView setUserInteractionEnabled:YES];
    imageView.tag = 100;
    [imageView setImage:[UIImage imageNamed:@"wdspk_icon_2"]];
    [textView addSubview:imageView];
    
    //添加手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [imageView addGestureRecognizer:tap];
    UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(65, textView.frame.size.height/3*2+15, 60, 20)];
    [lable setText:@"添加图片"];
    [lable setFont:[UIFont systemFontOfSize:10]];
    [textView addSubview:lable];
    
    
    
    
}

#pragma mark - 发送方法
-(void)rightBtnAction:(id)sender
{
    self.loginDic = [CommFunc readUserLogin];
    NSLog(@"55555%@",self.loginDic);
    
    if ([UIImage imageNamed:@"home_tb_05"]) {
        
        CustomHttpRequest * customRequest1 = [[CustomHttpRequest alloc]init];
        NSString * serverUrl =@"Topic/addTopic";
        NSString * paramUrl = [NSString stringWithFormat:@"{\"users_id\":\"%@\",\"topic_title\":\"%@\",\"topic_content\":\"%@\",\"token\":\"%@\"}",self.loginDic[@"data"][@"users_id"],textView.text,textView.text,self.loginDic[@"data"][@"token"]];
        [customRequest1 fetchResponseByPost:serverUrl WithParameter:paramUrl WithResponse:^(NSDictionary *info) {
        
            //                if ([info objectForKey:@"fail"])
            //                {
            //
            //
            //                }
            //                else
            //
            //                {
            //                   if (info[@"data"]!= (id)[NSNull null])
            //                   {
            
            infoDic = [NSDictionary dictionaryWithDictionary:info];
            //                        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:infoDic[@"info"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            //                        [alert show];
            NSLog(@"76746%@",infoDic);
            [self.navigationController popViewControllerAnimated:YES];

            
        }];
    }else
         {
    
    [UploadPhoto upLoadImage:imageView.image completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dic);
        if ([dic[@"status"]intValue]==1) {
            str = dic[@"data"][@"file"][@"path"];
            NSLog(@"上传的图片为%@",str);
            
            NSString * str2 =[NSString stringWithFormat:@"http://112.74.105.205/zhizu%@",str];
            NSURL * url = [NSURL URLWithString:str2];
            
            CustomHttpRequest * customRequest1 = [[CustomHttpRequest alloc]init];
            NSString * serverUrl =@"Topic/addTopic";
            NSString * paramUrl = [NSString stringWithFormat:@"{\"users_id\":\"%@\",\"topic_title\":\"%@\",\"topic_image_url\":\"%@\",\"topic_content\":\"%@\",\"token\":\"%@\"}",self.loginDic[@"data"][@"users_id"],textView.text,url,textView.text,self.loginDic[@"data"][@"token"]];
            [customRequest1 fetchResponseByPost:serverUrl WithParameter:paramUrl WithResponse:^(NSDictionary *info) {

//                   if (info[@"data"]!= (id)[NSNull null])
//                   {
                
                        infoDic = [NSDictionary dictionaryWithDictionary:info];

                        NSLog(@"76746%@",infoDic);
                
                        [self.navigationController popViewControllerAnimated:YES];
 
            }];
   
        }
    }];

         }

}

#pragma mark - 手势方法实现
-(void)tapAction:(id)sender
{
    NSLog(@"你好");
     UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"图片", nil];
    [sheet showInView:self.view];
    
    
    
    
}



-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",(int)buttonIndex);
    if (buttonIndex==0)
    {
        NSLog(@"哈哈");
        //判断是否可以打开照相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController * picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            //指定调用资源为摄像头
            [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentViewController:picker animated:YES completion:nil];
        }

        
        
    }else if (buttonIndex==1)
        
    {
        NSLog(@"嘿嘿");
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
#pragma mark - 选择完毕
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获取照相拍摄的图片
    UIImage * PhoneImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    [imageView setImage:PhoneImage];
    imageView.tag = 101;
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
