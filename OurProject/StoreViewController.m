//
//  StoreViewController.m
//  OurProject
//
//  Created by StephenHe on 10/9/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "StoreViewController.h"
#import "SetStoreViewLayout.h"
#import "StoreTableViewCell.h"
#import "PreviewViewController.h"
#import "SetSourceViewLayout.h"
#import "ProductDetailsViewController.h"
#import "CommoditySearchViewController.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "CreateStoreViewController.h"
#import "CustomHttpRequest.h"
#import "CommFunc.h"
#import "CommonViewController.h"
#import "MBProgressHUD.h"

@interface StoreViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *buttonsInfoArray;
    CustomHttpRequest *customRequest;
    NSString *storeID;
    NSString *storeName;
    //存储图片
    NSMutableArray *storeImageData;
    NSMutableDictionary *saveAllImages;
    //存储数据
    NSMutableArray *storeInfoArr;
}
@property(strong,nonatomic)UIImageView *headView;
@property(strong,nonatomic)UIImageView *buttonBackgroundView;
@property(strong,nonatomic)UIImageView *scrollBar;//滚动条
@property(strong,nonatomic)UITableView *storeTableView;
@property(strong,nonatomic)UILabel *buttonLB;//按钮
@property(strong,nonatomic)NSDictionary *loginInfo;
@property(strong,nonatomic)NSMutableArray *goodsAllInfoArr;
@property(strong,nonatomic)MBProgressHUD *hud;
@end

static int loadStoreTime = 0;
static int loadHeadTime = 0;
@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"店铺";
    storeID = 0;

    self.loginInfo = [CommFunc readUserLogin];//获取登录信息
    self.goodsAllInfoArr = [[NSMutableArray alloc]init];
    [self.hud show:YES];
    

}
#pragma mark - 设置头部区域
-(void)setStoreHeadArea
{
    //搜索按钮
    UIBarButtonItem *seekBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(seekBtnAction:)];
    [seekBtn setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = seekBtn;
    //设置头像区域的tap

    customRequest = [[CustomHttpRequest alloc]init];
    if ([customRequest IsCurrentWIFIReached] == YES)
    {
        
        [customRequest fetchImageDataAsync:self.loginInfo[@"data"][@"headPic"] WithResponse:^(NSData *info) {
            _headView = [SetStoreViewLayout setHeadViewLayout:self andImage:[UIImage imageWithData:info] andStoreName:storeName];
            UITapGestureRecognizer *henadTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toStorePreview:)];
            [_headView addGestureRecognizer:henadTap];
            
        }];
    }
}
-(void)toStorePreview:(id)sender
{
    PreviewViewController *storePreview = [[PreviewViewController alloc]init];
//    self.hidesBottomBarWhenPushed = YES;//隐藏标签栏
    [storePreview setHidesBottomBarWhenPushed:YES];
    storePreview.storeID = storeID;
    [self.navigationController pushViewController:storePreview animated:YES];
//    self.hidesBottomBarWhenPushed = NO;//显示标签栏
    
}

#pragma mark - 店铺搜索按钮的功能设置
-(void)seekBtnAction:(id)sender
{
    CommoditySearchViewController *commoditySearch = [[CommoditySearchViewController alloc]init];
    commoditySearch.storeID = storeID;
    commoditySearch.token = self.loginInfo[@"data"][@"token"];
    [self.navigationController pushViewController:commoditySearch animated:YES];
    
}
#pragma mark - 设置按钮及其功能
-(void)setButtons
{
    
    //接收按钮的信息，接收货源定义的滚动条设置
    buttonsInfoArray = [SetStoreViewLayout setStoreButtons:self];
    _buttonBackgroundView = buttonsInfoArray[0];
    _scrollBar = [SetSourceViewLayout setScrollBar:_buttonBackgroundView andLehgth:self.view.bounds.size.width/4];
    [_scrollBar setBackgroundColor:[UIColor colorWithRed:0.961 green:0.525 blue:0.039 alpha:1.000]];
    //按钮添加手势
    for (int i = 1; i < 5; ++i) {
        UITapGestureRecognizer *buttonTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonAction:)];
        [buttonsInfoArray[i] addGestureRecognizer:buttonTap];
    }
    
}
-(void)buttonAction:(UITapGestureRecognizer *)sender
{
    self.goodsAllInfoArr = [[NSMutableArray alloc]init];
    storeImageData = [[NSMutableArray alloc]init];
    [self.storeTableView reloadData];
    [self.hud show:YES];
    //利用tag的值，获取点击的tag值，从而进行位置的偏移
    [UIView animateWithDuration:0.2 animations:^{
        [self.scrollBar setFrame:CGRectMake(self.view.bounds.size.width/4*sender.view.tag, _buttonBackgroundView.bounds.size.height-3, self.view.bounds.size.width/4, 3)];
    }];
    if (sender.view.tag > 0) {
        [self getStoreGoodsData:sender.view.tag];
    }
    else [self getStoreGoodsData:4];

}
#pragma mark - 设置tableView
-(void)setTableView
{
    _storeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height/3.2, self.view.bounds.size.width, self.view.bounds.size.height/1.53) style:UITableViewStylePlain];
    [_storeTableView setDataSource:self];
    [_storeTableView setDelegate:self];
    [self.view addSubview:_storeTableView];
//    [_storeTableView addHeaderWithTarget:self action:@selector(updateTableView:)];
    
}
//设置行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.goodsAllInfoArr count];
}
//设置tableViewCell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    StoreTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!tableCell) {
        tableCell = [[StoreTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    tableCell.commodityImage.image = nil;

    if (storeImageData.count == self.goodsAllInfoArr.count) {
        [tableCell.commodityImage setImage:storeImageData[indexPath.row]];
    }
    if (self.goodsAllInfoArr.count > 0)
    {
        [tableCell.goodsName setText:self.goodsAllInfoArr[indexPath.row][@"goods_name"]];
        [tableCell.goodsPrice setText:self.goodsAllInfoArr[indexPath.row][@"goods_price"]];
        [tableCell.storage setText:self.goodsAllInfoArr[indexPath.row][@"goods_storage"]];
        [tableCell.sales setText:self.goodsAllInfoArr[indexPath.row][@"goods_salenum"]];
    }
    
    return tableCell;
    
}
//设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.bounds.size.width/4;
    
}
//设置尾视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}
//设置选中时执行的动作
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailsViewController *commodityView = [[ProductDetailsViewController alloc]init];
    commodityView.token = self.loginInfo[@"data"][@"token"];
    commodityView.storeID = storeID;
    commodityView.goodsID = self.goodsAllInfoArr[indexPath.row][@"goods_id"];
    [self.navigationController pushViewController:commodityView animated:YES];
    loadStoreTime --;
}
//-(void)updateTableView:(id)sender
//{
//    //关闭下拉效果
//    [_storeTableView headerEndRefreshing];
//    //数据重载
//    [_storeTableView reloadData];
//}
//#pragma mark - 店铺未开通
-(void)goToCreatStore
{
    UIImageView *goToStoreView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/4, self.view.bounds.size.height/2.5, self.view.bounds.size.width/2, self.view.bounds.size.height/4)];
    [goToStoreView setContentMode:UIViewContentModeScaleAspectFit];
    [goToStoreView setImage:[UIImage imageNamed:@"qin"]];
    [self.view addSubview:goToStoreView];
    
    UILabel *goToCreatBtn = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/4, self.view.bounds.size.height/1.5, self.view.bounds.size.width/2, self.view.bounds.size.height/25)];
    [goToCreatBtn setBackgroundColor:[UIColor colorWithRed:0.906 green:0.118 blue:0.071 alpha:1.000]];
    [goToCreatBtn setText:@"开通店铺"];
    [goToCreatBtn setTextAlignment:NSTextAlignmentCenter];
    [goToCreatBtn setTextColor:[UIColor whiteColor]];
    [goToCreatBtn setFont:[UIFont boldSystemFontOfSize:self.view.bounds.size.height/35]];
    [goToCreatBtn setUserInteractionEnabled:YES];
    [self.view addSubview:goToCreatBtn];
    
    UITapGestureRecognizer *tapGoto = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToCreatStoreAction)];
    [goToCreatBtn addGestureRecognizer:tapGoto];
    
}
-(void)goToCreatStoreAction
{
    CreateStoreViewController *creatStore = [[CreateStoreViewController alloc]init];
    [self.navigationController pushViewController:creatStore animated:YES];
    loadStoreTime --;
}
#pragma mark - 获取店铺商品排序
-(void)getStoreGoodsData:(long)order_field
{
    int pageIndex;
    NSString* serverUrl = @"Store/showStore";
    NSString* paramUrl = [NSString stringWithFormat:@"{\"token\":\"%@\",\"storeid\":\"%@\",\"order_field\":\"%ld\",\"pageIndex\":\"%d\"}",self.loginInfo[@"data"][@"token"],storeID,order_field,pageIndex];
    CommonViewController* commCtrl = [[CommonViewController alloc]init];
    [commCtrl handleServerSideInfo:serverUrl WithParamUrl:paramUrl];
    
    commCtrl.jsonData = ^(NSDictionary* info)
    {
        if (info != nil) {
            self.goodsAllInfoArr = info[@"data"];
            [self setTableView];
            [self.hud hide:YES];
            
            if (self.goodsAllInfoArr.count > 0)
            {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [self getStoreGoodsImages];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.storeTableView reloadData];
                        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                    });
                });
            }

        }
    };

}
#pragma mark - 获取店铺信息
-(void)getStoreInfoData
{
     CustomHttpRequest* httpRequest = [[CustomHttpRequest alloc]init];
    NSString* serverUrl = @"Store/userStore";
    NSString* paramUrl = [NSString stringWithFormat:@"{\"token\":\"%@\",\"uid\":\"%@\"}",self.loginInfo[@"data"][@"token"],self.loginInfo[@"data"][@"users_id"]];
    
    [httpRequest fetchResponseByPost:serverUrl WithParameter:paramUrl WithResponse:^(NSDictionary *info) {
        if ([info objectForKey:@"fail"])
        {
            [self promptSingleButtonWarningDialog:@"网络不给力，请稍候"];
        }
        else
        {
            if ((int)[info[@"status"]integerValue] != 1)
            {
                CommonViewController *commonView = [[CommonViewController alloc]init];
                [commonView promptDoubleButtonRedirectDialog:@"您账号已在其他地方登录!"];
            }
             else if(([info[@"data"] isKindOfClass:[NSArray class]]||[info[@"data"] isKindOfClass:[NSDictionary class]]))
            {
                storeID = info[@"data"][@"id"];
                storeName = info[@"data"][@"name"];
                [self setStoreHeadArea];//设置头部区域
                [self setTableView];//自定义方法,设置tableView
                
                [self getStoreGoodsData:4];

            }
             else{
                 [self setStoreHeadArea];//设置头部区域
                 [self goToCreatStore];
             }

        }
    }];
    
}

#pragma mark - 用户认证状态
-(void)userApprove
{
    NSString* serverUrl = @"users/checkCredit";
    NSString* paramUrl = [NSString stringWithFormat:@"{\"token\":\"%@\",\"users_id\":\"%@\"}",self.loginInfo[@"data"][@"token"],self.loginInfo[@"data"][@"users_id"]];
    
    CommonViewController* commCtrl = [[CommonViewController alloc]init];
    [commCtrl handleServerSideInfo:serverUrl WithParamUrl:paramUrl];
    
    commCtrl.jsonData = ^(NSDictionary* info)
    {
        if (info != nil) {
            NSLog(@"%@",info[@"info"]);
        }
        
    };
    
}


-(void)promptSingleButtonWarningDialog:(NSString*)msg
{
    UIAlertView* warnAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    warnAlert.tag = 1;
    [warnAlert show];
}
#pragma mark - 获取图盘信息
-(void)getStoreGoodsImages
{
    customRequest = [[CustomHttpRequest alloc]init];
    if ([customRequest IsCurrentWIFIReached] == YES)
    {
        if (self.goodsAllInfoArr != nil) {
            storeImageData = [[NSMutableArray alloc]init];
            for (int i = 0; i < [self.goodsAllInfoArr count]; i++) {
                NSString* imgUrl = self.goodsAllInfoArr[i][@"goods_image_url"]!= (id)[NSNull null]?self.goodsAllInfoArr[i][@"goods_image_url"]:@"";
                UIImage* currImage = [UIImage imageWithData:[customRequest fetchImageData:imgUrl]];
                if (currImage == nil)
                {
                    currImage = [UIImage imageNamed:@"noimage"];
                }
                [storeImageData addObject:currImage];
            }
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    if (loadStoreTime < 1) {
        if (loadHeadTime < 1) {
            [self getStoreInfoData];//获取店铺id
            [self setButtons];//自定义方法，设置按钮及其功能
            loadHeadTime ++;
            loadHeadTime ++;
        }
        else {
            [self getStoreInfoData];//获取店铺id
            loadStoreTime ++;
        }
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
