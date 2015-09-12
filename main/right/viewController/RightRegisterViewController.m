//
//  RightRegisterViewController.m
//  项目三
//
//  Created by Mac on 15/8/28.
//  Copyright (c) 2015年 杨梦佳. All rights reserved.
//

#import "RightRegisterViewController.h"
#import <AVOSCloud/AVOSCloud.h>
@interface RightRegisterViewController ()
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;

@end

@implementation RightRegisterViewController


//注册
- (IBAction)certainAction:(id)sender {
        AVUser *user = [AVUser user];
    
    
        user.username =_userName.text;
        user.password =  _password.text;
        user.email = _email.text;
        [user setObject:_phoneNumber.text forKey:@"phone"];
    
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"注册成功");
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                NSLog(@"注册失败");
                
                
                //跳出框  还未做

            }
        }];

    
}
- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



@end
