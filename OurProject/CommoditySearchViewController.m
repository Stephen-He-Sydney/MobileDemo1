//
//  CommoditySearchViewController.m
//  OurProject
//
//  Created by ibokan on 15/10/14.
//  Copyright (c) 2015年 StephenHe. All rights reserved.
//

#import "CommoditySearchViewController.h"
#import "StoreTableViewCell.h"
#import "ProductDetailsViewController.h"
#import "MJRefresh.h"
#import "CommFunc.h"
#import "CustomHttpRequest.h"
#import "CommonViewController.h"

@interface CommoditySearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    CustomHttpRequest *customRequest;
    UILabel *message;
    //存储图片
    NSMutableArray *storeGoodsImages;
}
@property(strong,nonatomic)UITableView *searchTableView;
@property(strong,nonatomic)NSDictionary *loginInfo;
@property(strong,nonatomic)UITextField *searchText;
@property(strong,nonatomic)NSMutableArray *myStoreGoodsInfo;
@end

@implementation CommoditySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
}
#pragma mark - 创建TabelView
-(void)creatTableView
{
    _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    [self.view addSubview:_searchTableView];
    [_searchTableView setDataSource:self];
    [_searchTableView setDelegate:self];
    //下拉刷新
    [_searchTableView addHeaderWithTarget:self action:@selector(updateTableView:)];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myStoreGoodsInfo.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"identifer";
    StoreTableViewCell *searchCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!searchCell) {
        searchCell = [[StoreTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    if (storeGoodsImages.count == self.myStoreGoodsInfo.count) {
        [searchCell.commodityImage setImage:storeGoodsImages[indexPath.row]];
    }
    [searchCell.goodsName setText:self.myStoreGoodsInfo[indexPath.row][@"goods_name"]];
    [searchCell.goodsPrice setText:self.myStoreGoodsInfo[indexPath.row][@"goods_price"]];
    [searchCell.storage setText:self.myStoreGoodsInfo[indexPath.row][@"goods_storage"]];
    [searchCell.sales setText:self.myStoreGoodsInfo[indexPath.row][@"goods_salenum"]];
    return searchCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return tableView.bounds.size.width/4;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailsViewController *commodityView = [[ProductDetailsViewController alloc]init];
    commodityView.token = self.token;
    commodityView.storeID = self.storeID;
    commodityView.goodsID = self.myStoreGoodsInfo[indexPath.row][@"goods_id"];
    [self.navigationController pushViewController:commodityView animated:YES];
}
-(void)updateTableView:(id)sender
{
    //关闭下拉效果
    [_searchTableView headerEndRefreshing];
    //数据重载
    [_searchTableView reloadData];
}
#pragma mark - 获取商品获取带数据
-(void)getSearchGoods
{
    NSString *searchText = [self.searchText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    CustomHttpRequest* httpRequest = [[CustomHttpRequest alloc]init];
    NSString* serverUrl = @"Store/showStore";
    NSString* paramUrl = [NSString stringWithFormat:@"{\"token\":\"%@\",\"storeid\":\"%@\",\"keyword\":\"%@\"}",self.token,self.storeID,searchText];
    
//    CommonViewController* commCtrl = [[CommonViewController alloc]init];
//    [commCtrl handleServerSideInfo:serverUrl WithParamUrl:paramUrl];
//    
//    commCtrl.jsonData = ^(NSDictionary* info)
//    {
//        if (info != nil) {
//            [message setHidden:YES];
//            [self creatTableView];
//            self.myStoreGoodsInfo = info[@"data"];
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                [self getStoreGoodsImages];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.searchTableView reloadData];
//                    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
//                });
//            });
//        }
//        else [message setHidden:NO];
//    };

    
    [httpRequest fetchResponseByPost:serverUrl WithParameter:paramUrl WithResponse:^(NSDictionary *info) {
        if ([info objectForKey:@"fail"])
        {
            [self promptSingleButtonWarningDialog:@"网络不给力，请稍候"];
        }
        else
        {
            if (info[@"data"]!= (id)[NSNull null])
            {
                if(([info[@"data"] isKindOfClass:[NSArray class]]||[info[@"data"] isKindOfClass:[NSDictionary class]])&& [info[@"data"] count] > 0)
                {
                    [message setHidden:YES];
                    [self creatTableView];
                    self.myStoreGoodsInfo = info[@"data"];
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        [self getStoreGoodsImages]; 
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.searchTableView reloadData];
                            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                        });
                    });

                }
                else {
                    [self.searchTableView setHidden:YES];
                    [message setHidden:NO];
                }
            }
        }
        
    }];

}
#pragma mark - 获取图盘信息
-(void)getStoreGoodsImages
{
    //[[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    customRequest = [[CustomHttpRequest alloc]init];
    if ([customRequest IsCurrentWIFIReached] == YES)
    {
        storeGoodsImages = [[NSMutableArray alloc]init];
        for (int i = 0; i < [self.myStoreGoodsInfo count]; i++) {
            NSString* imgUrl = self.myStoreGoodsInfo[i][@"goods_image_url"]!= (id)[NSNull null]?self.myStoreGoodsInfo[i][@"goods_image_url"]:@"";
            UIImage* currImage = [UIImage imageWithData:[customRequest fetchImageData:imgUrl]];
            if (currImage == nil)
            {
                currImage = [UIImage imageNamed:@"noimage"];
            }
            [storeGoodsImages addObject:currImage];
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchText resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (1 == range.length) {//按下回格键
        [self getSearchGoods];
        return YES;
    }
    if ([string isEqualToString:@"\n"]) {//按下return键
        //这里隐藏键盘，不做任何处理
//        [self getSearchGoods];
        [textField resignFirstResponder];
        return NO;
    }else {
        if ([string length] < 140) {//判断字符个数
            [self getSearchGoods];
            return YES;
        }
    }
    return NO;
}
-(void)promptSingleButtonWarningDialog:(NSString*)msg
{
    UIAlertView* warnAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    warnAlert.tag = 1;
    [warnAlert show];
}
-(void)message
{
    message = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/5, self.view.bounds.size.height/2.5, self.view.bounds.size.width/5*3, self.view.bounds.size.height/20)];
    [message setFont:[UIFont boldSystemFontOfSize:self.view.bounds.size.height/20]];
    [message setTextColor:[UIColor redColor]];
    [message setTextAlignment:NSTextAlignmentCenter];
    [message setText:@"没有相关商品"];
    [self.view addSubview:message];
}
-(void)viewWillAppear:(BOOL)animated
{
    //设置搜索框
    UIImageView *searchBackgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0,30, self.navigationController.view.bounds.size.width/3*2, 30)];
    [searchBackgroundView setUserInteractionEnabled:YES];
    [searchBackgroundView setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.titleView = searchBackgroundView;
    //放大镜图标
    UIImageView *searchImage = [[UIImageView alloc]initWithFrame:CGRectMake(2, 5, 15, 20)];
    [searchImage setContentMode:UIViewContentModeScaleAspectFit];
    [searchImage setImage:[UIImage imageNamed:@"search"]];
    [searchBackgroundView addSubview:searchImage];
    
    self.searchText = [[UITextField alloc]initWithFrame:CGRectMake(25, 5, self.navigationController.view.bounds.size.width/3*1.7, 20)];
    [self.searchText setClearButtonMode:UITextFieldViewModeWhileEditing];//清除按钮
    [self.searchText setTintColor:[UIColor grayColor]];
    
    self.searchText.delegate = self;
    [searchBackgroundView addSubview:self.searchText];
    
    [self creatTableView];
    [self.searchTableView setHidden:YES];
    [self message];
    [message setHidden:YES];

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
