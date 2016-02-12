//
//  OrderDetailViewController.h
//  OurProject
//
//  Created by StephenHe on 10/16/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "CommonViewController.h"
#import "WealthView.h"
#import "OrderDetailTableViewCell.h"
#import "ProductDetailsViewController.h"

@interface OrderDetailViewController : CommonViewController
<UITableViewDelegate,
UITableViewDataSource>
{
    NSDictionary* orderDetailData;
    
    CGFloat cellHeight;
    NSArray* secondSectionTxts;
    NSArray* thirdSectionTxts;
    
    NSData* productImage;
}
@property(nonatomic,strong)NSString* token;
@property (nonatomic,strong)NSString* orderID;
@property (nonatomic,strong)UITableView* orderDetailTableView;
@end
