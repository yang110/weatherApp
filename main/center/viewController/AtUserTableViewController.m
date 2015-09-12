//
//  AtUserTableViewController.m
//  项目三
//
//  Created by Mac on 15/9/5.
//  Copyright (c) 2015年 杨梦佳. All rights reserved.
//

#import "AtUserTableViewController.h"
#import "AtUserTableViewCell.h"
@interface AtUserTableViewController ()
{


}




@property (nonatomic,strong) NSMutableArray *arrayModel;


@end

@implementation AtUserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"用户列表";
    [self loadData];
    
    UINib *nib=[UINib nibWithNibName:@"AtUserTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    

}

-(void)loadData
{
    
    _arrayModel=[[NSMutableArray alloc]init];
    
    
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];

    
    NSArray *users= [query findObjects];
    
    
    
    for (int i=0; i<users.count; i++)
    {
        
    
        FirstModel *model=[[FirstModel alloc]init  ];
        
        
        AVUser *user=users[i];
        
        model.imageStr=   [user valueForKey:@"image"];
        model.name=[user valueForKey:@"username"];
        
        
        [_arrayModel addObject:model];
        
    }
    

}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _arrayModel.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    AtUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
 
    cell.model=_arrayModel[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    FirstModel *model=_arrayModel[indexPath.row];
    
    
    _block112(model.name);
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
@end
