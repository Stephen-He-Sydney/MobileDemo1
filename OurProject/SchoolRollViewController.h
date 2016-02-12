//
//  SchoolRollViewController.h
//  OurProject
//
//  Created by StephenHe on 10/9/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolRollViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(strong,nonatomic)NSDictionary * loginDic;

@end
