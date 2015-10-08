//
//  FirstCollectionViewCell.m
//  项目三
//
//  Created by Mac on 15/9/6.
//  Copyright (c) 2015年 杨梦佳. All rights reserved.
//

#import "FirstCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation FirstCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(FirstModel *)model
{
    _model=model;
    [self setNeedsLayout];
    
    
}


-(void)layoutSubviews
{
    
    
    
    _location.text=_model.location110;
    
    
    
    //缩略图
    AVFile *file = [AVFile fileWithURL:_model.imageStr];
    [file getThumbnail:YES width:100 height:100 withBlock:^(UIImage *image, NSError *error) {
        
      
        
        if (error==nil) {
            _imageView.image=image;
            
            
        }
        else
        {
            
            [_imageView sd_setImageWithURL:[NSURL URLWithString:_model.imageStr]];
            
            
        }
        
        
        
        
    }];
    
    
}

@end
