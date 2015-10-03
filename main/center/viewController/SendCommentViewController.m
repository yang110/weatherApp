//
//  SendCommentViewController.m
//  项目三
//
//  Created by Mac on 15/8/31.
//  Copyright (c) 2015年 杨梦佳. All rights reserved.
//

#import "SendCommentViewController.h"
#import "UIViewExt.h"
#import <AVOSCloud/AVOSCloud.h>
#import "DataService.h"
#import "Common.h"
#import "AtUserTableViewController.h"

@interface SendCommentViewController ()<UIActionSheetDelegate,ZoomImageViewDelegate,CLLocationManagerDelegate,FaceViewDelegate>
{
    UILabel *geoLable;
}
@end

@implementation SendCommentViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//一先
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return  self;
    
    
}

//三 后
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"评论";
    
    
    //弹出键盘
    [_textView becomeFirstResponder];
}

//二 再
-(instancetype)init
{
    self=[super init];
    if (self) {
        
        self.edgesForExtendedLayout=UIRectEdgeNone;//不延伸
        
        [self _createNavItems];
        [self _createEditorViews];
        
    }
    return self;
    
}

//导航按钮
- (void)_createNavItems
{
    
    //1.关闭按钮
    UIButton *closeButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [closeButton setBackgroundImage:[UIImage imageNamed: @"button_icon_close.png" ] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeItem=[[UIBarButtonItem alloc]initWithCustomView:closeButton];
    self.navigationItem.leftBarButtonItem=closeItem;
    
    
    
    //2.发送按钮
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
      [sendButton setBackgroundImage:[UIImage imageNamed: @"button_icon_ok.png" ] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    self.navigationItem.rightBarButtonItem=sendItem;
    
    
}

//初始化
- (void)_createEditorViews
{
   
    //1 文本输入视图
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    _textView.font=[UIFont systemFontOfSize:16];
    _textView.editable = YES;
    _textView.backgroundColor=[UIColor lightGrayColor];
    _textView.layer.cornerRadius=10;
    _textView.layer.borderWidth=2;
    _textView.layer.borderColor=[UIColor blackColor].CGColor;
    [self.view addSubview:_textView];



    
    //2 编辑工具栏
    _editorBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 55)];
    _editorBar.backgroundColor = [UIColor redColor];
    [self.view addSubview:_editorBar];
    
    
    //3.创建多个编辑按钮
    NSArray *imgs = @[
                      @"compose_toolbar_1.png",
                      @"compose_toolbar_4.png",
                      @"compose_toolbar_3.png",
                      @"compose_toolbar_5.png",
                      @"compose_toolbar_6.png"
                      ];
    for (int i=0; i<imgs.count; i++) {
        NSString *imgName = imgs[i];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15+(kScreenWidth/5)*i, 10, 40, 33)];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10+i;
        
        
        [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        
        
        [_editorBar addSubview:button];
    }
    
    //    4创建地理位置
    geoLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    geoLable.text=@"该用户未定位";
    geoLable.hidden=YES;
    geoLable.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:geoLable];
  
    
    

}


#pragma mark - 工具栏按钮执行 12345
- (void)buttonAction:(UIButton*)button
{
    NSLog(@"%li",button.tag);
    
    if (button.tag==10)
    {
        [self _selectPhoto];
    }
    else  if (button.tag==11)
    {
        //加个#
        NSMutableString *mString=[[NSMutableString alloc]initWithString:_textView.text];
        _textView.text= [mString stringByAppendingString:@"#"];
    }
    else  if (button.tag==12)
    {

        
        

        AtUserTableViewController *vc=[[AtUserTableViewController alloc]init];
        
        
        __block SendCommentViewController *blockSelf=self;
        
        
        vc.block112=^(NSString *name){
          NSMutableString *mString=[[NSMutableString alloc]initWithString:_textView.text];
          blockSelf.textView.text= [mString stringByAppendingFormat:@"@%@ ",name];
    
        };
        
        
        
        [self.navigationController pushViewController:vc animated:YES];
    
    }
    else  if (button.tag==13)
    {
        [self _location];
    }
    else if(button.tag == 14)
    {
        //显示、隐藏表情
        BOOL isFirstResponder = _textView.isFirstResponder;
        
        //输入框是否是第一响应者，如果是，说明键盘已经显示
        if (isFirstResponder)
        {
            //隐藏键盘
            [_textView resignFirstResponder];
            //显示表情
            [self _showFaceView];
            //隐藏键盘
            
        }
        else
        {
            //隐藏表情
            [self _hideFaceView];
            
            //显示键盘
            [_textView becomeFirstResponder];
        }
        
    }

    
}



#pragma 地理位置
-(void)_location
{
    if (_locationManager==nil)
    {
        _locationManager=[[CLLocationManager alloc]init];
        
        
        if (kVersion>8.0)
        {
            //获取授权使用地理位置服务
            [_locationManager requestWhenInUseAuthorization];
        }
        
    }
    
    //定位精确度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    _locationManager.delegate=self;
    
    [_locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    
    
    //停止定位
    [_locationManager stopUpdatingLocation];
    
    CLLocation *location=[locations lastObject];
    
    
    CLLocationCoordinate2D coordinate=location.coordinate;
    
    NSLog(@"%lf  %lf",coordinate.latitude,coordinate.longitude);
    
    
  __weak SendCommentViewController *weakSelf=self;

    //方法二 自带的
    CLGeocoder *geoCoder=[[CLGeocoder alloc]init];
        [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
    
            
              __strong SendCommentViewController *strongSelf=weakSelf;
            
         
              
                
                CLPlacemark *place=[placemarks lastObject];
                NSLog(@"%@",place.locality);
                
                
                strongSelf->geoLable.hidden=NO;
           
                strongSelf->geoLable.bottom=strongSelf->_editorBar.top;
                
            if (error==nil) {
                  strongSelf->geoLable.text=place.locality;
            
            }
            else
            {
                 strongSelf->geoLable.text=@"定位失败";
                
            }
            
            
            
        }];
    
//    //授权(暂时失败 ，有空再说)(具体需要研究下demo)
//    
//    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
//    
//    [params setObject:@"3874545647" forKey:@"client_id"];
//    [params setObject:@"http://www.baidu.com" forKey:@"redirect_uri"];
//    [params setObject:@"code" forKey:@"response_type"];
//    
//
//    
//    [DataService requestUrl:@"/oauth2/authorize" httpMethod:@"GET" params:params block:^(id result) {
//        
//        
//        NSString *urlStr=(NSString *)result;
//
//        UIWebView*   _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenHeight-60)];
//        [self.view addSubview:_webView];
//        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
//        [_webView loadRequest:request];
//        
//        
//       
//    }];
//    
    
    
}


#pragma mark - 导航栏左右按钮

- (void)sendAction//右
{
    NSString *text = _textView.text;
    NSString *error = nil;
    
    if (text.length == 0)
    {
        error = @"内容为空";
    }
    else if(text.length > 140)
    {
        error = @"内容大于140字符";
    }
    
    if (error != nil) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    // 发送 用block  回调到second页面
    _block110(text,_zoomImageView.image,geoLable.text);
    
    [self closeAction];
    
}

-(void)closeAction//左
{
    [_textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - 键盘弹出通知
- (void)keyBoardWillShow:(NSNotification *)notification
{
    
    
    //1 取出键盘frame
    NSValue *bounsValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    
    CGRect frame = [bounsValue CGRectValue];
    
    //3 调整视图的高度
  
    _editorBar.bottom =frame.origin.y-64;

    
    //4 调整地理位置label高度
    geoLable.bottom=_editorBar.top;
    
    
    //5隐藏
    [self _hideFaceView];
    
    
    
}

#pragma mark - 选择照片
-(void)_selectPhoto
{
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    
    
    [actionSheet showInView:self.view];
    

    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    
    
    UIImagePickerControllerSourceType sourceType;
    
    if (buttonIndex==0)
    {
        //拍照
        sourceType=UIImagePickerControllerSourceTypeCamera;
        
        BOOL isCamera=[UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (isCamera==NO)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"摄像头无法使用" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            return;
            
        }
        
    }
    else if (buttonIndex==1)
    {
        //选择相册
        sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    else if(buttonIndex==2)
    {
        return;
        
        
    }
    
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.sourceType=sourceType;
    picker.delegate=self;
    
    [self presentViewController:picker animated:YES completion:nil];
    
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (_zoomImageView==nil)
    {
        _zoomImageView=[[ZoomImageView alloc]initWithImage:image];
        _zoomImageView.frame=CGRectMake(10, _textView.bottom+10, 80, 80);
        [self.view addSubview:_zoomImageView ];
        _zoomImageView.delegate=self;
        
    }
    
    _zoomImageView.image=image;
    
    
    
    
    
    
    
    
}

#pragma mark - 表情处理

//显示表情
- (void)_showFaceView
{

    //创建表情面板
    if (_faceViewPanel == nil) {
        
        
        _faceViewPanel = [[FaceScrollView alloc] init];
        
        //注意 隔着 2层
        [_faceViewPanel setFaceViewDelegate:self];
        
        
        //放到底部
        _faceViewPanel.top  = kScreenHeight-64;
        [self.view addSubview:_faceViewPanel];
    }
    
    //显示表情
    [UIView animateWithDuration:0.3 animations:^{
        
        _faceViewPanel.bottom = kScreenHeight-64;
        
        //重新布局工具栏、输入框
        _editorBar.bottom = _faceViewPanel.top;
        
        geoLable.bottom=_editorBar.top;
        
        
    }];
}

//隐藏表情
- (void)_hideFaceView
{
    
    //隐藏表情
    [UIView animateWithDuration:0.3 animations:^{
        _faceViewPanel.top = kScreenHeight;
        
        geoLable.bottom=_editorBar.top;
        
        
        
    }];
    
}

#pragma mark - 表情代理方法
//代理方法
- (void)faceDidSelect:(NSString *)text
{
    NSLog(@"选中了%@",text);
    
    NSMutableString *mString=[[NSMutableString alloc]initWithString:_textView.text];

    _textView.text= [mString stringByAppendingString:text];
    
    
}


#pragma mark - zoomImageView代理

-(void)imageWillZoomOut:(ZoomImageView *)imageView
{
    
    
    [_textView becomeFirstResponder];
}

-(void)imageWillZoomin:(ZoomImageView *)imageView
{
    
    
    [_textView resignFirstResponder];
    
}


@end
