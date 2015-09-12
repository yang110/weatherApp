//
//  YangView.h
//  项目三
//
//  Created by Mac on 15/9/4.
//  Copyright (c) 2015年 杨梦佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YangView : UIView<UIScrollViewDelegate>
{
    
    UIScrollView *scrollview;
    
    
    UIPageControl *pageControl;
    
    
    NSMutableArray *arrayImageView;
}

@property(nonatomic,strong)NSArray *array;//arrayModel


@end
