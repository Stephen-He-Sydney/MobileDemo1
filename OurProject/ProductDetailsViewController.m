//
//  ProductDetailsViewController.m
//  OurProject
//
//  Created by ibokan on 15/10/14.
//  Copyright (c) 2015年 StephenHe. All rights reserved.
//

#import "ProductDetailsViewController.h"
#import "CommodityInfoViewLayout.h"
#import "CheckDetailViewController.h"
#import "UMSocial.h"
#import "SourceViewController.h"
#import "CommonViewController.h"
#import "CustomHttpRequest.h"
#import "MBProgressHUD.h"

@interface ProductDetailsViewController ()
{
    UIImage *goodsImage;
    NSMutableArray *addGoodsToLocal;
    NSString *isInStoreInfo;
}
@property(strong,nonatomic)MBProgressHUD *hud;
@end

@implementation ProductDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"商品详情"];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    
}
#pragma mark - 各个按钮的功能块
-(void)buttonAction:(UITapGestureRecognizer *)sender
{
    switch (sender.view.tag) {
        case 100:
        {
            
            if ([_touchBtnName.text isEqualToString:@"下架"]) {
                [self goodsSoldOut];
                [_touchBtn setImage:[UIImage imageNamed:@"wdspk_icon1"]];
                [_touchBtnName setText:@"上架"];
                
                
            }
            else{
                [_touchBtn setImage:[UIImage imageNamed:@"wdspk_icon"]];
                [_touchBtnName setText:@"下架"];
                [self goodsPutaway];
            }
            
        }
            break;
        case 101:
        {
            CheckDetailViewController *commityView = [[CheckDetailViewController alloc]init];
            commityView.URLString = self.goodsInfo[@"goods_info"][@"goods_body"];
            [self.navigationController pushViewController:commityView animated:YES];
        }
            break;
        case 102:
        {
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:@"507fcab25270157b37000010"
                                              shareText:[NSString stringWithFormat:@"http://112.74.105.205/zhizu/index.php?s=/Mobile1/Goods/show/id/%@.html&StoreID=%@",self.goodsID,self.storeID]
                                             shareImage:[UIImage imageNamed:@"icon.png"]
                                        shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,nil]
                                               delegate:self];
        }
            break;
    }
    
}
#pragma mark - 获取商品信息
-(void)getGoodsInfoData
{
    NSString* curServerUrl = @"goods/detail";
    NSString* curParamUrl = [NSString stringWithFormat:@"{\"goodsId\":\"%@\",\"token\":\"%@\",\"Storeid\":\"%@\"}",self.goodsID,self.token,self.storeID];
    
    CommonViewController *commonView = [[CommonViewController alloc]init];
    [commonView handleServerSideInfo:curServerUrl WithParamUrl:curParamUrl];
    commonView.jsonData = ^(NSDictionary* info)
    {
        if (info != nil)
        {
            //展示你的数据
            self.goodsInfo = info[@"data"];
            [self.hud show:YES];
            CustomHttpRequest *customRequest = [[CustomHttpRequest alloc]init];
            if ([customRequest IsCurrentWIFIReached] == YES)
            {
                
                [customRequest fetchImageDataAsync:info[@"data"][@"goods_images"][0]WithResponse:^(NSData *info) {
                    buttonsArray = [CommodityInfoViewLayout setCommodityInfo:self andDoodsInfo:self.goodsInfo andImage:[UIImage imageWithData:info]];
                }];
            }
            
            //关闭小菊花
            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
            [self.hud hide:YES];
        }
        else
        {
            [self promptSingleButtonWarningDialog:@"店铺暂无该商品!"];
        }
    };
}

-(void)promptSingleButtonWarningDialog:(NSString*)msg
{
    UIAlertView* warnAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    warnAlert.tag = 1;
    [warnAlert show];
}
#pragma mark - 上架的数据请求
-(void)goodsPutaway
{
    CustomHttpRequest* httpRequest = [[CustomHttpRequest alloc]init];
    NSString* serverUrl = @"Store/addgoods";
    NSString* paramUrl = [NSString stringWithFormat:@"{\"token\":\"%@\",\"store_goods\":[{\"store_id\":\"%@\",\"goods_id\":\"%@\"}]}",self.token,self.storeID,self.goodsID];
    
    [httpRequest fetchResponseByPost:serverUrl WithParameter:paramUrl WithResponse:^(NSDictionary *info) {
        if ([info objectForKey:@"fail"])
        {
            [self promptSingleButtonWarningDialog:@"网络不给力，请稍候"];
        }
        else
        {
            if (info[@"data"]!= (id)[NSNull null])
            {
                UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:info[@"info"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [aler show];

            }
           
        }
        
    }];
    
}

#pragma mark - 下架的数据请求
-(void)goodsSoldOut
{
    CustomHttpRequest* httpRequest = [[CustomHttpRequest alloc]init];
    
    NSString* serverUrl = @"Store/removeSingleGoods";
    NSString* paramUrl = [NSString stringWithFormat:@"{\"token\":\"%@\",\"store_id\":\"%@\",\"goods_id\":\"%@\"}",self.token,self.storeID,self.goodsID];
    [httpRequest fetchResponseByPost:serverUrl WithParameter:paramUrl WithResponse:^(NSDictionary *info) {
        if ([info objectForKey:@"fail"])
        {
            [self promptSingleButtonWarningDialog:@"网络不给力，请稍候"];
        }
        else
        {
            if (info[@"data"]!= (id)[NSNull null])
            {
                UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:info[@"info"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [aler show];

            }
           
        }
        
    }];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    addGoodsToLocal = [[NSMutableArray alloc]init];
    NSUserDefaults *myStoreGoods = [NSUserDefaults standardUserDefaults];
    addGoodsToLocal = [myStoreGoods objectForKey:@"MyStoreGoods"];
    [self getGoodsInfoData];
}
-(void)viewWillLayoutSubviews
{
    //获取按钮
    
    _touchBtn = buttonsArray[0];
    _touchBtnName = buttonsArray[1];
    _checkInfo = buttonsArray[2];
    _shareBtn = buttonsArray[3];
    //利用手势实现按钮功能
    UITapGestureRecognizer *buttonAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonAction:)];
    
    [_touchBtn addGestureRecognizer:buttonAction];
    buttonAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonAction:)];
    [_checkInfo addGestureRecognizer:buttonAction];
    buttonAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonAction:)];
    [_shareBtn addGestureRecognizer:buttonAction];
    
    
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
