//
//  WealthViewController.m
//  OurProject
//
//  Created by StephenHe on 10/9/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "WealthViewController.h"

@interface WealthViewController ()

@end

@implementation WealthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"财富";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    orderView = [[OrderView alloc]init];
    wealthView = [[WealthView alloc]init];
    
    [self createDisplayRevenueArea];
    
    [self createContentView];
    
    [self createCollectionViews];
    
    [self createTableViewArea];
    
    [self loadDataToCurrPage];
}

-(void)loadDataToCurrPage
{
    //load data
    loginInfo = [CommFunc readUserLogin];
    
    NSString* serverUrl = @"users/ownWage2";
    NSString* paramUrl = [NSString stringWithFormat:@"{\"uid\":\"%@\",\"token\":\"%@\"}",loginInfo[@"data"][@"users_id"],loginInfo[@"data"][@"token"]];
    orderData = [[NSArray alloc]init];
    
    [self addloadingMark:self.view];
    [self handleServerSideInfo:serverUrl WithParamUrl:paramUrl];
        
    __block WealthViewController* wealthCtrl = self;
    self.jsonData = ^(NSDictionary* info)
    {
        orderData = info[@"data"];
        [wealthCtrl createTableView];
    };
}

-(void)promptSingleButtonWarningDialog:(NSString*)msg
{
    UIAlertView* warnAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    warnAlert.tag = 1;
    [warnAlert show];
}

-(void)createDisplayRevenueArea
{
    UIImageView* disPlayArea = [orderView getImageViewPanel:0.16];
    
    for (int i = 0; i < 2; i++) {
        UILabel* field = [[UILabel alloc]initWithFrame:CGRectMake(15,7+40*i,CURRSIZE.width - 20,30)];
        if (i == 0)
        {
            field.text = @"本月收入(元)";
            [field setFont:[UIFont systemFontOfSize:15]];
        }
        else
        {
            field.text = self.currWage;
            [field setFont:[UIFont boldSystemFontOfSize:30]];
        }
        [field setTextColor:[UIColor whiteColor]];
        [disPlayArea addSubview:field];
    }
    
    [self.view addSubview:disPlayArea];
}

-(void)createContentView
{
    mainArea = [orderView getContentPanel:self.navigationController WithTabController:self.tabBarController];
    
    [self.view addSubview:mainArea];
}

-(void)createCollectionViews
{
    btnImages = @[@"home_tb_04",@"wd_icon_7",@"bankother"];
    btnTxts = @[@"订单",@"管理费",@"推荐奖"];
    
    wealthCollectionView = [wealthView getCollectionView];
    wealthCollectionView.delegate = self;
    wealthCollectionView.dataSource = self;
    
    [mainArea addSubview:wealthCollectionView];
}

-(void)createTableViewArea
{
    tableViewArea = [[UIView alloc]initWithFrame:CGRectMake(0, CURRSIZE.width/3-1, CURRSIZE.width, mainArea.frame.size.height - CURRSIZE.width/3)];
    
    [mainArea addSubview:tableViewArea];
}

#pragma mark - 集合视图
/* CollectionView */
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

-(WealthCollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WealthCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionView" forIndexPath:indexPath];
    
    cell.layer.borderColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1].CGColor;
    cell.layer.borderWidth = 1;
    
    cell.btnImage.image = [UIImage imageNamed:btnImages[indexPath.row]];
    cell.buttonName.text = btnTxts[indexPath.row];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
    {
        CurrAdminFeeViewController* adminCtrl = [[CurrAdminFeeViewController alloc]init];
        adminCtrl.currWage = self.currWage;
        
        [self.navigationController pushViewController:adminCtrl animated:YES];
    }
    else if (indexPath.row == 2)
    {
        RecomPrizeViewController* prizeCtrl = [[RecomPrizeViewController alloc]init];
        [self.navigationController pushViewController:prizeCtrl animated:YES];
    }
}

-(void)createTableView
{
    wealthTableView = [wealthView getCurrentTableView:tableViewArea];
    wealthTableView.delegate = self;
    wealthTableView.dataSource = self;
    [wealthTableView setBackgroundColor:[UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1]];
    
    [tableViewArea addSubview:wealthTableView];
}

#pragma mark - 表视图
/* TableView */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return orderData.count;
}

-(WealthTableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifer = @"currCell";
    WealthTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell){
        cell = [[WealthTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer
                ];
        
        cell.orderNo.text = orderData[indexPath.row][@"order_sn"]== (id)[NSNull null]?@"":orderData[indexPath.row][@"order_sn"];
        
        cell.orderAmount.text = orderData[indexPath.row][@"commis_rate"]== (id)[NSNull null]?@"":orderData[indexPath.row][@"commis_rate"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableViewArea.frame.size.height/5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailViewController* orderDetailCtrl = [[OrderDetailViewController alloc]init];
    orderDetailCtrl.orderID = orderData[indexPath.row][@"order_id"];
    orderDetailCtrl.token = loginInfo[@"data"][@"token"];
    
    [self.navigationController pushViewController:orderDetailCtrl animated:YES];
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
