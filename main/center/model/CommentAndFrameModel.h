//
//  CommentAndFrameModel.h
//  项目三
//
//  Created by Mac on 15/8/27.
//  Copyright (c) 2015年 杨梦佳. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface CommentAndFrameModel : NSObject

@property (nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *comment;
@property(nonatomic,strong) NSString *userImageUrl;
@property(nonatomic,strong) NSString *date;
@property(nonatomic,strong) NSString *commentUrl;
@property(nonatomic,strong) NSString *geo;


@property(nonatomic,assign) CGRect labelFrame;
@property(nonatomic,assign) CGRect cellFrame;
@property(nonatomic,assign)CGRect zoomFrame;



@end




