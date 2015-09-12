//
//  ZoomImageView.m
//  HWWeiBo
//
//  Created by Mac on 15/8/29.
//  Copyright (c) 2015年 杨梦佳. All rights reserved.
//

#import "ZoomImageView.h"
#import "MBProgressHUD.h"



#import <ImageIO/ImageIO.h>
#import "UIImage+GIF.h"
#import "UIViewExt.h"




#define kwidth  self.view.bounds.size.width
#define kheight self.view.bounds.size.height



#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height




@implementation ZoomImageView 
{
    double _length;//总长度
    NSMutableData *_data;
    
    UIProgressView *_progressView;
    
    NSURLConnection *_connection;
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame ];
    
    if (self)
    {
        [self initTap];
         [self _createGifIcon];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self)
    {
            [self initTap];
         [self _createGifIcon];
    }
    return self;
}

-(instancetype)initWithImage:(UIImage *)image
{
    
    self=[super  initWithImage:image];
    if (self)
    {
        
        [self initTap];
         [self _createGifIcon];
        
    }
    return self;
    
    
    
}

//#warning -----gif处理
- (void)_createGifIcon{
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _iconImageView.hidden = YES;
    _iconImageView.image = [UIImage imageNamed:@"timeline_gif.png"];
    [self addSubview:_iconImageView];
    
    
    
    
}
//添加手势
-(void)initTap
{
    //01 打开交互
    self.userInteractionEnabled=YES;
    
    //02 创建单击手势
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomIn)];
    [self addGestureRecognizer:tap];
    
    //03 设置显示模式
    self.contentMode=UIViewContentModeScaleAspectFit;
    
    
    
    
}

-(void)zoomIn
{
    
    //调用代理方法
    if ([self.delegate respondsToSelector:@selector(imageWillZoomin:)])
    {
        [self.delegate imageWillZoomin:self];
        
    }
    
    
    
    
    
    
    //01隐藏原图
    self.hidden=YES;
    
    //02 创建大图浏览_scrollView
    [self createScrollView];
    
    //03 计算 _fullImmageView 相对于window坐标
    CGRect frame=[self convertRect:self.bounds toView:self.window];
    _fullImageView.frame=frame;//1
    
    //04 放大图片动画
    [UIView animateWithDuration:0.5 animations:^{
      
        _fullImageView.frame=_scrollView.bounds;//2
        
        
    } completion:^(BOOL finished) {
         _scrollView.backgroundColor=[UIColor blackColor];

        
//        #warning 本人改动地方  如果自己上传 需要看长图
         if (_fullImageUrlString.length>0)
        {
            
        }
        else
        {
            

            
            //处理尺寸
            CGFloat length=kScreenWidth/self.image.size.width*self.image.size.height;
            
            if (length  < kScreenHeight)
            {
                
                
            }
            else
            {
                _fullImageView.height=length;
                _scrollView.contentSize=CGSizeMake(kScreenWidth, length);
            }
            
            

        }
    }];
    
    //05 请求网络 下载大图
    if (_fullImageUrlString.length>0) {
        
        NSURL *url=[NSURL URLWithString:_fullImageUrlString];
        NSURLRequest *request=[NSURLRequest  requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
        
        _connection=    [NSURLConnection connectionWithRequest:request delegate:self];
        
        
        _progressView=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame=CGRectMake(0, kScreenWidth/2, kScreenWidth, 20);
        
        [_scrollView addSubview:_progressView];
        
        
    }

    
}


-(void)zoonOut
{
    //调用代理方法
    if ([self.delegate respondsToSelector:@selector(imageWillZoomOut:)])
    {
        
        [self.delegate imageWillZoomOut:self];

        
    }
    
    
    
    [_connection cancel];
    self.hidden=NO;
    
    [UIView animateWithDuration:0.5 animations:^{
         _scrollView.backgroundColor=[UIColor clearColor];
        CGRect frame=[self convertRect:self.bounds toView:self.window];
        _fullImageView.frame=frame;
    
    } completion:^(BOOL finished) {
     
        [_scrollView removeFromSuperview];
        _scrollView=nil;
        _fullImageView=nil;
        
        _progressView = nil;
        _data = nil;
        
        
    }];
}

-(void)createScrollView
{
    
    if (_scrollView==nil)
    {
        
        //1 创建scrollView
        _scrollView=[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds  ];
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.showsVerticalScrollIndicator=NO;
    
        [self.window addSubview:_scrollView];
        
        //2 创建大图图片
        _fullImageView=[[UIImageView alloc]initWithFrame:CGRectZero];//后面动画时 会计算 1 2
        _fullImageView.contentMode=UIViewContentModeScaleAspectFit;
        _fullImageView.image=self.image;
        [_scrollView addSubview:_fullImageView];
        
        
        //3 添加手势
        //01 单击
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoonOut)];
        [_scrollView addGestureRecognizer:tap];
        
        //02 长按 保存
        UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(savePhoto:)];
        [_scrollView addGestureRecognizer:longPress];
        
        
    }
   
    
    
    
    
}

#pragma mark - 长按图片处理
- (void)savePhoto:(UILongPressGestureRecognizer *)longPress{
    
    
    if (longPress.state==UIGestureRecognizerStateBegan)
    {
        //弹出提示框
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否保存图片" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alert show];

    }


}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        UIImage *img = [UIImage imageWithData:_data];
        //1.提示保存
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        hud.labelText = @"正在保存";
        hud.dimBackground = YES;
        
        //2.将大图图片保存到相册
        //  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
        UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)(hud));
        
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    //提示保存成功
    MBProgressHUD *hud = (__bridge MBProgressHUD *)(contextInfo);
    
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    //显示模式改为：自定义视图模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"保存成功";
    
    //延迟隐藏
    [hud hide:YES afterDelay:1.5];
}




#pragma -mark  网络代理
//收到响应 ，建立连接
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    
    

    
    NSHTTPURLResponse *httpResponse=(NSHTTPURLResponse *)response;
    
    NSDictionary *allHeaderFields=[httpResponse allHeaderFields];
    
    NSString *size=[allHeaderFields objectForKey:@"Content-Length"];
    
    _length=[size doubleValue];
    
    _data=[[NSMutableData alloc]init];
    
    _progressView.hidden = NO;

}

//接收数据 会被多次调用
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
    
    CGFloat progress=_data.length/_length;
    _progressView.progress=progress ;
    
    
}

//接受数据结束
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
     _progressView.hidden = YES;
    
    _progressView=nil;
    
    UIImage *image=[UIImage imageWithData:_data];
    _fullImageView.image=image;
    

    //处理尺寸
    CGFloat length=kScreenWidth/image.size.width*image.size.height;
    
    if (length  < kScreenHeight)
    {
    
    
//        _fullImageView.top=(kScreenHeight-length)/2;
//        _fullImageView.height=length;
//        _scrollView.contentSize=CGSizeMake(kScreenWidth, length);
    }
    else
    {
    
        _fullImageView.height=length;
        _scrollView.contentSize=CGSizeMake(kScreenWidth, length);
    
    }
    
    
    
    if (self.isGif) {
        [self gifImageShow];
    }

    
}



- (void)gifImageShow{
    //1.-----------------webView播放---------------------
//                UIWebView *webView = [[UIWebView alloc] initWithFrame:_scrollView.bounds];
//                webView.userInteractionEnabled = NO;
//                webView.backgroundColor = [UIColor clearColor];
//                webView.scalesPageToFit = YES;
//    
//                //使用webView加载图片数据
//                [webView loadData:_data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
//                [_scrollView addSubview:webView];
    
    
    //2. ---------使用ImageIO 提取GIF中所有帧的图片进行播放---------------
    //#import <ImageIO/ImageIO.h>
    
    //
    //    //1>创建图片源
    //    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)(_data), NULL);
    //
    //    //2>获取图片源中图片的个数
    //    size_t count = CGImageSourceGetCount(source);
    //
    //    NSMutableArray *images = [NSMutableArray array];
    //
    //    NSTimeInterval duration = 0;
    //
    //    for (size_t i=0; i<count; i++) {
    //
    //        //3>取得每一张图片
    //        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
    //        UIImage *uiImg = [UIImage imageWithCGImage:image];
    //        [images addObject:uiImg];
    //
    //        //0.1 是一帧播放的时间，累加每一帧的时间
    //        duration += 0.1;
    //    }
    //
    //    //>4-1.或者将所有帧的图片集成到一个动画UIImage对象中
    //    UIImage *imgs = [UIImage animatedImageWithImages:images duration:duration];
    //    _fullImageView.image = imgs;
    //
    //    //        //>4-2.或者将播放的图片组交给_fullImageView播放
    //    //        _fullImageView.animationImages = images;
    //    //        _fullImageView.animationDuration = duration;
    //    //        [_fullImageView startAnimating];
    
    
    //3 -------------SDWebImage 封装的GIF播放------------------
    //#import "UIImage+GIF.h"
    
    
  _fullImageView.image = [UIImage sd_animatedGIFWithData:_data];
    
    
}







@end
