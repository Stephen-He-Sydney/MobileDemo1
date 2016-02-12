//
//  SourceCollectionViewCell.m
//  OurProject
//
//  Created by ibokan on 15/10/12.
//  Copyright (c) 2015年 StephenHe. All rights reserved.
//

#import "SourceCollectionViewCell.h"
#import "SourceViewController.h"

@implementation SourceCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //设置图片展示区
        self.imageShow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height/1.4)];
        [self.imageShow.layer setBorderColor:[UIColor grayColor].CGColor];
        [self.imageShow.layer setBorderWidth:1];
        [self.imageShow setContentMode:UIViewContentModeScaleAspectFit];
        [self.contentView addSubview:self.imageShow];
        
        //设置商品名称
        _commodityName = [[UILabel alloc]initWithFrame:CGRectMake(3, self.contentView.bounds.size.height/1.35, self.contentView.bounds.size.width, self.contentView.bounds.size.height/17)];
        [_commodityName setText:@"此处是商品名称"];
        [_commodityName setFont:[UIFont boldSystemFontOfSize:self.contentView.bounds.size.height/17]];
        [self.contentView addSubview:_commodityName];
        
        //设置价格
        self.priceShow = [[UILabel alloc]initWithFrame:CGRectMake(8, self.contentView.bounds.size.height/1.15, self.contentView.bounds.size.width/2.5, self.contentView.bounds.size.height/16)];
        [self.priceShow setFont:[UIFont boldSystemFontOfSize:self.contentView.bounds.size.height/16]];
        [self.priceShow setTextColor:[UIColor redColor]];
        [self.contentView addSubview:self.priceShow];
        
        //设置添加、下架按钮
        _touchBtn = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.bounds.size.width/1.5, self.contentView.bounds.size.height/1.25, self.contentView.bounds.size.width/7, self.contentView.bounds.size.width/4.8)];
        //    [touchBtn setBackgroundColor:[UIColor colorWithRed:0.410 green:0.593 blue:1.000 alpha:1.000]];
//        [_touchBtn setImage:[UIImage imageNamed:@"wdspk_icon1"]];
        [_touchBtn setUserInteractionEnabled:YES];
        [_touchBtn setContentMode:UIViewContentModeTop];
        [self.contentView addSubview:_touchBtn];
        
        _strName = [[UILabel alloc]initWithFrame:CGRectMake(0, _touchBtn.bounds.size.height/1.55, _touchBtn.bounds.size.width, _touchBtn.bounds.size.height/3)];
//        [_strName setText:@"添加"];
        [_strName setFont:[UIFont boldSystemFontOfSize:_touchBtn.bounds.size.height/3]];
        [_strName setUserInteractionEnabled:YES];
        [_touchBtn addSubview:_strName];

    }
    
    
    
    return self;
}



@end
