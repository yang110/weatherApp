//
//  SendCommentViewController.h
//  项目三
//
//  Created by Mac on 15/8/31.
//  Copyright (c) 2015年 杨梦佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoomImageView.h"
#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "FaceScrollView.h"

typedef void(^AlertBlock) (NSString *string1,UIImage *image,NSString *geo);


@interface SendCommentViewController : BaseViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    

    
    //2 工具栏
    UIView *_editorBar;
    
    
    ZoomImageView *_zoomImageView;
    
    
    //4
    CLLocationManager *_locationManager;
    
    //5 表情面板
    FaceScrollView *_faceViewPanel;

}

//1 文本编辑栏
@property(nonatomic) UITextView *textView;

@property(nonatomic,copy)  AlertBlock block110;

@end
