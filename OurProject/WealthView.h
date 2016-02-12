//
//  WealthView.h
//  OurProject
//
//  Created by StephenHe on 10/12/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalConstants.h"
#import "WealthCollectionViewCell.h"
#import "WealthTableViewCell.h"

@interface WealthView : UIView

-(UICollectionView*)getCollectionView;

-(UITableView*)getCurrentTableView:(UIView*)currContainer;

-(UITableView*)getCurrentTableView:(UINavigationController*)navigationController WithTabController:(UITabBarController*)tabBarController;

-(UITableView*)getGroupedTableView:(UINavigationController*)navigationController WithTabController:(UITabBarController*)tabBarController;

@end
