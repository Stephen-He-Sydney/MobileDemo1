//
//  AppDelegate.m
//  OurProject
//
//  Created by StephenHe on 10/9/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //change back button style
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    
    NSDictionary* loginInfo = [CommFunc readUserLogin];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isLogined"] == nil|| loginInfo.count == 0)
    {
        StartAppViewController* startCtrl = [[StartAppViewController alloc]init];
        UINavigationController* navCtrl = [[UINavigationController alloc] initWithRootViewController:startCtrl];
        navCtrl.navigationBar.hidden = YES;
        
        [navCtrl.navigationBar setBarTintColor:[CommonViewController getCurrRedColor]];
        
        //Change main title style
        [navCtrl.navigationBar setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:23.0f],
                                                        
                                                        }];
        //self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        //删除main和箭头后需添加以上代码，否则失去启动窗口
        
        [self.window setRootViewController:navCtrl];
    }
    else  //自动登录
    {
        NSString* serverUrl = @"Index/login";
        NSString* paramUrl = [NSString stringWithFormat:@"{\"moblie\":\"%@\",\"password\":\"%@\",\"oswer_status\":2}",loginInfo[@"mobile"],loginInfo[@"password"]];
        
        CommonViewController* comm = [[CommonViewController alloc]init];
        [comm autoLogin:serverUrl WithParamUrl:paramUrl WithLoginInfo:loginInfo];
        
        comm.isReady = ^(UITabBarController* appTabCtrl)
        {
            [self.window.rootViewController presentViewController:appTabCtrl animated:YES completion:nil];
        };
    }
    
    [self.window makeKeyAndVisible];
    
    //第三方分享
    [UMSocialData setAppKey:@"507fcab25270157b37000010"];
    
    //远程通知准备
    [self isAllowClientReceivingNotification];
    
    return YES;
}

#pragma mark - 通知用户是否接收通知
-(void)isAllowClientReceivingNotification
{
    //iOS8.0之后版本
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8)
    {
        [[UIApplication sharedApplication]registerForRemoteNotifications];
        
        UIUserNotificationType types = UIUserNotificationTypeAlert|
        UIUserNotificationTypeSound|
        UIUserNotificationTypeBadge;
        
        UIUserNotificationSettings* setting = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication]registerUserNotificationSettings:setting];
    }
    else
    {
        [[UIApplication sharedApplication]registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    }
}

#pragma mark - 用户已注册远程通知
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

#pragma mark - 将应用程序的token发送给apple server，来通过验证获取通知
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // convert token into string
    NSString * token =[NSString stringWithFormat:@"%@",deviceToken];
    
    //remove all whitessapaces and curve bracket
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    [self sendToServerWithToken:token];
}

#pragma mark - 发送token给服务端
-(void)sendToServerWithToken:(NSString*)token
{
    NSDictionary* loginInfo = [CommFunc readUserLogin];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isLogined"] != nil
        && loginInfo.count > 0)
    {
        NSString* serverUrl = @"public/addDeviceToken";
        NSString* paramUrl = [NSString stringWithFormat:@"{\"deviceToken\":\"%@\",\"uid\":\"%@\",\"type\":1}",token,loginInfo[@"data"][@"users_id"]];
        
        CommonViewController* commCtrl = [[CommonViewController alloc]init];
        [commCtrl handleServerSideInfo:serverUrl WithParamUrl:paramUrl];
        
        commCtrl.jsonData = ^(NSDictionary* info)
        {
        };
    }
}

#pragma mark - 执行通知接收之后的行为
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSDictionary* loginInfo = [CommFunc readUserLogin];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isLogined"] != nil
        && loginInfo.count > 0)
    {
        application.applicationIconBadgeNumber = ++count;
        
        if(self.isPushedReady != nil)
        {
            self.isPushedReady();
        }
    }
}

#pragma mark - 应用程序激活后的状态
-(void)applicationDidBecomeActive:(UIApplication *)application
{
    if (application.applicationIconBadgeNumber > 0)
    {
        application.applicationIconBadgeNumber = 0;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
