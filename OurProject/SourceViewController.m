//
//  SourceViewController.m
//  OurProject
//
//  Created by StephenHe on 10/9/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "SourceViewController.h"
#import "SetSourceViewLayout.h"
#import "SourceCollectionViewCell.h"
#import "ProductDetailsViewController.h"
#import "MJRefresh.h"
#import "CustomHttpRequest.h"
#import "CommFunc.h"
#import "MBProgressHUD.h"

@interface SourceViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *buttonsArray;//接收按钮栏设置的内容
    NSArray *screenButtonView;//接收筛选栏设置的内容
    //设置添加、下架按钮
    UIImageView *touchBtn;
    UILabel *strName;
    NSArray *getInfo;//数据请求返回的值
    NSMutableArray *buttonNameArray;
    CustomHttpRequest* customRequest;
    NSMutableArray *imageData;
    //标记上下架
    NSMutableArray *isInStoreArr;
    NSMutableDictionary *isAllInStoreSignDic;
    UIAlertView *warnGoodsAlert;
    UIAlertView *screenAlert;
}
@property(strong,nonatomic)UIImageView *buttonView;
@property(strong,nonatomic)UIImageView *stopView;
@property(strong,nonatomic)UIScrollView *screenView;
@property(strong,nonatomic)UICollectionView *collectionView;
@property(strong,nonatomic)UIImageView *scrollBar;
@property(strong,nonatomic)NSDictionary *loginInfo;
@property(strong,nonatomic)UIAlertView *toolTip;
@property(strong,nonatomic)NSMutableArray *gcIDArr;
@property(strong,nonatomic)NSMutableArray *gcNameArr;
@property(strong,nonatomic)NSMutableArray *goodsInfoArr;
@property(strong,nonatomic)MBProgressHUD *hud;
@property(strong,nonatomic)NSArray *collectionViewInfoArr;
@end

NSString *collectionID = @"collectionID";
//存储图片
static NSMutableDictionary *saveAllimages;
static NSMutableDictionary *saveAllScreenImages;
//存储数据
static NSMutableDictionary *saveAllInfoDic;
//筛选按钮数组
static NSMutableArray *screenNameArr;
//判断图片的加载方式
static BOOL loadGoodsImage;
static NSMutableDictionary *timesDic;
static int n = 0;//用于获取当前按钮是gcIDArr或gcNameArr哪个
static int reloadTime = 0;
static int loadTime = 0;
@implementation SourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"货源";
    
    //实例化
    buttonNameArray = [[NSMutableArray alloc]init];
    _gcNameArr = [[NSMutableArray alloc]init];
    _gcIDArr = [[NSMutableArray alloc]init];
    screenNameArr = [[NSMutableArray alloc]init];
    saveAllimages = [[NSMutableDictionary alloc]init];
    saveAllScreenImages = [[NSMutableDictionary alloc]init];
    saveAllInfoDic = [[NSMutableDictionary alloc]init];
    loadGoodsImage = YES;
    timesDic = [[NSMutableDictionary alloc]init];

    
    _loginInfo = [CommFunc readUserLogin];//获取登录信息
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self getDataMethodForClassifies];//获取货源商品类目数据
    
    isInStoreArr = [[NSMutableArray alloc]init];
    
    saveAllInfoDic = [[NSMutableDictionary alloc]init];
    [self.hud hide:YES];
    
}
#pragma mark - 设置筛选及其按钮的功能
-(void)setScreenButton
{
    //筛选按钮
    UIBarButtonItem *screenBtn = [[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStyleDone target:self action:@selector(screenAction:)];
    [screenBtn setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = screenBtn;
}
//筛选按钮的功能
-(void)screenAction:(id)sender
{
    if (self.screenView.hidden == YES) {
        self.screenView.hidden = NO;
        self.stopView.hidden = NO;
        self.buttonView.userInteractionEnabled = NO;
        self.collectionView.userInteractionEnabled = NO;
        
        //筛选里面的按钮
        for (int i = 2; i < [screenButtonView count]; i++) {
            [screenButtonView[i] addTarget:self action:@selector(screenBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    else {
        self.screenView.hidden = YES;
        self.stopView.hidden = YES;
        self.buttonView.userInteractionEnabled = YES;
        self.collectionView.userInteractionEnabled = YES;
    }
    
}
//筛选界面里面的按钮功能
-(void)screenBtnAction:(UIButton *)sender
{
    self.collectionViewInfoArr = nil;
    [self.collectionView reloadData];
    [self getScreenData:_gcIDArr[n] brandID:getInfo[n][@"brand_list"][sender.tag][@"brand_id"]];
    self.screenView.hidden = YES;
    self.stopView.hidden = YES;
    self.buttonView.userInteractionEnabled = YES;
    self.collectionView.userInteractionEnabled = YES;
    
}
#pragma mark - 筛选按钮的数据请求
-(void)getScreenData:(NSString *)gcID brandID:(NSString *)brandID
{
    int pageIndex = 0;
    loadGoodsImage = NO;
    NSString* serverUrl = @"goods/showList";
    NSString* paramUrl = [NSString stringWithFormat:@"{\"gcId\":\"%@\",\"token\":\"%@\",\"Storeid\":\"%@\",\"PageIndex\":\"%d\",\"pageCount\":\"20\",\"brandId\":\"%@\"}",gcID,_loginInfo[@"data"][@"token"],_loginInfo[@"data"][@"Store"][0][@"id"],pageIndex,brandID];

    CommonViewController* commCtrl = [[CommonViewController alloc]init];
    [commCtrl handleServerSideInfo:serverUrl WithParamUrl:paramUrl];
    
    commCtrl.jsonData = ^(NSDictionary* info)
    {
        if (info != nil) {
        
            if ([info[@"data"] count] > 0) {
                self.collectionViewInfoArr = info[@"data"];
                [self creatCollectionView];
                screenButtonView = [SetSourceViewLayout setScreenBtn:self buttonName:screenNameArr];//接收返回的筛选按钮的内容
                self.stopView = screenButtonView[0];//筛选按钮显示时的背景
                self.screenView = screenButtonView[1];//筛选按钮
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [self getGoodsImagesforGoods:NO];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionView reloadData];
                        [self.hud hide:YES];
                    });
                });

            }
            else {
                screenAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂无数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [screenAlert show];
            }
            
        }
    };
}
#pragma mark - 设置按钮及其执行的动作
-(void)setButtons
{
    static int num = 0;
    buttonsArray = [SetSourceViewLayout setButtons:self andButtonsName:_gcNameArr];//接收按钮栏设置的内容
    self.buttonView = buttonsArray[0];//按钮栏
    [self.hud show:YES];
    self.scrollBar = [SetSourceViewLayout setScrollBar:self.buttonView andLehgth:(int)[_gcNameArr[0] length]*30];//滚动条
    [_scrollBar setBackgroundColor:[UIColor colorWithRed:0.931 green:0.225 blue:0.131 alpha:1.000]];
    
    num = (int)[_gcNameArr count];
    for (int i = 1; i < [buttonsArray count]; ++i) {
//        [buttonsArray[i] addTarget:self action:@selector(buttonsAction:) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonsAction:)];
        [buttonsArray[i] addGestureRecognizer:tap];
    }
    
    
}
//按钮栏按钮的功能
-(void)buttonsAction:(UITapGestureRecognizer *)sender
{
    MBProgressHUD* progressMark = [[MBProgressHUD alloc]initWithView:self.view];
    [progressMark show:YES];
    [self.view addSubview:progressMark];
    [progressMark hide:YES afterDelay:1];
    loadGoodsImage = YES;
    n = (int)sender.view.tag;
    //利用tag的值，获取点击的tag值，从而进行位置的偏移
    [UIView animateWithDuration:0.2 animations:^{
        [self.scrollBar setFrame:CGRectMake([_gcNameArr[0] length]*30*sender.view.tag, self.buttonView.bounds.size.height-3, [_gcNameArr[sender.view.tag] length]*25, 3)];
    }];
    
    self.collectionViewInfoArr = nil;
    [self.collectionView reloadData];
    
    [self getDataMethodForShowList:(int)sender.view.tag];
    screenNameArr = [[NSMutableArray alloc]init];//重置
    if (([getInfo[n][@"brand_list"] isKindOfClass:[NSArray class]]||[getInfo[n][@"brand_list"] isKindOfClass:[NSDictionary class]])&& [getInfo[n][@"brand_list"] count] > 0){
            for (int i = 0; i < [getInfo count]; i++) {
                [screenNameArr addObject:getInfo[n][@"brand_list"][i][@"brand_name"]];
                

            }
        
    }
    
    
}
#pragma mark - 创建collectionView及方法
-(void)creatCollectionView
{
    self.collectionView = [SetSourceViewLayout setCollectionVIew:self andCollectionID:collectionID];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
//    [_collectionView addHeaderWithTarget:self action:@selector(updateCollectionView:)];
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.collectionViewInfoArr count];
}
-(SourceCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    SourceCollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionID forIndexPath:indexPath];
    
    [collectionCell setBackgroundColor:[UIColor colorWithRed:0.994 green:1.000 blue:0.949 alpha:1.000]];//指定背景色
    [collectionCell setUserInteractionEnabled:YES];
    
    if (collectionCell.imageShow.image != nil) {
        collectionCell.imageShow.image = nil;
    }
    
    if ([self.collectionViewInfoArr count] > 0 && [self.collectionViewInfoArr count] > 0) {
        [collectionCell.commodityName setText:self.collectionViewInfoArr[indexPath.row][@"goods_name"]];
        [collectionCell.priceShow setText:[NSString stringWithFormat:@"%@",self.collectionViewInfoArr[indexPath.row][@"goods_price"]]];
    }
    if (loadGoodsImage == YES) {
        if ([saveAllimages[self.gcIDArr[n]] count] == self.collectionViewInfoArr.count) {
            UIImage *image = saveAllimages[self.gcIDArr[n]][indexPath.row];
            [collectionCell.imageShow setImage:image];
        }
    }
    else{
        
        if ([saveAllScreenImages[self.gcIDArr[n]] count] == self.collectionViewInfoArr.count) {
            UIImage *image = saveAllScreenImages[self.gcIDArr[n]][indexPath.row];
            [collectionCell.imageShow setImage:image];
        }

    }

    UITapGestureRecognizer *changeBtn = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addAndRemoveAction:)];
    [collectionCell.touchBtn addGestureRecognizer:changeBtn];
    collectionCell.touchBtn.tag = indexPath.row;
    
    //检索该商品是否加入店铺
    NSString *isInStore = self.collectionViewInfoArr[indexPath.row][@"isInStore"];
    if (isAllInStoreSignDic[self.collectionViewInfoArr[indexPath.row][@"goods_id"]] == nil) {
        [isAllInStoreSignDic setObject:isInStore forKey:self.collectionViewInfoArr[indexPath.row][@"goods_id"]];
    }
    
    if ([isAllInStoreSignDic[self.collectionViewInfoArr[indexPath.row][@"goods_id"]] intValue] == 0) {
        [collectionCell.touchBtn setImage:[UIImage imageNamed:@"wdspk_icon1"]];
        [collectionCell.strName setText:@"添加"];
    }
    else {
        [collectionCell.touchBtn setImage:[UIImage imageNamed:@"wdspk_icon"]];
        [collectionCell.strName setText:@"下架"];
    }

    return collectionCell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailsViewController *commodityView = [[ProductDetailsViewController alloc]init];
    commodityView.goodsID = self.collectionViewInfoArr[indexPath.row][@"goods_id"];
    commodityView.token = _loginInfo[@"data"][@"token"];
    commodityView.storeID = _loginInfo[@"data"][@"Store"][0][@"id"];
    commodityView.indexPath = (int)indexPath.row;
    [self.navigationController pushViewController:commodityView animated:YES];
    reloadTime --;
}

//-(void)updateCollectionView:(id)sender
//{
//    //关闭下拉效果
//    [_collectionView headerEndRefreshing];
//    //数据重载
//    [_collectionView reloadData];
//}

#pragma mark - 获取货源商品类目数据
-(void)getDataMethodForClassifies
{
    NSString* serverUrl = @"goods/classifies";
    NSString* paramUrl = [NSString stringWithFormat:@"{\"token\":\"%@\"}",_loginInfo[@"data"][@"token"]];
    
    CommonViewController* commCtrl = [[CommonViewController alloc]init];
    [commCtrl handleServerSideInfo:serverUrl WithParamUrl:paramUrl];
    
    commCtrl.jsonData = ^(NSDictionary* info)
    {
        if (info != nil) {
            getInfo = info[@"data"];
            for (int i = 0; i < [getInfo count]; i++) {
                [screenNameArr addObject:getInfo[0][@"brand_list"][i][@"brand_name"]];
            }
            
            for (NSDictionary *dic in getInfo) {
                NSString *gcID = [dic objectForKey:@"gc_id"];
                NSString *gcName = [dic objectForKey:@"gc_name"];
                [_gcIDArr addObject:gcID];
                [_gcNameArr addObject:gcName];
            
            }
            [self setButtons];//设置其他按钮


        }
        else {
                _toolTip = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂无数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [_toolTip show];
        }
    };
    
}
#pragma mark - 获取货源商品列表数据
-(void)getDataMethodForShowList:(int)time
{
   
    int pageIndex = 0;
    NSString* serverUrl = @"goods/showList";
    
    NSString* paramUrl = [NSString stringWithFormat:@"{\"gcId\":\"%@\",\"token\":\"%@\",\"Storeid\":\"%@\",\"PageIndex\":\"%d\",\"pageCount\":\"20\"}",_gcIDArr[abs(time)],_loginInfo[@"data"][@"token"],_loginInfo[@"data"][@"Store"][0][@"id"],pageIndex];
    
    CommonViewController* commCtrl = [[CommonViewController alloc]init];
    [commCtrl handleServerSideInfo:serverUrl WithParamUrl:paramUrl];
    
    commCtrl.jsonData = ^(NSDictionary* info)
    {
        if (info != nil) {
            _goodsInfoArr = info[@"data"];
            if (time >= 0) {
                if (([saveAllInfoDic[_gcIDArr[time]] count] == 0) || (![saveAllInfoDic[_gcIDArr[time]] isEqualToArray:_goodsInfoArr])) {
                    [saveAllInfoDic setObject:_goodsInfoArr forKey:_gcIDArr[time]];

                }
                if (time == n) {
                    self.collectionViewInfoArr = saveAllInfoDic[_gcIDArr[n]];
                    [self creatCollectionView];
                    [self setScreenButton];//设置筛选按钮
                    screenButtonView = [SetSourceViewLayout setScreenBtn:self buttonName:screenNameArr];//接收返回的筛选按钮的内容
                    self.stopView = screenButtonView[0];//筛选按钮显示时的背景
                    self.screenView = screenButtonView[1];//筛选按钮
                    //获取图片
                    if (self.collectionViewInfoArr.count > 0 && [saveAllimages[self.gcIDArr[n]] count] != self.collectionViewInfoArr.count)
                    {
                        if ([saveAllimages[self.gcIDArr[n]] count] != 0) {
                            [saveAllimages removeObjectForKey:saveAllimages[self.gcIDArr[n]]];
                        }
                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                [self getGoodsImagesforGoods:YES];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self.collectionView reloadData];
                                });
                            });
                    }

                    //数据为空时
                    if ([self.collectionViewInfoArr count] ==0) {
                        [self.hud hide:YES];
                        warnGoodsAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂无数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [warnGoodsAlert show];
                    }
                }
                [self.hud hide:YES];
            }
            else{
                [saveAllInfoDic setObject:_goodsInfoArr forKey:_gcIDArr[-time]];
                self.collectionViewInfoArr = saveAllInfoDic[_gcIDArr[n]];
                [self creatCollectionView];
            }
        }
    };
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == warnGoodsAlert) {
        [self buttonsAction:nil];
    }
    else if (alertView == screenAlert)
    {
        [self buttonsAction:nil];
    }
}
#pragma mark - 获取图盘信息
-(void)getGoodsImagesforGoods:(BOOL)isOrNo
{
    
        customRequest = [[CustomHttpRequest alloc]init];
        if ([customRequest IsCurrentWIFIReached] == YES)
        {
            imageData = [[NSMutableArray alloc]init];
            for (int i = 0; i < [self.collectionViewInfoArr count]; i++) {
                NSString* imgUrl = self.collectionViewInfoArr[i][@"goods_image_url"]!= (id)[NSNull null]?self.collectionViewInfoArr[i][@"goods_image_url"]:@"";
                    
                    UIImage* currImage = [UIImage imageWithData:[customRequest fetchImageData:imgUrl]];
                if (currImage == nil)
            {
                currImage = [UIImage imageNamed:@"noimage"];
            }
            [imageData addObject:currImage];
        }
        if (isOrNo == YES) {
                    [saveAllimages setObject:imageData forKey:_gcIDArr[n]];
        }
        else [saveAllScreenImages setObject:imageData forKey:_gcIDArr[n]];
    }

}

-(void)promptSingleButtonWarningDialog:(NSString*)msg
{
    UIAlertView* warnAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    warnAlert.tag = 1;
    [warnAlert show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 添加、下架按钮的功能及数据请求
-(void)addAndRemoveAction:(UITapGestureRecognizer *)sender
{
    
//    NSString *theIsInStore =self.collectionViewInfoArr[sender.view.tag][@"isInStore"];
    if ([isAllInStoreSignDic[self.collectionViewInfoArr[sender.view.tag][@"goods_id"]] intValue] == 0) {
        [self goodsPutaway:(int)sender.view.tag];
    }
    else {
        [self goodsSoldOut:(int)sender.view.tag];
    
    }
    
    
}
//上架数据请求
-(void)goodsPutaway:(int)indexPath
{
    CustomHttpRequest* httpRequest = [[CustomHttpRequest alloc]init];
    
    NSString* serverUrl = @"Store/addgoods";
    NSString* paramUrl = [NSString stringWithFormat:@"{\"token\":\"%@\",\"store_goods\":[{\"store_id\":\"%@\",\"goods_id\":\"%@\"}]}",_loginInfo[@"data"][@"token"],_loginInfo[@"data"][@"Store"][0][@"id"],self.collectionViewInfoArr[indexPath][@"goods_id"]];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [httpRequest fetchResponseByPost:serverUrl WithParameter:paramUrl WithResponse:^(NSDictionary *info) {
        if ([info objectForKey:@"fail"])
        {
            [self promptSingleButtonWarningDialog:@"网络不给力，请稍候"];
        }
        else
        {
            if (info[@"data"]!= (id)[NSNull null])
            {
                [isAllInStoreSignDic setObject:[NSString stringWithFormat:@"%d",1] forKey:self.collectionViewInfoArr[indexPath][@"goods_id"]];
                [self.collectionView reloadData];
                UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:info[@"info"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [aler show];
                
            }
        }
        
    }];
    
}
//下架数据请求
-(void)goodsSoldOut:(int)indexPath
{
    CustomHttpRequest* httpRequest = [[CustomHttpRequest alloc]init];
    
    NSString* serverUrl = @"Store/removeSingleGoods";
    NSString* paramUrl = [NSString stringWithFormat:@"{\"token\":\"%@\",\"store_id\":\"%@\",\"goods_id\":\"%@\"}",_loginInfo[@"data"][@"token"],_loginInfo[@"data"][@"Store"][0][@"id"],self.collectionViewInfoArr[indexPath][@"goods_id"]];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [httpRequest fetchResponseByPost:serverUrl WithParameter:paramUrl WithResponse:^(NSDictionary *info) {
        if ([info objectForKey:@"fail"])
        {
            [self promptSingleButtonWarningDialog:@"网络不给力，请稍候"];
        }
        else
        {
            if (info[@"data"]!= (id)[NSNull null])
            {
                [isAllInStoreSignDic setObject:[NSString stringWithFormat:@"%d",0] forKey:self.collectionViewInfoArr[indexPath][@"goods_id"]];
                [self.collectionView reloadData];
                UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:info[@"info"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [aler show];
                
            }
        }
        
    }];
    

}

-(void)viewDidAppear:(BOOL)animated
{
    isAllInStoreSignDic = [[NSMutableDictionary alloc]init];
    if (loadTime < 1) {
        for (int i = 0; i < [screenNameArr count]; ++i) {
            [self getDataMethodForShowList:i];
        }
        loadTime ++;
        reloadTime ++;
    }
    if (reloadTime < 1) {
        [self getDataMethodForShowList:n];
    }

}
-(void)viewWillAppear:(BOOL)animated
{
    MBProgressHUD* progressMark = [[MBProgressHUD alloc]initWithView:self.view];
    [progressMark show:YES];
    [self.view addSubview:progressMark];
    [progressMark hide:YES afterDelay:1];

}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
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
