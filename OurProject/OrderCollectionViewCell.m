
//
//  OrderCollectionViewCell.m
//  OurProject
//
//  Created by StephenHe on 10/10/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "OrderCollectionViewCell.h"

@implementation OrderCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.img = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width/2-12.5, self.contentView.frame.size.height*0.23, 25, 25)];
    
        self.img.contentMode = UIViewContentModeScaleAspectFit;
        //img.image = [UIImage imageNamed:@"find_tb_02"];
        [self.contentView addSubview:self.img];
        
        self.buttonName = [[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width/2-40, self.contentView.frame.size.height*0.23+30, 80, 25)];
        //buttonName.text = @"全部订单";
        [self.buttonName setFont:[UIFont systemFontOfSize:15]];
        self.buttonName.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.buttonName];
        
        self.buttonExplan = [[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width/2-40, self.contentView.frame.size.height*0.23+50, 80, 25)];
        //buttonExplan.text = @"所有订单";
        [self.buttonExplan setFont:[UIFont systemFontOfSize:10]];
        self.buttonExplan.textAlignment = NSTextAlignmentCenter;
        [self.buttonExplan setTextColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:self.buttonExplan];
    }
    
    return self;
}

@end
