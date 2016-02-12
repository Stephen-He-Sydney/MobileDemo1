//
//  SetSourceViewLayout.h
//  OurProject
//
//  Created by ibokan on 15/10/10.
//  Copyright (c) 2015年 StephenHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetSourceViewLayout : UIView

+(NSMutableArray *)setButtons:(UIViewController *)myController andButtonsName:(NSMutableArray *)buttons;
+(NSMutableArray *)setScreenBtn:(UIViewController *)myController buttonName:(NSMutableArray *)screenBtnName;
+(UICollectionView *)setCollectionVIew:(UIViewController *)myController andCollectionID:(NSString *)strID;
+(UIImageView *)setScrollBar:(UIImageView *)imzgeView andLehgth:(int)length;
@end
