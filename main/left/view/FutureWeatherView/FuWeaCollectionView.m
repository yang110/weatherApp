//
//  FuWeaCollectionView.m
//  02天气
//
//  Created by zhoujie on 15/8/30.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import "FuWeaCollectionView.h"
#import "FuWeaCollectionViewCell.h"

@implementation FuWeaCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
 
    self=[super initWithFrame:frame collectionViewLayout:layout];
    if (self) {

        
        UINib *nib=[UINib nibWithNibName:@"FuWeaCollectionViewCell" bundle:[NSBundle mainBundle]];
        [self registerNib:nib forCellWithReuseIdentifier:@"cell"];
        
        self.delegate=self;
        self.dataSource=self;
        
        self.pagingEnabled=YES;

    }
    return self;
}



-(void)setModal:(Modal *)modal
{
    _modal=modal;
    [self reloadData];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return 6;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    FuWeaCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    cell.futuremodal=_modal.futureArray[indexPath.row];
    
    
    
    
    
    return cell;
}



@end
