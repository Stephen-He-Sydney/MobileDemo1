
//
//  OrderViewController.m
//  OurProject
//
//  Created by StephenHe on 10/9/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "OrderViewController.h"

@interface OrderViewController ()

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"订单";
    
    orderView = [[OrderView alloc]init];
    currStatus = @[@"-1",@"1",@"2",@"3",@"4",@"5"];
    
    [self createTapArea];
    
    __block OrderViewController* orderCtrl = self;
    __block CommonViewController* commCtrl = self;
    self.isDataReady = ^()
    {
        [commCtrl removeAllSubViews:orderCtrl.tapArea];
        
        [orderCtrl createDisplayText];
        // tabBar height value can be obtain only in this method after completion of tabBar loading
    };
    
    AppDelegate* app = [[UIApplication sharedApplication]delegate];
    app.isPushedReady = ^()
    {
        NSDictionary* loginInfo = [CommFunc readUserLogin];
        
        NSString* status = [NSString stringWithFormat:@"%d",1];
        NSString* storeID = [NSString stringWithFormat:@"%ld",(long)[loginInfo[@"data"][@"Store"][0][@"id"]longLongValue]];//注意有小括号，首先是数组元素
        
        CurrAdminDetailViewController* adminDetailCtrl = [[CurrAdminDetailViewController alloc]init];
        adminDetailCtrl.token = loginInfo[@"data"][@"token"];
        adminDetailCtrl.status = status;
        adminDetailCtrl.storeID = storeID;
        
        [self.navigationController pushViewController:adminDetailCtrl animated:YES];
        
    };
}

-(void)createTapArea
{
    self.tapArea = [orderView getImageViewPanel:0.3];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapResponse:)];
    [self.tapArea addGestureRecognizer:tap];
    [self.view addSubview:self.tapArea];
}

-(void)createDisplayText
{
    for (int i = 0; i < 4; i++) {
        UILabel* field = [[UILabel alloc]initWithFrame:CGRectMake(20, 2+self.tapArea.frame.size.height*0.25*i, CURRSIZE.width, self.tapArea.frame.size.height/4)];
        
        switch (i) {
            case 0:
                field.text = [NSString stringWithFormat:@"累计收入:￥%.2f",totalRevenue];
                break;
            case 1:
                field.text = @"本月收入(元)";
                break;
            case 2:
                field.text = [NSString stringWithFormat:@"￥%.2f",currWage];
                [field setFont:[UIFont boldSystemFontOfSize:30]];
                break;
            default:
                field.text = @"客官别急,赶紧添加商品分享好友赚钱吧~";
                break;
        }
        if (i != 2)
        {
            [field setFont:[UIFont systemFontOfSize:15]];
        }
        [field setTextColor:[UIColor whiteColor]];
        [self.tapArea addSubview:field];
    }
}

-(void)createCollectionViewArea
{
    collectionButtonArea = [orderView getContentPanel:self.navigationController WithTabController:self.tabBarController];
    [self.view addSubview:collectionButtonArea];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //load data
    NSDictionary* loginInfo = [CommFunc readUserLogin];
    
    NSString* serverUrl = @"users/expWage";
    NSString* anotherUrl = @"users/wage";
    
    NSString* paramUrl = [NSString stringWithFormat:@"{\"uid\":\"%@\",\"token\":\"%@\"}",loginInfo[@"data"][@"users_id"],loginInfo[@"data"][@"token"]];
    
    totalRevenue = 0.0;
    currWage = 0.0;
    
    [self handleServerSideInfo:serverUrl WithParamUrl:paramUrl];
    
    __block  OrderViewController* orderCtrl = self;
    self.jsonData = ^(NSDictionary* info)
    {
        currWage = info[@"data"][@"amount"]? (float)[info[@"data"][@"amount"]floatValue]:0.0;
        CommonViewController* commCtrl = [[CommonViewController alloc]init];
        [commCtrl handleServerSideInfo:anotherUrl WithParamUrl:paramUrl];
        commCtrl.jsonData = ^(NSDictionary* json)
        {
            totalRevenue = json[@"data"][@"wage"]? (float)[json[@"data"][@"wage"]floatValue]:0.0;
            
            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
            
            if (orderCtrl.isDataReady != nil)
            {
                orderCtrl.isDataReady();
            }
        };
    };
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![self.view.subviews containsObject:collectionButtonArea])
    {
        [self createCollectionViewArea];
        
        [self createCollectionViews];
    }
    
    [self addloadingMark:self.view];
}

-(void)createCollectionViews
{
    btnImages = @[@"find_tb_02",@"find_tb_03",@"find_tb_04",@"find_tb_05",@"find_tb_02",@"find_tb_03"];
    btnTxts = @[@"全部订单",@"待配货",@"已配货",@"待完成",@"已完成",@"退货单"];
    btnExplan = @[@"所有订单",@"货源还没来",@"快点发货吧",@"差一点就完成了",@"搞定",@"退货"];
    
    orderCollectionView = [orderView getCollectionView:collectionButtonArea];
    orderCollectionView.delegate = self;
    orderCollectionView.dataSource = self;
    
    [collectionButtonArea addSubview:orderCollectionView];
}

#pragma mark - 集合视图
/* CollectionView */
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

-(OrderCollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    OrderCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionView" forIndexPath:indexPath];
    
    cell.layer.borderColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1].CGColor;
    cell.layer.borderWidth = 1;
    
    cell.img.image = [UIImage imageNamed:btnImages[indexPath.row]];
    cell.buttonName.text = btnTxts[indexPath.row];
    cell.buttonExplan.text = btnExplan[indexPath.row];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self redirectToOrderPage:(int)indexPath.row];
}

-(void)redirectToOrderPage:(int)currIndex
{
    //pageIndex要定义成全局变量
    //load data
    NSDictionary* loginInfo = [CommFunc readUserLogin];
    NSString* status = [NSString stringWithFormat:@"%d",(int)[currStatus[currIndex]integerValue]];
    NSString* storeID = [NSString stringWithFormat:@"%ld",(long)[loginInfo[@"data"][@"Store"][0][@"id"]longLongValue]];//注意有小括号，首先是数组元素
    
    CurrAdminDetailViewController* adminDetailCtrl = [[CurrAdminDetailViewController alloc]init];
    adminDetailCtrl.token = loginInfo[@"data"][@"token"];
    adminDetailCtrl.status = status;
    adminDetailCtrl.storeID = storeID;
    
    [self.navigationController pushViewController:adminDetailCtrl animated:YES];
}

-(void)tapResponse:(UITapGestureRecognizer*)sender
{
    WealthViewController* wealthCtrl = [[WealthViewController alloc]init];
    wealthCtrl.currWage = [NSString stringWithFormat:@"￥%.2f",currWage];
    
    [self.navigationController pushViewController:wealthCtrl animated:YES];
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
