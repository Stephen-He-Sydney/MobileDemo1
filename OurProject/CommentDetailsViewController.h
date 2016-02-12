//
//  CommentDetailsViewController.h
//  OurProject
//
//  Created by ibokan on 15/10/14.
//  Copyright (c) 2015年 StephenHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UIImageView * portraitView;
@property(strong,nonatomic)UILabel * nameLable;
@property(strong,nonatomic)UILabel * timeLable;
@property(strong,nonatomic)UIButton * perfectView;

@property(strong,nonatomic)NSMutableDictionary * allDic;
@property(assign,nonatomic)int number;
@property(strong,nonatomic)NSMutableArray * arr;

@property(strong,nonatomic)NSDictionary * loginDic;

@property(strong,nonatomic)NSString *token;
@property(strong,nonatomic)NSString *topic_id;
@property(strong,nonatomic)NSString *headPic;
@property(strong,nonatomic)NSString *contentImage;
@property(strong,nonatomic)NSString *username;
@property(strong,nonatomic)NSString *time;
@property(strong,nonatomic)NSString *content;

@property(strong,nonatomic)NSString *  talkTitle;
@property(strong,nonatomic)NSString *replyCount;


@end
