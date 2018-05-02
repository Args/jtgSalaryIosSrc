//
//  HomePageVC.m
//  OfficeOA
//
//  Created by sunzhaokai on 2017/7/6.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "HomePageVC.h"
#import "SalaryInfoVC.h"
#import "NotificationInfoVC.h"
#import "SystemSettingVC.h"
#import "UIImageView+AFNetworking.h"

#define logoWidth AutoFitWidth(166)         //logo宽度
#define topSpace AutoFitHeight(96)          //顶部间距
#define leftSpace   AutoFitWidth(100)          //按钮距离左边距离
#define contentBtWidth SCREEN_WIDTH-AutoFitWidth(100)*2       //按钮宽度
#define contentBtHeight AutoFitHeight(53)    //按钮高度
#define contentBtMidHeight AutoFitHeight(125)  //按钮之间高度
@interface HomePageVC ()

//@property(nonatomic,retain)UIButton * contentBt;//工资信息，通知信息，系统设置按钮
@property(nonatomic,retain)UIScrollView *myScrollView;//全屏的scrollview
@property(nonatomic,copy)NSArray *dataArr;
@property(nonatomic,strong)NSArray *imageArr;
@property (nonatomic,retain)UIImageView *logoImg;
@end

@implementation HomePageVC

-(NSArray *)dataArr
{
    if (_dataArr==nil) {
        _dataArr=@[@"工资信息",@"通知信息",@"系统设置"];
    }
    return _dataArr;
}
-(NSArray *)imageArr{
    if (!_imageArr) {
        _imageArr = @[@"gongzi",@"tongzhi",@"shezhi"];
    }
    return  _imageArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithHexString:@"#f7f7f7"];
    
    
    //logo图标
    self.backImg.hidden = YES;

    
    [self addMyScrollView];
    self.logoImg=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x-logoWidth/2,AutoFitHeight(110), logoWidth, logoWidth)];
    self.logoImg.image=[UIImage imageNamed:@"title"];
    self.logoImg.layer.cornerRadius=logoWidth/2;
    self.logoImg.layer.masksToBounds=YES;
    [self.myScrollView addSubview:self.logoImg];
    //工资信息，通知信息，系统设置按钮
    for (int i=0; i<3; i++) {
        
        UIButton * _contentBt=[[UIButton alloc]initWithFrame:CGRectMake(leftSpace, AutoFitHeight(180)+(contentBtHeight+contentBtMidHeight)*i+logoWidth, contentBtWidth, contentBtHeight)];
        _contentBt.titleLabel.font = [UIFont systemFontOfSize:AutoFitHeight(26)];

//        _contentBt.backgroundColor=[UIColor colorWithHexString:@"#3e64b4"];
        [_contentBt setTitle:self.dataArr[i] forState:UIControlStateNormal];
        [_contentBt setImage:[UIImage imageNamed:self.imageArr[i]] forState:UIControlStateNormal];
        _contentBt.layer.cornerRadius=AutoFitWidth(10);
        _contentBt.layer.masksToBounds=YES;
        _contentBt.tag=111+i;
        [_contentBt addTarget:self action:@selector(contentBtClick:) forControlEvents:UIControlEventTouchUpInside];
        [_myScrollView addSubview:_contentBt];
        _myScrollView.contentSize=CGSizeMake(SCREEN_WIDTH,CGRectGetMaxY(_contentBt.frame)+AutoFitHeight(70));
    }
}
#pragma mark---添加scrollview
-(void)addMyScrollView
{
    _myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, topSpace, SCREEN_WIDTH, SCREEN_HEIGHT-logoWidth)];
    _myScrollView.bounces=NO;
//    _myScrollView.backgroundColor=[UIColor colorWithHexString:@"#f7f7f7"];
    _myScrollView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_myScrollView];
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImage.image = [UIImage imageNamed:@"背景1"];
    [self.view insertSubview:backImage atIndex:0];
}

- (UIImage *) dataURL2Image: (NSString *) imgSrc
{
    if (!imgSrc) {
        return [UIImage imageNamed:@"title"];
    }
    
//    NSData *_decodedImageData   = [[NSData alloc] initWithBase64Encoding:imgSrc];
//    
//    UIImage *_decodedImage      = [UIImage imageWithData:_decodedImageData];
//    return [UIImage imageNamed:@"title"];
//    if (!_decodedImage) {
//        return [UIImage imageNamed:@"title"];
//    }
//    return _decodedImage;
    NSURL *url = [NSURL URLWithString: imgSrc];
    NSData *data = [NSData dataWithContentsOfURL: url];
    UIImage *image = [UIImage imageWithData: data];
    
    return image;
}
-(void)getHeadProtrait{
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",get_head ]
//    self.logoImg setImageWithURL:<#(nonnull NSURL *)#> placeholderImage:<#(nullable UIImage *)#>
//    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    hud.tag        = 1002;
//    hud.label.text = @"正在加载...";
    AFHTTPSessionManager * mgr            = [AFHTTPSessionManager manager];
    mgr.responseSerializer                = [[AFHTTPResponseSerializer alloc] init];
    mgr.requestSerializer.timeoutInterval = REQUEST_TIMEOUT;
    //    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    AFSecurityPolicy *secu = [[AFSecurityPolicy alloc]init];
    [secu setAllowInvalidCertificates:true];
    [mgr setSecurityPolicy:secu];
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSString * userid = [df objectForKey:@"userID"];
    if (!userid) {
        userid = @"";
    }
    [mgr POST:get_head parameters:@{@"UserID":userid} progress:^(NSProgress * _Nonnull downloadProgress) {
        //progress
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //下次使用上次设置的IP
        NSError *err;
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];

        if (str) {
            NSString *tmp = [dic valueForKey:@"Column_头像"];
            UIImage * img = [self dataURL2Image:tmp];
            _logoImg.image = img;
        }
   
        
      //  [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            MBProgressHUD *hud = (MBProgressHUD *)[self.navigationController.view viewWithTag:1002];
//            hud.mode = MBProgressHUDModeCustomView;
//            hud.label.text = @"载入失败！\n请检查网络是否通畅！\n(＞﹏＜)";
//            hud.label.numberOfLines = 3;
//            [hud hideAnimated:YES afterDelay:1];
//            
//        });
        
        NSLog(@"error%@",error);
    }];

}
#pragma mark---按钮点击事件
-(void)contentBtClick:(UIButton *)sender
{
    switch (sender.tag) {
        //工资信息
        case 111:{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"查看工资信息" message:@"已签收或未签收" preferredStyle: UIAlertControllerStyleActionSheet];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            UIAlertAction *signedAction = [UIAlertAction actionWithTitle:@"已签收" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                SalaryInfoVC *salaryInfo=[[SalaryInfoVC alloc]init];
                salaryInfo.isSigned = YES;
                [self.navigationController pushViewController:salaryInfo animated:YES];
            }];
            
            UIAlertAction *noSignedAction = [UIAlertAction actionWithTitle:@"未签收" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                SalaryInfoVC *salaryInfo=[[SalaryInfoVC alloc]init];
                salaryInfo.isSigned = NO;
                [self.navigationController pushViewController:salaryInfo animated:YES];
            }];
            
            [alertController addAction:cancelAction];
            
            
            [alertController addAction:signedAction];
            [alertController addAction:noSignedAction];
            [self presentViewController:alertController animated:YES completion:nil];

        }
            break;
        //通知信息
        case 112:{
            NotificationInfoVC *notificationInfo=[[NotificationInfoVC alloc]init];
            [self.navigationController pushViewController:notificationInfo animated:YES];
        }
            break;
        //系统设置
        case 113:{
            SystemSettingVC *systemSetting=[[SystemSettingVC alloc]init];
            [self.navigationController pushViewController:systemSetting animated:YES];
        }
            break;
        default:
            break;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=YES;
    [self getHeadProtrait];

}

@end
