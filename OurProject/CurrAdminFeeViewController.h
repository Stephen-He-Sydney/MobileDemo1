//
//  CurrAdminFeeViewController.h
//  OurProject
//
//  Created by StephenHe on 10/15/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "CommonViewController.h"
#import "OrderView.h"
#import "CurrAdminTableViewCell.h"
#import "WealthView.h"
#import "CurrAdminDetailViewController.h"
#import "CommFunc.h"
#import "CustomHttpRequest.h"

@interface CurrAdminFeeViewController : CommonViewController
<UITableViewDelegate,UITableViewDataSource>
{
    OrderView* orderView;
    WealthView* wealthView;
    UIView* tableViewArea;
    UITableView* adminTableView;
    UIImageView* statisticsArea;
    
    NSArray* adminData;
    float total;
}
@property(nonatomic,strong)NSString* currWage;
@property(nonatomic,strong)NSDictionary* loginInfo;

@end
