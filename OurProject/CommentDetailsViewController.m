//
//  CommentDetailsViewController.m
//  OurProject
//
//  Created by ibokan on 15/10/14.
//  Copyright (c) 2015年 StephenHe. All rights reserved.
//

#import "CommentDetailsViewController.h"
#import "GlobalConstants.h"
#import "CustomHttpRequest.h"
#import "CommFunc.h"
@interface CommentDetailsViewController ()<UIAlertViewDelegate>
{    CGSize size;
    CGSize size1;
     NSString *strTime;
    NSMutableDictionary * infoDic;
    UIImageView * imageView;
     NSMutableArray *content_array;
    UITableView * commentView;
    UILabel * lable;

}
@end

@implementation CommentDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"评论详情";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    content_array=[[NSMutableArray alloc]init];
    
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"评论" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnAction:)];
    self.navigationItem.rightBarButtonItem = rightBtn ;
    //tableview
    commentView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CURRSIZE.width, CURRSIZE.height) style:UITableViewStylePlain];
    commentView.delegate = self;
    commentView.dataSource =self;
    [commentView setSectionHeaderHeight:0];
    [commentView setSectionFooterHeight:0];
    [self.view addSubview:commentView];
    
    //头视图
    imageView = [[UIImageView alloc]init];
    [imageView setBackgroundColor:[UIColor whiteColor]];
    [imageView setUserInteractionEnabled:YES];
    [commentView setTableHeaderView:imageView];
    //头像
    self.portraitView = [[UIImageView alloc]initWithFrame:CGRectMake(CURRSIZE.width/15, 5, 40, 40)];
    self.portraitView.image= self.arr[self.number];
    [imageView addSubview:self.portraitView];
    //用户名
    self.nameLable = [[UILabel alloc]initWithFrame:CGRectMake(CURRSIZE.width/15+40, 5, CURRSIZE.width/15*9, 20)];
    [self.nameLable setFont:[UIFont systemFontOfSize:15]];
    self.nameLable.text=self.username;
    [imageView addSubview:self.nameLable];
    //时间
    self. timeLable = [[UILabel alloc]initWithFrame:CGRectMake(CURRSIZE.width/15+40, 25, CURRSIZE.width/15*9, 20)];
    [self.timeLable setFont:[UIFont systemFontOfSize:10]];
    
//    //时间转码
    NSString * time = [NSString stringWithFormat:@"%@",self.allDic[@"data"][@"topics"][self.number][@"topic_add_time"]];
    NSDate *date=[[NSDate alloc]initWithTimeIntervalSince1970:time.longLongValue];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    strTime=[formatter stringFromDate:date];
    self.timeLable.text =  [NSString stringWithFormat:@"%@",strTime];
    self.timeLable.text=self.time;
    //[self.timeLable setBackgroundColor:[UIColor yellowColor]];
    [imageView addSubview:self.timeLable];
    //分享
    self.perfectView =[UIButton buttonWithType:UIButtonTypeSystem];
    [self.perfectView setFrame:CGRectMake(CURRSIZE.width/15*11+40, 10, 40, 30)];
    [self.perfectView setTitle:@"分享" forState:UIControlStateNormal];
    [self.perfectView setTintColor:[UIColor blueColor]];
    [self.perfectView.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [imageView addSubview:self.perfectView];


    
    
    //文本内容
    UITextView * textV = [[UITextView alloc]init];
    [textV  setUserInteractionEnabled:NO];
    size=[self.content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(CURRSIZE.width/15, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
     [textV setFrame: CGRectMake(CURRSIZE.width/15, 60, CURRSIZE.width/15*13, size.height)];
    textV.text = self.content;
    [imageView addSubview:textV];
    
    UIImageView * Cimage = [[UIImageView alloc]init];
    if ([self.contentImage isEqualToString:@""]||[self.contentImage isEqualToString:@"(null)"]||[self.contentImage isEqualToString:@"http://112.74.105.205/zhizu(null)"]||self.contentImage==nil) {
        Cimage.hidden = YES;
        [imageView setFrame:CGRectMake(0, 0, CURRSIZE.width, 50+size.height+20)];
        //[lable setFrame:CGRectMake(0, 50+size.height+19.5, imageView.frame.size.width, 0.5)];
    }
    else
    {   Cimage.hidden = NO;
        [Cimage setFrame:CGRectMake(CURRSIZE.width/15, 60+size.height, 100, 50)];
        [imageView setFrame:CGRectMake(0, 0, CURRSIZE.width, 50+size.height+20+50)];
        //[lable setFrame:CGRectMake(0, 50+size.height+50+19.5, imageView.frame.size.width, 0.5)];
    }
    [ Cimage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://112.74.105.205/zhizu%@",self.contentImage]]]]];
    [imageView addSubview:Cimage];
    
    
  
//    self.loginDic = [CommFunc readUserLogin];
//    NSLog(@"88888888888%@",self.loginDic);
  //  NSLog(@"2222222%@",self.allDic);
    
    self.loginDic = [CommFunc readUserLogin];
    
    CustomHttpRequest * customRequest1 = [[CustomHttpRequest alloc]init];
    NSString * serverUrl =@"topic/getReplyList";
    NSString * paramUrl = [NSString stringWithFormat:@"{\"topic_id\":\"%@\", \"token\":\"%@\", \"pageIndex\":\"%@\", \"pageCount\":\"%@\"}",self.topic_id,self.loginDic[@"data"][@"token"],[NSString stringWithFormat:@"%d",0],[NSString stringWithFormat:@"%d",10]];
    [customRequest1 fetchResponseByPost:serverUrl WithParameter:paramUrl WithResponse:^(NSDictionary *info) {
        
         if (info[@"data"]!= (id)[NSNull null])
         {
              infoDic = [NSMutableDictionary dictionaryWithDictionary:info];
        
        
             NSLog(@"%@",infoDic);
        if (![infoDic[@"data"] isEqual:@""]) {
            for (NSDictionary *dic1 in infoDic[@"data"][@"topics"]) {
                [content_array addObject:dic1];
                NSLog(@"---------------%@",content_array);
        }
        
                }
             
            }
        [commentView reloadData];
    }];
    
}



#pragma mark - 指定行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([content_array count]>0) {
        return content_array.count;
    }else
    {
        return 0;
    
    }
    

}
#pragma mark - 指定行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 120;

}
#pragma mark - 创建cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString * cellIndex = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndex];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndex];
    }
    //头像
    UIImageView *  headView = [[UIImageView alloc]initWithFrame:CGRectMake(CURRSIZE.width/15, 5, 40, 40)];
    //[self.portraitView setBackgroundColor:[UIColor redColor]];
    if (content_array.count > 0) {
        if ([content_array[indexPath.row][@"users_headPic"] isEqualToString:@""]||[content_array[indexPath.row][@"users_headPic"] isEqualToString:@"(null)"]||[content_array[indexPath.row][@"users_headPic"] isEqualToString:@"http://112.74.105.205/zhizu(null)"])
        {
            headView.image=[UIImage imageNamed:@"home_tb_05"];
        }
        else
        {
            [headView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:content_array[indexPath.row][@"users_headPic"]]]]];
        }
        
        [cell.contentView addSubview:headView];
        
        //用户名
        UILabel *  username = [[UILabel alloc]initWithFrame:CGRectMake(CURRSIZE.width/15+40, 5, CURRSIZE.width/15*9, 20)];
        username.text = content_array[indexPath.row][@"users_name"];
        [username setFont:[UIFont systemFontOfSize:15]];
        
        //[self.nameLable setBackgroundColor:[UIColor greenColor]];
        [cell.contentView addSubview:username];
        //时间
        UILabel *  timeL= [[UILabel alloc]initWithFrame:CGRectMake(CURRSIZE.width/15+40, 25, CURRSIZE.width/15*9, 20)];
        [timeL setFont:[UIFont systemFontOfSize:10]];
        
        //时间转码
                NSString * time = [NSString stringWithFormat:@"%@",content_array[indexPath.row][@"reply_time"]];
                NSDate *date=[[NSDate alloc]initWithTimeIntervalSince1970:time.longLongValue];
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                 NSString *  stringTime=[formatter stringFromDate:date];
                timeL.text =  [NSString stringWithFormat:@"%@",stringTime];
        timeL .text = content_array[indexPath.row][@"reply_time"];
        [cell.contentView addSubview:timeL];
        
        
        size1=[content_array[indexPath.row][@"reply_content"] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(CURRSIZE.width/15, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        UITextView * context = [[UITextView alloc]initWithFrame:CGRectMake(CURRSIZE.width/15, 50, CURRSIZE.width/15*13, size1.height+10)];
        [context setUserInteractionEnabled:YES];
        [context setFont:[UIFont systemFontOfSize:12]];
        context.text= content_array[indexPath.row][@"reply_content"];
        [cell.contentView addSubview:context];
        
        
    }

    return cell;
}

-(void)CommentDeatils_send
{
    self.loginDic = [CommFunc readUserLogin];
    
    CustomHttpRequest * customRequest1 = [[CustomHttpRequest alloc]init];
    NSString * serverUrl =@"Topic/replyTopic";
    NSString * paramUrl = [NSString  stringWithFormat:@"{\"replay_content\":\"%@\",\"topic_id\":\"%@\",\"token\":\"%@\",\"users_id\":\"%@\"}",self.talkTitle,self.topic_id,self.loginDic[@"data"][@"token"],self.loginDic[@"data"][@"users_id"]];
    [customRequest1 fetchResponseByPost:serverUrl WithParameter:paramUrl WithResponse:^(NSDictionary *info) {
    infoDic = [NSMutableDictionary dictionaryWithDictionary:info];
        [commentView reloadData];
    }];
    
}





#pragma mark - 评论button方法
-(void)rightBtnAction:(id)sender
{
    NSLog(@"嘻嘻");
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"评论" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.delegate =self;
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
    
}

#pragma mark - 选中alert执行的方法
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{




}
#pragma - mark 获取输入的内容
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"确定"]) {
        UITextField * tf= [alertView textFieldAtIndex:0];
        self.talkTitle = tf.text;
        if ([self.talkTitle  isEqual: @""]) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写评论" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }else{
            [self CommentDeatils_send];
            self.replyCount = [NSString stringWithFormat:@"%d",1];
            
        }

    
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
