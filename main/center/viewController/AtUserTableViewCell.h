//
//  AtUserTableViewCell.h
//  项目三
//
//  Created by Mac on 15/9/5.
//  Copyright (c) 2015年 杨梦佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstModel.h"
@interface AtUserTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;


@property (nonatomic)FirstModel *model;


@end
