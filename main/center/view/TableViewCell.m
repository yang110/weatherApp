//
//  TableViewCell.m
//  项目三
//
//  Created by Mac on 15/8/26.
//  Copyright (c) 2015年 杨梦佳. All rights reserved.
//

#import "TableViewCell.h"
#import <AVOSCloud/AVOSCloud.h>
#import "UIImageView+WebCache.h"

@implementation TableViewCell

- (void)awakeFromNib {
   
    
    _zoomImageView=[[ZoomImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_zoomImageView];
    
    
    _comment=[[WXLabel alloc]initWithFrame:CGRectZero];
     _comment.numberOfLines=0;
    _comment.wxLabelDelegate=self;
    
    [self.contentView addSubview:_comment];
    
    
    
    _userImageView.layer.cornerRadius=25;
    _userImageView.layer.masksToBounds=YES;
    _userImageView.layer.borderColor=[UIColor blackColor].CGColor;
    _userImageView.layer.borderWidth=2;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}







-(void)setCommentModel:(CommentAndFrameModel *)commentModel
{
    _commentModel=commentModel  ;
    
    [self setNeedsLayout];
    
    
    
}

-(void)layoutSubviews
{

    
        //frame固定
    if (_commentModel.userName!=nil) {
          _userName.text=_commentModel.userName;

    }
    
    
   
       _comment.text=_commentModel.comment;
        _comment.frame=_commentModel.labelFrame;
  
      

        
 

    //frame固定
    if (_commentModel.userImageUrl!=nil) {
        
        //缩略图
        AVFile *file = [AVFile fileWithURL:_commentModel.userImageUrl];
        [file getThumbnail:YES width:100 height:100 withBlock:^(UIImage *image, NSError *error) {
            _userImageView.image=image;
            
        }];

        
    }
 

     //frame固定
    _createTime.text=_commentModel.date;
    
    
    
    
    if (_commentModel.commentUrl!=nil) {
        
        
        //缩略图
        AVFile *file = [AVFile fileWithURL:_commentModel.commentUrl];
        [file getThumbnail:YES width:100 height:100 withBlock:^(UIImage *image, NSError *error) {
            _zoomImageView.image=image;
        }];
        
        
        _zoomImageView.fullImageUrlString=_commentModel.commentUrl;
        
        _zoomImageView.frame=_commentModel.zoomFrame;
        

    }
    else
    {
        _zoomImageView.frame=CGRectZero;

    }
    
   
    _geoLabel.text=_commentModel.geo;
    
    
}



#pragma  mark - WXLabel delegate
//手指离开当前超链接文本响应的协议方法
- (void)toucheEndWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context
{
    NSLog(@"%@",context);
    
}

- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel
{
    //需要添加链接字符串的正则表达式：@用户、http://、#话题#
    NSString *regex1 = @"@\\w+";
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    NSString *regex3 = @"#\\w+#";
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
    return regex;
}

//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel
{
    return [UIColor redColor];
}


//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel
{
    return [UIColor blueColor];
}



@end
