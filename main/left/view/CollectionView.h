//
//  CollectionView.h
//  02天气
//
//  Created by Mac on 15/8/13.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CollectionView : UICollectionView <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>



@property (nonatomic) NSArray *modalArray;
@property (nonatomic) NSArray *futureDataArray;



@end
