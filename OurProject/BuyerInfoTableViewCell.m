//
//  BuyerInfoTableViewCell.m
//  OurProject
//
//  Created by StephenHe on 10/12/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "BuyerInfoTableViewCell.h"

@implementation BuyerInfoTableViewCell

//only in this default method, self.contentView width and height will be correct, because of execution sequence
//-(void)layoutSubviews
//{
//    [self createHeaderView];
//    
//    [self createMainBody];
//    
//    [self addComponentsToMainBody];
//    
//    [self addComponentsToMainFooter];
//    
//    [self createFooterView];
//}

//The height only will be updated within layoutSubviews
-(void)fetchCurrCellSize:(CGFloat)height WithWidth:(CGFloat)width
{
    cellHeight = height;
    cellWidth = width;
}

-(void)createHeaderView
{
    UIView* header = [[UIView alloc]initWithFrame:CGRectMake(15, 0, cellWidth-30, 35)];
    //[header setBackgroundColor:[UIColor redColor]];

    UILabel* buyer = [[UILabel alloc]initWithFrame:CGRectMake(0, header.frame.size.height*0.15, 60, 25)];
    buyer.text = @"买家:";
    [buyer setTextColor:[UIColor lightGrayColor]];
    
    self.buyerNo = [[UILabel alloc]initWithFrame:CGRectMake(45, header.frame.size.height*0.15, 80, 25)];

    UIImageView* forwardArrow = [[UIImageView alloc]initWithFrame:CGRectMake(self.buyerNo.frame.origin.x + self.buyerNo.frame.size.width,header.frame.size.height*0.31, 20, 13)];
    forwardArrow.image = [UIImage imageNamed:@"bz_tbjt"];
    forwardArrow.contentMode = UIViewContentModeScaleAspectFit;
  
    [buyer setFont:[UIFont systemFontOfSize:12]];
    [self.buyerNo setFont:[UIFont systemFontOfSize:12]];
    
    self.purchaseStatus = [[UILabel alloc]initWithFrame:CGRectMake(header.frame.size.width - 40, header.frame.size.height*0.15, 40, 25)];
    //self.purchaseStatus.text = @"待完成";
    [self.purchaseStatus setTextColor:[CommonViewController getCurrRedColor]];
    [self.purchaseStatus setFont:[UIFont systemFontOfSize:12]];
    
    [header addSubview:self.purchaseStatus];
    [header addSubview:buyer];
    [header addSubview:self.buyerNo];
    [header addSubview:forwardArrow];
    [self.contentView addSubview:header];
    
    UIView* underline = [[UIView alloc]initWithFrame:CGRectMake(header.frame.origin.x, header.frame.size.height, header.frame.size.width, 1)];
    [underline.layer setBorderColor:[UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1].CGColor];
    [underline.layer setBorderWidth:1];
    [self.contentView addSubview:underline];
}

-(void)createMainBody
{
    mainBody = [[UIView alloc]initWithFrame:CGRectMake(0, 36, cellWidth, cellHeight*0.3)];
    //[mainBody setBackgroundColor:[UIColor blueColor]];

    [self.contentView addSubview:mainBody];
}

-(void)createMainFooter
{
    UIView* underline = [[UIView alloc]initWithFrame:CGRectMake(mainBody.frame.origin.x+15, mainBody.frame.origin.y+mainBody.frame.size.height, mainBody.frame.size.width-30, 1)];
    [underline.layer setBorderColor:[UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1].CGColor];
    [underline.layer setBorderWidth:1];
    [self.contentView addSubview:underline];
    
    mainFooter = [[UIView alloc]initWithFrame:CGRectMake(0, underline.frame.origin.y+underline.frame.size.height, cellWidth, (cellHeight - 36)*0.35)];
    //[mainFooter setBackgroundColor:[UIColor yellowColor]];
    
    [self.contentView addSubview:mainFooter];
}

-(void)addComponentsToMainBody
{
    self.mainImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, mainBody.frame.size.width*0.25, mainBody.frame.size.height)];
    //[self.mainImage setBackgroundColor:[UIColor yellowColor]];

    self.mainImage.contentMode = UIViewContentModeScaleAspectFit;
    [mainBody addSubview:self.mainImage];
    
    [self createMainFooter];
    
    self.productTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.mainImage.frame.origin.x + self.mainImage.frame.size.width+5, 0, mainBody.frame.size.width*0.5, 50)];
  
    self.productTitle.numberOfLines = 0;
    [self.productTitle setFont:[UIFont systemFontOfSize:12]];
    //[self.productTitle setBackgroundColor:[UIColor redColor]];
    [mainBody addSubview:self.productTitle];
    
    UILabel* shopTxt = [[UILabel alloc]initWithFrame:CGRectMake(self.mainImage.frame.origin.x + self.mainImage.frame.size.width+5, self.productTitle.frame.size.height+self.productTitle.frame.origin.y, 30, mainBody.frame.size.height - self.productTitle.frame.size.height)];
    //[shopTxt setBackgroundColor:[UIColor yellowColor]];
    shopTxt.text = @"店名:";
    [shopTxt setFont:[UIFont systemFontOfSize:10]];
    
    self.shopName = [[UILabel alloc]initWithFrame:CGRectMake(self.mainImage.frame.origin.x + self.mainImage.frame.size.width+30,  self.productTitle.frame.size.height+self.productTitle.frame.origin.y, mainBody.frame.size.width*0.3-20, mainBody.frame.size.height - self.productTitle.frame.size.height)];
    //[self.shopName setBackgroundColor:[UIColor redColor]];
    //self.shopName.text = @"Steven's Store";
    [self.shopName setFont:[UIFont systemFontOfSize:10]];
    [self.shopName setTextColor:[CommonViewController getCurrRedColor]];
    
    [mainBody addSubview:shopTxt];
    [mainBody addSubview:self.shopName];
    
    self.unitPrice = [[UILabel alloc]initWithFrame:CGRectMake(self.productTitle.frame.size.width+self.productTitle.frame.origin.x, 0, mainBody.frame.size.width-self.mainImage.frame.size.width - self.productTitle.frame.size.width, 20)];
    //[self.unitPrice setBackgroundColor:[UIColor yellowColor]];
    [self.unitPrice setTextColor:[CommonViewController getCurrRedColor]];
    [self.unitPrice setFont:[UIFont systemFontOfSize:12]];
    
    self.totalPrice = [[UILabel alloc]initWithFrame:CGRectMake(self.productTitle.frame.size.width+self.productTitle.frame.origin.x, self.unitPrice.frame.origin.y+self.unitPrice.frame.size.height, mainBody.frame.size.width-self.mainImage.frame.size.width - self.productTitle.frame.size.width, 20)];
    //[self.totalPrice setBackgroundColor:[UIColor greenColor]];
    [self.totalPrice setTextColor:[CommonViewController getCurrRedColor]];
    [self.totalPrice setFont:[UIFont systemFontOfSize:12]];
    
    self.quantity = [[UILabel alloc]initWithFrame:CGRectMake(self.productTitle.frame.size.width+self.productTitle.frame.origin.x, self.totalPrice.frame.origin.y+self.totalPrice.frame.size.height, mainBody.frame.size.width-self.mainImage.frame.size.width - self.productTitle.frame.size.width, 20)];
    //[self.quantity setBackgroundColor:[UIColor purpleColor]];
    [self.quantity setFont:[UIFont systemFontOfSize:12]];
    
    [mainBody addSubview:self.unitPrice];
    [mainBody addSubview:self.totalPrice];
    [mainBody addSubview:self.quantity];
}

-(void)addComponentsToMainFooter
{
    UILabel* timeTxt = [[UILabel alloc]initWithFrame:CGRectMake(15, mainFooter.frame.size.height*0.1, 30, 25)];
    timeTxt.text = @"时间:";
    //[timeTxt setBackgroundColor:[UIColor redColor]];
    
    self.purchaseTime = [[UILabel alloc]initWithFrame:CGRectMake(45,mainFooter.frame.size.height*0.1, 130, 25)];
    //self.purchaseTime.text = @"2010-10-10 11:11:00";
    [self.purchaseTime setTextColor:[CommonViewController getCurrRedColor]];
    //[self.purchaseTime setBackgroundColor:[UIColor yellowColor]];
    
    [timeTxt setFont:[UIFont systemFontOfSize:12]];
    [self.purchaseTime setFont:[UIFont systemFontOfSize:12]];
    
    [mainFooter addSubview:timeTxt];
    [mainFooter addSubview:self.purchaseTime];
    
    UILabel* totalTxt = [[UILabel alloc]initWithFrame:CGRectMake(mainFooter.frame.size.width*0.685,mainFooter.frame.size.height*0.1,35, 25)];
    //[totalTxt setBackgroundColor:[UIColor blueColor]];
    totalTxt.text = @"总计:";
    [totalTxt setFont:[UIFont systemFontOfSize:12]];
    [mainFooter addSubview:totalTxt];
    
    self.summaryPrice = [[UILabel alloc]initWithFrame:CGRectMake(totalTxt.frame.size.width + totalTxt.frame.origin.x, mainFooter.frame.size.height*0.1,mainFooter.frame.size.width/5*2-35, 25)];
    //self.summaryPrice.text = @"￥2300.00";
    [self.summaryPrice setFont:[UIFont systemFontOfSize:12]];
    [self.summaryPrice setTextColor:[CommonViewController getCurrRedColor]];
    
    [mainFooter addSubview:self.summaryPrice];
}

-(void)addButtonsToMainFooter
{
    UIView* underline = [[UIView alloc]initWithFrame:CGRectMake(mainBody.frame.origin.x+15, self.purchaseTime.frame.origin.y+self.purchaseTime.frame.size.height+mainFooter.frame.size.height*0.1, mainBody.frame.size.width-30, 1)];
    [underline.layer setBorderColor:[UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1].CGColor];
    [underline.layer setBorderWidth:1];
    [mainFooter addSubview:underline];
    
    self.sendToClient = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.sendToClient setFrame:CGRectMake(cellWidth-90, underline.frame.origin.y+underline.frame.size.height+mainFooter.frame.size.height*0.12, 70, 25)];
    //[self.sendToClient setTitle:@"发给客户" forState:UIControlStateNormal];
    self.sendToClient.layer.cornerRadius = 5;
    [self.sendToClient.layer setBorderColor:[CommonViewController getCurrRedColor].CGColor];
    [self.sendToClient.layer setBorderWidth:0.5];
    [self.sendToClient setTitleColor:[CommonViewController getCurrRedColor] forState:UIControlStateNormal];
    [self.sendToClient.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.sendToClient addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    self.sendToClient.hidden = YES;
    
    [mainFooter setUserInteractionEnabled:YES];
    [mainFooter addSubview:self.sendToClient];
}

-(void)btnResponse:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]])
    {
        UIButton* btn = (UIButton*)sender;
        if (self.sendButtonText != nil)
        {
            self.sendButtonText(btn.titleLabel.text);
        }
    }
}

-(void)createFooterView
{
    UIView* footer = [[UIView alloc]initWithFrame:CGRectMake(0, mainFooter.frame.size.height+mainFooter.frame.origin.y, cellWidth, cellHeight-(mainFooter.frame.size.height+mainFooter.frame.origin.y))];
    //[footer setBackgroundColor:[UIColor redColor]];

    [self.contentView addSubview:footer];
}

//-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
//    {
//        
//        
//    }
//    return self;
//}

@end
