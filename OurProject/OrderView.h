//
//  OrderView.h
//  OurProject
//
//  Created by StephenHe on 10/10/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalConstants.h"
#import "OrderCollectionViewCell.h"
#import "CommonViewController.h"

@interface OrderView : UIView
{
    UIImageView* tapArea;
}
-(UICollectionView*)getCollectionView:(UIView*)currContainer;

-(UIImageView*)getImageViewPanel:(float)heightPercent;

-(UIView*)getContentPanel:(UINavigationController*)navigationController;

-(UIView*)getContentPanel:(UINavigationController*)navigationController WithTabController:(UITabBarController*)tabBarController;

@end
