//
//  PreviewViewController.m
//  OurProject
//
//  Created by ibokan on 15/10/14.
//  Copyright (c) 2015年 StephenHe. All rights reserved.
//

#import "PreviewViewController.h"
#import "StoreViewController.h"
#import "MBProgressHUD.h"

@interface PreviewViewController ()<UIWebViewDelegate>
@property(strong,nonatomic)MBProgressHUD *hud;
@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"店铺预览"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.hud = [[MBProgressHUD alloc]init];
    //创建网页视图
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/1.2)];
    //加载网页链接
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://112.74.105.205/zhizu/index.php?s=/Mobile1/Index/index.html&StoreID=%@",self.storeID ]];
//    NSURL *requestURL = [NSURL URLWithString:@"http://www.taobao.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    [webView loadRequest:request];
    //明确当前网页视图是否按原网页比例缩放
    [webView setScalesPageToFit:YES];
    //指定webView的代理
    webView.delegate = self;
    [self.view addSubview:webView];
    
//    //网页后退
//    [webView goBack];
//    //网页前进
//    [webView goForward];
//    //网页重载
//    [webView reload];
//    //网页停止加载
//    [webView stopLoading];

}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    //打开活动指示器
     [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //获取当前连接是否正确
    //    NSLog(@"%@",request.URL);
    //返回值的YES或NO将直接决定webView是否加载当前链接
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    return YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{

    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
//    StoreViewController *storeView = [[StoreViewController alloc]init];
//    storeView.hidesBottomBarWhenPushed = YES;
//    [self.tabBarController setHidesBottomBarWhenPushed:YES];

}
-(void)viewWillDisappear:(BOOL)animated
{
//    StoreViewController *storeView = [[StoreViewController alloc]init];
//    storeView.hidesBottomBarWhenPushed = NO;
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
