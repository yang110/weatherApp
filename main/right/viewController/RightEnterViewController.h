//
//  RightEnterViewController.h
//  项目三
//
//  Created by Mac on 15/8/28.
//  Copyright (c) 2015年 杨梦佳. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Block111)(void);

@interface RightEnterViewController : UIViewController


@property (nonatomic,strong) Block111 block;
@property (nonatomic,strong)UIImageView *LogInImgView;
@property (nonatomic,strong)UITextField *userName;
@property (nonatomic,strong)UITextField *passWord;
@property (nonatomic,strong)UIButton *LogInBtn;
@property (nonatomic,strong)UIButton *CancelBtn;


@property (nonatomic,strong)UIButton *RegisterBtn;


@property (nonatomic,strong)UILabel *userLaber;
@property (nonatomic,strong)UILabel *passLabel;
@end
