//
//  ChatTableViewCell.m
//  OurProject
//
//  Created by ibokan on 15/10/14.
//  Copyright (c) 2015年 StephenHe. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "GlobalConstants.h"
@implementation ChatTableViewCell

#pragma mark - 重写父类方法
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //创建cell需要的控件

        
        //头像
        self.portraitView = [[UIImageView alloc]initWithFrame:CGRectMake(CURRSIZE.width/15, 5, 40, 40)];
        //[self.portraitView setBackgroundColor:[UIColor redColor]];
        [self.contentView addSubview:self.portraitView];
        //用户名
        self.nameLable = [[UILabel alloc]initWithFrame:CGRectMake(CURRSIZE.width/15+40, 5, CURRSIZE.width/15*9, 20)];
        [self.nameLable setFont:[UIFont systemFontOfSize:15]];
        //[self.nameLable setBackgroundColor:[UIColor greenColor]];
        [self.contentView addSubview:self.nameLable];
        //时间
        self. timeLable = [[UILabel alloc]initWithFrame:CGRectMake(CURRSIZE.width/15+40, 25, CURRSIZE.width/15*9, 20)];
        [self.timeLable setFont:[UIFont systemFontOfSize:10]];
        //[self.timeLable setBackgroundColor:[UIColor yellowColor]];
        [self.contentView addSubview:self.timeLable];
        //精
        self.perfectView = [[ UIImageView alloc]initWithFrame:CGRectMake(CURRSIZE.width/15*11+40, 10, 20, 30)];
        //[self.perfectView setBackgroundColor:[UIColor blueColor]];
        [self.contentView addSubview:self.perfectView];
       //横线
        self.line = [[UILabel alloc]initWithFrame:CGRectMake(0, 49.8, CURRSIZE.width, 0.2)];
        
        [self.line setBackgroundColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:self.line];
        
        
        //编辑区
        self. writeView = [[UITextView alloc]init];
        [self.writeView setUserInteractionEnabled:NO];
//        //[self.writeView setText:@"灌灌灌灌灌灌灌灌灌灌sgfgggggggggggggggggggggggggggggggggggggggg"];
//        CGSize titleSize = [self.writeView.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(CURRSIZE.width/15*13, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
//        [self.writeView setFrame:CGRectMake(CURRSIZE.width/15, 50.5, CURRSIZE.width/15*13, titleSize.height)];
             // NSLog(@"%lf",titleSize.height);
        [self.writeView setFont:[UIFont systemFontOfSize:12]];
               [self.contentView addSubview:self.writeView];
        
        //图片区
        self.mainView = [[UIImageView alloc]init ];
//                         WithFrame:CGRectMake(CURRSIZE.width/15, 50.5+titleSize.height, 150, 100)];
        //[self.mainView setBackgroundColor:[UIColor yellowColor]];
        [self.contentView addSubview:self.mainView];
        
                //评论数
        self.count  = [[UILabel alloc]init];
//                       WithFrame:CGRectMake(0, 50.5+titleSize.height+100+10, CURRSIZE.width, 30)];
        [self.count setFont:[UIFont systemFontOfSize:12]];
        [self.count setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.count];
        //横线
        self.line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CURRSIZE.width, 0.2)];
        [self.line1 setBackgroundColor:[UIColor lightGrayColor]];
        [self.count addSubview:self.line1];
 
    }
    return  self;
}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
