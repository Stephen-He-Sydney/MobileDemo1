//
//  AppDelegate.h
//  OurProject
//
//  Created by StephenHe on 10/9/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartAppViewController.h"
#import "CommonViewController.h"
#import "CurrAdminDetailViewController.h"

typedef void(^isNotificationPushed)();
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    int count;
}
@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)isNotificationPushed isPushedReady;

@end

