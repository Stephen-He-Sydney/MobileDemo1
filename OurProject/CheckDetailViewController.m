//
//  CheckDetailViewController.m
//  OurProject
//
//  Created by ibokan on 15/10/13.
//  Copyright (c) 2015年 StephenHe. All rights reserved.
//

#import "CheckDetailViewController.h"

@interface CheckDetailViewController ()<UIWebViewDelegate>

@end

@implementation CheckDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"商品详情"];
    //创建网页视图
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    //加载网页链接
        NSURL *requestURL = [NSURL URLWithString:self.URLString];
//    NSURL *requestURL = [NSURL URLWithString:@"http://www.taobao.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    [webView loadRequest:request];
    //明确当前网页视图是否按原网页比例缩放
    [webView setScalesPageToFit:YES];
    //指定webView的代理
    webView.delegate = self;
    [self.view addSubview:webView];
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    //打开活动指示器
    
    
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
