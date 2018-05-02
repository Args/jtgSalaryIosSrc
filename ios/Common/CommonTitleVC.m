//
//  CommonTitleVC.m
//  OfficeOA
//
//  Created by sunzhaokai on 2017/7/14.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "CommonTitleVC.h"

#define titleH AutoFitHeight(96)

@interface CommonTitleVC ()<UIAlertViewDelegate>
{
    UILabel *workNumLb;
    UILabel *nameLb;
}
@property(nonatomic,retain)UIView *leftView;
@property(nonatomic,retain)UIView *rightView;

@end

@implementation CommonTitleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //title左边view
    _leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2,titleH)];
//    _leftView.backgroundColor=[UIColor colorWithHexString:@"#f7f7f7"];
    _leftView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_leftView];
    //logo
    UIImageView *logoImg=[[UIImageView alloc]initWithFrame:CGRectMake(AutoFitWidth(75), AutoFitHeight(20), 414/132 * AutoFitHeight(70), AutoFitHeight(70))];
    logoImg.image=[UIImage imageNamed:@"returnHomePage"];
    logoImg.contentMode = UIViewContentModeScaleAspectFit;
    logoImg.userInteractionEnabled=YES;
    logoImg.hidden = YES;
    [self.view addSubview:logoImg];
    
    //logo上面添加单击手势
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToRoot)];
    [logoImg addGestureRecognizer:tap];
    _backImg=[[UIImageView alloc]initWithFrame:CGRectMake(AutoFitWidth(35), AutoFitHeight(30), AutoFitHeight(50), AutoFitHeight(50))];
    _backImg.image=[UIImage imageNamed:@"back2"];
    _backImg.contentMode = UIViewContentModeScaleAspectFit;
    _backImg.userInteractionEnabled=YES;
    [self.view addSubview:_backImg];
    UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];

    [_backImg addGestureRecognizer:tap2];
    //title右边view
    _rightView=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftView.frame), CGRectGetMinY(_leftView.frame), SCREEN_WIDTH/2,titleH)];
//    _rightView.backgroundColor=[UIColor colorWithHexString:@"#979797"];
    _rightView.backgroundColor=[UIColor clearColor];
    _rightView.hidden = YES;
    [self.view addSubview:_rightView];
    //工号:
    workNumLb=[[UILabel alloc]initWithFrame:CGRectMake(AutoFitWidth(40), 0, SCREEN_WIDTH/2 - AutoFitWidth(40), CGRectGetHeight(_rightView.frame)/2)];
    workNumLb.text=@"工号:";
    workNumLb.textColor=[UIColor whiteColor];
    workNumLb.font=[UIFont systemFontOfSize:AutoFitHeight(20)];
    [_rightView addSubview:workNumLb];
    //姓名:
    nameLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(workNumLb.frame), CGRectGetMaxY(workNumLb.frame), CGRectGetWidth(workNumLb.frame), CGRectGetHeight(workNumLb.frame))];
    nameLb.text=@"姓名:";
    nameLb.textColor=[UIColor whiteColor];
    nameLb.font=[UIFont systemFontOfSize:AutoFitHeight(20)];
    [_rightView addSubview:nameLb];
    //退出按钮
    UIButton *exitBt=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(_rightView.frame)-AutoFitHeight(66), AutoFitHeight(32), AutoFitHeight(32), AutoFitHeight(32))];
    [exitBt setBackgroundImage:[UIImage imageNamed:@"exit"] forState:UIControlStateNormal];
    [exitBt addTarget:self action:@selector(exitBtClick) forControlEvents:UIControlEventTouchUpInside];
    [_rightView addSubview:exitBt];
    [ self setupNavi];
}
#pragma mark---logo点击手势事件
-(void)tap
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tapToRoot
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark---退出到登陆页面
-(void)exitBtClick
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"退出登录？" message:@"您是否要退出此账号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil ];
    [alert show];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1 ) {
        [self dismissViewControllerAnimated:YES completion:nil];

    }

}
-(void)setOpCode:(NSString *)opCode{
    _opCode = opCode;
    workNumLb.text = [NSString stringWithFormat:@"%@%@",@"工号：",opCode ];
}
-(void)setOpName:(NSString *)opName{
    _opName = opName;
    nameLb.text = [NSString stringWithFormat:@"%@%@",@"姓名：",opName ];

}
#pragma mark---状态栏隐藏
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
-(void)setupNavi{
    NSString *opName = [[NSUserDefaults standardUserDefaults]valueForKey:@"OpName"];
    NSString *opCode = [[NSUserDefaults standardUserDefaults]valueForKey:@"OpCode"];
    
    if (!opName) {
        AFHTTPSessionManager * mgr            = [AFHTTPSessionManager manager];
        mgr.responseSerializer                = [[AFHTTPResponseSerializer alloc] init];
        mgr.requestSerializer.timeoutInterval = REQUEST_TIMEOUT;
        
        
        AFSecurityPolicy *secu = [[AFSecurityPolicy alloc]init];
        [secu setAllowInvalidCertificates:true];
        [mgr setSecurityPolicy:secu];
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        NSString *code = [df objectForKey:@"OpCode"];
        if (!code) {
            code = @"";
        }
        [mgr POST:get_name parameters:@{@"OpCode":code} progress:^(NSProgress * _Nonnull downloadProgress) {
            //progress
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //下次使用上次设置的IP
            NSError *err;
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
            if ([dic valueForKey:@"OpName"]) {
                [[NSUserDefaults standardUserDefaults]setValue:[dic valueForKey:@"OpName"] forKey:@"OpName"];
                [[NSUserDefaults standardUserDefaults]setValue:[dic valueForKey:@"OpCode"] forKey:@"OpCode"];
                self.opName =[dic valueForKey:@"OpName"];
                self.opCode = [dic valueForKey:@"OpCode"];
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"error%@",error);
        }];
        
        
    }else{
        self.opName =opName;
        self.opCode = opCode;
    }
}
@end
