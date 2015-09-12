//
//  FirstCollectionViewCell.h
//  项目三
//
//  Created by Mac on 15/9/6.
//  Copyright (c) 2015年 杨梦佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstModel.h"
@interface FirstCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *location;


@property(nonatomic,strong)FirstModel   *model;

@end
