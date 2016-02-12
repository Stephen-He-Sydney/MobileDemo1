//
//  PhotoUploadViewController.m
//  OurProject
//
//  Created by StephenHe on 10/9/15.
//  Copyright (c) 2015 StephenHe. All rights reserved.
//

#import "PhotoUploadViewController.h"
#import "GlobalConstants.h"
#import "UploadPhoto.h"
@interface PhotoUploadViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    UIImageView * View;
    NSMutableArray * ImageArr;
    UITableViewCell * cell;
    UITableView * PhotoUploadView;
    int selectIndex;
    
    UIImageView * image1;
    UIImageView * image2;
     NSString * str;
    NSUserDefaults * userDefa;
   
}

@end

@implementation PhotoUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectIndex = 100;
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"上传图片";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    ImageArr = [[NSMutableArray alloc]init];
    userDefa = [NSUserDefaults standardUserDefaults];
    
    PhotoUploadView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CURRSIZE.width, CURRSIZE.height) style:UITableViewStyleGrouped];
    
    [PhotoUploadView setSectionFooterHeight:0];
    [PhotoUploadView setSectionHeaderHeight:0];
    PhotoUploadView.delegate =self;
    PhotoUploadView.dataSource =self;
    
    [self.view addSubview:PhotoUploadView];

}


#pragma  mark - 设置分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
#pragma mark -设置每组的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
#pragma mark - 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((CURRSIZE.width/8)*4)+20;
}
#pragma mark - 设置section头视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
#pragma mark -设置section头视图文字
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.number==0) {
        if (section==0) {
            return @"身份证正面照";
        }else if (section==1)
        {
            return @"身份证反面照";
        }
    }else if (self.number==1)
    {
        if (section==0) {
            return @"学生证正面照片";
        }else if (section==1)
        {
         return @"手持学生证正面照";
        
        }
    
    }
    return nil;
    
}

#pragma mark - 创建cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * indexCell = @"cell";
   cell = [tableView dequeueReusableCellWithIdentifier:indexCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indexCell];
    }
    if (indexPath.section == 0) {
        image1 = [[UIImageView alloc]initWithFrame:CGRectMake(CURRSIZE.width/9, 10 ,(CURRSIZE.width/9)*7, ((CURRSIZE.width/9)*4)+20)];
            [cell.contentView addSubview:image1];
    }else if (indexPath.section == 1)
    {
        image2 = [[UIImageView alloc]initWithFrame:CGRectMake(CURRSIZE.width/9, 10 ,(CURRSIZE.width/9)*7, ((CURRSIZE.width/9)*4)+20)];
        [cell.contentView addSubview:image2];

    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - 选中cell的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectIndex = (int)indexPath.section;
    //判断当前App是否可以使用相册
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing=YES;
        //指定picker调用资源为当前设备相册
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:picker animated:YES completion:nil];
    }
   
}


#pragma mark - 选择完毕
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获取照相拍摄的图片
    UIImage * PhoneImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    //[ImageArr addObject:PhoneImage];
    
//    [PhotoUploadView reloadData];
    
    [UploadPhoto upLoadImage:PhoneImage completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"status"]intValue]==1) {
            str = dic[@"data"][@"file"][@"path"];
            NSLog(@"%@",dic);
        
            
        }
        
        if (self.number==0) {
            switch (selectIndex) {
                case 0:
                {
                    image1.image = PhoneImage;
                    NSURL *  url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://112.74.105.205/zhizu",str]];
                    
                    [userDefa setObject:url1 forKey:@"IDzhengMian"];
                }
                    break;
                case 1:
                {
                    image2.image = PhoneImage;
                    NSURL *  url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://112.74.105.205/zhizu",str]];
                    
                    [userDefa setObject:url2 forKey:@"IDfanMian"];
                    
                }
                    break;
                    
            }
        }else if (self.number==1){
            
            switch (selectIndex) {
                case 0:
                {
                    image1.image = PhoneImage;
                    NSURL *  url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://112.74.105.205/zhizu",str]];
                    
                    [userDefa setObject:url3 forKey:@"zhengMian"];
                }
                    break;
                case 1:
                {
                    image2.image = PhoneImage;
                    NSURL *  url4 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://112.74.105.205/zhizu",str]];
                
                    [userDefa setObject:url4 forKey:@"fanMian"];
                    
                }
                    break;
                    
            }

        }

    }];
    

    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
