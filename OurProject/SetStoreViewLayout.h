//
//  SetStoreViewLayout.h
//  OurProject
//
//  Created by ibokan on 15/10/13.
//  Copyright (c) 2015年 StephenHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetStoreViewLayout : UIView

+(UIImageView *)setHeadViewLayout:(UIViewController *)myController andImage:(UIImage *)image andStoreName:(NSString *)name;
+(NSMutableArray *)setStoreButtons:(UIViewController *)myController;
@end
