//
//  SchoolRollViewController.m
//  OurProject
//
//  Created by StephenHe on 10/9/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "SchoolRollViewController.h"
#import "GlobalConstants.h"
#import "EmergencyContactViewController.h"
#import "CustomHttpRequest.h"
#import "CommFunc.h"
@interface SchoolRollViewController ()
{
    NSMutableArray * nameArr;
    NSMutableArray * messageArr;
    NSMutableArray * stayArr;
    NSMutableArray * allGroup;
    UIImageView * view;
    NSDictionary * infoDic;
    UITableViewCell * cell;
    UITableView * schoolRollView;
     UITextField * textField;
    NSMutableDictionary *param_dic;
}
@end

@implementation SchoolRollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"学籍认证(1/4)";
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
     schoolRollView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, CURRSIZE.width, CURRSIZE.height) style:UITableViewStyleGrouped];
    
    [schoolRollView setSectionFooterHeight:0];
    [schoolRollView setSectionHeaderHeight:0];

    schoolRollView.delegate = self;
    schoolRollView.dataSource = self;
    [self.view addSubview:schoolRollView];
    UIImageView * footView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CURRSIZE.width, 40)];
    [footView setUserInteractionEnabled:YES];
    [schoolRollView setTableFooterView:footView];
    UIButton * nextbBtn = [UIButton buttonWithType:UIButtonTypeSystem ];
    [nextbBtn setFrame:CGRectMake(CURRSIZE.width/10, 5,(CURRSIZE.width/10)*8, 30)] ;
    nextbBtn.layer.cornerRadius = 5;
    [nextbBtn setBackgroundColor:[UIColor colorWithRed:219/255.0 green:57/255.0 blue:33/255.0 alpha:1]];
    [nextbBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextbBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [nextbBtn setTintColor:[UIColor whiteColor]];
    //添加事件
    
    [nextbBtn addTarget:self action:@selector(footViewClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:nextbBtn];

    nameArr = [NSMutableArray arrayWithObjects:@"姓名:",@"身份证号:",nil];
    messageArr = [NSMutableArray arrayWithObjects:@"省份:",@"城市:",@"学校:",@"毕业年份:",@"学历:",@"学院:",@"专业:", nil];
    stayArr = [NSMutableArray arrayWithObjects:@"学信网帐号",@"学信网密码",@"手机号码认证",@"手机号码", nil];
    allGroup = [NSMutableArray arrayWithObjects:nameArr,messageArr,stayArr, nil];
    
}
#pragma mark - 指定分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return allGroup.count;
}
#pragma mark - 指定行数
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
//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section ==2) {
//      return @"学信网认证";
//        
//    }
//    return nil;
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CURRSIZE.width, 40)];
        [view setUserInteractionEnabled:YES];
        //[view setBackgroundColor:[UIColor yellowColor]];
        UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(CURRSIZE.width/10, 10, (CURRSIZE.width/10)*3, 20)];
        [lable setFont:[UIFont systemFontOfSize:13]];
        [lable setText:@"学信网认证"];
        [view addSubview:lable];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setFrame:CGRectMake((CURRSIZE.width/10)*3, 10, (CURRSIZE.width/10)*2, 20)];
        [button setTitle:@"帮助?" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button setTintColor:[UIColor blueColor]];
        [view addSubview:button];
        return view;

    }
    return nil;
}

#pragma mark - section头视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        return 40;
    }else if (section==1)
    {
        return 10;
    }
    return 0;
}

#pragma mark - 创建cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  //创建重用标示符
    static NSString * indexCell =@"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:indexCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indexCell];
        UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, (CURRSIZE.width/9)*2, 20)];
        lable.text = allGroup[indexPath.section][indexPath.row];
        [lable setFont:[UIFont systemFontOfSize:11]];
        [lable setTextAlignment:NSTextAlignmentRight];
        [cell.contentView addSubview:lable];
        
        textField = [[UITextField alloc]initWithFrame:CGRectMake((CURRSIZE.width/9)*2, 10, (CURRSIZE.width/9)*7, 20)];
        textField.delegate =self;
        [textField setFont:[UIFont systemFontOfSize:11]];
        [cell.contentView addSubview:textField];
        //[textField setBackgroundColor:[UIColor yellowColor]];
        switch (indexPath.section) {
            case 0:
                
               textField.tag=indexPath.row;
                break;
            case 1:
                
                textField.tag=indexPath.row+2;
                break;
            case 2:
                
                textField.tag=indexPath.row+9;
                break;
            default:
                
                textField.tag=indexPath.row+11;
                break;
        }
    }
return cell;

}

#pragma mark - nextBtn触发方法
-(void)footViewClick
{
 
    self.loginDic = [CommFunc readUserLogin];
    CustomHttpRequest * customRequest = [[CustomHttpRequest alloc]init];
    NSString * serverUrl = @"users/credit_edu";
    NSString * paramUrl = [NSString stringWithFormat:@"{\"username\":\"%@\",\"num_no\":\"%@\",\"province_id\":\"%@\",\"city_id\":\"%@\",\"school_name\":\"%@\",\"graduation_time\":\"%@\",\"school_roll_id\":\"%@\",\"school_areaname\":\"%@\",\"school_zhangye\":\"%@\",\"xueqin\":\"%@\",\"xueqinpassword\":\"%@\",\"mobile\":\"%@\",\"token\":\"%@\",\"users_id\":\"%@\",\"educational_id\":\"8\",\"school_id\":\"132\"}",param_dic[@"0"],param_dic[@"1"],param_dic[@"2"],param_dic[@"3"],param_dic[@"4"],param_dic[@"5"],param_dic[@"6"],param_dic[@"7"],param_dic[@"8"],param_dic[@"9"],param_dic[@"10"],param_dic[@"11"],self.loginDic[@"data"][@"token"],self.loginDic[@"data"][@"users_id"]];

     [customRequest fetchResponseByPost:serverUrl WithParameter:paramUrl WithResponse:^(NSDictionary *info) {
         NSDictionary * dic = [NSDictionary dictionaryWithDictionary:info];
         NSLog(@"dhfjgjh%@",dic);
        
         if ([dic[@"status"]intValue]==1) {
             
         }
         else
         {
             UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:dic[@"info"] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
             [alert show];

         }
     }];
  
}

#pragma mark-文本编辑结束的时候，把内容添加到字典中
-(void)textFieldDidEndEditing:(UITextField *)textField
    {
      [param_dic setObject:textField.text forKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]];
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
    NSLog(@"%@",textField.text);
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
