//
//  AppTabBarController.h
//  OurProject
//
//  Created by StephenHe on 10/9/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface AppTabBarController : UITabBarController
<UITabBarControllerDelegate>

-(UITabBarController*)LoadTabBarAndNavComponents;

@end
