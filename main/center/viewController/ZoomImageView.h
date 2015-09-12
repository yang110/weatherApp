//
//  ZoomImageView.h
//  HWWeiBo
//
//  Created by Mac on 15/8/29.
//  Copyright (c) 2015年 杨梦佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZoomImageView;

@protocol ZoomImageViewDelegate <NSObject>


@optional

//图片将要放大
-(void)imageWillZoomin:(ZoomImageView *)imageView;

-(void)imageWillZoomOut:(ZoomImageView*)imageView;


@end




@interface ZoomImageView : UIImageView<NSURLConnectionDataDelegate,UIAlertViewDelegate>
{
    UIScrollView *_scrollView;
    UIImageView *_fullImageView;
    
    
    
    
}

@property (nonatomic,weak)id <ZoomImageViewDelegate>delegate;


@property(nonatomic,strong) NSString *fullImageUrlString;




// 暂时不考虑gif图
//gif
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,assign)BOOL isGif;



@end
