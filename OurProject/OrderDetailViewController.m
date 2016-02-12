

//
//  OrderDetailViewController.m
//  OurProject
//
//  Created by StephenHe on 10/16/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "OrderDetailViewController.h"

@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"订单详情";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self loadDataToCurrPage];
}

-(void)loadDataToCurrPage
{
    NSString* curServerUrl = @"order/show_orderid";
    NSString* curParamUrl = [NSString stringWithFormat:@"{\"token\":\"%@\",\"order_id\":\"%@\"}",self.token,self.orderID];
    
    orderDetailData = [[NSDictionary alloc]init];
    
    [self addloadingMark:self.view];
    [self handleServerSideInfo:curServerUrl WithParamUrl:curParamUrl];
    
    __block OrderDetailViewController* orderDetailCtrl = self;
    self.jsonData = ^(NSDictionary* info)
    {
        orderDetailData = info[@"data"];

        [orderDetailCtrl createTableView];
        
        CustomHttpRequest* customRequest = [[CustomHttpRequest alloc]init];
        if ([customRequest IsCurrentWIFIReached] == YES)
        {
            if (info[@"data"][@"OrderGoods"][0][@"goods_image"] != (id)[NSNull null])
            {
                [customRequest fetchImageDataAsync:info[@"data"][@"OrderGoods"][0][@"goods_image"] WithResponse:^(NSData *info) {
                    
                    productImage = info;
                    [orderDetailCtrl.orderDetailTableView reloadData];
                }];
            }
        }
    };
}
    
-(void)createTableView
{
    WealthView* wealthView = [[WealthView alloc]init];
    self.orderDetailTableView = [wealthView getGroupedTableView:self.navigationController WithTabController:self.tabBarController];
    self.orderDetailTableView.delegate = self;
    self.orderDetailTableView.dataSource = self;
    
    cellHeight = 100.0f;
  
    secondSectionTxts =
  @[[NSString stringWithFormat:@"收货人:%@",orderDetailData[@"OrderCommon"][@"reciver_name"]],
   [NSString stringWithFormat:@"联系电话:%@",orderDetailData[@"buyer_name"]],
   [NSString stringWithFormat:@"地址:%@",orderDetailData[@"OrderCommon"][@"reciver_info"]]];
    
    NSString* addTime = [CommFunc tranfromTime:[orderDetailData[@"add_time"]longLongValue]];
    
    thirdSectionTxts =
  @[[NSString stringWithFormat:@"订单编号:%@",orderDetailData[@"order_sn"]],
    [NSString stringWithFormat:@"下单时间:%@",addTime],
    [NSString stringWithFormat:@"快递单号:%@",orderDetailData[@"shipping_code"]],
    @"运费:用户评论后可免邮费",
    [NSString stringWithFormat:@"店铺名称:%@",orderDetailData[@"store_name"]]];
    
    [self.view addSubview:self.orderDetailTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [orderDetailData[@"OrderGoods"] count];
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 5;
            break;
        default:
            break;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            static NSString* cellIdentifer = @"currCell1";
            OrderDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
            if (!cell)
            {
                cell = [[OrderDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer
                        ];
                
                [cell setCurrCellSize:cellHeight WithWidth:CURRSIZE.width];
                
                [cell createProfileLayout];
                [cell createProductInfo];
                //[cell createArrowImageLayout];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                cell.productTitle.text = orderDetailData[@"OrderGoods"][indexPath.row][@"goods_name"];
                cell.salePrice.text = orderDetailData[@"OrderGoods"][indexPath.row][@"goods_price"];
                cell.revenue.text = orderDetailData[@"OrderGoods"][indexPath.row][@"goods_pay_price"];
                cell.quantity.text = orderDetailData[@"OrderGoods"][indexPath.row][@"goods_num"];
            }
            if (productImage != nil)
            {
                cell.productImage.image = [UIImage imageWithData:productImage];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            break;
        }
        case 1:
        {
            static NSString* cellIdentifer = @"currCell2";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
            if (!cell)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer
                        ];
                
                cell.textLabel.text = [NSString stringWithFormat:@"%@",secondSectionTxts[indexPath.row]];
                
                [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
            }
            return cell;
            break;
        }
        case 2:
        {
            static NSString* cellIdentifer = @"currCell3";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
            if (!cell)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer
                        ];
                
                cell.textLabel.text = [NSString stringWithFormat:@"%@",thirdSectionTxts[indexPath.row]];
                [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
            }
            return cell;
            break;
        }
        default:
            return nil;
            break;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return cellHeight;
    }
    else
    {
        return 40.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    long section = indexPath.section;
 
    if (section == 0)
    {
        NSDictionary* loginInfo = [CommFunc readUserLogin];

        ProductDetailsViewController* productDetail = [[ProductDetailsViewController alloc]init];
        productDetail.goodsID = orderDetailData[@"OrderGoods"][0][@"goods_id"];
        productDetail.token = loginInfo[@"data"][@"token"];
        productDetail.storeID = orderDetailData[@"OrderCommon"][@"store_id"];
        
        [self.navigationController pushViewController:productDetail animated:YES];
    };
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 1.0f;
    return 25.0f;
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
