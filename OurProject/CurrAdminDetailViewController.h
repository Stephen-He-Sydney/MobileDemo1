//
//  CurrAdminDetailViewController.h
//  OurProject
//
//  Created by StephenHe on 10/15/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "CommonViewController.h"
#import "WealthView.h"
#import "BuyerInfoTableViewCell.h"
#import "CustomHttpRequest.h"
#import "CommFunc.h"
#import "OrderDetailViewController.h"
#import "MJRefresh.h"

@interface CurrAdminDetailViewController : CommonViewController
<UITableViewDelegate, UITableViewDataSource>
{
    WealthView* wealthView;
    NSArray* adminDetailData;
    CGFloat cellHeight;
    CGFloat cellWidth;
    int pageIndex;
    NSMutableArray* imageData;
    
    NSMutableArray* refreshingData;
    
    NSString* serverUrl;
    NSString* paramUrl;
}

@property(nonatomic,strong)NSString* status;
@property(nonatomic,strong)NSString* storeID;
@property(nonatomic,strong)NSString* token;
@property(nonatomic,strong)NSString* usersID;
@property(nonatomic,assign)BOOL isNotRequiredTitle;
@property(nonatomic,strong)UITableView* buyInfoTableView;

@end
