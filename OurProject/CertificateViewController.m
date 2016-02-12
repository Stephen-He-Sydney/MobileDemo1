//
//  CertificateViewController.m
//  OurProject
//
//  Created by StephenHe on 10/9/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "CertificateViewController.h"
#import "GlobalConstants.h"
#import "PhotoUploadViewController.h"

#import "UploadPhoto.h"
#import "PhotoUploadViewController.h"
#import "CustomHttpRequest.h"
#import "CommFunc.h"
@interface CertificateViewController ()<UITableViewDelegate,UITableViewDataSource>
{
   
     NSString * str;
    NSUserDefaults * userDefa;
}
@end

@implementation CertificateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"认证证件(3/4)";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    userDefa = [NSUserDefaults standardUserDefaults];
    
    UITableView *CertificateView = [[UITableView alloc]initWithFrame:CGRectMake(0, -30, CURRSIZE.width, CURRSIZE.height) style:UITableViewStyleGrouped];
    [CertificateView setSectionHeaderHeight:0];
    [CertificateView setSectionFooterHeight:0];
    //尾视图
    UIImageView * footView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CURRSIZE.width, 30)];
    [footView setUserInteractionEnabled:YES];
    [CertificateView setTableFooterView:footView];
    UIButton * finishBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [finishBtn setFrame:CGRectMake(0, 0, CURRSIZE.width, 30)];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTintColor:[UIColor blueColor]];
    [finishBtn setBackgroundColor:[UIColor colorWithRed:219/255.0 green:57/255.0 blue:33/255.0 alpha:1]];
        //添加事件
    [finishBtn addTarget:self action:@selector(finishBtn) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:finishBtn];

    CertificateView.delegate =self;
    CertificateView.dataSource =self;
    [self.view addSubview:CertificateView];
    

}

#pragma  mark - 设置分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
#pragma mark -设置每组的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
#pragma mark - 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
#pragma mark - 设置section头视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
#pragma mark -设置section头视图文字
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return @"身份证正面照  身份证反面照";
    }else if (section==1)
    {
     return @"学生证正面照片  手持学生证正面照";
    }
    return nil;

}


#pragma mark - 创建cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString * indexCell = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indexCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indexCell];
        
        UIImageView * builtView = [[UIImageView alloc]initWithFrame:CGRectMake((CURRSIZE.width/9)*8.2, 45, 10, 10)];
        [builtView setImage:[UIImage imageNamed:@"bz_tbjt"]];
        [cell.contentView addSubview:builtView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    
    return cell;
}

#pragma mark - 完成按钮方法
-(void)finishBtn
{
 
    [self SendContent];
 

}

-(void)SendContent
{    self.loginDic = [CommFunc readUserLogin];
    NSURL * url1 = [NSURL URLWithString:[userDefa objectForKey:@"IDzhengMian"]];
    NSURL * url2 = [NSURL URLWithString:[userDefa objectForKey:@"IDfanMian"]];
    NSURL * url3 = [NSURL URLWithString:[userDefa objectForKey:@"zhengMian"]];
    NSURL * url4 = [NSURL URLWithString:[userDefa objectForKey:@"fanMian"]];
    
    if (![url1 isEqual:[NSNull null] ]&&![url2 isEqual:[NSNull null]]&&![url3 isEqual:[NSNull null]]&&![url4 isEqual:[NSNull null]]) {
      
        CustomHttpRequest * customRequest = [[CustomHttpRequest alloc]init];
        NSString * serverUrl = @"users/credit_credentials";
        NSString * paramUrl = [NSString stringWithFormat:@"{\"users_id\":\"%@\",\"id_card_up\":\"%@\",\"id_card_down\":\"%@\",\"student_card\":\"%@\",\"student_recode\":\"%@\",\"token\":\"%@\"}",self.loginDic[@"data"][@"users_id"],url1,url2,url3,url4,self.loginDic[@"data"][@"token"]];
        
        [customRequest fetchResponseByPost:serverUrl WithParameter:paramUrl WithResponse:^(NSDictionary *info) {
            NSNumber *status=info[@"status"];
            
            if (status.intValue==1) {
                
            }
            else
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:info[@"info"] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
                [alert show];
                
                
                
            }
        }];
        

        
        
        
    }
    
    
   
    
}

#pragma mark - 选中cell的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoUploadViewController * photoUp = [[PhotoUploadViewController alloc]init];
    photoUp.number = (int)indexPath.section;
    
    [self.navigationController pushViewController:photoUp animated:YES];
    
    
    
    


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
