//
//  BankAuthenViewController.m
//  OurProject
//
//  Created by StephenHe on 10/9/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "BankAuthenViewController.h"
#import "GlobalConstants.h"
#import "CustomHttpRequest.h"
#import "CommFunc.h"
@interface BankAuthenViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    NSArray * arr ;
    NSArray * textArr;
      NSMutableDictionary *param_dic;
    UITextView * joinTextView;
    UITextView * workTextView;
}

@end

@implementation BankAuthenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"银行信息验证(4/4)";
    [self.view setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]];
    param_dic=[[NSMutableDictionary alloc]init];

    UITableView * BankAuThen = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CURRSIZE.width, CURRSIZE.height) style:UITableViewStyleGrouped];
    [BankAuThen setSectionHeaderHeight:0];
    [BankAuThen setSectionFooterHeight:0];
//    UIImageView * footView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CURRSIZE.width, 50)];
//    [footView setUserInteractionEnabled:YES];
//    [BankAuThen setTableFooterView:footView];
    
    BankAuThen.dataSource =self;
    BankAuThen.delegate = self;
    
    [self.view addSubview:BankAuThen];
    arr = [NSArray arrayWithObjects:@"银行卡号:",@"支行名称:",@"绑定手机:", nil];
    
    textArr =[NSArray arrayWithObjects:@"请输入银行卡号", @"请选择开户行",@"请输入银行预留手机号",nil];
    
    
   /*
    
    UILabel * bankMessage  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CURRSIZE.width, 40)];
    [bankMessage setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]];
    [bankMessage setText:@"\n   银行信息"];
    [bankMessage setFont:[UIFont systemFontOfSize:10]];
    [bankMessage setLineBreakMode:NSLineBreakByCharWrapping];
    [bankMessage setNumberOfLines:2];
    [self.view addSubview:bankMessage];
    
    UIImageView * bankImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, CURRSIZE.width, 90)];
    [bankImage setUserInteractionEnabled:YES];
    [bankImage setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bankImage];
    
    //银行卡号
    UILabel * bankCar = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, bankImage.frame.size.width/5, 30)];
    [bankCar setText:@"银行卡号:"];
    [bankCar setFont:[UIFont systemFontOfSize:12]];
    [bankCar setTextAlignment:NSTextAlignmentRight];
    [bankImage addSubview:bankCar];
    
    UITextField *bankCarField = [[UITextField alloc]initWithFrame:CGRectMake(bankImage.frame.size.width/5, 0, bankImage.frame.size.width/5*4, 30)];
    [bankCarField setPlaceholder:@"  请输入银行卡号"];
    [bankCarField setFont:[UIFont systemFontOfSize:12]];
    [bankImage addSubview:bankCarField];
    
    //银行名称
    UILabel * bankName = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, bankImage.frame.size.width/5, 30)];
    [bankName setText:@"银行名称:"];
    [bankName setFont:[UIFont systemFontOfSize:12]];
    [bankName setTextAlignment:NSTextAlignmentRight];
    [bankImage addSubview:bankName];
    
    UITextField *bankNameField = [[UITextField alloc]initWithFrame:CGRectMake(bankImage.frame.size.width/5, 30, bankImage.frame.size.width/5*4, 30)];
    [bankNameField setPlaceholder:@"  请选择开户行"];
    [bankNameField setFont:[UIFont systemFontOfSize:12]];
    [bankImage addSubview:bankNameField];
    
    //绑定手机
    UILabel * phone = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, bankImage.frame.size.width/5, 30)];
    [phone setText:@"绑定手机:"];
    [phone setFont:[UIFont systemFontOfSize:12]];
    [phone setTextAlignment:NSTextAlignmentRight];
    [bankImage addSubview:phone];
    
    UITextField *phoneField = [[UITextField alloc]initWithFrame:CGRectMake(bankImage.frame.size.width/5, 60, bankImage.frame.size.width/5*4, 30)];
    [phoneField setPlaceholder:@"  请输入银行预留手机号"];
    [phoneField setFont:[UIFont systemFontOfSize:12]];
    [bankImage addSubview:phoneField];
    
   //加入万校网
    UILabel * joinLable  = [[UILabel alloc]initWithFrame:CGRectMake(0, 130, CURRSIZE.width, 40)];
    [joinLable setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]];
    [joinLable setText:@"\n   请在下方输入申请加入万校网的原因:"];
    [joinLable setFont:[UIFont systemFontOfSize:10]];
    [joinLable setLineBreakMode:NSLineBreakByCharWrapping];
    [joinLable setNumberOfLines:2];
    [self.view addSubview:joinLable];
    
    UIImageView * joinView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 170, CURRSIZE.width, 100)];
    [joinView setUserInteractionEnabled:YES];
    [joinView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:joinView];
    
    UITextView * joinTextView = [[UITextView alloc]initWithFrame:CGRectMake(joinView.frame.size.width/10, 5, joinView.frame.size.width/10*8, 90)];
    joinTextView.layer.cornerRadius = 5;
    joinTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
     joinTextView.layer.borderWidth = 0.5;
    [joinTextView setFont:[UIFont systemFontOfSize:12]];
    [joinView addSubview:joinTextView];
    
    //入职目标
    UILabel * workLable  = [[UILabel alloc]initWithFrame:CGRectMake(0, 270, CURRSIZE.width, 40)];
    [workLable setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]];
    [workLable setText:@"\n   请在下方输入你的入职目标:"];
    [workLable setFont:[UIFont systemFontOfSize:10]];
    [workLable setLineBreakMode:NSLineBreakByCharWrapping];
    [workLable setNumberOfLines:2];
    [self.view addSubview:workLable];

    UIImageView * workView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 310, CURRSIZE.width, 140)];
    [workView setUserInteractionEnabled:YES];
    [workView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:workView];
    
    UITextView * workTextView = [[UITextView alloc]initWithFrame:CGRectMake(workView.frame.size.width/10, 5, workView.frame.size.width/10*8, 90)];
    
    workTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    workTextView.layer.borderWidth = 0.5;
    workTextView.layer.cornerRadius = 5;
    [workTextView setFont:[UIFont systemFontOfSize:12]];
    [workView addSubview:workTextView];

    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [submitBtn setFrame:CGRectMake(workView.frame.size.width/8,105 ,(workView.frame.size.width/8)*6, 30)] ;
    submitBtn.layer.cornerRadius = 5;
    [submitBtn setBackgroundColor:[UIColor colorWithRed:219/255.0 green:57/255.0 blue:33/255.0 alpha:1]];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [submitBtn setTintColor:[UIColor whiteColor]];
    [workView addSubview:submitBtn];
    
    
*/
}






#pragma mark - 指定分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;

}
#pragma mark - 指定行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;

}

#pragma mark - 指定cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section==0) {
        return 120;
      
    }else if (indexPath.section ==1)

    {
        return 100;
        
    }else if (indexPath.section==2)
    {
        
        return 150;
        
        
    }
    return 0;
    
}
#pragma mark -section头视图
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    if (section==0) {
        return @"银行信息";
    }else if (section==1)
    {
    return @"请在下方输入申请加入万校网的原因:";
    
    }else if (section==2)
    {
    return @"请在下方输入你的入职目标:";
    
    
    }
    return nil;
}



#pragma mark -创建cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString * IndexCell= @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:IndexCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IndexCell];
        
        if (indexPath.section==0) {
            int sum = 0;
            for (int i =0; i<arr.count; i++) {
                UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width/15, sum, cell.frame.size.width/15*3, 40)];
               
                //[lable setBackgroundColor:[UIColor yellowColor]];
                lable.text = arr[i];
                [lable setFont:[UIFont systemFontOfSize:12]];
                [cell.contentView addSubview:lable];
                UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(cell.frame.size.width/15*4, sum, cell.frame.size.width/15*10, 40)];
                textField.tag = i;
                textField.delegate =self;
                [textField setPlaceholder:textArr[i]];
                [textField setFont:[UIFont systemFontOfSize:12]];
                //[textField setBackgroundColor:[UIColor redColor]];
                [cell.contentView addSubview:textField];
                
                 sum=sum+40;
                
            }
   
        }else if (indexPath.section==1)
        {
         
             joinTextView = [[UITextView alloc]initWithFrame:CGRectMake(cell.frame.size.width/20, 5, cell.frame.size.width/20*18, 90)];
            joinTextView.delegate = self;
            joinTextView.layer.cornerRadius = 5;
            joinTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            joinTextView.layer.borderWidth = 0.5;
            [joinTextView setFont:[UIFont systemFontOfSize:12]];
            [cell.contentView addSubview:joinTextView];
        
        
        }else if (indexPath.section==2)
        {
        
             workTextView = [[UITextView alloc]initWithFrame:CGRectMake(cell.frame.size.width/20, 5, cell.frame.size.width/20*18, 90)];
            workTextView.delegate= self;
            workTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            workTextView.layer.borderWidth = 0.5;
            workTextView.layer.cornerRadius = 5;
            [workTextView setFont:[UIFont systemFontOfSize:12]];
            [cell.contentView addSubview:workTextView];
            
            
            UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            [submitBtn setFrame:CGRectMake(cell.frame.size.width/10,105 ,(cell.frame.size.width/10)*8, 30)] ;
            submitBtn.layer.cornerRadius = 5;
            [submitBtn setBackgroundColor:[UIColor colorWithRed:219/255.0 green:57/255.0 blue:33/255.0 alpha:1]];
            [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
            [submitBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [submitBtn setTintColor:[UIColor whiteColor]];
            //添加事件
            [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:submitBtn];
   
    
        }

        
    }

    return cell;

}
#pragma mark -提交方法
-(void)submitBtnClick
{
    NSLog(@"你好");
    
    
    if (![param_dic[@"0"] isEqualToString:@""]&&![param_dic[@"1"] isEqualToString:@""]&&![param_dic[@"2"] isEqualToString:@""]&&![joinTextView.text isEqualToString:@""]&&[workTextView.text isEqualToString:@""]&&[param_dic count]!=0) {
        self.loginDic = [CommFunc readUserLogin];
        
        CustomHttpRequest * customRequest = [[CustomHttpRequest alloc]init];
        NSString * serverUrl = @"users/credit_BandCard";
        NSString * paramUrl = [NSString stringWithFormat:@"{\"band_numno\":\"%@\",\"band_name\":\"%@\",\"band_mobile\":\"%@\",\"reason\":\"%@\",\"content\":\"%@\",\"token\":\"%@\",\"users_id\":\"%@\",\"educational_id\":\"8\",\"school_id\":\"132\"}",param_dic[@"0"],param_dic[@"1"],param_dic[@"2"],joinTextView.text,workTextView.text,self.loginDic[@"data"][@"token"],self.loginDic[@"data"][@"users_id"]];
        [customRequest fetchResponseByPost:serverUrl WithParameter:paramUrl WithResponse:^(NSDictionary *info) {
            NSNumber *status=info[@"status"];
            
            if (status.intValue==1) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:info[@"info"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                
            }
            else
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:info[@"info"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"取消", nil];
                [alert show];
                
                
            }
            
            
        }];
        
    
        
    }else
    {
        if ([param_dic[@"0"] isEqualToString:@""]) {
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"银行卡不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
        }
        else if ([param_dic[@"1"] isEqualToString:@""])
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"支行名称不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
        }
        else if ([param_dic[@"2"] isEqualToString:@""])
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"绑定手机不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        else if ([param_dic count]==0)
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"信息不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }

    
    
    }
    
    
    


}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [param_dic setObject:textField.text forKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]];
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
