//
//  SourceCollectionViewCell.h
//  OurProject
//
//  Created by ibokan on 15/10/12.
//  Copyright (c) 2015年 StephenHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SourceCollectionViewCell : UICollectionViewCell

@property(strong,nonatomic)UIImageView *touchBtn;
@property(strong,nonatomic)UILabel *strName;
@property(strong,nonatomic)UIAlertView *alertInformation;
@property(strong,nonatomic)UIImageView *imageShow;
@property(strong,nonatomic)UILabel *commodityName;
@property(strong,nonatomic)UILabel *priceShow;
@end
