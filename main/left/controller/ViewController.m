//
//  ViewController.m
//  02天气
//
//  Created by Mac on 15/8/13.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import "ViewController.h"
#import "DataService.h"
#import "Modal.h"
#import "CollectionView.h"
#import "PresentViewController.h"
#import "ManageTableViewController.h"
#import "Common.h"


@interface ViewController ()
{
    
    CollectionView *_collectionView;
    NSArray *_weatherIdArray;
    
}
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    

    _modalArray =[[NSMutableArray alloc]init];

    [self loadData1:@"苏州"];
    
    [self setNav];
    
    [self createCollectionView];
    

    
 
}

//下载数据
-(void)loadData1:(NSString *)str
{
 
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:IdValue forKey:IdKenKey];
    [params setValue:str forKey:@"cityname"];
    
    
     [DataService requestAFUrl:@"index" httpMethod:@"GET" params:params data:nil block:^(id result) {


        
        NSDictionary *dic=(NSDictionary *)result;
        NSDictionary *dic1 = dic[@"result"];
        
         NSDictionary *skDic = dic1[@"sk"];
         NSDictionary *todayDic = dic1[@"today"];
         NSDictionary *future = dic1[@"future"];
         
         
         Modal *modal=[[Modal alloc]init];
         
         modal.city = str;
         modal.temp = [skDic objectForKey:@"temp"];
         modal.time = [skDic objectForKey:@"time"];
         modal.humidity = [skDic objectForKey:@"humidity"];
         modal.wind_strength = [skDic objectForKey:@"wind_strength"];
         modal.wind_direction = [skDic objectForKey:@"wind_direction"];
//         modal.week = [todayDic objectForKey:@"week"];
         modal.date_y = [todayDic objectForKey:@"date_y"];
         
         
         modal.temperature1 =[todayDic objectForKey:@"temperature"];
         modal.week1=[todayDic objectForKey:@"week"];
         modal.weather=[todayDic objectForKey:@"weather"];
         modal.weather_id1 = [todayDic objectForKey:@"weather_id"];
         
         NSMutableArray *futureArray = [[NSMutableArray alloc]init];
         NSMutableArray *futureDataArray = [[NSMutableArray alloc]init];
         
        for (NSString *futStr in future) {
            NSString *a = [futStr substringFromIndex:4];
            
            [futureArray addObject:a];
        
        }
         
        NSComparator cmptr = ^(id obj1, id obj2){
            if ([obj1 integerValue] > [obj2 integerValue]) {
                 return (NSComparisonResult)NSOrderedDescending;
            }
             
            if ([obj1 integerValue] < [obj2 integerValue]) {
                 return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        NSArray *sortArray = [[NSArray alloc] initWithArray:futureArray];
         //排序前
        

        //第一种排序
         NSArray *array = [[NSArray alloc]init];
         array =[sortArray sortedArrayUsingComparator:cmptr];
        
         
         for (int i = 0; i<array.count; i++) {
             NSString *str = [NSString stringWithFormat:@"day_%@",array[i]];
             NSDictionary *futureDic = [future objectForKey:str];
             [futureDataArray addObject:futureDic];
         }
  
//         NSDictionary *future0 = futureDataArray[0];
//         modal.temperature2 =[future1 objectForKey:@"temperature"];
//         modal.week2=[future1 objectForKey:@"week"];
//         modal.weather2=[future1 objectForKey:@"weather"];
//         modal.weather_id2 = [future1 objectForKey:@"weather_id"];
//         modal.wind2 = [future1 objectForKey:@"weather_id"];
         
         
         
         
         NSDictionary *future1 = futureDataArray[1];
         modal.temperature2 =[future1 objectForKey:@"temperature"];
         modal.week2=[future1 objectForKey:@"week"];
         modal.weather2=[future1 objectForKey:@"weather"];
         modal.weather_id2 = [future1 objectForKey:@"weather_id"];
//         modal.wind2 = [future1 objectForKey:@"weather_id"];
         
         NSDictionary *future2 = futureDataArray[2];
         modal.temperature3 =[future2 objectForKey:@"temperature"];
         modal.week3=[future2 objectForKey:@"week"];
         modal.weather3=[future2 objectForKey:@"weather"];
         modal.weather_id3 = [future2 objectForKey:@"weather_id"];
         
         NSDictionary *future3 = futureDataArray[3];
         modal.temperature4 =[future3 objectForKey:@"temperature"];
         modal.week4=[future3 objectForKey:@"week"];
         modal.weather4=[future3 objectForKey:@"weather"];
         modal.weather_id4 = [future3 objectForKey:@"weather_id"];
         
         NSDictionary *future4 = futureDataArray[4];
         modal.temperature5 =[future4 objectForKey:@"temperature"];
         modal.week5=[future4 objectForKey:@"week"];
         modal.weather5=[future4 objectForKey:@"weather"];
         modal.weather_id5 = [future4 objectForKey:@"weather_id"];
         
         NSDictionary *future5 = futureDataArray[5];
         modal.temperature6 =[future5 objectForKey:@"temperature"];
         modal.week6=[future5 objectForKey:@"week"];
         modal.weather6=[future5 objectForKey:@"weather"];
         modal.weather_id6= [future5 objectForKey:@"weather_id"];
         
         NSDictionary *future6 = futureDataArray[6];
         modal.temperature7 =[future6 objectForKey:@"temperature"];
         modal.week7=[future6 objectForKey:@"week"];
         modal.weather7=[future6 objectForKey:@"weather"];
         modal.weather_id7 = [future6 objectForKey:@"weather_id"];
         
         modal.futureArray = futureDataArray;
        
         
         
        [_modalArray addObject:modal];
      
         
         _collectionView.modalArray=_modalArray;
    }];
    
    
}


//设leftBarButtonItem
-(void)setNav
{
  
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cm_tag_icon_4@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(manageCity)];
    
    self.navigationItem.leftBarButtonItem=left;
    
    
}


//创建collectionView
-(void)createCollectionView
{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.itemSize=CGSizeMake(kScreenWidth, (kScreenHeight-64-49)*2);
    layout.minimumLineSpacing=0;
    layout.minimumInteritemSpacing=0;
    layout.sectionInset=UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection= UICollectionViewScrollDirectionHorizontal;
    
    
    _collectionView=[[CollectionView alloc]initWithFrame:CGRectMake(0,-64, kScreenWidth, kScreenHeight*2) collectionViewLayout:layout];
    [self.view addSubview:_collectionView];
}


#pragma mark - Action

//push
- (void)manageCity
{
    
    

    ManageTableViewController *vc =[[ManageTableViewController alloc]init];
   
    
    
    //初始化  城市列表
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i=0; i<_modalArray.count; i++)
    {
        Modal *model =_modalArray[i];
        
        [arr addObject:model.city];
    }
    vc.cityNameArray =arr;
    
    
    
    
    vc.block1=^(NSArray *arrayM)
    {
        
        
        [_modalArray removeAllObjects];
        
        for (NSString *str in arrayM)
        {
            [self loadData1:str];
        }
    };
    
    
     [self.navigationController pushViewController:vc animated:YES];
}

@end
