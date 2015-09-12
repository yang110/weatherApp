//
//  AtUserTableViewCell.m
//  项目三
//
//  Created by Mac on 15/9/5.
//  Copyright (c) 2015年 杨梦佳. All rights reserved.
//

#import "AtUserTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation AtUserTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModel:(FirstModel *)model
{
    _model=model;
    
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    _name.text=_model.name;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_model.imageStr] placeholderImage:[UIImage imageNamed:@"1"]];
}



@end
