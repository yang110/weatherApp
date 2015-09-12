//
//  WeiboAnnotationView.m
//  HWWeiBo
//
//  Created by Mac on 15/9/2.
//  Copyright (c) 2015年 杨梦佳. All rights reserved.
//

#import "WeiboAnnotationView.h"
#import "UIImageView+WebCache.h"
@implementation WeiboAnnotationView

-(instancetype)initWithFrame:(CGRect)frame
{
    
    
    
    self=[super initWithFrame:frame ];
    if (self)
    {
        
         self.bounds = CGRectMake(0, 0, 100, 50);
        [self _createViews];
        
        
        
        
        
    }
    return self;
}


-(void)_createViews
{
    _userHeadImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:_userHeadImageView  ];
    
    
    _textLabel=[[UILabel alloc]initWithFrame:CGRectZero];
 _textLabel.backgroundColor = [UIColor lightGrayColor];
    _textLabel.numberOfLines=3;
    _textLabel.textColor=[UIColor blackColor];
    _textLabel.font=[UIFont systemFontOfSize:13];
    [self addSubview:_textLabel];
    
}


-(void)layoutSubviews
{
    
    
    
    [super layoutSubviews];
    
    
    _userHeadImageView.frame=CGRectMake(0, 0, 60, 50);
    _textLabel.frame=CGRectMake(60, 0, 100, 50);
    
    
    WeiboAnnotation *annotation=self.annotation;
    WeiboModel *model=annotation.weiboModel;
    
    
    
    _textLabel.text=model.text;
    
    [_userHeadImageView sd_setImageWithURL:[NSURL URLWithString:model.userModel.profile_image_url] placeholderImage:[UIImage imageNamed:@"icon"]];
    
    
    
    
    
}

@end
