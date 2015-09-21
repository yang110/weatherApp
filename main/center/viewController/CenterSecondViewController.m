//
//  CenterSecondViewController.m
//  项目三
//
//  Created by Mac on 15/8/27.
//  Copyright (c) 2015年 杨梦佳. All rights reserved.
//

#import "CenterSecondViewController.h"
#import "TableViewCell.h"
#import "UIImageView+WebCache.h"
#import <AVOSCloud/AVOSCloud.h>

#import "CommentAndFrameModel.h"
#import "RightEnterViewController.h"

#define kwidth  self.view.bounds.size.width
#define kheight self.view.bounds.size.height


#import "SendCommentViewController.h"
#import "BaseNavViewController.h"


@interface CenterSecondViewController ()<UITableViewDelegate,UITableViewDataSource>
{
  
    
    NSMutableArray *arrayComment;
    UILabel *label;//显示点赞数
    NSNumber *temp;
    NSString *commectStr;//要发表的评论内容
    UIImageView *headerImageView;
    UIButton *buttonPraise;//点赞按钮
    NSDate *localeDate;//纪录 时区 （东八区为准）
    
    
    
    UILabel *nameLabel;
    UILabel *cityLabel;
    
   
}


@end

@implementation CenterSecondViewController



-(instancetype)init
{
    self=[super init];
    if (self)
    {
        
       
        
        
        
         self.hidesBottomBarWhenPushed=YES;
        
        
        _tableView  =[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=[UIColor clearColor];
    
        _tableView.separatorStyle= UITableViewCellSeparatorStyleNone;

        [self.view addSubview:_tableView];
        
        UINib *nib=[UINib nibWithNibName:@"TableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"cell"];
        
        
        //下啦刷新
        self.tableView.header=[MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        
        //创建头大图
        [self createHeader];
        
        
    }
    return self;
    
}

//下啦刷新
- (void)loadNewData
{
     NSLog(@"下载刷新");
    

    [self loadComment];
    
}


-(void)createHeader
{
    headerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 200)];
//    headerImageView.userInteractionEnabled=YES;
    _tableView.tableHeaderView=headerImageView;
    
    nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 170, 100, 30)];
    nameLabel.textColor=[UIColor whiteColor];
    nameLabel.font=[UIFont systemFontOfSize:11];
    [_tableView addSubview:nameLabel];
    
    cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 180, 100, 30)];
    cityLabel.textColor=[UIColor whiteColor];
    cityLabel.font=[UIFont systemFontOfSize:11];
    [_tableView addSubview:cityLabel];
    
    
    
    
    
}


//日期
-(void)getLocalDate
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    localeDate = [date  dateByAddingTimeInterval: interval];

}

//上传 评论 和 图片
-(void)commentAction:(NSString *)string1 and:(UIImage *)image andGeo:(NSString *)geo
{
    
    
    
    
    [self getLocalDate];
    
    
    //分为 有图片传 没图片传
    if (image!=nil)
    {
        
    
        
            NSData *imageData = UIImagePNGRepresentation(image);
            AVFile *imageFile = [AVFile fileWithName:@"image.png" data:imageData];
        

       
        
             [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
                 
                 if (succeeded) {
              

            
                                AVQuery *query = [AVQuery queryWithClassName:@"Comment"];
                                AVObject *post = [query getObjectWithId:_model.commentId];
                                
                                AVUser *user=[AVUser currentUser];
                                NSLog(@"%@",user.username);
                                
                                if(user==nil)
                                {
                                    //请登入;
                                    RightEnterViewController *vc=[[RightEnterViewController alloc]init];
                                    [self presentViewController:vc animated:YES completion:nil];
                                    return;
                                }
                                NSLog(@"%@",user.username);
                                
                                NSDictionary *dic;
                                if (user[@"image"]==nil)
                                {

                                    //用户没上传头像 则默认
                                    dic=@{ @"comment"  : string1,
                                           @"userName" :   user.username,
                                           @"userImageUrl" : @"http://ac-To7omRIV.clouddn.com/vSvplLLL3pKy0Jp1keomLNC.png",
                                           @"date" :  [NSString stringWithFormat:@"%@",localeDate ],
                                           @"commentUrl":imageFile.url,//暂时顶一下
                                           @"geo":geo
                                        };
                                    
                                }
                                else
                                {
                                    
                                    
                                 dic=@{  @"comment"  : string1,
                                         @"userName" :   user.username,
                                         @"userImageUrl" : user[@"image"],
                                         @"date" :[NSString stringWithFormat:@"%@",localeDate],
                                        @"commentUrl":imageFile.url,//暂时顶一下]
                                         @"geo":geo

                                         
                                        };
                                    
                                    
                                }
                                
                                
                                [post addObject:dic forKey:@"com"];
                                [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    
                                    if (succeeded)
                                    {
                                        NSLog(@"评论上传成功");
                                        [self loadComment];
                                        
                                        
                                        [self showStatusTip:@"下载完毕" show:NO andInterger:100];
                                    }
                                }];
                            }
            
             } progressBlock:^(NSInteger percentDone) {
                 
                 
                 
                 [self showStatusTip:@"正在下载..." show:YES andInterger:percentDone];
                 
                 
                 
             }];
        
    
    
    }
    else
    {
        AVQuery *query = [AVQuery queryWithClassName:@"Comment"];
        AVObject *post = [query getObjectWithId:_model.commentId];
        
        AVUser *user=[AVUser currentUser];
        NSLog(@"%@",user.username);
        
        if(user==nil)
        {
            //请登入;
            
            RightEnterViewController *vc=[[RightEnterViewController alloc]init];
            
            [self presentViewController:vc animated:YES completion:nil];
            
            
            
            return;
        }
        
        
        
        NSLog(@"%@",user.username);
        
        NSDictionary *dic;
        if (user[@"image"]==nil)
        {
            
            //用户没上传头像 则默认
            dic=@{ @"comment"  : string1,
                   @"userName" :   user.username,
                   @"userImageUrl" : @"http://ac-To7omRIV.clouddn.com/vSvplLLL3pKy0Jp1keomLNC.png",
                   @"date" :  [NSString stringWithFormat:@"%@",localeDate ],
                   @"commentUrl":@"",//暂时顶一下
                      @"geo":geo
                   };
            
        }
        
        else
        {
            
            
            dic=@{  @"comment"  : string1,
                    @"userName" :   user.username,
                    @"userImageUrl" : user[@"image"],
                    @"date" :[NSString stringWithFormat:@"%@",localeDate],
                    @"commentUrl":@"",//暂时顶一下]
                       @"geo":geo
                    };
            
            
        }
        
        
        [post addObject:dic forKey:@"com"];
        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded)
            {
                NSLog(@"评论上传成功");
                [self loadComment];
            }
        }];

    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *button=[[UIBarButtonItem alloc]initWithTitle:@"评论" style:UIBarButtonItemStylePlain target:self action:@selector(presentViewController)];
    self.navigationItem.rightBarButtonItem = button;

}

//要评论 到SendCommentViewController
-(void)presentViewController
{
  
    
    AVUser *user=[AVUser currentUser];
    
    if (user==nil) {
        
        
        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请先登入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alterView show];
        
        
        return;
    }
    
    
    
    
    
    
    SendCommentViewController *vc=[[SendCommentViewController alloc]init];
    
    UINavigationController *vc1=[[UINavigationController alloc]initWithRootViewController:vc];
    
    
  __weak  CenterSecondViewController *vcc=self;
    
    vc.block110=^(NSString *string1,UIImage *image,NSString *geo)
    {
        [vcc commentAction:string1 and:image andGeo:geo];
    };
    
    [self presentViewController:vc1 animated:YES completion:nil];
    
    
    
}

-(void)setModel:(FirstModel *)model
{
    
    _model=model;
    
    //下载大图
    [headerImageView sd_setImageWithURL:[NSURL URLWithString: _model.imageStr ] ];
    nameLabel.text=_model.name;
    cityLabel.text=_model.location110;
    
    
    
    
    //下载评论
    [self loadComment];
    
    

}

-(void)loadComment
{
  

    
    AVQuery *query = [AVQuery queryWithClassName:@"Comment"];
     [query getObjectInBackgroundWithId:_model.commentId block:^(AVObject *object, NSError *error) {
         
         AVObject *post=object;
         
            NSArray *array=  post[@"com"];
         
         
         
         
             arrayComment=[[NSMutableArray alloc]init];
         
         
             for (int i=0; i<array.count; i++)
             {
         
                 NSDictionary *dic= array[i];
                 CommentAndFrameModel *commentModel=[[CommentAndFrameModel alloc]init];
                 commentModel.commentUrl=dic[@"commentUrl"];//必须要comment前面
                 commentModel.geo=dic[@"geo"];//必须在comment前面
         
                 commentModel.userName=dic[@"userName"];
                 commentModel.comment=dic[@"comment"];    //在这里面 计算frame 高度
                 commentModel.userImageUrl=dic[@"userImageUrl"];
                 commentModel.date=dic[@"date"];
                 
                
                 
                 
                 [arrayComment insertObject:commentModel atIndex:0];
                 
             }
         
         //获取点赞数
          temp= post[@"upvotes"];
         [_tableView reloadData];
         
           
//          拿到当前的下拉刷新控件，结束刷新状态
             [self.tableView.header endRefreshing];
           
       }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return arrayComment.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.commentModel=arrayComment[indexPath.row];
    
    return cell;
    
    
    
}

//返回Row高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentAndFrameModel *model=arrayComment[indexPath.row];
    return model.cellFrame.size.height;
    

}

//组头 添加图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 44)];
    view.backgroundColor=[UIColor grayColor];
    
    

    UILabel *label110=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 44)];
    label110.text=[NSString stringWithFormat:@"评论数:%li", arrayComment.count];
   [view addSubview:label110];
    
    buttonPraise=[[UIButton alloc]initWithFrame:CGRectMake(kwidth-65, 10, 30, 24)];
    [buttonPraise addTarget:self action:@selector(buttonAction1:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buttonPraise];

    
    //网上搜prise里有没有我用户的id
    AVObject *post = [AVObject objectWithoutDataWithClassName:@"Comment" objectId:_model.commentId];
    [post fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        
        NSArray *array=  post[@"prise"];//需要搜查的数组
        
        AVUser *user=[AVUser currentUser];
        NSString *str=[NSString stringWithFormat:@"self='%@'",user.objectId];
        NSPredicate*  predicate=[NSPredicate predicateWithFormat:str];
        
        NSArray *filterArray=[array filteredArrayUsingPredicate:predicate];
        
        //寻找里面的是否有我id
        if (   filterArray.count!=0   )
        {
            //如果有 说明点赞点过了
            [buttonPraise setBackgroundImage:[UIImage imageNamed:@"btn_starred@2x.png"] forState:UIControlStateNormal];
            buttonPraise.tag=1;
            
        }
        else
        {
            [buttonPraise setBackgroundImage:[UIImage imageNamed:@"btn_unstarred@2x.png"] forState:UIControlStateNormal];
            buttonPraise.tag=2;
            
        }
    }];
    
    
    
    
    
    label=[[UILabel  alloc]initWithFrame:CGRectMake(kwidth-25, 0, 50, 44)];
    [view addSubview:label];
    if (temp==nil) {
        label.text=@"0";
    }
    else
    {
        label.text =[temp  stringValue];
    }
    
    
    return view;
    
}

//返回组的头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}


//点赞
-(void)buttonAction1:(UIButton *)button
{
    
    
    if (button.tag==1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该账号已点过👍了" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
        
    }
    
    AVUser *user=[AVUser currentUser];
    if (user!=nil) {
    
        [buttonPraise setBackgroundImage:[UIImage imageNamed:@"btn_starred@2x.png"] forState:UIControlStateNormal];
  
        button.tag=1;
        
        
        AVObject *post = [AVObject objectWithoutDataWithClassName:@"Comment" objectId:_model.commentId];
        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            // 增加点赞的人数
            post.fetchWhenSave = YES;
            [post incrementKey:@"upvotes"];
            [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"%@", post[@"upvotes"]) ;
                NSNumber *temp1=post[@"upvotes"];
                label.text= [temp1 stringValue];
                
            }];
        }];
        
        //保存id号 标示点过赞了
        [post addObject:user.objectId forKey:@"prise"];
        [post saveInBackground];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请先登入" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
   
    
    
}



//回复
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AVUser *user=[AVUser currentUser];
    
    if (user==nil) {
        
        
        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请先登入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alterView show];
        
        
        return;
    }

    
    SendCommentViewController *vc=[[SendCommentViewController alloc]init];
    
    UINavigationController *vc1=[[UINavigationController alloc]initWithRootViewController:vc];
    
    
    __weak  CenterSecondViewController *vcc=self;
    
    vc.block110=^(NSString *string1,UIImage *image,NSString *geo)
    {
        
        [vcc commentAction:string1 and:image andGeo:geo];
        
    };
    
    
    CommentAndFrameModel   *model=arrayComment[indexPath.row];
    
    
    vc.textView.text=[NSString stringWithFormat:@"@%@ ",model.userName];
    
    [self presentViewController:vc1 animated:YES completion:nil];
    

}


@end
