//
//  RightTableViewCell.m
//  项目三
//
//  Created by Mac on 15/8/27.
//  Copyright (c) 2015年 杨梦佳. All rights reserved.
//

#import "RightTableViewCell.h"
#import "UIViewExt.h"
@implementation RightTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    //先注册  后高度
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        
        _imgView=[[UIImageView alloc]initWithFrame:CGRectZero];
        _imgView.backgroundColor=[UIColor redColor];

        [self.contentView addSubview:_imgView];
        
        
        
        
        _mainLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 0, 200, 44)];
        [self.contentView addSubview:_mainLabel];
        
        
    }
    return self;
}



- (void)drawRect:(CGRect)rect
{
    
    [[UIImage imageNamed:@"account_bg@2x.png"] drawInRect:rect];
    
}



















@end
