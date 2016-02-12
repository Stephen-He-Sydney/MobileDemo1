//
//  WealthView.m
//  OurProject
//
//  Created by StephenHe on 10/12/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "WealthView.h"

@implementation WealthView

-(UICollectionViewFlowLayout*)getFlowlayout
{
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setItemSize:CGSizeMake((CURRSIZE.width)/3, CURRSIZE.width/3)];
    [layout setMinimumInteritemSpacing:0];
    [layout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [layout setMinimumLineSpacing:0];
    
    return layout;
}

-(UICollectionView*)getCollectionView
{
    UICollectionView* collectionView = [[UICollectionView alloc]
                                        initWithFrame:CGRectMake(0, 0, CURRSIZE.width, CURRSIZE.width/3) collectionViewLayout:[self getFlowlayout]];
    
    [collectionView setBackgroundColor:[UIColor clearColor]];
    
    [collectionView registerClass:[WealthCollectionViewCell class] forCellWithReuseIdentifier:@"collectionView"];
    
    return collectionView;
}

-(UITableView*)getCurrentTableView:(UIView*)currContainer
{
    UITableView* tableView = [[UITableView alloc]initWithFrame:currContainer.bounds style:UITableViewStylePlain];
    
    [tableView setUserInteractionEnabled:YES];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return tableView;
}

-(UITableView*)getCurrentTableView:(UINavigationController*)navigationController WithTabController:(UITabBarController*)tabBarController
{
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CURRSIZE.width, CURRSIZE.height - navigationController.navigationBar.frame.size.height - tabBarController.tabBar.frame.size.height) style:UITableViewStylePlain];
    
    [tableView setUserInteractionEnabled:YES];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return tableView;
}

-(UITableView*)getGroupedTableView:(UINavigationController*)navigationController WithTabController:(UITabBarController*)tabBarController
{
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CURRSIZE.width, CURRSIZE.height - navigationController.navigationBar.frame.size.height - tabBarController.tabBar.frame.size.height) style:UITableViewStyleGrouped];
    
    [tableView setUserInteractionEnabled:YES];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return tableView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
