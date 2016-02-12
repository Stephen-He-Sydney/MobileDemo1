//
//  StoreTableViewCell.m
//  OurProject
//
//  Created by ibokan on 15/10/14.
//  Copyright (c) 2015年 StephenHe. All rights reserved.
//

#import "StoreTableViewCell.h"
#import "GlobalConstants.h"

@implementation StoreTableViewCell

//-(void)layoutSubviews
//{
//    _commodityImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width/4, self.contentView.bounds.size.height)];
//    [_commodityImage setBackgroundColor:[UIColor grayColor]];
//    [self.contentView addSubview:_commodityImage];
////    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
//}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
   
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //设置图片展示的区域
        _commodityImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CURRSIZE.width/4, CURRSIZE.width/4)];
//        [_commodityImage setBackgroundColor:[UIColor grayColor]];
        [_commodityImage setContentMode:UIViewContentModeScaleAspectFit];
        [self.contentView addSubview:_commodityImage];  
        //设置展示出来的文字
        _goodsName = [[UILabel alloc]initWithFrame:CGRectMake(CURRSIZE.width/4, 0, CURRSIZE.width/1.5, CURRSIZE.width/20)];
        [_goodsName setText:@"无"];
        [_goodsName setFont:[UIFont boldSystemFontOfSize:CURRSIZE.width/28]];
        [self.contentView addSubview:_goodsName];
        _goodsPrice = [[UILabel alloc]initWithFrame:CGRectMake(CURRSIZE.width/4,  CURRSIZE.width/16, CURRSIZE.width/1.5, CURRSIZE.width/20)];
        [_goodsPrice setText:@"mon"];
        [_goodsPrice setFont:[UIFont boldSystemFontOfSize:CURRSIZE.width/28]];
        [_goodsPrice setTextColor:[UIColor redColor]];
        [self.contentView addSubview:_goodsPrice];
        
        UILabel *storageName = [[UILabel alloc]initWithFrame:CGRectMake(CURRSIZE.width/4, CURRSIZE.width/8, 40, CURRSIZE.width/20)];
        [storageName setText:@"库存:"];
        [storageName setFont:[UIFont boldSystemFontOfSize:CURRSIZE.width/28]];
        [self.contentView addSubview:storageName];
        
        _storage = [[UILabel alloc]initWithFrame:CGRectMake(CURRSIZE.width/4+40, CURRSIZE.width/8, CURRSIZE.width/2, CURRSIZE.width/20)];
        [_storage setFont:[UIFont boldSystemFontOfSize:CURRSIZE.width/28]];
        [self.contentView addSubview:_storage];
        
        UILabel *salesName = [[UILabel alloc]initWithFrame:CGRectMake(CURRSIZE.width/4, CURRSIZE.width/16*3, 40, CURRSIZE.width/20)];
        [salesName setText:@"销量:"];
        [salesName setFont:[UIFont boldSystemFontOfSize:CURRSIZE.width/28]];
        [self.contentView addSubview:salesName];
        
        _sales = [[UILabel alloc]initWithFrame:CGRectMake(CURRSIZE.width/4+40, CURRSIZE.width/16*3, CURRSIZE.width/2, CURRSIZE.width/20)];
        [_sales setFont:[UIFont boldSystemFontOfSize:CURRSIZE.width/28]];
        [self.contentView addSubview:_sales];
        
        _turnImage = [[UIImageView alloc]initWithFrame:CGRectMake(CURRSIZE.width/1.04, CURRSIZE.width/8.3, CURRSIZE.width/45, CURRSIZE.width/40)];
        [_turnImage setImage:[UIImage imageNamed:@"zjsp_icon10"]];
        [_turnImage setContentMode:UIViewContentModeScaleAspectFill];
        [self.contentView addSubview:_turnImage];
        
    }
    return self;
}
//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
//    CGContextFillRect(context, rect);
//    
//    //上分割线，
//    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextStrokeRect(context, CGRectMake(0, -1, rect.size.width - 10, 1));
//    
//    //下分割线
//    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width - 10, 1));
//}  

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
