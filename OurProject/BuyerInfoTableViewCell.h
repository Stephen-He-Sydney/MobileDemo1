//
//  BuyerInfoTableViewCell.h
//  OurProject
//
//  Created by StephenHe on 10/12/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

typedef void(^sendButtonText)(NSString* btnText);
@interface BuyerInfoTableViewCell : UITableViewCell
{
    UIView* mainBody;
    UIView* mainFooter;
    
    CGFloat cellWidth;
    CGFloat cellHeight;
}
@property(nonatomic,strong)sendButtonText sendButtonText;

@property(nonatomic,strong)UILabel* buyerNo;  //buyer_name
@property(nonatomic,strong)UIImageView* mainImage;//OrderGoods[0][goods_image]
@property(nonatomic,strong)UILabel* purchaseStatus;//OrderCommon[status]
@property(nonatomic,strong)UILabel* productTitle;//OrderGoods[0][goods_name]
@property(nonatomic,strong)UILabel* unitPrice;//OrderGoods[0]goods_price
@property(nonatomic,strong)UILabel* totalPrice;//OrderGoods[0]goods_pay_price
@property(nonatomic,strong)UILabel* shopName;//store_name
@property(nonatomic,strong)UILabel* quantity;//OrderGoods[0]goods_num
@property(nonatomic,strong)UILabel* summaryPrice;//goods_amount
@property(nonatomic,strong)UILabel* purchaseTime;//add_time

@property(nonatomic,strong)UIButton* sendToClient;

-(void)fetchCurrCellSize:(CGFloat)height WithWidth:(CGFloat)width;

-(void)createHeaderView;

-(void)createMainBody;

-(void)addComponentsToMainBody;

-(void)addComponentsToMainFooter;

-(void)addButtonsToMainFooter;

-(void)createFooterView;

@end
