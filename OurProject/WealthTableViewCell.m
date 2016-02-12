//
//  WealthTableViewCell.m
//  OurProject
//
//  Created by StephenHe on 10/12/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "WealthTableViewCell.h"

@implementation WealthTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        NSArray* showTxt = @[@"订单号:",@"订单金额:"];
        for (int i = 0; i < 2; i++) {
            UILabel* labelTxt = [[UILabel alloc]initWithFrame:CGRectMake(10, 9+20*i,CURRSIZE.width/6, 15)];
            labelTxt.text = showTxt[i];
            [labelTxt setFont:[UIFont systemFontOfSize:12]];
            [self.contentView addSubview:labelTxt];
            
            if (i == 0)
            {
                self.orderNo = [[UILabel alloc]initWithFrame:CGRectMake(10 + CURRSIZE.width/6+3, 9+20*i,CURRSIZE.width/5*4, 15)];
                [self.orderNo setFont:[UIFont boldSystemFontOfSize:12]];
                [self.contentView addSubview:self.orderNo];
            }
            else
            {
                self.orderAmount = [[UILabel alloc]initWithFrame:CGRectMake(10+ CURRSIZE.width/6+3, 9+20*i,CURRSIZE.width/5*4, 15)];
                [self.orderAmount setFont:[UIFont boldSystemFontOfSize:12]];
                [self.orderAmount setTextColor:[UIColor redColor]];
                
                [self.contentView addSubview:self.orderAmount];
            }
        }
    }
    return self;
}

@end
