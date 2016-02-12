//
//  SetStoreViewLayout.m
//  OurProject
//
//  Created by ibokan on 15/10/13.
//  Copyright (c) 2015年 StephenHe. All rights reserved.
//

#import "SetStoreViewLayout.h"

@implementation SetStoreViewLayout

#pragma mark - 设置头像
+(UIImageView *)setHeadViewLayout:(UIViewController *)myController andImage:(UIImage *)image andStoreName:(NSString *)name
{
    UIImageView *headBackgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, myController.view.bounds.size.width, myController.view.bounds.size.height/4)];
    [headBackgroundView setBackgroundColor:[UIColor colorWithRed:0.945 green:0.192 blue:0.114 alpha:1.000]];
    [headBackgroundView setUserInteractionEnabled:YES];
    [myController.view addSubview:headBackgroundView];
    //头像
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(headBackgroundView.bounds.size.width/5*2, headBackgroundView.bounds.size.height/5,headBackgroundView.bounds.size.width/5,headBackgroundView.bounds.size.width/5)];
    [headImage setBackgroundColor:[UIColor whiteColor]];
    [headImage setContentMode:UIViewContentModeScaleAspectFit];
    if (image == nil) {
        [headImage setImage:[UIImage imageNamed:@"dpzs_icon10"]];
    }else [headImage setImage:image];
    
    [headImage.layer setCornerRadius:headBackgroundView.bounds.size.width/10];
    [headBackgroundView addSubview:headImage];
    
    UILabel *storeName = [[UILabel alloc]initWithFrame:CGRectMake(headBackgroundView.bounds.size.width/10, headBackgroundView.bounds.size.height/5*3.8, headBackgroundView.bounds.size.width/1.25, headBackgroundView.bounds.size.height/10)];
    [storeName setText:[NSString stringWithFormat:@"前往 %@ 的店",name]];
    [storeName setTextAlignment:NSTextAlignmentCenter];
    [storeName setTextColor:[UIColor whiteColor]];
    [headBackgroundView addSubview:storeName];
    
    
    return headBackgroundView;
}
#pragma mark - 设置店铺按钮
+(NSMutableArray *)setStoreButtons:(UIViewController *)myController
{
    NSMutableArray *buttonsArray = [[NSMutableArray alloc]init];
    
    UIImageView *buttonBackgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, myController.view.bounds.size.height/4, myController.view.bounds.size.width, myController.view.bounds.size.height/17)];
//    [buttonBackgroundView setBackgroundColor:[UIColor colorWithWhite:0.836 alpha:1.000]];
    [buttonBackgroundView setUserInteractionEnabled:YES];
    [myController.view addSubview:buttonBackgroundView];
    
    [buttonsArray addObject:buttonBackgroundView];
    //设置按钮
    NSArray *buttonName = [NSArray arrayWithObjects:@"最新",@"销量",@"收藏",@"佣金",nil];
    for (int i = 0; i < 4; ++i) {
        UILabel *button = [[UILabel alloc]initWithFrame:CGRectMake(buttonBackgroundView.bounds.size.width/4*i, buttonBackgroundView.bounds.size.height/3.3, buttonBackgroundView.bounds.size.width/4, buttonBackgroundView.bounds.size.height/2)];
        [button setText:[NSString stringWithFormat:@"%@",buttonName[i]]];
        [button setTextAlignment:NSTextAlignmentCenter];
        [button setTag:i];
        [button setUserInteractionEnabled:YES];
        [buttonBackgroundView addSubview:button];
        [buttonsArray addObject:button];
        
    }
    
    return buttonsArray;//把按钮返回去设置按钮功能
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
