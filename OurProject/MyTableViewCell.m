//
//  MyTableViewCell.m
//  OurProject
//
//  Created by ibokan on 15/10/12.
//  Copyright (c) 2015年 StephenHe. All rights reserved.
//

#import "MyTableViewCell.h"
@implementation MyTableViewCell


#pragma mark- 重写父类方法
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //创建当前cell需要的控件
        self.headView  =[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
        [self.contentView addSubview: self.headView];
        
        self.nameLable = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 150, 50)];
        [self.contentView addSubview:self.nameLable];
        
        self.boultView = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width-20, 20, 10, 10)];
        [self.contentView addSubview:self.boultView];
        
    }
    return self;
}












- (void)awakeFromNib {
    // Initialization code
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
