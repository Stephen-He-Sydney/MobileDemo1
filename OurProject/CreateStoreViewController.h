//
//  CreateStoreViewController.h
//  OurProject
//
//  Created by ibokan on 15/10/17.
//  Copyright (c) 2015年 StephenHe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^byTureBlock)(int num);

@interface CreateStoreViewController : UIViewController

@property(strong,nonatomic)byTureBlock blockValue;
-(void)blockValue:(byTureBlock)value;
@end
