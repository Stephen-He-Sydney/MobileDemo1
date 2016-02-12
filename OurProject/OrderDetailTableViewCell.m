//
//  OrderDetailTableViewCell.m
//  OurProject
//
//  Created by StephenHe on 10/20/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "OrderDetailTableViewCell.h"

@implementation OrderDetailTableViewCell

-(void)setCurrCellSize:(CGFloat)height WithWidth:(CGFloat)width
{
    cellHeight = height;
    cellWidth = width;
}

-(void)createProfileLayout
{
    imagePanel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cellHeight, cellHeight)];
    [self.contentView addSubview:imagePanel];
    
    self.productImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, imagePanel.frame.size.width-10, cellHeight)];
    
    //[self.productImage setBackgroundColor:[UIColor redColor]];
    
    self.productImage.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.contentView addSubview:self.productImage];
//
    self.productTitle = [[UILabel alloc]initWithFrame:CGRectMake(imagePanel.frame.size.width, 0, cellWidth*0.85-imagePanel.frame.size.width, 40)];
    [self.productTitle setFont:[UIFont systemFontOfSize:12]];
    self.productTitle.numberOfLines = 0;
    //[self.productTitle setBackgroundColor:[UIColor blueColor]];
    
    [self.contentView addSubview:self.productTitle];
}

-(void)createProductInfo
{
    UILabel* priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(imagePanel.frame.size.width, self.productTitle.frame.size.height+cellHeight/8, cellWidth*0.125, 25)];
    priceLabel.text = @"售价:￥";
    //[priceLabel setBackgroundColor:[UIColor purpleColor]];
    [priceLabel setFont:[UIFont systemFontOfSize:12]];
    
    self.salePrice = [[UILabel alloc]initWithFrame:CGRectMake(priceLabel.frame.size.width+priceLabel.frame.origin.x,self.productTitle.frame.size.height+cellHeight/8,cellWidth/4,25)];
    [self.salePrice setFont:[UIFont systemFontOfSize:12]];
    //[self.salePrice setBackgroundColor:[UIColor yellowColor]];
    
    [self.contentView addSubview:priceLabel];
    [self.contentView addSubview:self.salePrice];
    
    UILabel* qtyLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.salePrice.frame.origin.x+self.salePrice.frame.size.width,self.productTitle.frame.size.height+cellHeight/8,cellWidth*0.09,25)];
    qtyLabel.text = @"数量:";
    //[qtyLabel setBackgroundColor:[UIColor purpleColor]];
    [qtyLabel setFont:[UIFont systemFontOfSize:12]];
    
    self.quantity =[[UILabel alloc]initWithFrame:CGRectMake(qtyLabel.frame.origin.x+qtyLabel.frame.size.width,self.productTitle.frame.size.height+cellHeight/8,cellWidth/6,25)];
    
    //[self.quantity setBackgroundColor:[UIColor grayColor]];
    [self.quantity setFont:[UIFont systemFontOfSize:12]];
    
    [self.contentView addSubview:qtyLabel];
    [self.contentView addSubview:self.quantity];
    
    UILabel* revenueLabel = [[UILabel alloc]initWithFrame:CGRectMake(imagePanel.frame.size.width, self.salePrice.frame.origin.y+self.salePrice.frame.size.height, cellWidth*0.125, 25)];
    revenueLabel.text = @"收入:￥";
    //[revenueLabel setBackgroundColor:[UIColor greenColor]];
    [revenueLabel setFont:[UIFont systemFontOfSize:12]];
    
    self.revenue = [[UILabel alloc]initWithFrame:CGRectMake(priceLabel.frame.size.width+priceLabel.frame.origin.x,self.salePrice.frame.origin.y+self.salePrice.frame.size.height,cellWidth/4,25)];
     [self.revenue setFont:[UIFont systemFontOfSize:12]];
    //[self.revenue setBackgroundColor:[UIColor blueColor]];
    
    [self.contentView addSubview:revenueLabel];
    [self.contentView addSubview:self.revenue];
    
}

//-(void)createArrowImageLayout
//{
//    UIImageView* forwardArrow = [[UIImageView alloc]initWithFrame:CGRectMake(cellWidth-30, cellHeight/2-10, 30, 20)];
//    [forwardArrow setImage:[UIImage imageNamed:@"bz_tbjt"]];
//    forwardArrow.contentMode = UIViewContentModeScaleAspectFit;
//    
//    [self.contentView addSubview:forwardArrow];
//}
@end
