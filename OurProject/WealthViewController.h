//
//  WealthViewController.h
//  OurProject
//
//  Created by StephenHe on 10/15/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "CommonViewController.h"
#import "OrderView.h"
#import "WealthView.h"
#import "CurrAdminFeeViewController.h"
#import "RecomPrizeViewController.h"
#import "CustomHttpRequest.h"
#import "CommFunc.h"

@interface WealthViewController : CommonViewController
<UICollectionViewDelegate,
UICollectionViewDataSource,
UITableViewDelegate,
UITableViewDataSource>

{
    OrderView* orderView;
    
    UIView* mainArea;
    
    UICollectionView* wealthCollectionView;
    
    NSArray*btnTxts;
    
    NSArray*btnImages;
    
    WealthView* wealthView;
    
    UIView* tableViewArea;
    
    UITableView* wealthTableView;
    
    NSArray* orderData;
    
    NSDictionary* loginInfo;
}

@property(nonatomic,strong)NSString* currWage;

@end
