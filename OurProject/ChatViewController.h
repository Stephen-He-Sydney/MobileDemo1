//
//  ChatViewController.h
//  OurProject
//
//  Created by StephenHe on 10/9/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)NSDictionary * loginDic;
@end
