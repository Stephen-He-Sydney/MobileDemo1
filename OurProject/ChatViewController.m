//
//  ChatViewController.m
//  OurProject
//
//  Created by StephenHe on 10/9/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "ChatViewController.h"
#import "GlobalConstants.h"
#import "ChatTableViewCell.h"
#import "PublishChatViewController.h"
#import "CommentDetailsViewController.h"
#import "CustomHttpRequest.h"
#import "CommFunc.h"
@interface ChatViewController ()
{
    NSMutableDictionary * infoDic;
    //NSData * imageData;
    UITableView * chatView;
    NSMutableArray * headImageArray;
    CGSize titleSize;
    NSDictionary * dic;
    NSData * headImageData1;
    NSString *strTime;
    NSMutableArray *ImageArray;
     NSMutableArray *content_array;
    ChatTableViewCell * cell;
    NSString *imageUrl;
   
}
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    content_array=[[NSMutableArray alloc]init];
    self.navigationItem.title = @"交流区";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    headImageArray = [[NSMutableArray alloc]init];
    //添加按钮
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
    self.navigationItem.rightBarButtonItem = rightBtn ;
    
    
    chatView = [[UITableView alloc]initWithFrame:CGRectMake(0, -15, CURRSIZE.width, CURRSIZE.height-20) style:UITableViewStyleGrouped];
    [chatView setSectionHeaderHeight:0];
    [chatView setSectionFooterHeight:15];
    
    
    chatView.delegate = self;
    chatView.dataSource = self;
    [self.view addSubview:chatView];
}

-(void)viewDidAppear:(BOOL)animated
{
    //网络请求
    self.loginDic = [CommFunc readUserLogin];
    
    CustomHttpRequest * customRequest1 = [[CustomHttpRequest alloc]init];
    NSString * serverUrl = @"Topic/getList";
    NSString * paramUrl = [NSString stringWithFormat:@"{\"pageIndex\":\"%@\",\"pageCount\":\"%@\",\"token\":\"%@\"}",[NSString stringWithFormat:@"%d",0],[NSString stringWithFormat:@"%d",10],self.loginDic[@"data"][@"token"]];
    
    [customRequest1 fetchResponseByPost:serverUrl WithParameter:paramUrl WithResponse:^(NSDictionary *info) {
        
        if ([info objectForKey:@"fail"])
        {
            //[self promptSingleButtonWarningDialog:@"网络不给力,请稍候"];
            
        }
        else
            
        {
            if (info[@"data"]!= (id)[NSNull null])
            {
                
                infoDic = [NSMutableDictionary dictionaryWithDictionary:info];
//                NSLog(@"%@",infoDic);
    
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    for ( dic in infoDic[@"data"][@"topics"]) {
                        NSLog(@"111111%@",dic);
                        [content_array addObject:dic];
                        
                        if ([dic[@"users_headPic"] isEqualToString:@""]) {
                            [headImageArray addObject:[UIImage imageNamed:@"home_tb_05"]];
                        }else{
                            NSURL * imageURL;
                            if ([dic[@"users_headPic"] hasPrefix:@"http://112.74.105.205/zhizu"]) {
                                imageURL = [NSURL URLWithString:dic[@"users_headPic"]];
                            }else {
                               imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://112.74.105.205/zhizu%@",dic[@"users_headPic"]]];
                            }
                            
                            NSData * headImageData = [NSData dataWithContentsOfURL:imageURL];
                            UIImage * image = [UIImage imageWithData:headImageData];
                            if (image) {
                                 [headImageArray addObject:image];
                            }else{
                                [headImageArray addObject:[UIImage imageNamed:@"home_tb_05"]];
                            }
                           
  
                        }
   
                    }

                    dispatch_async(dispatch_get_main_queue(), ^{
                        [chatView reloadData];
                    });
                    
                });
            }
            }
        }];
}
#pragma mark - 添加按钮方法
-(void)addAction:(id)sender
{
    PublishChatViewController * publishChat = [[PublishChatViewController alloc]init];
    [self.navigationController pushViewController:publishChat animated:YES];

}

#pragma mark - z指定分组数

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray * tmparr = infoDic[@"data"][@"topics"];
    if (tmparr.count > 0) {
        return tmparr.count;
    }else{
        return 0;
    }
}
#pragma mark - 指定行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;

}
#pragma mark - 指定cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        titleSize = [infoDic[@"data"][@"topics"][indexPath.section][@"topic_content"] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(CURRSIZE.width/15*13, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        NSLog(@"aaaaaaaaaa%lf",titleSize.height);
    
    
//    if ([infoDic[@"data"][@"topics"][indexPath.section][@"topic_image_url"] isEqualToString:@""] || [infoDic[@"data"][@"topics"][indexPath.section][@"topic_image_url"] isEqualToString:@"(null)"]||[infoDic[@"data"][@"topics"][indexPath.section][@"topic_image_url"] isEqualToString:@"http://112.74.105.205/zhizu(null)"] )
    NSString *Url=content_array[indexPath.section][@"topic_image_url"];
    if ([Url containsString:@"/Uploads/Picture/"]&&![Url containsString:@"http://112.74.105.205/zhizu"]){
        [cell.mainView setFrame:CGRectMake(CURRSIZE.width/15, 70.5+titleSize.height, 100, 50)];
        [cell.count setFrame:CGRectMake(0, 70.5+titleSize.height+50+10, CURRSIZE.width, 30)];
        return titleSize.height+50.5+30+50+50;
    }
    else
    {
        return titleSize.height+49.8+30+50;
        
    }
    
    


}

#pragma mark - 创建cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//创建重用标示符
    static NSString * indexCell = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:indexCell];
    if (!cell) {
        cell = [[ChatTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indexCell];
    }
    
    

   
    [cell.writeView setFrame:CGRectMake(CURRSIZE.width/15, 50.5, CURRSIZE.width/15*13, titleSize.height+20)];
    
    [cell.mainView setFrame:CGRectMake(CURRSIZE.width/15, 70.5+titleSize.height, 100, 50)];
    
//    if ([dic[@"topic_image_url"] isEqualToString:@""]||[dic[@"topic_image_url"] isEqualToString:@"(null)"]) {
//        [cell.count setFrame:CGRectMake(0, 70.5+titleSize.height+10, CURRSIZE.width, 30)];
//
//    }else {
//        [cell.count setFrame:CGRectMake(0, 70.5+titleSize.height+50+10, CURRSIZE.width, 30)];
//
//        
//        
//    }

    
    if (headImageArray.count > 0) {
         cell.portraitView.image= headImageArray[indexPath.section];
    }else{
        cell.portraitView.image = [UIImage imageNamed:@"home_tb_05"];
    }
    
    cell.nameLable.text = infoDic[@"data"][@"topics"][indexPath.section][@"users_name"];
    NSLog(@"%@",cell.nameLable.text);
    //时间转码
    NSString * time = [NSString stringWithFormat:@"%@",infoDic[@"data"][@"topics"][indexPath.section][@"topic_add_time"]];
    NSDate *date=[[NSDate alloc]initWithTimeIntervalSince1970:time.longLongValue];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    strTime=[formatter stringFromDate:date];
    cell.timeLable.text =  [NSString stringWithFormat:@"%@",strTime];
    cell.writeView.text = infoDic[@"data"][@"topics"][indexPath.section][@"topic_content"];
    
    //判断是否有图片
    imageUrl=content_array[indexPath.section][@"topic_image_url"];
//    [content_array[indexPath.section][@"topic_image_url"] isEqualToString:@""]||[content_array[indexPath.section][@"topic_image_url"] isEqualToString:@"(null)"]||[content_array[indexPath.section][@"topic_image_url"] isEqualToString:@"http://112.74.105.205/zhizu(null)"]
    if ([imageUrl containsString:@"/Uploads/Picture/"]&&![imageUrl containsString:@"http://112.74.105.205/zhizu"]) {
        cell.mainView.hidden=NO;
//        NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://112.74.105.205/zhizu%@",dic[@"topic_image_url"]]];
//        NSLog(@"%@",imageURL);
//        headImageData1 = [NSData dataWithContentsOfURL:imageURL];
        //        [cell.mainView setImage:ImageArray[indexPath.section]];
        
         [cell.mainView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://112.74.105.205/zhizu%@",imageUrl]]]]];
        
    }
    else
    {
        cell.mainView.hidden=YES;
        [cell.mainView setFrame:CGRectMake(0, 70.5+titleSize.height, 100, 50)];
        [cell.count setFrame:CGRectMake(0, 70.5+titleSize.height+10, CURRSIZE.width, 30)];
    }
  


    NSString * str = [NSString stringWithFormat:@"评论数"];
    NSString * str1 =[NSString stringWithFormat:@"(%@)",infoDic[@"data"][@"topics"][indexPath.section][@"replyCount"]];
    NSString * str2 = [str stringByAppendingString:str1];
    cell.count.text = str2;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


#pragma mark - 选中cell执行的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentDetailsViewController * comment = [[CommentDetailsViewController alloc]init];
    comment.arr = headImageArray;
    comment.number = (int)indexPath.section;
    comment.token=infoDic[@"data"][@"token"];
    comment.topic_id=content_array[indexPath.section][@"topic_id"];
    comment.headPic=content_array[indexPath.section][@"users_headPic"];
    [cell.mainView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://112.74.105.205/zhizu%@",imageUrl]]]]];
    
    if ([content_array[indexPath.section][@"topic_image_url"] isEqualToString:@""]) {
       comment.contentImage=nil;
    }
    else
    {
       comment.contentImage=content_array[indexPath.section][@"topic_image_url"];
    }
  
   // comment.headPic=headImageArray[indexPath.section];

    comment.username=[NSString stringWithFormat:@"%@",content_array[indexPath.section][@"users_name"]];
        
    //时间转码
    NSString * time = [NSString stringWithFormat:@"%@",infoDic[@"data"][@"topics"][indexPath.section][@"topic_add_time"]];
    NSDate *date=[[NSDate alloc]initWithTimeIntervalSince1970:time.longLongValue];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* strTime1=[formatter stringFromDate:date];
    comment.time=[NSString stringWithFormat:@"%@",strTime1];
    comment.content=[NSString stringWithFormat:@"%@",content_array[indexPath.section][@"topic_content"]];
    
    [self.navigationController pushViewController:comment animated:YES];

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
