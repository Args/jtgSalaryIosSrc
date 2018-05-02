//
//  LoginVC.m
//  LeTuWIFI
//
//  Created by sunzhaokai on 2017/2/20.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "LoginVC.h"
#import "HomePageVC.h"
#import "JPUSHService.h"

#define topHeight AutoFitHeight(25)
#define leftSpace AutoFitWidth(50)
#define lbWidth   (SCREEN_WIDTH-leftSpace*2)/4
#define tfWidth   lbWidth*2
#define lbHeight  AutoFitHeight(50)

@interface LoginVC ()

@property(nonatomic,retain)UIScrollView *myScrollView;//全屏的scrollview

@property(nonatomic,retain)UIImageView *logoImg;//logo图
@property(nonatomic,retain)UILabel *titleSubNameLb;//工资电子签收系统
@property(nonatomic,retain)UITextField *phoneTf;//手机号输入框
@property(nonatomic,retain)UITextField *nameTf;//姓名输入框
@property(nonatomic,retain)UITextField *passwordTf;//验证码输入框

@property(nonatomic,retain)UITextField *checkCodeTf;//验证码输入框
@property(nonatomic,retain) UILabel *checkCodelb;
@property(nonatomic,retain)UILabel *separateLineVLb3;
@property(nonatomic,retain)UIButton *checkCodeBt;
@property(nonatomic,retain)UILabel *separateLineHLb3;

@property(nonatomic,retain)UIButton *loginBt;//登陆按钮
@property(nonatomic,copy)NSString *checkCode;//
@property(nonatomic,copy)NSString *opName;//
@property(nonatomic,copy)NSString *opCode;//

@property (nonatomic,assign)BOOL isNeedCode;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithHexString:@"#f7f7f7"];
    //添加全屏的滑动视图
    [self addMyScrollView];
}

#pragma mark---添加scrollview
-(void)addMyScrollView
{
    _myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _myScrollView.bounces=NO;
//    _myScrollView.backgroundColor=[UIColor colorWithHexString:@"#f7f7f7"];
    [self.view addSubview:_myScrollView];
    //添加logo图
    [self addLogoImg];
    //添加内容视图
    [self addContentView];
    _myScrollView.contentSize=CGSizeMake(SCREEN_WIDTH,CGRectGetMaxY(_loginBt.frame)+30);
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImage.image = [UIImage imageNamed:@"背景1"];
    [self.view insertSubview:backImage atIndex:0];
}
#pragma mark---添加logo图
-(void)addLogoImg
{
    _logoImg=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x-AutoFitWidth(80), AutoFitHeight(114), AutoFitWidth(160), AutoFitWidth(160))];
    _logoImg.image=[UIImage imageNamed:@"title"];
    [_myScrollView addSubview:_logoImg];
    //上海动车段
    UILabel *titleNameLb=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_logoImg.frame)+AutoFitHeight(10), SCREEN_WIDTH, AutoFitHeight(30))];
    titleNameLb.text=@"上海动车段";
    titleNameLb.font=[UIFont systemFontOfSize:AutoFitHeight(15)];
    titleNameLb.textAlignment=NSTextAlignmentCenter;
    [_myScrollView addSubview:titleNameLb];
    //工资电子签收系统
    _titleSubNameLb=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleNameLb.frame)+AutoFitHeight(20), SCREEN_WIDTH, AutoFitHeight(30))];
    _titleSubNameLb.text=@"工资电子签收系统";
    _titleSubNameLb.textAlignment=NSTextAlignmentCenter;
    _titleSubNameLb.font=[UIFont systemFontOfSize:AutoFitHeight(30)];
    [_myScrollView addSubview:_titleSubNameLb];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardBack)];
    [_myScrollView addGestureRecognizer:tap];
}
-(void)keyboardBack{
    [self.phoneTf resignFirstResponder];
    [self.passwordTf resignFirstResponder];
    [self.checkCodeTf resignFirstResponder];
}
#pragma mark---内容view
-(void)addContentView
{
    //手机号/账号label
    UILabel *phoneLb=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace,CGRectGetMaxY(_titleSubNameLb.frame)+AutoFitHeight(55),lbWidth,lbHeight)];
    phoneLb.text=@"账号";
    phoneLb.font = [UIFont systemFontOfSize:AutoFitHeight(26)];
    phoneLb.textAlignment=NSTextAlignmentCenter;
    [_myScrollView addSubview:phoneLb];
    //竖向分割线
    UILabel *separateLineVLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(phoneLb.frame), CGRectGetMinY(phoneLb.frame), 1, CGRectGetHeight(phoneLb.frame))];
    separateLineVLb.backgroundColor=[UIColor colorWithWhite:0.7 alpha:0.9];
    [_myScrollView addSubview:separateLineVLb];
    //手机号输入框
    _phoneTf=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(separateLineVLb.frame), CGRectGetMinY(separateLineVLb.frame), SCREEN_WIDTH - AutoFitWidth(100) - lbWidth , lbHeight)];
    _phoneTf.placeholder=@"手机号或工号";
//    _phoneTf.backgroundColor=[UIColor colorWithHexString:@"f7f7f7"];
    _phoneTf.clearButtonMode=UITextFieldViewModeAlways;
    [_phoneTf addTarget:self action:@selector(phoneChange) forControlEvents:UIControlEventEditingChanged];
    [_myScrollView addSubview:_phoneTf];
    //横向分割线
    UILabel *separateLineHLb=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, CGRectGetMaxY(_phoneTf.frame)+topHeight, SCREEN_WIDTH-leftSpace*2, 1)];
    separateLineHLb.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.8];
    [_myScrollView addSubview:separateLineHLb];
    //姓名
    UILabel *nameLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(separateLineHLb.frame),CGRectGetMaxY(separateLineHLb.frame)+topHeight,lbWidth,lbHeight)];
    nameLb.text=@"姓名";
    nameLb.font = [UIFont systemFontOfSize:AutoFitHeight(26)];
    nameLb.textAlignment=NSTextAlignmentCenter;
    [_myScrollView addSubview:nameLb];
    //竖向分割线
    UILabel *separateLineVLb1=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLb.frame), CGRectGetMinY(nameLb.frame), 1, CGRectGetHeight(nameLb.frame))];
    separateLineVLb1.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.8];
    [_myScrollView addSubview:separateLineVLb1];
    //姓名输入框
    _nameTf=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(separateLineVLb1.frame), CGRectGetMinY(separateLineVLb1.frame), SCREEN_WIDTH - AutoFitWidth(100) - lbWidth , lbHeight)];
//    _nameTf.backgroundColor=[UIColor colorWithHexString:@"f7f7f7"];
    _nameTf.enabled = NO;
    [_myScrollView addSubview:_nameTf];
    //横向分割线1
    UILabel *separateLineHLb1=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, CGRectGetMaxY(_nameTf.frame)+topHeight, SCREEN_WIDTH-leftSpace*2, 1)];
    separateLineHLb1.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.8];
    [_myScrollView addSubview:separateLineHLb1];
    //验证码
    UILabel *passwordlb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(separateLineHLb1.frame),CGRectGetMaxY(separateLineHLb1.frame)+topHeight,lbWidth,lbHeight)];
    passwordlb.text=@"密码";
    passwordlb.font = [UIFont systemFontOfSize:AutoFitHeight(26)];

    passwordlb.textAlignment=NSTextAlignmentCenter;
    [_myScrollView addSubview:passwordlb];
    //竖向分割线
    UILabel *separateLineVLb2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(passwordlb.frame), CGRectGetMinY(passwordlb.frame), 1, CGRectGetHeight(passwordlb.frame))];
    separateLineVLb2.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.8];
    [_myScrollView addSubview:separateLineVLb2];
    //密码输入框
    _passwordTf=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(separateLineVLb2.frame), CGRectGetMinY(passwordlb.frame),  SCREEN_WIDTH - AutoFitWidth(100) - lbWidth , lbHeight)];
    _passwordTf.placeholder=@"密码";
    _passwordTf.secureTextEntry=YES;
//    _passwordTf.backgroundColor=[UIColor whiteColor];
    _passwordTf.clearButtonMode=UITextFieldViewModeAlways;
//    _passwordTf.backgroundColor=[UIColor colorWithHexString:@"f7f7f7"];
    
    [_myScrollView addSubview:_passwordTf];
    //验证码按钮
//    UIButton *checkCodeBt=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_checkCodeTf.frame), CGRectGetMinY(checkCodelb.frame)-AutoFitHeight(5), AutoFitWidth(164), AutoFitHeight(63))];
//    [checkCodeBt setTitle:@"获取" forState:UIControlStateNormal];
//    checkCodeBt.titleLabel.font = [UIFont systemFontOfSize:AutoFitHeight(26)];
//
//    [checkCodeBt addTarget:self action:@selector(checkCodeBtClick) forControlEvents:UIControlEventTouchUpInside];
//    checkCodelb.textAlignment=NSTextAlignmentCenter;
//    checkCodeBt.backgroundColor=[UIColor colorWithHexString:@"#3e64b4"];
//    checkCodeBt.layer.cornerRadius=5;
//    checkCodeBt.layer.masksToBounds=YES;
//    [self.view addSubview:checkCodeBt];
    //横向分割线2
    UILabel *separateLineHLb2=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, CGRectGetMaxY(passwordlb.frame)+topHeight, SCREEN_WIDTH-leftSpace*2, 1)];
    separateLineHLb2.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.8];
    [_myScrollView addSubview:separateLineHLb2];
    
    
    
    _checkCodelb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(separateLineHLb1.frame),CGRectGetMaxY(separateLineHLb2.frame)+topHeight,lbWidth,lbHeight)];
    _checkCodelb.text=@"验证码";
    _checkCodelb.font = [UIFont systemFontOfSize:AutoFitHeight(26)];
    
    _checkCodelb.textAlignment=NSTextAlignmentCenter;
    [_myScrollView addSubview:_checkCodelb];
    _checkCodelb.hidden = YES;
    //竖向分割线
    _separateLineVLb3=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_checkCodelb.frame), CGRectGetMinY(_checkCodelb.frame), 1, CGRectGetHeight(_checkCodelb.frame))];
    _separateLineVLb3.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.8];
    [_myScrollView addSubview:_separateLineVLb3];
    _separateLineVLb3.hidden = YES;
    //验证码输入框
    _checkCodeTf=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(separateLineVLb2.frame), CGRectGetMinY(_checkCodelb.frame),  SCREEN_WIDTH - AutoFitWidth(264) - lbWidth , lbHeight)];
    _checkCodeTf.placeholder=@"验证码";
//    _checkCodeTf.backgroundColor=[UIColor whiteColor];
    _checkCodeTf.clearButtonMode=UITextFieldViewModeAlways;
//    _checkCodeTf.backgroundColor=[UIColor colorWithHexString:@"f7f7f7"];
    
    [_myScrollView addSubview:_checkCodeTf];
    _checkCodeTf.hidden  = YES;
    //验证码按钮
        _checkCodeBt=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_checkCodeTf.frame), CGRectGetMinY(_checkCodelb.frame)-AutoFitHeight(5), AutoFitWidth(164), AutoFitHeight(63))];
        [_checkCodeBt setTitle:@"获取" forState:UIControlStateNormal];
        _checkCodeBt.titleLabel.font = [UIFont systemFontOfSize:AutoFitHeight(26)];
    
        [_checkCodeBt addTarget:self action:@selector(checkCodeBtClick) forControlEvents:UIControlEventTouchUpInside];
        _checkCodelb.textAlignment=NSTextAlignmentCenter;
        _checkCodeBt.backgroundColor=[UIColor colorWithHexString:@"#3e64b4"];
        _checkCodeBt.layer.cornerRadius=5;
        _checkCodeBt.layer.masksToBounds=YES;
        [_myScrollView addSubview:_checkCodeBt];
    _checkCodeBt.hidden = YES;
    //横向分割线3
    _separateLineHLb3=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, CGRectGetMaxY(_checkCodelb.frame)+topHeight, SCREEN_WIDTH-leftSpace*2, 1)];
    _separateLineHLb3.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.8];
    [_myScrollView addSubview:_separateLineHLb3];
    
    _separateLineHLb3.hidden =YES;
    
    //登录按钮
    _loginBt=[[UIButton alloc]initWithFrame:CGRectMake(leftSpace, CGRectGetMaxY(separateLineHLb2.frame)+AutoFitHeight(100), AutoFitWidth(620), AutoFitHeight(84))];
    _loginBt.backgroundColor=[UIColor orangeColor];
    [_loginBt setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBt addTarget:self action:@selector(loginBtClick) forControlEvents:UIControlEventTouchUpInside];
    _loginBt.backgroundColor=[UIColor colorWithHexString:@"#3e64b4"];
    _loginBt.layer.cornerRadius=5;
    _loginBt.layer.masksToBounds=YES;
    [_myScrollView addSubview:_loginBt];
//    //更多按钮
//    UIButton *moreBt=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4, SCREEN_HEIGHT-AutoFitHeight(100), SCREEN_WIDTH/2, AutoFitHeight(40))];
//    moreBt.titleLabel.font = [UIFont systemFontOfSize:AutoFitHeight(26)];
//    [moreBt setTitle:@"更多" forState:UIControlStateNormal];
//    [moreBt addTarget:self action:@selector(moreBtClick) forControlEvents:UIControlEventTouchUpInside];
//    [moreBt setTitleColor:[UIColor colorWithHexString:@"#3e64b4"] forState:UIControlStateNormal];
//    [self.view addSubview:moreBt];
}
#pragma mark---姓名获取
-(void)phoneChange{
    
    AFHTTPSessionManager * mgr            = [AFHTTPSessionManager manager];
    mgr.responseSerializer                = [[AFHTTPResponseSerializer alloc] init];
    mgr.requestSerializer.timeoutInterval = REQUEST_TIMEOUT;
    NSDictionary *parameterdict = @{@"PhoneNum":_phoneTf.text};
    [mgr POST:get_name parameters:parameterdict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *rawString=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic valueForKey:@"OpName"]&&[dic valueForKey:@"OpCode"]) {
            
            if ([_phoneTf.text isEqualToString:@"430363"]) {
                [[NSUserDefaults standardUserDefaults]setValue:@"2570" forKey:@"userID"];
            }else{
                [[NSUserDefaults standardUserDefaults]setValue:[dic valueForKey:@"userID"] forKey:@"userID"];
            }
            [[NSUserDefaults standardUserDefaults]setValue:[dic valueForKey:@"OpName"] forKey:@"OpName"];
            [[NSUserDefaults standardUserDefaults]setValue:[dic valueForKey:@"OpCode"] forKey:@"OpCode"];
            [[NSUserDefaults standardUserDefaults]setValue:[dic valueForKey:@"OrganID"] forKey:@"OrganID"];
//            [[NSUserDefaults standardUserDefaults]setValue:[dic valueForKey:@"userID"] forKey:@"userID"];
            NSString *phoneNum = [dic valueForKey:@"PhoneNum"];
            NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            NSString *str = [[NSString alloc]initWithString:[phoneNum stringByTrimmingCharactersInSet:whiteSpace]];
            [[NSUserDefaults standardUserDefaults] setValue:str forKey:@"phoneNumber"];

            _nameTf.text = [dic valueForKey:@"OpName"];
            [self updateRegistration];

        }else{
            _nameTf.text = @"";
            [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"OpName"];
            [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"OpCode"];
            [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"OrganID"];
            [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"userID"];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
        _nameTf.text = @"";
        [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"OpName"];
        [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"OpCode"];
        [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"OrganID"];
        [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"userID"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"phoneNumber"];
    }];
}

-(void)updateRegistration{
    AFHTTPSessionManager * mgr            = [AFHTTPSessionManager manager];
    mgr.responseSerializer                = [[AFHTTPResponseSerializer alloc] init];
    mgr.requestSerializer.timeoutInterval = REQUEST_TIMEOUT;
    NSDictionary *parameterdict = @{@"UserID":[[NSUserDefaults standardUserDefaults] valueForKey:@"userID"],@"RegistrationID":[[NSUserDefaults standardUserDefaults] valueForKey:@"registrationID"]};

    [mgr POST:updateRegistrationID parameters:parameterdict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSString *rawString=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[dic valueForKey:@"Result"] isEqualToString:@"True"]) {
            _isNeedCode = true;
        }else{
            _isNeedCode = false;
        }
        [self checkCheckCodeShowWithFlag:_isNeedCode];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);

    }];
}
-(void)checkCheckCodeShowWithFlag:(BOOL) flag{
    if (!flag) {
        self.checkCodeTf.hidden  = YES;
        self.checkCodelb.hidden  = YES;
        self.separateLineVLb3.hidden  = YES;
        self.checkCodeBt.hidden  = YES;
        self.separateLineHLb3.hidden  = YES;
    }else{
        self.checkCodeTf.hidden  = NO;
        self.checkCodelb.hidden  = NO;
        self.separateLineVLb3.hidden  = NO;
        self.checkCodeBt.hidden  = NO;
        self.separateLineHLb3.hidden  = NO;
        self.loginBt.frame = CGRectMake(leftSpace, CGRectGetMaxY(_separateLineHLb3.frame)+AutoFitHeight(100), AutoFitWidth(620), AutoFitHeight(84));
    }
    
}
#pragma mark---登录按钮点击事件
-(void)loginBtClick
{
//    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
////    HomePageVC * home=[[HomePageVC alloc]init];
////    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:home];
////    [self presentViewController:navi animated:YES completion:nil];
////    return;
//    NSString *number = [df valueForKey:@"phoneNumber"];
//    if (([_checkCodeTf.text isEqualToString:self.checkCode]||[_checkCodeTf.text isEqualToString:@"888888"])&&[number isEqualToString:_phoneTf.text]) {
//        NSString *opCode =  [[NSUserDefaults standardUserDefaults] objectForKey:@"OpCode"];
//
//        [JPUSHService setAlias:opCode completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//            if (iResCode==0) {
//            
//            }
//        } seq:0];
//        
//        HomePageVC * home=[[HomePageVC alloc]init];
//        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:home];
//        [self presentViewController:navi animated:YES completion:nil];
//    }else{
//        MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//
////        MBProgressHUD *hud = (MBProgressHUD *)[self.navigationController.view viewWithTag:1002];
//        hud.mode = MBProgressHUDModeCustomView;
//        hud.label.text = @"验证码错误！";
//        hud.label.numberOfLines = 3;
//        [hud hideAnimated:YES afterDelay:1];
//    }
//
//
//    return;
    
    if ([_phoneTf.text isEqualToString:@""]) {
        [self showAlert:@"请输入账号"];
        return;
    }
    if ([_passwordTf.text isEqualToString:@""]) {
        [self showAlert:@"请输入密码"];
        return;
    }
    NSString *phoneN = [[NSUserDefaults standardUserDefaults] valueForKey:@"phoneNumber"];
    if (!phoneN||[phoneN isEqualToString:@""]) {
        [self showAlert:@"请去电脑端绑定手机"];
        return;
    }
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.tag        = 1002;
    hud.label.text = @"正在登录...";
    AFHTTPSessionManager * mgr            = [AFHTTPSessionManager manager];
    mgr.responseSerializer                = [[AFHTTPResponseSerializer alloc] init];
    mgr.requestSerializer.timeoutInterval = REQUEST_TIMEOUT;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    AFSecurityPolicy *secu = [[AFSecurityPolicy alloc]init];
    [secu setAllowInvalidCertificates:true];
    [mgr setSecurityPolicy:secu];
    
    NSDictionary *parameterdict;
    if (_isNeedCode) {
        parameterdict= @{@"UserID":[[NSUserDefaults standardUserDefaults] valueForKey:@"userID"],@"Password":_passwordTf.text,@"PhoneCode":_checkCodeTf.text};

    }else{
        parameterdict= @{@"UserID":[[NSUserDefaults standardUserDefaults] valueForKey:@"userID"],@"Password":_passwordTf.text};

    }
    
//    NSDictionary *parameterdict = @{@"UserID":@"admin",@"Password":@"123"};

    [mgr POST:login_url parameters:parameterdict progress:^(NSProgress * _Nonnull downloadProgress) {
        //progress
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //下次使用上次设置的IP
        NSError *err;
        NSString *rawString=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];

        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        if ([[dic valueForKey:@"Result"] isEqualToString:@"True"]) {
//            NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
//            [df setValue:[dic valueForKey:@"ID"] forKey:@"userID"];
//            [df setValue:[dic valueForKey:@"OrganID"] forKey:@"OrganID"];
//            [df setValue:_phoneTf.text forKey:@"phoneNumber"];
            NSString *opCode =  [[NSUserDefaults standardUserDefaults] objectForKey:@"OpCode"];

            [JPUSHService setAlias:opCode completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                if (iResCode==0) {
                    
                }
            } seq:0];
            HomePageVC * home=[[HomePageVC alloc]init];
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:home];
            [self presentViewController:navi animated:YES completion:nil];
//            [self.navigationController pushViewController:home animated:YES];
        }else{
            [self showAlert:@"登录失败！请检查账号密码是否正确！"];
        }
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = (MBProgressHUD *)[self.navigationController.view viewWithTag:1002];
            hud.mode = MBProgressHUDModeCustomView;
            hud.label.text = @"登录失败！\n请检查网络是否通畅！\n";
            hud.label.numberOfLines = 3;
            [hud hideAnimated:YES afterDelay:1];
        });
        
        NSLog(@"error%@",error);
    }];
    
}


#pragma mark---验证码按钮点击事件
-(void)checkCodeBtClick
{
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.tag        = 1002;
    hud.label.text = @"正在请求...";
    AFHTTPSessionManager * mgr            = [AFHTTPSessionManager manager];
    mgr.responseSerializer                = [[AFHTTPResponseSerializer alloc] init];
    mgr.requestSerializer.timeoutInterval = REQUEST_TIMEOUT;
    //    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    AFSecurityPolicy *secu = [[AFSecurityPolicy alloc]init];
    [secu setAllowInvalidCertificates:true];
    [mgr setSecurityPolicy:secu];
    
    //    NSDictionary *parameterdict = @{@"OpCode":[[NSUserDefaults standardUserDefaults] valueForKey:@"OpCode"],@"Password":_checkCodeTf.text};
    NSDictionary *parameterdict = @{@"UserID":[[NSUserDefaults standardUserDefaults] valueForKey:@"userID"],@"PhoneNum":[[NSUserDefaults standardUserDefaults]valueForKey:@"phoneNumber"]};
    
    [mgr POST:get_checkcode parameters:parameterdict progress:^(NSProgress * _Nonnull downloadProgress) {
        //progress
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //下次使用上次设置的IP
        NSError *err;
        NSString *rawString=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];

        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        if ([[dic valueForKey:@"Result"] isEqualToString:@"True"]) {
//            NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
//
//            [df setValue:_phoneTf.text forKey:@"phoneNumber"];
//
//            self.checkCode = [dic valueForKey:@"Code"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                MBProgressHUD *hud = (MBProgressHUD *)[self.navigationController.view viewWithTag:1002];
                hud.mode = MBProgressHUDModeCustomView;
                hud.label.text = @"验证码已发送";
                hud.label.numberOfLines = 3;
                [hud hideAnimated:YES afterDelay:1];
                
            });

        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                MBProgressHUD *hud = (MBProgressHUD *)[self.navigationController.view viewWithTag:1002];
                hud.mode = MBProgressHUDModeCustomView;
                hud.label.text = @"请求验证码失败！\n请检查网络是否通畅！\n";
                hud.label.numberOfLines = 3;
                [hud hideAnimated:YES afterDelay:1];
                
            });

        }
        
        //[MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = (MBProgressHUD *)[self.navigationController.view viewWithTag:1002];
            hud.mode = MBProgressHUDModeCustomView;
            hud.label.text = @"请求验证码失败！\n请检查网络是否通畅！\n";
            hud.label.numberOfLines = 3;
            [hud hideAnimated:YES afterDelay:1];
            
        });
        
        NSLog(@"error%@",error);
    }];

}
#pragma mark----更多按钮点击事件
-(void)moreBtClick
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=YES;
    self.passwordTf.text = @"";
    self.checkCodeTf.text = @"";
}
/**
 *  只有文字的弹出框
 */
- (void)showAlert:(NSString *)message //弹出框
{
    UIAlertView *promptAlert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:promptAlert repeats:YES];
    [promptAlert show];
}

-(void)timerFireMethod:(NSTimer *)theTimer //时间
{
    UIAlertView *promptAlert = (UIAlertView *)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert = NULL;
}
@end

