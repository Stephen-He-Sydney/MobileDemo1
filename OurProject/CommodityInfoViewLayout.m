//
//  CommodityInfoViewLayout.m
//  OurProject
//
//  Created by ibokan on 15/10/13.
//  Copyright (c) 2015年 StephenHe. All rights reserved.
//

#import "CommodityInfoViewLayout.h"
#import "GlobalConstants.h"

@implementation CommodityInfoViewLayout

#pragma mark - 设置商品详情布局
+(NSMutableArray *)setCommodityInfo:(UIViewController *)myController andDoodsInfo:(NSMutableDictionary *)goodsInfo andImage:(UIImage *)goodsImage
{
   
    //把按钮返回出去实现功能
     NSMutableArray *buttonArray = [[NSMutableArray alloc]init];
    
    //图片展示
    UIImageView *commodityImage = [[UIImageView alloc]initWithFrame:CGRectMake((CURRSIZE.width-CURRSIZE.width/1.2)/2, 0, CURRSIZE.width/1.2, CURRSIZE.height/2.5)];
    [commodityImage setImage:goodsImage];
    
    [commodityImage setContentMode:UIViewContentModeScaleAspectFit];
    [myController.view addSubview:commodityImage];
    
    
    
    //文字区
    UILabel *commodityName = [[UILabel alloc]initWithFrame:CGRectMake(3, CURRSIZE.height/2.2, CURRSIZE.width, CURRSIZE.height/40)];
    [commodityName setText:[NSString stringWithFormat:@"%@",goodsInfo[@"goods_info"][@"goods_name"]]];
    [commodityName setFont:[UIFont boldSystemFontOfSize:CURRSIZE.height/50]];
    [myController.view addSubview:commodityName];
    
    NSString *commodityPrice = goodsInfo[@"goods_info"][@"goods_price"];
    UILabel *priceShow = [[UILabel alloc]initWithFrame:CGRectMake(CURRSIZE.width/20, CURRSIZE.height/2.05, CURRSIZE.width/2, CURRSIZE.height/30)];
    [priceShow setText:[NSString stringWithFormat:@"￥%@",commodityPrice]];
    [priceShow setFont:[UIFont boldSystemFontOfSize:CURRSIZE.height/35]];
    [priceShow setTextColor:[UIColor redColor]];
    [myController.view addSubview:priceShow];
    
    UILabel *commissionPrice = [[UILabel alloc]initWithFrame:CGRectMake(myController.view.bounds.size.width/2.8, myController.view.bounds.size.height/1.86, CURRSIZE.width/2, CURRSIZE.height/30)];
    [commissionPrice setText:[NSString stringWithFormat:@"佣金:%@",commodityPrice]];
    [commissionPrice setTextColor:[UIColor redColor]];
    [commissionPrice setFont:[UIFont boldSystemFontOfSize:CURRSIZE.height/50]];
    [myController.view addSubview:commissionPrice];
    
    //添加、下架按钮
    UIImageView *touchBtn = [[UIImageView alloc]initWithFrame:CGRectMake(myController.view.bounds.size.width/1.2, myController.view.bounds.size.height/1.87, myController.view.bounds.size.width/12, myController.view.bounds.size.width/9.5)];
//        [touchBtn setBackgroundColor:[UIColor colorWithRed:0.410 green:0.593 blue:1.000 alpha:1.000]];
    
    [touchBtn setUserInteractionEnabled:YES];
    [touchBtn setContentMode:UIViewContentModeTop];
    [touchBtn setTag:100];
    [myController.view addSubview:touchBtn];
    //存入数组
    [buttonArray addObject:touchBtn];
    
    UILabel *strName = [[UILabel alloc]initWithFrame:CGRectMake(0, touchBtn.bounds.size.height/1.55, touchBtn.bounds.size.width, touchBtn.bounds.size.height/3)];
    
    [strName setTextAlignment:NSTextAlignmentCenter];
    [strName setFont:[UIFont boldSystemFontOfSize:touchBtn.bounds.size.height/3.5]];
    [strName setUserInteractionEnabled:YES];
    [touchBtn addSubview:strName];
    //存入数组
    [buttonArray addObject:strName];
    
    //检索该商品是否加入店铺
    NSString *isInStore = goodsInfo[@"isInStore"];
    if ([isInStore intValue] == 0) {
        [touchBtn setImage:[UIImage imageNamed:@"wdspk_icon1"]];
        [strName setText:@"上架"];
    }
    else {
        [touchBtn setImage:[UIImage imageNamed:@"wdspk_icon"]];
        [strName setText:@"下架"];
    }

    //信息介绍
    UILabel *commodityInfo = [[UILabel alloc]initWithFrame:CGRectMake(3, myController.view.bounds.size.height/1.65, myController.view.bounds.size.width, myController.view.bounds.size.height/30)];
    [commodityInfo setText:[NSString stringWithFormat:@"%@",goodsInfo[@"goods_info"][@"goods_jingle"]]];
    [commodityInfo setFont:[UIFont boldSystemFontOfSize:myController.view.bounds.size.height/40]];
    [myController.view addSubview:commodityInfo];
    
    //信息详情按钮
    UILabel *checkInfo = [[UILabel alloc]initWithFrame:CGRectMake(myController.view.bounds.size.width/20, myController.view.bounds.size.height/1.55, myController.view.bounds.size.width/3, myController.view.bounds.size.height/30)];
    [checkInfo setText:@"查看详情"];
    [checkInfo setTextColor:[UIColor redColor]];
    [checkInfo setFont:[UIFont boldSystemFontOfSize:myController.view.bounds.size.height/50]];
    [checkInfo setTag:101];
    [checkInfo setUserInteractionEnabled:YES];
    [myController.view addSubview:checkInfo];
    //存入数组
    [buttonArray addObject:checkInfo];
    
    //分享按钮
    UILabel *shareInfo = [[UILabel alloc]initWithFrame:CGRectMake(0, myController.view.bounds.size.height/1.4, myController.view.bounds.size.width, myController.view.bounds.size.height/20)];
    [shareInfo setBackgroundColor:[UIColor colorWithRed:0.914 green:0.216 blue:0.122 alpha:1.000]];
    [shareInfo setText:@"分享"];
    [shareInfo setTextAlignment:NSTextAlignmentCenter];
    [shareInfo setTextColor:[UIColor whiteColor]];
    [shareInfo setTag:102];
    [shareInfo setUserInteractionEnabled:YES];
    [myController.view addSubview:shareInfo];
    //存入数组
    [buttonArray addObject:shareInfo];
   
    
    return buttonArray;

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
