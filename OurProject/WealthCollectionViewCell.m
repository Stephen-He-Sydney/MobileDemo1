//
//  WealthCollectionViewCell.m
//  OurProject
//
//  Created by StephenHe on 10/12/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "WealthCollectionViewCell.h"

@implementation WealthCollectionViewCell
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.btnImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width/2-22.5, self.contentView.frame.size.height*0.2, 50, 45)];
        
        self.btnImage.contentMode = UIViewContentModeScaleAspectFit;
        //self.btnImage.image = [UIImage imageNamed:@"home_tb_04"];
        
        [self.contentView addSubview:self.btnImage];
        
        self.buttonName = [[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width/2-30+2, self.contentView.frame.size.height*0.2+self.btnImage.frame.size.height+2, 60, 20)];
        self.buttonName.text = @"订单";
        [self.buttonName setFont:[UIFont systemFontOfSize:12]];
        self.buttonName.textAlignment = NSTextAlignmentCenter;
      
        [self.contentView addSubview:self.buttonName];
    }
    
    return self;
}
@end
