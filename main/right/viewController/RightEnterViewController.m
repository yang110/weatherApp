//
//  RightEnterViewController.m
//  项目三
//
//  Created by Mac on 15/8/28.
//  Copyright (c) 2015年 杨梦佳. All rights reserved.
//

#import "RightEnterViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "RightRegisterViewController.h"
#import "Common.h"

@interface RightEnterViewController ()


@end

@implementation RightEnterViewController

- (void)_createView
{
    //背景设置
    UIImage *image=[UIImage imageNamed:@"login_background.png"];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image=image;
    [self.view addSubview:imageView];
    //登陆标志
    _LogInImgView=[[UIImageView alloc]initWithFrame:CGRectMake(140, 90, 100, 100)];
    _LogInImgView.image=[UIImage imageNamed:@"rounded_icon.png"];
    
    [self.view addSubview:_LogInImgView];
    //Label的设置
    _userLaber=[[UILabel alloc]initWithFrame:CGRectMake(50, 230, 80, 20)];
    _userLaber.text=@"用户名";
    [self.view addSubview:_userLaber];
    
    _passLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 280, 80, 20)];
    _passLabel.text=@"密码";
    
    [self.view addSubview:_passLabel];
    //输入框的设置
    
    _userName=[[UITextField alloc]initWithFrame:CGRectMake(150,225,150,30)];
    _userName.borderStyle=UITextBorderStyleRoundedRect;
    [self.view addSubview:_userName];
    
    _passWord=[[UITextField alloc]initWithFrame:CGRectMake(150, 275, 150, 30)];
    
    _passWord.borderStyle=UITextBorderStyleRoundedRect;
    _passWord.secureTextEntry=YES;
    [self.view addSubview:_passWord];
    
    _LogInBtn=[[UIButton alloc]initWithFrame:CGRectMake(70, 340, 250, 40)];
    
    [_LogInBtn setImage:[UIImage imageNamed:@"login_disabled@2x.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:_LogInBtn];
    
    [_LogInBtn addTarget:self action:@selector(LoginAction) forControlEvents:UIControlEventTouchUpInside];
    
    _RegisterBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, kScreenHeight-40,kScreenWidth/2-2, 40)];
    
    [_RegisterBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_RegisterBtn setBackgroundColor:[UIColor grayColor]];
    
    [self.view addSubview:_RegisterBtn];
    [_RegisterBtn addTarget:self action:@selector(RegisterAction) forControlEvents:UIControlEventTouchUpInside];
    
    _CancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2, kScreenHeight-40, kScreenWidth/2, 40)];
    
    [_CancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_CancelBtn setBackgroundColor:[UIColor grayColor]];
    
    [self.view addSubview:_CancelBtn];
    
    [_CancelBtn addTarget:self action:@selector(CancelAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

#pragma -隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_userName resignFirstResponder];
    [_passWord resignFirstResponder];
    
}

#pragma - Action

- (void)LoginAction
{
    
    
    [AVGeoPoint geoPointForCurrentLocationInBackground:^(AVGeoPoint *geoPoint, NSError *error) {
        

    
    [AVUser logInWithUsernameInBackground:_userName.text password:_passWord.text block:^(AVUser *user, NSError *error)
     {
         if (user != nil)
         {
             NSLog(@"登入成功");
             
             NSLog(@"用户为 %@",user.username);
             
             [user setObject:geoPoint forKey:@"location"];
             [user save];

             
             [self dismissViewControllerAnimated:YES completion:nil];
             
             
             //调用block,返回去调用 isEnter
             _block();
             
             
             
         } else {
             NSLog(@"登入失败");
             
         }
     }];
    
        
        
    }];

    
}


- (void)RegisterAction
{
    
    
    
    RightRegisterViewController *vc=[[RightRegisterViewController alloc]init];
    
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
}


- (void)CancelAction
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self _createView];
}

- (IBAction)registerAction:(id)sender
{
    
    RightRegisterViewController *vc=[[RightRegisterViewController alloc]init];
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
    
}



@end
