//
//  EmergencyContactViewController.m
//  OurProject
//
//  Created by StephenHe on 10/9/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "EmergencyContactViewController.h"
#import "GlobalConstants.h"
#import "CustomHttpRequest.h"
#import "CommFunc.h"
@interface EmergencyContactViewController ()
{
    UITableView * EmergencyView;
    NSMutableArray * nameArr;
    NSMutableArray * messageArr;
    NSMutableArray * allGroup;
    UIImageView * view;
     NSMutableDictionary *param_dic;
}
@end

@implementation EmergencyContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"紧急联系方式(2/4)";
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
     param_dic=[[NSMutableDictionary alloc]init];
    
    EmergencyView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CURRSIZE.width, CURRSIZE.height) style:UITableViewStyleGrouped];
    [EmergencyView setSectionFooterHeight:0];
    [EmergencyView setSectionHeaderHeight:0];
    EmergencyView.delegate = self;
    EmergencyView.dataSource =self;
    [self.view addSubview:EmergencyView];
    //头视图
    UIImageView * headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CURRSIZE.width, 60)];
    //[headView setBackgroundColor:[UIColor yellowColor]];
    UILabel * headText = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, CURRSIZE.width, 50)];
    [headText setFont:[UIFont systemFontOfSize:11]];
    [headText setTextColor:[UIColor redColor]];
    [headText setText:@"请务必填写真实信息,如填虚假信息,被驳回后没有\n第二次申请机会!"];
    
    [headText setLineBreakMode:NSLineBreakByCharWrapping];
    [headText setNumberOfLines:2];
    
    [headView addSubview:headText];
    [EmergencyView setTableHeaderView:headView];
    //尾视图
    UIImageView * footView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CURRSIZE.width, 60)];
    [footView setUserInteractionEnabled:YES];
    
    UIButton * finishbBtn = [UIButton buttonWithType:UIButtonTypeSystem ];
    [finishbBtn setFrame:CGRectMake(CURRSIZE.width/10, 10,(CURRSIZE.width/10)*8, 30)] ;
    finishbBtn.layer.cornerRadius = 5;
    [finishbBtn setBackgroundColor:[UIColor colorWithRed:219/255.0 green:57/255.0 blue:33/255.0 alpha:1]];
    [finishbBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishbBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [finishbBtn setTintColor:[UIColor whiteColor]];
    //添加事件
    [finishbBtn addTarget:self action:@selector(finishbBtn) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:finishbBtn];
    
    
    
    [EmergencyView setTableFooterView:footView];
    
    
    
    nameArr = [NSMutableArray arrayWithObjects:@"舍友名字:",@"舍友手机号:",@"父亲姓名:",@"父亲手机:",@"母亲姓名:",@"母亲手机:",@"辅导员手机:", nil];
    messageArr =[NSMutableArray arrayWithObjects:@"QQ号:",@"微信号:", nil];
    allGroup = [NSMutableArray arrayWithObjects:nameArr,messageArr, nil];
    
}
#pragma mark - 完成按钮方法
-(void)finishbBtn
{
    self.loginDic = [CommFunc readUserLogin];
    CustomHttpRequest * customRequest = [[CustomHttpRequest alloc]init];
    NSString * serverUrl = @"users/credit_edu";
    NSString * paramUrl = [NSString stringWithFormat:@"{\"class_username\":\"%@\",\"class_moblie\":\"%@\",\"parent_username\":\"%@\",\"parent_moblie\":\"%@\",\"parent_username1\":\"%@\",\"parent_moblie1\":\"%@\",\"fdyuan\":\"%@\",\"qq\":\"%@\",\"weixin\":\"%@\",\"token\":\"%@\",\"users_id\":\"%@\"}",param_dic[@"0"],param_dic[@"1"],param_dic[@"2"],param_dic[@"3"],param_dic[@"4"],param_dic[@"5"],param_dic[@"6"],param_dic[@"7"],param_dic[@"8"],self.loginDic[@"data"][@"token"],self.loginDic[@"data"][@"users_id"]];
    [customRequest fetchResponseByPost:serverUrl WithParameter:paramUrl WithResponse:^(NSDictionary *info) {
        NSNumber *status=info[@"status"];
        view.hidden=YES;
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
    
    
    


}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [param_dic setObject:textField.text forKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]];
}


#pragma mark - 指定分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return allGroup.count;
    
}
#pragma mark - 指定每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allGroup[section]count];
    
}
#pragma mark - 指定行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
    
}
#pragma mark - section头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CURRSIZE.width, 100)];
        //[view setBackgroundColor:[UIColor yellowColor]];
        UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, CURRSIZE.width, 60)];
        [lable setFont:[UIFont systemFontOfSize:11]];
        [lable setTextColor:[UIColor redColor]];
        [lable setText:@"重点提醒:\n1.审核时不会告诉您父母分期借款的事,请您放心填好.\n2.如果提供虚假号码,直接拒绝贷款,超过两次系统直接拉黑."];
        [lable setLineBreakMode:NSLineBreakByCharWrapping];
        [lable setNumberOfLines:3];
        [view addSubview:lable];
        
    
        
 
    }
    
    return view;
}

#pragma mark - section头视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return 100;
    }
    return 0;
}


#pragma mark - 创建cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建重用标示符
    static NSString * indexCell = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indexCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indexCell];
        
        UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, (CURRSIZE.width/9)*2, 20)];
        [lable setFont:[UIFont systemFontOfSize:11]];
        [lable setTextAlignment:NSTextAlignmentRight];
        lable.text = allGroup[indexPath.section][indexPath.row];
        
        [cell.contentView addSubview:lable];
        
        UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake((CURRSIZE.width/9)*2, 10, (CURRSIZE.width/9)*7, 20)];
        textField.delegate = self;
         [textField setFont:[UIFont systemFontOfSize:11]];
        switch (indexPath.section) {
            case 0:
                
                textField.tag=indexPath.row;
                break;
            default:
              textField.tag=indexPath.row+7;
                break;
        }

        
        [cell.contentView addSubview:textField];
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
