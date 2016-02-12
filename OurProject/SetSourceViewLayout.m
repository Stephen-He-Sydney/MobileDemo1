//
//  SetSourceViewLayout.m
//  OurProject
//
//  Created by ibokan on 15/10/10.
//  Copyright (c) 2015年 StephenHe. All rights reserved.
//

#import "SetSourceViewLayout.h"
#import "GlobalConstants.h"
#import "SourceCollectionViewCell.h"

@implementation SetSourceViewLayout

#pragma mark - 设置按钮栏按钮
+(NSMutableArray *)setButtons:(UIViewController *)myController andButtonsName:(NSMutableArray *)buttonName
{
    NSMutableArray *buttons = [[NSMutableArray alloc]init];
        
    float buttonsViewLength = 0;
    for (NSString *name in buttonName) {
        buttonsViewLength +=[name length]*25;
    }
    
    UIScrollView *buttonsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,CURRSIZE.width, CURRSIZE.height/15)];
    [buttonsView setBackgroundColor:[UIColor colorWithWhite:0.789 alpha:1.000]];
    [buttonsView setUserInteractionEnabled:YES];
    [buttonsView setContentSize:CGSizeMake(buttonsViewLength, 0)];
    [buttonsView setShowsHorizontalScrollIndicator:NO];
    [myController.view addSubview:buttonsView];
    
    [buttons addObject:buttonsView];
    
    float buttonWidth = 10;//用户计算button的横向开始位置
    
//    for (int i = 0; i < [buttonName count]; ++i) {
//        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//        [button setTitle:[NSString stringWithFormat:@"%@",buttonName[i]] forState:UIControlStateNormal];
//        [button setFrame:CGRectMake(buttonWidth,0, [buttonName[i] length]*20, buttonsView.bounds.size.height)];
//        buttonWidth += [buttonName[i] length]*30;//用于计算下一个button的横向开始位置
//        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:buttonsView.bounds.size.height/2.5]];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button setTag:i];
//        [buttonsView addSubview:button];
//        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
//        [buttons addObject:button];
//    }
    
    for (int i = 0; i < [buttonName count]; ++i) {
        
        UILabel *button = [[UILabel alloc]initWithFrame:CGRectMake(buttonWidth,0, [buttonName[i] length]*20, buttonsView.bounds.size.height)];
        buttonWidth += [buttonName[i] length]*30;//用于计算下一个button的横向开始位置
        [button setFont:[UIFont boldSystemFontOfSize:buttonsView.bounds.size.height/2.5]];
        [button setText:[NSString stringWithFormat:@"%@",buttonName[i]]];
        [button setTextColor:[UIColor blackColor]];
        [button setTag:i];
        [buttonsView addSubview:button];
        [button setTextAlignment:NSTextAlignmentCenter];
        [button setUserInteractionEnabled:YES];
        [buttons addObject:button];
    }
    
    return buttons;
}

#pragma mark - 设置筛选按钮
+(NSMutableArray *)setScreenBtn:(UIViewController *)myController buttonName:(NSMutableArray *)screenBtnName
{
    NSMutableArray *screenInfo = [[NSMutableArray alloc]init];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:myController.view.bounds];
    [imageView setBackgroundColor:[UIColor blackColor]];
    [imageView setHidden:YES];
    [imageView setAlpha:0.5];
    [myController.view addSubview:imageView];
    
    [screenInfo addObject:imageView];
    
    UIScrollView *screenView = [[UIScrollView alloc]initWithFrame:CGRectMake(CURRSIZE.width/1.8, 0, CURRSIZE.width/2.2, [screenBtnName count]*40)];
    [screenView setBackgroundColor:[UIColor whiteColor]];
    [screenView setHidden:YES];
    if ([screenBtnName count]*40 > CURRSIZE.height) {
        [screenView setContentSize:CGSizeMake(0,[screenBtnName count]*40)];
    }
    
    [screenView setShowsVerticalScrollIndicator:YES];
    [myController.view addSubview:screenView];
    
    [screenInfo addObject:screenView];
    
    for (int i = 0; i < [screenBtnName count]; ++i) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:[NSString stringWithFormat:@"%@",screenBtnName[i]] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(screenView.bounds.size.width/10, 40*i, 100, 40)];
        [button setTag:i];
        [screenView addSubview:button];
        
        [screenInfo addObject:button];
    }
    
    
    return screenInfo;
}
#pragma mark - 设置collectionVIew
+(UICollectionView *)setCollectionVIew:(UIViewController *)myController andCollectionID:(NSString *)strID
{
    
    
    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc]init];
    //设置格子的大小
    [collectionLayout setItemSize:CGSizeMake(CURRSIZE.width/2.2, CURRSIZE.height/3)];
    //设置格子之间的距离
    [collectionLayout setMinimumInteritemSpacing:3];
    //设置格子四周的距离
    [collectionLayout setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    //设置尾视图
    [collectionLayout setFooterReferenceSize:CGSizeMake(CURRSIZE.width, 20)];
    
    UICollectionView *myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CURRSIZE.height/15, CURRSIZE.width, CURRSIZE.height/1.3) collectionViewLayout:collectionLayout];
    //设置单元格背景色
    [myCollectionView setBackgroundColor:[UIColor colorWithRed:0.883 green:0.829 blue:0.818 alpha:1.000]];
    //打开用户交互
    [myCollectionView setUserInteractionEnabled:YES];
    //注册单元格
    [myCollectionView registerClass:[SourceCollectionViewCell class] forCellWithReuseIdentifier:strID];
    //注册尾视图
    [myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footView"];
    [myController.view addSubview:myCollectionView];
    
    
    return myCollectionView;
}
#pragma mark - 设置滚动条
+(UIImageView *)setScrollBar:(UIImageView *)imageView andLehgth:(int)theWidth
{
    UIImageView *scrollBar = [[UIImageView alloc]initWithFrame:CGRectMake(0, imageView.bounds.size.height-3, theWidth, 3)];
//    [scrollBar setBackgroundColor:[UIColor colorWithRed:0.931 green:0.225 blue:0.131 alpha:1.000]];
    [imageView addSubview:scrollBar];
    
    return scrollBar;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
