//
//  TableViewCell.h
//  项目三
//
//  Created by Mac on 15/8/26.
//  Copyright (c) 2015年 杨梦佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentAndFrameModel.h"
#import "ZoomImageView.h"
#import "WXLabel.h"

@interface TableViewCell : UITableViewCell<WXLabelDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *createTime;
@property (strong, nonatomic) IBOutlet UILabel *geoLabel;


@property (strong, nonatomic)  WXLabel *comment;
@property(strong,nonatomic)ZoomImageView *zoomImageView;

//传过来的数据  包含frame
@property(nonatomic,strong) CommentAndFrameModel *commentModel;


@end
