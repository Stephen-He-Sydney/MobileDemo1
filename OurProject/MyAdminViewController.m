//
//  MyAdminViewController.m
//  OurProject
//
//  Created by StephenHe on 10/9/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "MyAdminViewController.h"
#import "GlobalConstants.h"
#import "MyTableViewCell.h"
#import "ChangeNickNameViewController.h"
#import "AdminFeeViewController.h"
#import "QRCodeViewController.h"
#import "CreditAuthenViewController.h"
#import "MemberNotifViewController.h"
#import "CurrAdminFeeViewController.h"
#import "LoginViewController.h"
#import "CustomHttpRequest.h"
#import "CommFunc.h"
#import "CommonViewController.h"

@interface MyAdminViewController ()
{
    UITableView * myAdminView;
   ;
    NSDictionary * infoDic;
    NSString * str;
    NSMutableString * strView;
    NSURL * imageUrl;
    NSData * imageData;
  
}
@end

@implementation MyAdminViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的";
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    myAdminView = [[UITableView alloc]initWithFrame:CGRectMake(0, -18,CURRSIZE.width, CURRSIZE.height) style:UITableViewStyleGrouped];
    //设置cell之间的间距
    [myAdminView setSectionFooterHeight:15];
    [myAdminView setSectionHeaderHeight:0];
    //尾视图
    UIImageView * footView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CURRSIZE.width, 50)];
    [footView setBackgroundColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1]];
    [footView setUserInteractionEnabled:YES];
    [myAdminView setTableFooterView:footView];
    //注销button
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelBtn setFrame:CGRectMake(20, 10, CURRSIZE.width-40, 30)];
    [cancelBtn setTitle:@"注销" forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    cancelBtn.layer.cornerRadius = 4;
    cancelBtn.layer.masksToBounds = YES;
    [cancelBtn setBackgroundColor:[UIColor colorWithRed:227/255.0 green:53/255.0 blue:36/255.0 alpha:0.9]];
    [cancelBtn setTintColor:[UIColor whiteColor]];
    //添加事件
    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:cancelBtn];
    myAdminView.delegate =self;
    myAdminView.dataSource = self;
     [self.view addSubview:myAdminView];
    

    
    
    
    
    
    
    
    
    
}
#pragma mark -指定分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;

}
#pragma mark - 指定行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    if (section==0) {
        return 1;
    }else if (section==1)
    {
        return 3;
    }else if (section==2)
    {
        return 1;
    
    }
    return 0;

}
#pragma mark - 指定单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;

}

#pragma mark - 创建cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString * cellIdentifier = @"cell";
    MyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MyTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    if (indexPath.section==0) {
        cell.boultView.image = [UIImage imageNamed:@"bz_tbjt"];
        cell.nameLable.text =str;
        cell.headView.image=[UIImage imageWithData:imageData];
        
        
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
             cell.boultView.image = [UIImage imageNamed:@"bz_tbjt"];
            cell.nameLable.text = @"我的团队";
            cell.headView.image = [UIImage imageNamed:@"xx_list_icon_5"];
        }else if (indexPath.row==1)
        {
            cell.boultView.image = [UIImage imageNamed:@"bz_tbjt"];
            cell.nameLable.text = @"店铺二维码查看";
            cell.headView.image = [UIImage imageNamed:@"tg_tb_bc_12"];
        
        }else if (indexPath.row==2)
        {
            cell.boultView.image = [UIImage imageNamed:@"bz_tbjt"];
            cell.nameLable.text = @"个人认证";
            cell.headView.image = [UIImage imageNamed:@"qd_zc"];
        
        }
        
    }else if (indexPath.section==2)
    {
        cell.nameLable.text =@"接收通知";
        cell.headView.image = [UIImage imageNamed:@"xx_list_icon_2"];
    }
    
    //cell.headView .image = [UIImage imageNamed:allImage[indexPath.section][indexPath.row]];
    return cell;
}

#pragma mark - 选中单元格cell执行的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        ChangeNickNameViewController * changeName = [[ChangeNickNameViewController alloc]init];
        [self.tabBarController.tabBar setHidden:YES];
        [self.navigationController pushViewController:changeName animated:YES];
  
    }else if (indexPath.section==1)
    {
        if(indexPath.row==0){
            CurrAdminFeeViewController * adminFee = [[CurrAdminFeeViewController alloc]init];
            [self.tabBarController.tabBar setHidden:YES];
            [self.navigationController pushViewController:adminFee animated:YES];
        }else if (indexPath.row==1){
            CreditAuthenViewController * Credit = [[CreditAuthenViewController alloc]init];
            [self.tabBarController.tabBar setHidden:YES];
            [self.navigationController pushViewController:Credit animated:YES];
        }else if (indexPath.row==2){
            
            QRCodeViewController * QRcode = [[QRCodeViewController alloc]init];
            [self.tabBarController.tabBar setHidden:YES];
            [self.navigationController pushViewController:QRcode animated:YES];

        }
            
    
    }else if (indexPath.section==2){
        MemberNotifViewController * memBerNotif = [[MemberNotifViewController alloc]init];
        [self.tabBarController.tabBar setHidden:YES];
        [self.navigationController pushViewController:memBerNotif animated:YES];
    }
        
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    self.loginDic = [CommFunc readUserLogin];
    NSLog(@"%@",self.loginDic);

    CustomHttpRequest * customRequest = [[CustomHttpRequest alloc]init];
    NSString * serverUrl = @"users/index";
    NSString * paramUrl = [NSString stringWithFormat:@"{\"token\":\"%@\",\"uid\":\"%@\"}",self.loginDic[@"data"][@"token"],self.loginDic[@"data"][@"users_id"]];
    
    [customRequest fetchResponseByPost:serverUrl WithParameter:paramUrl WithResponse:^(NSDictionary *info) {
        
        if ([info objectForKey:@"fail"])
        {
            //[self promptSingleButtonWarningDialog:@"网络不给力,请稍候"];
            
        }
        else
            
        {
            if (info[@"data"]!= (id)[NSNull null])
            {
                infoDic = [NSDictionary dictionaryWithDictionary:info];
                NSLog(@"%@",infoDic);
                if ([infoDic[@"data"][@"nickname"]isEqual:[NSNull null]]) {
                    str = @"暂无昵称";
                }else{
                    str = infoDic[@"data"][@"nickname"];}
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    if ([infoDic[@"data"][@"headPic"]isEqualToString:@""]) {
                        
                    }else {
                        
                        NSURL * imageURL = [NSURL URLWithString:infoDic[@"data"][@"headPic"]];
                        imageData = [NSData dataWithContentsOfURL:imageURL];
                        
                        NSLog(@"aaaaaaaa%@",imageData);
                    }
                    
                    
                    {
                        
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            
                            [myAdminView reloadData];
                            
                        });
                        
                    }
                    
                });
                
            }
        }
        
        
    }];
    

    
    
    
    
}

#pragma mark - 注销方法
-(void)cancelBtnAction:(id)sender
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isLogined"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    
    LoginViewController* loginCtrl = [[LoginViewController alloc]init];
    loginCtrl.isHiddenBackBtn = YES;
    
    [self.navigationController pushViewController:loginCtrl animated:YES];
    
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
