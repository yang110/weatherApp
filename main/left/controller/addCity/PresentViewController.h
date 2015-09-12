//
//  PresentViewController.h
//  02天气
//
//  Created by Mac on 15/8/13.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Block) (NSString *str);

@interface PresentViewController : UIViewController
{
    UITableView *_tableView;
    
    NSArray *_arrayKeys;
    NSArray *_arrayValues;
}

//@property(nonatomic) NSMutableArray *cityArray;
@property(nonatomic,strong) NSMutableArray *cityNameArray;


@property(nonatomic,strong)Block block;










@end
