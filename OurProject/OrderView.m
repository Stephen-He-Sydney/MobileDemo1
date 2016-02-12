//
//  OrderView.m
//  OurProject
//
//  Created by StephenHe on 10/10/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "OrderView.h"

@implementation OrderView

-(UICollectionViewFlowLayout*)getFlowlayout:(UIView*)container
{
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setItemSize:CGSizeMake((CURRSIZE.width)/3, container.frame.size.height/2)];
    [layout setMinimumInteritemSpacing:0];
    [layout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [layout setMinimumLineSpacing:0];
    
    return layout;
}

-(UICollectionView*)getCollectionView:(UIView*)currContainer
{
    UICollectionView* collectionView = [[UICollectionView alloc]
                                        initWithFrame:currContainer.bounds collectionViewLayout:[self getFlowlayout:currContainer]];
    
    [collectionView setBackgroundColor:[UIColor clearColor]];
    
    [collectionView registerClass:[OrderCollectionViewCell class] forCellWithReuseIdentifier:@"collectionView"];
    
    return collectionView;
}

-(UIImageView*)getImageViewPanel:(float)heightPercent
{
    tapArea = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CURRSIZE.width, CURRSIZE.height*heightPercent)];
    //at viewDidAppear, the height is no longer required to start after navigationController
    
    [tapArea setUserInteractionEnabled:YES];
    [tapArea setBackgroundColor:[CommonViewController getCurrRedColor]];
    
    return tapArea;
}

-(UIView*)getContentPanel:(UINavigationController*)navigationController
{
    UIView* collectionButtonArea = [[UIView alloc]init];
    
    [collectionButtonArea setFrame:CGRectMake(0, tapArea.frame.origin.y + tapArea.frame.size.height, CURRSIZE.width, CURRSIZE.height - navigationController.navigationBar.frame.size.height - tapArea.frame.size.height)];
    
    return collectionButtonArea;
}

-(UIView*)getContentPanel:(UINavigationController*)navigationController WithTabController:(UITabBarController*)tabBarController
{
    UIView* collectionButtonArea = [[UIView alloc]init];
    
    [collectionButtonArea setFrame:CGRectMake(0, tapArea.frame.origin.y + tapArea.frame.size.height, CURRSIZE.width, CURRSIZE.height - navigationController.navigationBar.frame.size.height - tapArea.frame.size.height - tabBarController.tabBar.frame.size.height)];
 
    return collectionButtonArea;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
