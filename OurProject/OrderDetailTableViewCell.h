//
//  OrderDetailTableViewCell.h
//  OurProject
//
//  Created by StephenHe on 10/20/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailTableViewCell : UITableViewCell
{
    CGFloat cellWidth;
    CGFloat cellHeight;
    UIView* imagePanel;
}
@property(nonatomic,strong)UIImageView* productImage;

@property(nonatomic,strong)UILabel* productTitle;//goods_name

@property(nonatomic,strong)UILabel* salePrice;//goods_price

@property(nonatomic,strong)UILabel* revenue;//goods_pay_price

@property(nonatomic,strong)UILabel* quantity;//goods_num

-(void)setCurrCellSize:(CGFloat)height WithWidth:(CGFloat)width;

-(void)createProfileLayout;

-(void)createProductInfo;

-(void)createArrowImageLayout;
@end
