//
//  PresentViewController.m
//  02天气
//
//  Created by Mac on 15/8/13.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import "PresentViewController.h"
#define kwidth  self.view.bounds.size.width
#define kheight self.view.bounds.size.height

@interface PresentViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PresentViewController


-(instancetype)init
{
    self=[super init];
    if (self)
    {
        
        //_cityArray=[[NSMutableArray alloc]init];
        
    
    }
    return self;
}


- (IBAction)goBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:NO];
}




- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    [self loadData];
    
    [self createTableView];
    
    
    
    
}

-(void)loadData
{
    
    NSString *path=[[NSBundle mainBundle]pathForResource:@"cityCode" ofType:@"plist"];
    NSDictionary *dic=[NSDictionary dictionaryWithContentsOfFile:path];
    
    _arrayKeys=[dic allKeys];
    _arrayValues=[dic allValues];
    
    
    
}

-(void)createTableView
{
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64,kwidth , kheight)];
    [self.view addSubview:_tableView];
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayKeys.count;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];

    cell.textLabel.text=_arrayKeys[indexPath.row];
    

    
    return cell;

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string=  _arrayValues[indexPath.row];
    BOOL isHold = NO;
    
    for (int i=0   ;i<_cityNameArray.count;i++  )
    {
        
        if ([string isEqualToString:_cityNameArray[i]])
        {
            isHold=YES;
            
            
        }
    }
    if (isHold==NO) {
        _block(  _arrayValues[indexPath.row]);
        [self dismissViewControllerAnimated:YES completion:nil];
//        [self.navigationController popViewControllerAnimated:NO];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    }
    

    

}




@end
