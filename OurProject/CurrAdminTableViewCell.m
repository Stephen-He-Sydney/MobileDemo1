//
//  CurrAdminTableViewCell.m
//  OurProject
//
//  Created by StephenHe on 10/12/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "CurrAdminTableViewCell.h"

@implementation CurrAdminTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        NSArray* fieldTxt = @[@"专员编号:",@"专员姓名:"];
        for (int i = 0; i < 2; i++) {
            UILabel* field = [[UILabel alloc]initWithFrame:CGRectMake(5, 5+35*i, 60, 30)];
            field.text = fieldTxt[i];
            [field setFont:[UIFont systemFontOfSize:12]];
            
            [self.contentView addSubview:field];
            
            if (i == 0)
            {
                self.staffNo = [[UILabel alloc]initWithFrame:CGRectMake(5+60, 5, 60, 30)];
                [self.staffNo setFont:[UIFont systemFontOfSize:12]];
                [self.contentView addSubview:self.staffNo];
            }
            else
            {
                self.staffName = [[UILabel alloc]initWithFrame:CGRectMake(5+60, 5+35*i, 60, 30)];
                [self.staffName setFont:[UIFont systemFontOfSize:12]];
                [self.contentView addSubview:self.staffName];
            }
        }
    }
    return self;
}

@end
