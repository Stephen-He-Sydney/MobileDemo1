//
//  StoreTableViewCell.h
//  OurProject
//
//  Created by ibokan on 15/10/14.
//  Copyright (c) 2015年 StephenHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreTableViewCell : UITableViewCell
@property(strong,nonatomic)UIImageView *commodityImage;
@property(strong,nonatomic)UILabel *goodsName;
@property(strong,nonatomic)UIImageView *turnImage;
@property(strong,nonatomic)UILabel *goodsPrice;
@property(strong,nonatomic)UILabel *storage;
@property(strong,nonatomic)UILabel *sales;
@end
