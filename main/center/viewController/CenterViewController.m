//
//  CenterViewController.m
//  项目三
//
//  Created by Mac on 15/8/27.
//  Copyright (c) 2015年 杨梦佳. All rights reserved.
//

#import "CenterViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "FirstModel.h"
#import "CenterSecondViewController.h"
#import "Common.h"
#import "YangView.h"
#import "FirstCollectionViewCell.h"
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CoreLocation.h>

@interface CenterViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate>
{
    NSMutableArray *_arrayModel;
    NSString *imageStr;
    UICollectionView *_collectionView;
    YangView *headView;
    NSString *location110;//当前地理位置（杭州）
    
}

@property(nonatomic, strong) UIImagePickerController *picker;//相册图片选择

@end

@implementation CenterViewController




#pragma  mark - 上传美景图

-(void)createBarButtonItem
{
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button addTarget:self action:@selector(selectImage) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
}

//打开相册框
- (void)selectImage
{
    
    
        [self getGeoPoint];
    
    
    
    AVUser *user=[AVUser currentUser];
    if (user!=nil) {
        
        [self presentViewController:_picker animated:YES completion:nil];

    }
    else
    {
        
        UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"请登入" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alter show];
        
    }

}

//关闭相册后  1）保存image  2）创建comment文件  3）获取url 4）model添加url和commentId  5）url添加到json并保存
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self showHUD:@"正在上传"];
 
    [_picker dismissViewControllerAnimated:YES completion:^{
        
        NSLog(@"图片选择完毕2");
        
    }];
    
    UIImage *image=info[@"UIImagePickerControllerOriginalImage"];
    NSData *imageData = UIImagePNGRepresentation(image);
    AVFile *imageFile = [AVFile fileWithName:@"image.png" data:imageData];
    
    //保存图片
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (succeeded)
        {
            NSLog(@"图片保存成功");
            

            [self completeHUD:@"上传完成"];
         
            
            
            //创建comment文件
            AVObject *comment = [AVObject objectWithClassName:@"Comment"];
            [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
               
       
                
                
                
                //  (1)查询基础文件
                AVObject *post = [AVObject objectWithoutDataWithClassName:@"Post" objectId:baseInit];
                
                    //新增2属性 username和location110，username暂时未用到
                AVUser *user=[AVUser currentUser];
                
                //  (2)_arrayModel添加新数据model  model添加url（直接添加 不是再从网上下载，节约资源）
                FirstModel *model=[[FirstModel  alloc]init];
                model.imageStr=imageFile.url;
                model.commentId=comment.objectId;
                model.name=user.username;
                model.location110=location110;
                [_arrayModel insertObject:model atIndex:0];

                // （3）设置 数据存储格式
                NSDictionary *dic=@{@"url": model.imageStr,
                                    @"commentId" :comment.objectId,
                                    @"userName":user.username,
                                    @"cityName":location110
                                    };
                [post addObject:dic forKey:@"image"];
                //（4）保存文件
                [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded)
                    {
                        NSLog(@"文件保存成功");
                    }
                }];
                
                
           
         
                [_collectionView reloadData];
                headView.array=_arrayModel;
                
          
          
            
            }]; //创建comment文件
            
        }// if (succeeded)
    }];//保存图片
}

#pragma mark 初始化picker
-(void)createImagePicker
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    _picker.allowsEditing = NO;
    _picker.sourceType = sourceType;
}

#pragma mark 初始化collectionView
-(void)createCollectionView
{
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing=10;
    layout.minimumInteritemSpacing=10;
    layout.itemSize=CGSizeMake((kwidth-50)/4 ,(kwidth-50)/4 );
    
    _collectionView=[[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor=[UIColor clearColor];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    
    

    
    
    //注册cell
    UINib *nib=[UINib nibWithNibName:@"FirstCollectionViewCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"cell"];
}

-(void)createHeaderView
{
    
    headView=[[YangView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 190)];
    headView.backgroundColor=[UIColor redColor];
    [_collectionView addSubview:headView];
}

#pragma mark 初始化获取地理坐标
-(void)getGeoPoint
{
    
    [AVGeoPoint geoPointForCurrentLocationInBackground:^(AVGeoPoint *geoPoint, NSError *error) {
        
        if (error!=nil) {
            NSLog(@"%@",error);
            
            
            
            UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"定位失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil   ,nil];
            
            [alterView show];
            
             location110=@"定位失败";
            
            
        }
        else
        {
          AVGeoPoint *  point=geoPoint;
            
            
            
            NSNumber *num2=[point valueForKey:@"longitude"];
            double longitude=[num2 longLongValue];
            NSNumber *num= [point valueForKey:@"latitude"];
            double latitude=[num doubleValue];
            
            //
            //    NSLog(@"%@",point);
            
            //
            //    NSLog(@"latitude=%lf longitude=%lf",latitude,longitude);
            //
            //进行反编码

            
            CLLocation *location=[[CLLocation alloc ]initWithLatitude:latitude longitude:longitude];
            CLGeocoder *geoCoder=[[CLGeocoder alloc]init];
            [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
                if (error==nil) {
                    
                    CLPlacemark *place=[placemarks lastObject];
                    location110=place.locality;
                    NSLog(@"%@",location110);
                }
                else
                {
                    location110=@"定位失败";
                    
                }
            }];

            
            
        }
        
        
    }];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"实景";
    
    
    [self getGeoPoint];//定位
  
    
    [self createBarButtonItem];//按钮

    [self createImagePicker];
 
    [self createCollectionView];
    
    
    [self createHeaderView];
    
    
    //从网上下载数据 到arraymodel,每次开机都需要，保证网络版
    [self loadData];
    
    //下啦刷新
    _collectionView .header=[MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];

}

#pragma mark 登入时 下载json数据 到_arrayModel
-(void)loadData
{


    _arrayModel=[[NSMutableArray array]init];
    //查询(永不改的地方   每个用户一开始就查询55dd95e060b20ee9ecd24f22文件)
    AVQuery *query = [AVQuery queryWithClassName:@"Post"];
    [query getObjectInBackgroundWithId:baseInit block:^(AVObject *object, NSError *error) {
        
        
        
        NSArray *array= object[@"image"];
        for (int i=0; i<array.count; i++)
        {
            FirstModel *model=[[FirstModel  alloc]init];
            model.imageStr=array[i][@"url"];
            model.commentId=array[i][@"commentId"];
            model.name=array[i][@"userName"];
            model.location110=array[i][@"cityName"];
                     
            
            
            [_arrayModel insertObject:model atIndex:0];
        }
        [_collectionView reloadData];
        
        headView.array=_arrayModel;
        
        
        

         [_collectionView.header endRefreshing];
    }];

    
}


#pragma -mark collection代理
//2
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arrayModel.count;
}

//3
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FirstCollectionViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor yellowColor];
    cell.model=_arrayModel[indexPath.row];
    
    return cell;
    
}


#pragma -mark 点击进入下个页面
//点击
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CenterSecondViewController *vc2=[[CenterSecondViewController alloc]init];
    vc2.model=_arrayModel[indexPath.row];
    [self.navigationController pushViewController:vc2 animated:YES];

}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size=CGSizeMake(kScreenWidth, 200);
    return size;
    
}

@end
