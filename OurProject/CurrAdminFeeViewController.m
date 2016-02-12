//
//  CurrAdminFeeViewController.m
//  OurProject
//
//  Created by StephenHe on 10/9/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "CurrAdminFeeViewController.h"

@interface CurrAdminFeeViewController ()

@end

@implementation CurrAdminFeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"管理费";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    orderView = [[OrderView alloc]init];
    wealthView = [[WealthView alloc]init];
    
    [self createStatisticsArea];
    
    [self createContentView];
    
    [self loadDataToCurrPage];
}

-(void)loadDataToCurrPage
{
    //load data
    self.loginInfo = [CommFunc readUserLogin];

    NSString* serverUrl = @"users/subWage2";
    NSString* paramUrl = [NSString stringWithFormat:@"{\"uid\":\"%@\",\"token\":\"%@\"}",self.loginInfo[@"data"][@"users_id"],self.loginInfo[@"data"][@"token"]];
    adminData = [[NSArray alloc]init];
    total = 0;
    
    [self addloadingMark:self.view];
    [self handleServerSideInfo:serverUrl WithParamUrl:paramUrl];
    
    __block CurrAdminFeeViewController* adminFeeCtrl = self;
    self.jsonData = ^(NSDictionary* info)
    {
        adminData = info[@"data"][@"teamItem"];
        
        if (adminData.count > 0)
        {
            total = (float)[info[@"data"][@"teamTotal"] floatValue];
            [adminFeeCtrl createTableView];
        }
        else
        {
            [adminFeeCtrl promptSingleButtonWarningDialog:@"暂无管理团队!"];
        }
    };
}

-(void)promptSingleButtonWarningDialog:(NSString*)msg
{
    UIAlertView* warnAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    warnAlert.tag = 1;
    [warnAlert show];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    for (int i = 0; i < 2; i++) {
        UILabel* leftCol = [[UILabel alloc]initWithFrame:CGRectMake(10, 7+40*i, 140, 30)];
        UILabel* rightCol = [[UILabel alloc]initWithFrame:CGRectMake(10+140, 7+40*i, 140, 30)];
        [leftCol setTextColor:[UIColor whiteColor]];
        [rightCol setTextColor:[UIColor whiteColor]];
        
        if (i == 0)
        {
            leftCol.text = self.loginInfo[@"mobile"];
            rightCol.text = [NSString stringWithFormat:@"总额:￥%.2f",total];
        }
        else
        {
            leftCol.text = [NSString stringWithFormat:@"工资:%@",self.currWage];
            rightCol.text = [NSString stringWithFormat:@"提成:￥%.2f",total*0.3];
        }
        [statisticsArea addSubview:leftCol];
        [statisticsArea addSubview:rightCol];
    }
}

-(void)createStatisticsArea
{
    statisticsArea = [orderView getImageViewPanel:0.16];
    [self.view addSubview:statisticsArea];
}

-(void)createContentView
{
    tableViewArea = [orderView getContentPanel:self.navigationController WithTabController:self.tabBarController];
    
    [self.view addSubview:tableViewArea];
}

-(void)createTableView
{
    adminTableView = [wealthView getCurrentTableView:tableViewArea];
    adminTableView.delegate = self;
    adminTableView.dataSource = self;
    
    [tableViewArea addSubview:adminTableView];
}

#pragma mark - 表视图
/* TableView */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return adminData.count;
}

-(CurrAdminTableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifer = @"currCell";
    CurrAdminTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell){
        cell = [[CurrAdminTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer
                ];
        
        cell.layer.borderColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1].CGColor;
        cell.layer.borderWidth = 1;
        
        cell.staffNo.text = adminData[indexPath.row][@"uid"];
        cell.staffName.text = adminData[indexPath.row][@"name"] == (id)[NSNull null]?@"":adminData[indexPath.row][@"name"];
        
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableViewArea.frame.size.height/5;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSString* serverUrl = @"users/index";
    NSString* paramUrl = [NSString stringWithFormat:@"{\"uid\":\"%@\",\"token\":\"%@\"}",adminData[indexPath.row][@"uid"],self.loginInfo[@"data"][@"token"]];
 
    [self handleServerSideInfo:serverUrl WithParamUrl:paramUrl];
    
    __block CurrAdminFeeViewController* adminFeeCtrl = self;
    self.jsonData = ^(NSDictionary* info)
    {
        if (info[@"data"][@"Store"] != (id)[NSNull null])
        {
            CurrAdminDetailViewController* adminDetailCtrl = [[CurrAdminDetailViewController alloc]init];
            adminDetailCtrl.token = adminFeeCtrl.loginInfo[@"data"][@"token"];
            adminDetailCtrl.status = @"4";//info[@"status"];
            adminDetailCtrl.storeID = info[@"data"][@"Store"][@"id"];
            adminDetailCtrl.isNotRequiredTitle = YES;
            adminDetailCtrl.usersID = adminFeeCtrl.loginInfo[@"data"][@"users_id"];
          
            [adminFeeCtrl.navigationController pushViewController:adminDetailCtrl animated:YES];
        }
        else
        {
            [adminFeeCtrl promptSingleButtonWarningDialog:@"此人还未开店!"];
        }
    
    };
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
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
