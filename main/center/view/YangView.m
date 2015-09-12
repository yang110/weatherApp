//
//  YangView.m
//  项目三
//
//  Created by Mac on 15/9/4.
//  Copyright (c) 2015年 杨梦佳. All rights reserved.
//

#import "YangView.h"
#import "Common.h"
#import "UIImageView+WebCache.h"
#import "FirstModel.h"  
@implementation YangView


-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame ];
    if (self) {
        
        
        
        [self createScrollerView];
        
        
        
       
        
    }
    return self;
}



-(void)setArray:(NSArray *)array
{
    
    _array=array;
  


    [self setNeedsLayout];
    
}

-(void)layoutSubviews
{
    //如果没有4张图 那么有几张显示几张
    if (_array.count>=4)
    {
        for (int i=0; i<4; i++)
        {
            FirstModel *model=_array[i];
            [arrayImageView[i] sd_setImageWithURL:[NSURL URLWithString:model.imageStr]];
        }
    }
    else
    {
        for (int i=0; i<_array.count; i++)
        {
            FirstModel *model=_array[i];
            [arrayImageView[i] sd_setImageWithURL:[NSURL URLWithString:model.imageStr]];
        }
    }
}

-(void)createScrollerView
{
    
    
    
    
    scrollview=[[UIScrollView alloc]initWithFrame:self.bounds];
    scrollview.contentSize=CGSizeMake(kScreenWidth*4, 190);
    scrollview.backgroundColor=[UIColor grayColor];
    scrollview.bounces=YES;
    scrollview.pagingEnabled=YES;
    scrollview.delegate=self;
    [self addSubview:scrollview];
    
    
    
    arrayImageView=[[NSMutableArray alloc]init];
    
  
    
    for (int i=0; i<4; i++)
    {
        
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, 190)];
        [scrollview addSubview:imageView];
        [arrayImageView addObject:imageView];
        
    }

    
    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((kScreenWidth-50)/2, 170, 50, 15)];
    [self addSubview:pageControl];
    pageControl.backgroundColor=[UIColor clearColor];
    pageControl.numberOfPages=4;
    pageControl.pageIndicatorTintColor=[UIColor grayColor];
    pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
    
    
    
}


//停止减速
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1
{
    NSLog(@"停止减速");
    pageControl.currentPage=(scrollview.contentOffset.x)/kScreenWidth;
    
}
@end
