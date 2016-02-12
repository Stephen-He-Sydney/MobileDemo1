//
//  ChatTableViewCell.h
//  OurProject
//
//  Created by ibokan on 15/10/14.
//  Copyright (c) 2015年 StephenHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTableViewCell : UITableViewCell
@property(strong,nonatomic)UIImageView * portraitView;
@property(strong,nonatomic)UILabel * nameLable;
@property(strong,nonatomic)UILabel * timeLable;
@property(strong,nonatomic)UIImageView * perfectView;
@property(strong,nonatomic)UILabel * line;
//@property(strong,nonatomic)UILabel * writelable;
@property(strong,nonatomic)UIImageView * mainView;
@property(strong,nonatomic)UILabel * line1;
@property(strong,nonatomic)UILabel * count;
@property(strong,nonatomic)UITextView * writeView;
@end
