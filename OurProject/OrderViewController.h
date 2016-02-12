//
//  OrderViewController.h
//  OurProject
//
//  Created by StephenHe on 10/15/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "CommonViewController.h"
#import "GlobalConstants.h"
#import "OrderView.h"
#import "WealthViewController.h"
#import "CustomHttpRequest.h"
#import "CommFunc.h"
#import "CurrAdminDetailViewController.h"
#import "AppDelegate.h"

typedef void(^isLoadingDataReady)();
@interface OrderViewController : CommonViewController
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>
{
    UICollectionView* orderCollectionView;
    UIView* collectionButtonArea;
    NSArray* btnImages;
    NSArray* btnTxts;
    NSArray* btnExplan;
    OrderView* orderView;
    
    float totalRevenue;
    float currWage;
    NSArray* currStatus;
}
@property(nonatomic,strong)UIImageView* tapArea;
@property(nonatomic,strong)isLoadingDataReady isDataReady;
@end
