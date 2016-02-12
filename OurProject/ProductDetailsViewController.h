//
//  ProductDetailsViewController.h
//  OurProject
//
//  Created by ibokan on 15/10/14.
//  Copyright (c) 2015年 StephenHe. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BlockGoodsIsInStore)(NSDictionary *dic);
@interface ProductDetailsViewController : UIViewController
{
    NSMutableArray *buttonsArray;//创建数组，接收View层返回的按钮
}
@property(strong,nonatomic)UIImageView *touchBtn;//上架、下架按钮
@property(strong,nonatomic)UILabel *touchBtnName;
@property(strong,nonatomic)UILabel *checkInfo;//查看详情按钮
@property(strong,nonatomic)UILabel *shareBtn;//分享按钮
@property(strong,nonatomic)UIAlertView *alertInformation;//提示框
@property(strong,nonatomic)NSMutableDictionary *goodsInfo;
@property(assign,nonatomic)int indexPath;
@property(strong,nonatomic)NSString* goodsID;
@property(strong,nonatomic)NSString* token;
@property(strong,nonatomic)NSString* storeID;
@end
