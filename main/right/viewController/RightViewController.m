//
//  RightViewController.m
//  项目三
//
//  Created by Mac on 15/8/27.
//  Copyright (c) 2015年 杨梦佳. All rights reserved.
//

#import "RightViewController.h"
#import "RightTableViewCell.h"
#import <AVOSCloud/AVOSCloud.h>
#import "RightEnterViewController.h"
#import "UIImageView+WebCache.h"
#import "UIViewExt.h"
#import "Common.h"
#import "MapViewController.h"
#import "AVOSCloudSNS.h"

@interface RightViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
{
    UITableView *_tableView;
    UIButton *headView;
    UIImageView *imageview;
    UILabel *label;

    
}

@end



@implementation RightViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.title=@"更多";
    [self createTableView];
    
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSSinaWeibo withAppKey:@"2548122881" andAppSecret:@"ba37a6eb3018590b0d75da733c4998f8" andRedirectURI:@"http://wanpaiapp.com/oauth/callback/sina"];
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSQQ withAppKey:@"100512940" andAppSecret:@"afbfdff94b95a2fb8fe58a8e24c4ba5f" andRedirectURI:nil];

    
}


-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[RightTableViewCell class] forCellReuseIdentifier:@"cell"];
    
  
    [self createHeadView];

    
    
}

#pragma mark - 创建头
-(void)createHeadView
{
    
    
    headView=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
    [headView  setBackgroundImage:[UIImage imageNamed:@"account_bg@2x.png"] forState:UIControlStateNormal];
    
    _tableView.tableHeaderView=headView;
    headView.backgroundColor=[UIColor whiteColor];
    [headView addTarget:self action:@selector(headImageViewButoonAction) forControlEvents:UIControlEventTouchUpInside];

     imageview=[[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 60, 60)];
    [headView addSubview:imageview];
    imageview.layer.cornerRadius=30;
    imageview.layer.masksToBounds = YES;
    imageview.layer.borderColor=[UIColor grayColor].CGColor;
    
    imageview.layer.borderWidth=1;
    
     label=[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 200, 60)];
    label.textAlignment=NSTextAlignmentCenter;
    
    [headView addSubview:label];
    
    [self isEnter];
}

-(void)isEnter
{
    AVUser *user=[AVUser currentUser];
    NSLog(@"%@",user.username);
    
    if (user!=nil) {
        
        //缩略图
        AVFile *file = [AVFile fileWithURL:user[@"image"]];
        [file getThumbnail:YES width:100 height:100 withBlock:^(UIImage *image, NSError *error) {
            imageview.image=image;
            
        }];
        
        label.text=user.username;
    
        [UIView beginAnimations:nil context:nil];
        
        [UIView setAnimationDuration:1];
        

        imageview.frame=CGRectMake((kScreenWidth-60)/2, 10, 60, 60);
        label.frame=CGRectMake((kScreenWidth-60)/2-70, 55, 200, 60);
        

        [UIView commitAnimations];
        
        
    }
    else
    {
        
        label.text= @"登入";
        imageview.image=[UIImage imageNamed:@"ugc_face_default.png"];
    
        [UIView beginAnimations:nil context:nil];
        
        [UIView setAnimationDuration:1];
    
        imageview.frame=CGRectMake(20, 20, 60, 60);
        label.frame=CGRectMake(20, 20, 200, 60);
        
        [UIView commitAnimations];
        

    }
    
}

-(void)headImageViewButoonAction
{
    
    AVUser *user=[AVUser currentUser];
    NSLog(@"%@",user.username);
    
    if (user!=nil) {
        //有用户
        NSLog(@"已有用户");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已有用户" message:@"请退出再登入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
    else
    {
        
        RightEnterViewController *vc=[[RightEnterViewController alloc]init];
        
        __weak RightViewController *vcc=self;
        
        vc.block=^{
            
            [vcc  isEnter];
            
            
            
        };
        
        [self presentViewController:vc animated:YES completion:nil];

        
    }
    
}

#pragma mark - tableView代理
//1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}

//2
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 5;
    }
    return 1;
    
    
    
}

//3
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RightTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.section==0)
    {
        //        高度为0  空着久好
        
    }
    else if(indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            cell.mainLabel.text=@"意见反馈";
            cell.imageView.image=[UIImage imageNamed:@"cm_unfavorite_btn_normal.png"];
          }
        else if(indexPath.row==1)
        {
            cell.mainLabel.text=@"修改密码";
            cell.imageView.image=[UIImage imageNamed:@"cm_unfavorite_btn_normal.png"];
        }
        else if(indexPath.row==2)
        {
            cell.mainLabel.text=@"上传头像";
            cell.imageView.image=[UIImage imageNamed:@"cm_unfavorite_btn_normal.png"];
        }
        else if(indexPath.row==3)
        {
            cell.mainLabel.text=@"附近用户";
            cell.imageView.image=[UIImage imageNamed:@"cm_unfavorite_btn_normal.png"];
        }
        else if(indexPath.row==4)
        {
            cell.mainLabel.text=@"其他登陆";
            cell.imageView.image=[UIImage imageNamed:@"cm_unfavorite_btn_normal.png"];
            _QQLogInbtn=[[UIButton alloc]initWithFrame:CGRectMake(300, 0, 40, 40)];
            [_QQLogInbtn setImage:[UIImage imageNamed:@"sns_qq@2x.png"] forState:UIControlStateNormal];
            [cell.contentView addSubview:_QQLogInbtn];
            [_QQLogInbtn addTarget:self action:@selector(QQbtnAction) forControlEvents:UIControlEventTouchUpInside];
            
            _WeiboLogInbtn=[[UIButton alloc]initWithFrame:CGRectMake(250, 0, 40, 40)];
            [_WeiboLogInbtn setImage:[UIImage imageNamed:@"sns_weibo@2x.png"] forState:UIControlStateNormal];
            [cell.contentView addSubview:_WeiboLogInbtn];
            [_WeiboLogInbtn addTarget:self action:@selector(WeibobtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        }


    }
    else if(indexPath.section==2)
    {
        cell.mainLabel.text=@"退出当前登入";
        cell.mainLabel.center=cell.contentView.center;
        cell.mainLabel.textAlignment=NSTextAlignmentCenter;
        
    }
    
    
    //设置箭头
    if (indexPath.section != 2&&indexPath.section != 0)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    }
    
    return cell;
}

//高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            return 0;
            
        }
    }
    return 44;
    
}

//点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    //空着，高度为0
    if (indexPath.section == 0&&indexPath.row == 0 )
    {
        //空着就行 高度为0
    }
    
    //用户退出
    if(indexPath.section==2&&indexPath.row==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认登出么?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        
        [alert show];
    }
    
    //修改密码
    if(indexPath.section==1&&indexPath.row==1)
    {
        NSLog(@"修改密码");
        [self resetPassword];

    }
    
    //意见反馈
    if(indexPath.section==1&&indexPath.row==0)
    {
        NSLog(@"意见反馈");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"感谢您的支持" message:@"请发送邮件到863354274@qq.com" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];

        
    }
    
    
    //上传头像
    if(indexPath.section==1&&indexPath.row==2)
    {
        [self updateHeadImage];
    }
    
    
    //附近用户
    if(indexPath.section==1&&indexPath.row==3)
    {
        
        
        MapViewController *vc=[[MapViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }

    
}



#pragma mark - 重设密码
-(void)resetPassword
{
    
    AVUser *user=[AVUser currentUser];
    
    if(user!=nil)
    {
        
        
        
        
        if(user.email!=nil)
        {
            [AVUser requestPasswordResetForEmailInBackground:user.email block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已发送注册邮箱" message:@"请在邮箱内查看" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    
                    [alert show];
                } else {
                    
                }
            }];
        
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"第三方登入" message:@"没有邮箱" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert show];

        }
        
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请先登入" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];

    }
}

#pragma mark - 用户退出
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        
        [self deleteAuthDataCache];
        [AVUser logOut];
        NSLog(@"用户退出");
        [self isEnter];
        
    }
    
}

/** 调用这个，下次 SNS 登录的时候会重新去第三方应用请求，而不会用本地缓存 */
- (void)deleteAuthDataCache {
    NSDictionary *authData = [[AVUser currentUser] objectForKey:@"authData"];
    if (authData) {
        if ([authData objectForKey:AVOSCloudSNSPlatformQQ]) {
            [AVOSCloudSNS logout:AVOSCloudSNSQQ];
        }
        else if ([authData objectForKey:AVOSCloudSNSPlatformWeiBo]) {
            [AVOSCloudSNS logout:AVOSCloudSNSSinaWeibo];
        }
    }
}

#pragma mark - 选择照片上传头像
-(void)updateHeadImage
{
    
    AVUser *user=[AVUser currentUser];
    NSLog(@"%@",user.username);
    
    if (user!=nil) {
        
        
        [self _selectPhoto];
        
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请先登入" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }

}

-(void)_selectPhoto
{
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    
    
    [actionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    UIImagePickerControllerSourceType sourceType;
    
    if (buttonIndex==0)
    {
        //拍照
        sourceType=UIImagePickerControllerSourceTypeCamera;
        
        BOOL isCamera=[UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (isCamera==NO)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"摄像头无法使用" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            return;
            
        }
        
    }
    else if (buttonIndex==1)
    {
        //选择相册
        sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    else if(buttonIndex==2)
    {
        return;
        
        
    }
    
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.sourceType=sourceType;
    picker.delegate=self;
    
    [self presentViewController:picker animated:YES completion:nil];
    
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    AVUser *user=[AVUser currentUser];
    NSLog(@"%@",user.username);

    

    [self showHUD:@"正在上传"];
    
    
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
   
    
    
      NSData *imageData = UIImagePNGRepresentation(image);
    
    
     AVFile *imageFile = [AVFile fileWithName:@"image.png" data:imageData];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            NSLog(@"图片保存成功");

            [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

                [user setObject: imageFile.url forKey:@"image"];
                [user saveInBackground];
                NSLog(@"上传头像");
                
                [self isEnter];
                
            }];

            [self completeHUD:@"上传完成"];
            
        }
    }];
    
}

#pragma mark -第三方登陆
- (void)QQbtnAction
{
    
    [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
        if (error) {
            NSLog(@"failed to get authentication from weibo. error: %@", error.description);
        } else {
            [AVUser loginWithAuthData:object platform:AVOSCloudSNSPlatformQQ block:^(AVUser *user, NSError *error) {
                if ([self filterError:error]) {
                    [self loginSucceedWithUser:user authData:object];
                }
            }];
        }
    } toPlatform:AVOSCloudSNSQQ];
    
    
}

- (void)WeibobtnAction
{
    [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
        if (error) {
            NSLog(@"failed to get authentication from weibo. error: %@", error.description);
        } else {
            [AVUser loginWithAuthData:object platform:AVOSCloudSNSPlatformWeiBo block:^(AVUser *user, NSError *error) {
                if ([self filterError:error]) {
                    [self loginSucceedWithUser:user authData:object];
                }
            }];
        }
    } toPlatform:AVOSCloudSNSSinaWeibo];
    
    
    
}



#pragma mark -登陆结果

- (void)alert:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}


- (BOOL)filterError:(NSError *)error {
    if (error) {
        [self alert:[error localizedDescription]];
        return NO;
    }
    return YES;
}

- (void)loginSucceedWithUser:(AVUser *)user authData:(NSDictionary *)authData{
    
    NSLog(@"%@",authData);

    
    if (user!=nil) {
        NSString *userName=[authData objectForKey:@"username"];
        user.username=userName;
        user[@"image"]=[authData objectForKey:@"avatar"];
        [user saveInBackground];
        [imageview sd_setImageWithURL:[NSURL URLWithString:user[@"image"]] placeholderImage:[UIImage imageNamed:@"adv_placeholder_comment@2x.png"]];
        label.text=user.username;
    
        [UIView beginAnimations:nil context:nil];
        
        [UIView setAnimationDuration:1];
        imageview.frame=CGRectMake((kScreenWidth-60)/2, 10, 60, 60);
        label.frame=CGRectMake((kScreenWidth-60)/2-70, 55, 200, 60);
        
        [UIView commitAnimations];
    
    
    }
    else
    {
        
        label.text= @"登入";
        imageview.image=[UIImage imageNamed:@"ugc_face_default.png"];
        
        [UIView beginAnimations:nil context:nil];
        
        [UIView setAnimationDuration:1];
        
        imageview.frame=CGRectMake(20, 20, 60, 60);
        label.frame=CGRectMake(20, 20, 200, 60);
        
        [UIView commitAnimations];
        
    }
    
}


@end
