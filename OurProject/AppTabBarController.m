//
//  AppTabBarController.m
//  OurProject
//
//  Created by StephenHe on 10/9/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "AppTabBarController.h"

@interface AppTabBarController ()

@end

@implementation AppTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(UITabBarController*)LoadTabBarAndNavComponents
{
    UINavigationController* orderPageNav =[self getUINavigationController:@"OrderViewController"];
    
    UINavigationController* sourceViewNav =[self getUINavigationController:@"SourceViewController"];
    
    UINavigationController* storeNav =[self getUINavigationController:@"StoreViewController"];
    
    UINavigationController* myAdminNav =[self getUINavigationController:@"MyAdminViewController"];
    
    UINavigationController* chatNav =[self getUINavigationController:@"ChatViewController"];
    
    //设置 tab Bar
    NSArray* allNavs =@[orderPageNav,sourceViewNav,storeNav,myAdminNav,chatNav];
    
    return [self getTabBarComponents:allNavs];
}

-(UITabBarController*) getTabBarComponents:(NSArray*)allNavs
{
    UITabBarController* myTabBar = [[UITabBarController alloc] init];
    [myTabBar setViewControllers:allNavs];
    
    NSArray* tabNames = @[@"订单",@"货源",@"店铺",@"我的",@"交流"];
    NSArray* tabImages = @[@"home_menu_01_a",@"home_menu_03_a",@"tab_shop",@"home_menu_02_a",@"home_menu_04_a"];
    NSArray* tabSelectedImages = @[@"home_menu_01",@"home_menu_03",@"tab_shop_selected",@"home_menu_02",@"home_menu_04"];
    
    for (int i = 0; i < 5; i++) {
        [myTabBar.tabBar.items[i] setTitle:[tabNames objectAtIndex:i]];
        
        UIImage* currImage = [UIImage imageNamed:[tabImages objectAtIndex:i]];
        
        [myTabBar.tabBar.items[i] setImage:currImage];
        
        UIImage* selectedImage = [UIImage imageNamed:[tabSelectedImages objectAtIndex:i]];
        
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [myTabBar.tabBar.items[i] setSelectedImage:selectedImage];
        [myTabBar.tabBar setTintColor:[CommonViewController getCurrRedColor]];
    }
    return myTabBar;
}

-(UINavigationController*) getUINavigationController:(NSString*) className
{
    id currPage = [[NSClassFromString(className) alloc] init];
    
    [((UIViewController*)currPage).view setBackgroundColor:[UIColor whiteColor]];
    
    UINavigationController* currPageNav = [[UINavigationController alloc]
                                           initWithRootViewController:currPage];
 
    [currPageNav.navigationBar setBarTintColor:[CommonViewController getCurrRedColor]];
    
    [currPageNav.navigationBar setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:23.0f],
                                                        
                                                        }];
    
    currPageNav.navigationBar.translucent = NO;
    //否则ios系统8.0开始，导航栏是透明的，不占高度了,需要往下移动64
    
    return currPageNav;
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
