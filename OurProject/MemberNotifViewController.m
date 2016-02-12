//
//  MemberNotifViewController.m
//  OurProject
//
//  Created by StephenHe on 10/9/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "MemberNotifViewController.h"
#import "GlobalConstants.h"
@interface MemberNotifViewController ()

@end

@implementation MemberNotifViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"会员通知";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UITableView * MemberNotifView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CURRSIZE.width, CURRSIZE.height) style:UITableViewStylePlain];
    
    MemberNotifView.delegate = self;
    MemberNotifView.dataSource =self;
    [self.view addSubview:MemberNotifView];
    
    
    
    
    
}
#pragma mark -指定行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
    
}
#pragma mark - 指定cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;

}
#pragma mark -创建cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * indexCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indexCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indexCell];
    }
    
    cell.textLabel.text = @"万校网是全国首创的大学生资源整合平台";
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    cell.detailTextLabel.text=@"15/10/13";
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:10]];
    cell.imageView.image=[UIImage imageNamed:@"home_menu_02"];
    return cell;
    

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
