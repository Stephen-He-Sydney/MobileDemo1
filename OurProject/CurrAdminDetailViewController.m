

//
//  CurrAdminDetailViewController.m
//  OurProject
//
//  Created by StephenHe on 10/12/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "CurrAdminDetailViewController.h"

@interface CurrAdminDetailViewController ()

@end

@implementation CurrAdminDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.status = [NSString stringWithFormat:@"%ld",(long)[self.status longLongValue]];
    
    if (!self.isNotRequiredTitle)
    {
        self.navigationItem.title = [self getCurrentOrderStage:self.status];
    }
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    wealthView = [[WealthView alloc]init];
    
    cellWidth = CURRSIZE.width;
    cellHeight = (CURRSIZE.height - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.frame.size.height)/7*4;
}

-(NSString*)getCurrentOrderStage:(NSString*)currStatusTag
{
    NSArray* titles = @[@"全部订单",@"待配货",@"已配货",@"待完成",@"已完成",@"退货单"];
    int titleIndex = [currStatusTag isEqualToString:@"-1"]?0:(int)[currStatusTag integerValue];
    
    return titles[titleIndex];
}

-(void)viewWillAppear:(BOOL)animated
{
    pageIndex = 0;
    refreshingData = [[NSMutableArray alloc]init];
    
    [self loadDataToCurrPage];
}

-(void)loadDataToCurrPage
{
    //pageIndex要定义成全局变量
    
    //load data
    NSString* curServerUrl = @"order/index";
    NSString* curParamUrl = [NSString stringWithFormat:@"{\"status\":\"%@\",\"token\":\"%@\",\"storeid\":\"%@\",\"PageIndex\":\"%d\"}",self.status,self.token,self.storeID,pageIndex];
    adminDetailData = [[NSArray alloc]init];
    
    [self addloadingMark:self.view];
    [self handleServerSideInfo:curServerUrl WithParamUrl:curParamUrl];
    
    __block CurrAdminDetailViewController* adminDetailCtrl = self;
    self.jsonData = ^(NSDictionary* info)
    {
        if (info != nil)
        {
            adminDetailData = info[@"data"];
            [adminDetailCtrl createTableView];
            
            //上提下拉功能
            [adminDetailCtrl.buyInfoTableView addHeaderWithTarget:adminDetailCtrl action:@selector(dragDownRefreshing:)];
            [adminDetailCtrl.buyInfoTableView addFooterWithTarget:adminDetailCtrl action:@selector(pullUpRefreshing:)];
            
            if (refreshingData.count > 0)
            {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [adminDetailCtrl getAllImages];
    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //tableView cannot be global variable, because it is uncertain to keep it unreleased
                        [adminDetailCtrl.buyInfoTableView reloadData];
                    });
                });
            }
        }
        else
        {
            [adminDetailCtrl promptSingleButtonWarningDialog:@"当前无任何订单!"];
            [adminDetailCtrl.buyInfoTableView footerEndRefreshing];
        }
    };
}

#pragma mark - 更新对应数组的后台数据
-(void)collectAllItems
{
    if (adminDetailData.count > 0)
    {
        if (pageIndex == 0)
        {
            //下拉刷新操作(永远只加载第一页)
            [refreshingData removeAllObjects];
        }
        
        for ( int i = 0; i < adminDetailData.count; i++) {
            [refreshingData addObject:adminDetailData[i]];
        }
    }
}

#pragma mark - 下拉(表，集合)视图事件
-(void)dragDownRefreshing:(id)sender
{
    //下拉是获取第一页
    pageIndex = 0;
    [self loadDataToCurrPage];
    [self.buyInfoTableView headerEndRefreshing];
}

#pragma mark - 上拉(表，集合)视图事件
-(void)pullUpRefreshing:(id)sender
{
    //上提是获取第一页开始的后几页数据,这里page++
    pageIndex++;
    [self loadDataToCurrPage];
    [self.buyInfoTableView footerEndRefreshing];
}

-(void)getAllImages
{
    CustomHttpRequest* customRequest = [[CustomHttpRequest alloc]init];
    if ([customRequest IsCurrentWIFIReached] == YES)
    {
        imageData = [[NSMutableArray alloc]init];
      
        for (int i = 0; i < [refreshingData count]; i++) {
            NSString* imgUrl = refreshingData[i][@"OrderGoods"][0][@"goods_image"]!= (id)[NSNull null]?refreshingData[i][@"OrderGoods"][0][@"goods_image"]:@"";
            
            UIImage* currImage = [UIImage imageWithData:[customRequest fetchImageData:imgUrl]];
            if (currImage == nil)
            {
                currImage = [UIImage imageNamed:@"noimage"];
            }
            [imageData addObject:currImage];
        }
    }
}

-(void)promptSingleButtonWarningDialog:(NSString*)msg
{
    UIAlertView* warnAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    warnAlert.tag = 1;
    [warnAlert show];
}

-(void)createTableView
{
    if ([self.view.subviews containsObject:self.buyInfoTableView])
    {
        [self removeAllSubViews:self.view];
    }
    [self collectAllItems];
    
    self.buyInfoTableView = [wealthView getCurrentTableView:self.navigationController WithTabController:self.tabBarController];
    self.buyInfoTableView.delegate = self;
    self.buyInfoTableView.dataSource = self;
    
    [self.view addSubview:self.buyInfoTableView];
    
}

#pragma mark - 表视图
/* TableView */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return refreshingData.count;
}

-(BuyerInfoTableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifer = @"currCell";
    BuyerInfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell){
        cell = [[BuyerInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer
                ];
        cell.layer.borderColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1].CGColor;
        cell.layer.borderWidth = 1;
        
        [self createTableCellLayout:cell];
        
        if ([self.status isEqualToString:@"-1"]
            ||[self.status isEqualToString:@"4"])
        {
            cell.sendToClient.hidden = YES;
        }
        else
        {
            cell.sendToClient.hidden = NO;
            [cell.sendToClient setTitle:[self getCurrentButtonText] forState:UIControlStateNormal];
            
            if ([refreshingData[indexPath.row][@"order_state"] isEqualToString:@"51"])
            {
                [cell.sendToClient setTitle:@"等待配货" forState:UIControlStateNormal];
            }
            else if ([refreshingData[indexPath.row][@"order_state"] isEqualToString:@"55"])
            {
                [cell.sendToClient setTitle:@"对账中" forState:UIControlStateNormal];
            }
            
            __block BuyerInfoTableViewCell* buyerInfoCell = cell;
            __block CurrAdminDetailViewController* adminDetailCtrl = self;
            [self handleAllButtonResponse:buyerInfoCell WithCurrAdminDetailViewController:adminDetailCtrl WithCell:cell WithIndex:indexPath.row];
        }
        
    }
    if (refreshingData.count > 0)
    {
        [self displayCellData:cell WithCurrIndex:indexPath.row];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)handleAllButtonResponse:(BuyerInfoTableViewCell*) buyerInfoCell WithCurrAdminDetailViewController:(CurrAdminDetailViewController*)adminDetailCtrl WithCell:(BuyerInfoTableViewCell*)cell WithIndex:(long)index
{
    cell.sendButtonText = ^(NSString* btnText)
    {
        NSString* orderID = refreshingData[index][@"OrderGoods"][0][@"order_id"];
        serverUrl = @"order/changeOrderState";
        
        if ([btnText isEqualToString:@"发给客户"])
        {
            paramUrl = [NSString stringWithFormat:@"{\"users_id\":\"%@\",\"token\":\"%@\",\"order_id\":\"%@\",\"status\":\"51\"}",self.usersID,self.token,orderID];
            [self promptIsConfirmNextStepDialog:@"确定发送给客户?"];
            
            self.jsonData = ^(NSDictionary* info)
            {
                [buyerInfoCell.sendToClient setTitle:@"等待配货" forState:UIControlStateNormal];
            };
        }
        else if([btnText isEqualToString:@"确认发货"])
        {
            paramUrl = [NSString stringWithFormat:@"{\"users_id\":\"%@\",\"token\":\"%@\",\"order_id\":\"%@\",\"status\":\"54\"}",self.usersID,self.token,orderID];
            [self promptIsConfirmNextStepDialog:@"确定要发货?"];
            
            self.jsonData = ^(NSDictionary* info)
            {
                [adminDetailCtrl refreshCurrPage:adminDetailCtrl];
            };
        }
        else if ([btnText isEqualToString:@"我要回款"])
        {
            paramUrl = [NSString stringWithFormat:@"{\"users_id\":\"%@\",\"token\":\"%@\",\"order_id\":\"%@\",\"status\":\"55\"}",self.usersID,self.token,orderID];
            
            [self promptIsConfirmNextStepDialog:@"确定要回款?"];
            
            self.jsonData = ^(NSDictionary* info)
            {
                [buyerInfoCell.sendToClient setTitle:@"对账中" forState:UIControlStateNormal];
            };
        }
    };
}

-(void)refreshCurrPage:(CurrAdminDetailViewController*)adminDetailCtrl
{
    for (UIView* subView in adminDetailCtrl.view.subviews) {
        [subView removeFromSuperview];
    }
    
    [adminDetailCtrl loadDataToCurrPage];
}

-(void)promptIsConfirmNextStepDialog:(NSString*)msg
{
    UIAlertView* warnAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"我再看看" otherButtonTitles:@"确认无误",nil];
    
    warnAlert.tag = 4;
    [warnAlert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 4)
    {
        if (buttonIndex == 1)
        {
            [self handleServerSideInfo:serverUrl WithParamUrl:paramUrl];
        }
    }
}

-(NSString*)getCurrentButtonText
{
    NSDictionary* btnTexts = @{@"1":@"发给客户",@"2":@"确认发货",@"3":@"我要回款"};
    
    return btnTexts[self.status];
}

-(NSString*)getCurrentPurchaseStatus:(NSString*)key
{
    NSDictionary* status = @{@"10":@"待配货",@"51":@"待配货",@"52":@"已配货",@"53":@"待退款",@"54":@"待完成",@"55":@"待完成",@"56":@"已完成"};
    
    if ([status objectForKey:key])
    {
        return status[key];
    }
    return @"";
}

-(void)displayCellData:(BuyerInfoTableViewCell*)cell WithCurrIndex:(long)index
{
    cell.buyerNo.text = refreshingData[index][@"buyer_name"];
    
    if (imageData.count == refreshingData.count)
    {
        cell.mainImage.image = imageData[index];
    }
    
    cell.purchaseStatus.text = [self getCurrentPurchaseStatus:refreshingData[index][@"order_state"]];
    
    cell.productTitle.text = refreshingData[index][@"OrderGoods"][0][@"goods_name"];
    
    cell.unitPrice.text = [NSString stringWithFormat:@"￥%@",refreshingData[index][@"OrderGoods"][0][@"goods_price"]];
    
    cell.totalPrice.text =[NSString stringWithFormat:@"￥%@",refreshingData[index][@"OrderGoods"][0][@"goods_pay_price"]];
    
    cell.shopName.text = refreshingData[index][@"store_name"];
    
    cell.quantity.text = [NSString stringWithFormat:@"x%@",refreshingData[index][@"OrderGoods"][0][@"goods_num"]];
    
    cell.summaryPrice.text = [NSString stringWithFormat:@"￥%@",refreshingData[index][@"goods_amount"]];
    
    cell.purchaseTime.text = [CommFunc tranfromTime:[refreshingData[index][@"add_time"]longLongValue]];
}

-(void)createTableCellLayout:(BuyerInfoTableViewCell*) cell
{
    [cell fetchCurrCellSize:cellHeight WithWidth:cellWidth];
    
    [cell createHeaderView];
    
    [cell createMainBody];

    [cell addComponentsToMainBody];
   
    [cell addComponentsToMainFooter];
    
    [cell addButtonsToMainFooter];
    
    [cell createFooterView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailViewController* orderDetailCtrl = [[OrderDetailViewController alloc]init];
    orderDetailCtrl.orderID = refreshingData[indexPath.row][@"OrderGoods"][0][@"order_id"];
    orderDetailCtrl.token = self.token;
    
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
