//
//  AdminFeeViewController.m
//  OurProject
//
//  Created by StephenHe on 10/9/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "AdminFeeViewController.h"
#import "GlobalConstants.h"
@interface AdminFeeViewController ()

@end

@implementation AdminFeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"管理费";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UITableView * adminFee = [[UITableView alloc]initWithFrame:CGRectMake(0, 150, CURRSIZE.width, CURRSIZE.height) style:UITableViewStylePlain];
    adminFee.delegate = self;
    adminFee.dataSource = self;
    [self.view addSubview:adminFee];
    UIImageView * headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CURRSIZE.width, 150)];
    [headView setBackgroundColor:[UIColor colorWithRed:227/255.0 green:47/255.0 blue:28/255.0 alpha:1]];
    [self.view addSubview:headView];
    
    UILabel * IDlable = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, CURRSIZE.width-210, 30)];
    [IDlable setText:@"13645825"];
    [IDlable setFont:[UIFont systemFontOfSize:15]];
    [IDlable setTextColor:[UIColor whiteColor]];
    //[IDlable setBackgroundColor:[UIColor orangeColor]];
    [headView addSubview:IDlable];
    
    UILabel * rentalLable = [[UILabel alloc]initWithFrame:CGRectMake(CURRSIZE.width-180, 30, CURRSIZE.width-190, 30)];
    rentalLable.text = [NSString stringWithFormat:@"总额:%d",0];
    [rentalLable setTextColor:[UIColor whiteColor]];
    [rentalLable setFont:[UIFont systemFontOfSize:15]];
    //[rentalLable setBackgroundColor:[UIColor orangeColor]];
    [headView addSubview:rentalLable];
    
    UILabel * salaryLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, CURRSIZE.width-200, 30)];
    [salaryLable setFont:[UIFont systemFontOfSize:15]];
    //[salaryLable setBackgroundColor:[UIColor orangeColor]];
    [salaryLable setTextColor:[UIColor whiteColor]];
    salaryLable.text = [NSString stringWithFormat:@"工资:%d",0];
    [headView addSubview:salaryLable];
    
    UILabel * royaltiesLable = [[UILabel alloc]initWithFrame:CGRectMake(CURRSIZE.width-170, 80, CURRSIZE.width-180, 30)];
    //[royaltiesLable setBackgroundColor:[UIColor orangeColor]];
    [royaltiesLable setFont:[UIFont systemFontOfSize:15]];
    royaltiesLable.text = [NSString stringWithFormat:@"提成%d",0];
    [royaltiesLable setTextColor:[UIColor whiteColor]];
    [headView addSubview:royaltiesLable];
}
#pragma mark - 指定行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;

}
#pragma mark - 指定行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
#pragma mark - 创建cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 //创建重用标示符
    static NSString * cellIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
       
    }
     return cell;
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
