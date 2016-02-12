//
//  QRCodeViewController.m
//  OurProject
//
//  Created by StephenHe on 10/9/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "QRCodeViewController.h"
#import "GlobalConstants.h"
#import "SchoolRollViewController.h"
#import "EmergencyContactViewController.h"
#import "CertificateViewController.h"
#import "BankAuthenViewController.h"
@interface QRCodeViewController ()
{
    NSMutableArray * imageViewArr;
    NSMutableArray * textArr;
    
    NSMutableArray * imageViewArr1;
    NSMutableArray * textArr1;
    
    NSMutableArray * imageViewArr2;
    NSMutableArray * textArr2;
    
    NSMutableArray * imageViewArr3;
    NSMutableArray * textArr3;
    NSMutableArray * allImageGroupArr;
    NSMutableArray * allTextGroupArr;
}
@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"信用认证";
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    UITableView * creditAuView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CURRSIZE.width, CURRSIZE.height) style:UITableViewStyleGrouped];
    
    [creditAuView setSectionFooterHeight:10];
    [creditAuView setSectionHeaderHeight:0];
    
    creditAuView.delegate = self;
    creditAuView.dataSource = self;
    [self.view addSubview:creditAuView];
    
    UIImageView * headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CURRSIZE.width, 40)];
    //[headView setBackgroundColor:[UIColor lightGrayColor]];
    [creditAuView setTableHeaderView:headView];
    UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(CURRSIZE.width/3, 10, CURRSIZE.width/3, 20)];
    //[lable setBackgroundColor:[UIColor yellowColor]];
    [lable setText:@"您未完成认证"];
    [lable setFont:[UIFont systemFontOfSize:11]];
    [lable  setTextAlignment:NSTextAlignmentCenter];
    [lable setTextColor:[UIColor orangeColor]];
    [headView addSubview:lable];
    UIImageView * footView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CURRSIZE.width, 30)];
    //[footView setBackgroundColor:[UIColor yellowColor]];
    [creditAuView setTableFooterView:footView];
    
    UILabel * footText = [[UILabel alloc]initWithFrame:CGRectMake(CURRSIZE.width/5, 0, (CURRSIZE.width/5)*3, 30)];
    [footText setText:@"nihao"];
    [footText setFont:[UIFont systemFontOfSize:11]];
    [footText setTextAlignment:NSTextAlignmentCenter];
    [footText setTextColor:[UIColor orangeColor]];
    [footView addSubview:footText];
    
    
    imageViewArr = [NSMutableArray arrayWithObjects:@"authentication_student", nil];
    textArr = [NSMutableArray arrayWithObjects:@"学籍认证", nil];
    
    imageViewArr1 = [NSMutableArray arrayWithObjects:@"authentication_phone", nil];
    textArr1 = [NSMutableArray arrayWithObjects:@"紧急联系方式", nil];
    
    imageViewArr2 = [NSMutableArray arrayWithObjects:@"authentication_paper", nil];
    textArr2 = [NSMutableArray arrayWithObjects:@"证件照", nil];
    
    imageViewArr3 =[NSMutableArray arrayWithObjects:@"authentication_bank", nil];
    textArr3 = [NSMutableArray arrayWithObjects:@"银行卡认证", nil];
    
    allImageGroupArr = [NSMutableArray arrayWithObjects:imageViewArr,imageViewArr1,imageViewArr2,imageViewArr3, nil];
    allTextGroupArr = [NSMutableArray arrayWithObjects:textArr,textArr1,textArr2,textArr3 ,nil];
    
}

#pragma mark - 指定分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return allTextGroupArr.count;
    
}
#pragma mark - 指定每组的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allTextGroupArr[section]count];
    
}
#pragma mark - 指定行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
#pragma mark - 创建cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建重用标识符
    static NSString * cellIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
    }
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    [imageView setImage:[UIImage imageNamed:allImageGroupArr[indexPath.section][indexPath.row]]];
    [cell addSubview:imageView];
    
    UILabel * textLable = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 150, 30)];
    textLable.text = allTextGroupArr[indexPath.section][indexPath.row ];
    [cell addSubview:textLable];
    
    UILabel * finishLable = [[UILabel alloc]initWithFrame:CGRectMake((CURRSIZE.width/10)*8, 20, CURRSIZE.width/10, 10)];
    [finishLable setFont:[UIFont systemFontOfSize:10]];
    [finishLable setText:@"未完成"];
    [cell addSubview:finishLable];
    
    UIImageView * boultView = [[UIImageView alloc]initWithFrame:CGRectMake((CURRSIZE.width/10)*9, 20, 10, 10)];
    [boultView setImage:[UIImage imageNamed:@"bz_tbjt"]];
    [cell addSubview:boultView];

    return cell;
}

#pragma mark - 选中执行的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            SchoolRollViewController * schoolR = [[SchoolRollViewController alloc]init];
            [self.tabBarController.tabBar setHidden:YES];
            [self.navigationController pushViewController:schoolR animated:YES];
            
        }
            break;
        case 1:
        {
            EmergencyContactViewController * emergency = [[EmergencyContactViewController alloc]init];
            [self.navigationController.tabBarController.tabBar setHidden:YES];
            [self.navigationController pushViewController:emergency animated:YES];
        
        }
            break;
            case 2:
        {
            CertificateViewController * certificate = [[CertificateViewController alloc]init];
            [self.tabBarController.tabBar setHidden:YES];
            [self.navigationController pushViewController:certificate animated:YES];
        }
            break;
        case 3:
        {
            BankAuthenViewController * bankAuthen = [[BankAuthenViewController alloc]init];
            [self.tabBarController.tabBar setHidden:YES];
            [self.navigationController pushViewController:bankAuthen animated:YES];
        }
            break;
    }
    
    
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
