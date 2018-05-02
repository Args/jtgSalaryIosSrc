//
//  SystemSetting.m
//  OfficeOA
//
//  Created by sunzhaokai on 2017/7/6.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "SystemSettingVC.h"
#import "PersonInfoCell.h"
#import "SZKImagePickerVC.h"
#define typeBtLeftSpa     AutoFitWidth(10)  //分类按钮距离左边距离
#define typeBtW           AutoFitWidth(150)  //分类按钮宽度
#define typeBtH           AutoFitWidth(69)  //分类按钮高度
//更换绑定手机view
#define lbWidth   AutoFitWidth(145)
#define midSpace  AutoFitWidth(25)
#define lbHeight  AutoFitHeight(64)

@interface SystemSettingVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *myTableView;
}
@property(nonatomic,retain)UIView * typeView;  //分类按钮view
@property(nonatomic,retain)UIButton * personInfoBt; //个人资料按钮
@property(nonatomic,retain)UIButton * changePhoneBt; //更换手机按钮
@property(nonatomic,retain)UIView * personInfoView;  //个人资料
@property(nonatomic,retain)UIView * changePhoneView; //更换手机
@property(nonatomic,retain)UIView * revisePasswordView; //修改密码
//个人资料view
@property(nonatomic,copy)NSArray *keyLbTitleArr;
@property(nonatomic,copy)NSArray *valueLbTitleArr;//测试数据（需要删除）
@property(nonatomic,retain)UITextField *phoneTf;//手机号输入框
@property(nonatomic,retain)UITextField *checkCodeTf;//验证码输入框
@property(nonatomic,retain)UIButton *bindBt;//确定按钮
@property(nonatomic,retain)UIButton *saveBt;//保存按钮
@end

@implementation SystemSettingVC

-(NSArray *)keyLbTitleArr
{
    if (_keyLbTitleArr==nil) {
        _keyLbTitleArr=@[@"设置头像:",@"工号:",@"姓名:",@"公积金分类:",@"公积金账号:",@"补充公积金账号:",@"绑定手机:"];
    }
    return _keyLbTitleArr;
}
-(NSArray *)valueLbTitleArr
{
    if (_valueLbTitleArr==nil) {
        _valueLbTitleArr=@[@"",@"",@"",@"",@"",@""];
    }
    return _valueLbTitleArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor=[UIColor colorWithHexString:@"f7f7f7"];
    //添加功能按钮
    _typeView=[[UIView alloc]initWithFrame:CGRectMake(typeBtLeftSpa, AutoFitHeight(155), SCREEN_WIDTH-typeBtLeftSpa*2, typeBtH)];
//    _typeView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_typeView];
    //个人资料按钮
    _personInfoBt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, typeBtW,typeBtH)];
    [_personInfoBt setTitle:@"个人资料" forState:UIControlStateNormal];
    [_personInfoBt setTitleColor:[UIColor colorWithHexString:@"#3e64b4"] forState:UIControlStateNormal];
    _personInfoBt.titleLabel.font=[UIFont systemFontOfSize:AutoFitHeight(26)];
    [_personInfoBt addTarget:self action:@selector(personInfoBtClick) forControlEvents:UIControlEventTouchUpInside];
    [_typeView addSubview:_personInfoBt];
    //分割线
    UILabel *separateLineLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_personInfoBt.frame), AutoFitHeight(23), 1, AutoFitHeight(23))];
    separateLineLb.backgroundColor=[UIColor colorWithHexString:@"#acacac"];
    [_typeView addSubview:separateLineLb];
    //更换手机按钮
    _changePhoneBt=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(separateLineLb.frame), 0, typeBtW + 40,typeBtH)];
    [_changePhoneBt setTitle:@"绑定手机更换" forState:UIControlStateNormal];
    [_changePhoneBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _changePhoneBt.titleLabel.font=[UIFont systemFontOfSize:AutoFitHeight(26)];
    [_changePhoneBt addTarget:self action:@selector(changePhoneBtClick) forControlEvents:UIControlEventTouchUpInside];
    [_typeView addSubview:_changePhoneBt];
    //添加修改密码view
//    [self addRevisePasswordView];
    //添加更换手机view
    [self addChangePhoneView];
    //添加个人资料view
    [self addPersonInfoView];
    [self loadData];
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImage.image = [UIImage imageNamed:@"背景1"];
    [self.view insertSubview:backImage atIndex:0];

}
-(void)viewWillDisappear:(BOOL)animated{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}
//?userID=3
//{"OpCode":"admin","OpName":"admin","公积金分类":"2000","公积金账号":"100","补充公积金账号":"1590","身份证号码":"310101197905222414","手机号码":"18866665555"}

#pragma mark---个人信息获取
-(void)loadData{
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.tag        = 1002;
    hud.label.text = @"正在加载...";
    //OpCode=admin&&isReadSignNum=0
    AFHTTPSessionManager * mgr            = [AFHTTPSessionManager manager];
    mgr.responseSerializer                = [[AFHTTPResponseSerializer alloc] init];
    mgr.requestSerializer.timeoutInterval = REQUEST_TIMEOUT;
    //    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:@"userID"];
    if (!userID) {
        userID = @"";
    }
    //?userID=3&&userOrganID=37
    [mgr POST:get_user_info parameters:@{@"userID":userID} progress:^(NSProgress * _Nonnull downloadProgress) {
        //progress
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *err;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        _valueLbTitleArr = @[[dic valueForKey:@"OpCode"],[dic valueForKey:@"OpName"],[dic valueForKey:@"公积金分类"],[dic valueForKey:@"公积金账号"],[dic valueForKey:@"补充公积金账号"],[[NSUserDefaults standardUserDefaults] valueForKey:@"phoneNumber"]];
        [myTableView reloadData];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = (MBProgressHUD *)[self.navigationController.view viewWithTag:1002];
            hud.mode = MBProgressHUDModeCustomView;
            hud.label.text = @"载入失败！\n请检查网络是否通畅！\n(＞﹏＜)";
            hud.label.numberOfLines = 3;
            [hud hideAnimated:YES afterDelay:1];
            
        });
        
        NSLog(@"error%@",error);
    }];
}

#pragma mark---个人信息按钮点击事件
-(void)personInfoBtClick
{
    //个人资料页面展示
    [_personInfoBt setTitleColor:[UIColor colorWithHexString:@"#3e64b4"] forState:UIControlStateNormal];
    _personInfoView.hidden=NO;
    //绑定手机更换页面隐藏
    [_changePhoneBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _changePhoneView.hidden=YES;
}
#pragma mark---更换手机按钮点击事件
-(void)changePhoneBtClick
{
    //绑定手机更换页面展示
    [_changePhoneBt setTitleColor:[UIColor colorWithHexString:@"#3e64b4"] forState:UIControlStateNormal];
    _changePhoneView.hidden=NO;
    //个人资料页面隐藏
    [_personInfoBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _personInfoView.hidden=YES;
}
#pragma mark---个人资料view
-(void)addPersonInfoView
{
    _personInfoView=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_typeView.frame), CGRectGetMaxY(_typeView.frame)+AutoFitHeight(10), CGRectGetWidth(_typeView.frame), SCREEN_HEIGHT-CGRectGetMaxY(_typeView.frame)-AutoFitHeight(50))];
//    _personInfoView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_personInfoView];
    //添加内容
    myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_personInfoView.frame), CGRectGetHeight(_personInfoView.frame)) style:UITableViewStylePlain];
    myTableView.delegate=self;
    myTableView.dataSource=self;
    myTableView.bounces=NO;
    myTableView.tableFooterView=[UIView new];
    myTableView.backgroundColor = [UIColor clearColor];
    [_personInfoView addSubview:myTableView];
}
#pragma mark---cell行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.keyLbTitleArr.count;
}
#pragma mark---cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AutoFitHeight(115);
}
#pragma mark---加载cell数据
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellID";
    PersonInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[PersonInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.text=self.keyLbTitleArr[indexPath.row];
    //上传头像按钮
    if (indexPath.row==0) {
        cell.uploadImgBt.hidden=NO;
        [cell.uploadImgBt addTarget:self action:@selector(uploadImgBtClick) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cell.detailTextLabel.text=self.valueLbTitleArr[indexPath.row-1];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    return cell;
}
#pragma mark---上传按钮点击事件
-(void)uploadImgBtClick
{
    
    //判断是否支持相机  模拟器去除相机功能
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从相册上传" ,nil];
        [sheet showInView:self.view];
    }else{
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册上传" ,nil];
        [sheet showInView:self.view];
    }

}
#pragma mark-----UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //判断是否支持相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        switch (buttonIndex) {
            case 0:{
                [self presentViewController:ImagePickerStyleCamera];
            }
                break;
            case 1:{
                [self presentViewController:ImagePickerStylePhotoLibrary];
            }
                break;
            default:
                break;
        }
    }else{
        switch (buttonIndex) {
            case 0:{
                [self presentViewController:ImagePickerStylePhotoLibrary];
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark----跳转到SZKImagePickerVC
-(void)presentViewController:(imagePickerStyle)style
{
    SZKImagePickerVC *picker=[[SZKImagePickerVC alloc]initWithImagePickerStyle:style];
    picker.SZKDelegate=self;
    [self presentViewController:picker animated:YES completion:nil];
}
- (BOOL) imageHasAlpha: (UIImage *) image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}
- (NSString *) image2DataURL: (UIImage *) image
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    UIImage *newImage = [self scaleFromImage:image toSize:CGSizeMake(80, 80)];
    if (0) {
        imageData = UIImagePNGRepresentation(newImage);
        mimeType = @"image/png";
    } else {
        float num = 1.0;
        imageData = UIImageJPEGRepresentation(newImage, num);
        while (imageData.length>1024*30) {
            num = num/2;
            
            imageData = UIImageJPEGRepresentation(newImage,num);
            if (num<=0.1) {
                break;
            }
        }
        mimeType = @"image/jpeg";
    }
    NSString * str= [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
                     [imageData base64EncodedStringWithOptions: 0]];
    
    str = [str stringByReplacingOccurrencesOfString:@"%" withString:@"%25"];
    str = [str stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    str = [str stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    return str;
    
}
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark----SZKImagePickerVCDelegate
-(void)imageChooseFinish:(UIImage *)image
{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
 
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.tag        = 1002;
    hud.label.text = @"上传中...";
    //OpCode=admin&&isReadSignNum=0
    AFHTTPSessionManager * mgr            = [AFHTTPSessionManager manager];
    mgr.responseSerializer                = [[AFHTTPResponseSerializer alloc] init];
//    mgr.requestSerializer.timeoutInterval = REQUEST_TIMEOUT;
//        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //UpdateID=94221&&isToSignNum=1&&Description=这是在测试
    
    AFSecurityPolicy *secu = [[AFSecurityPolicy alloc]init];
    [secu setAllowInvalidCertificates:true];
    [mgr setSecurityPolicy:secu];
    NSString *userID = @"";
    NSUserDefaults * df = [NSUserDefaults standardUserDefaults];
    if ([df valueForKey:@"userID"]) {
        userID = [df valueForKey:@"userID"];
    }
    NSDictionary *parameterDict = @{@"userID":userID,@"HeadPortrait":[self image2DataURL:image]};
    [mgr POST:upload_head parameters:parameterDict progress:^(NSProgress * _Nonnull downloadProgress) {
        //progress
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *err;
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        if ([[dic valueForKey:@"Result"] isEqualToString:@"True"]) {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];

        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                MBProgressHUD *hud = (MBProgressHUD *)[self.navigationController.view viewWithTag:1002];
                hud.mode = MBProgressHUDModeCustomView;
                hud.label.text = @"上传失败！\n请检查网络是否通畅！\n(＞﹏＜)";
                hud.label.numberOfLines = 3;
                [hud hideAnimated:YES afterDelay:1];
                
            });
        }
   
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = (MBProgressHUD *)[self.navigationController.view viewWithTag:1002];
            hud.mode = MBProgressHUDModeCustomView;
            hud.label.text = @"上传失败！\n请检查网络是否通畅！\n(＞﹏＜)";
            hud.label.numberOfLines = 3;
            [hud hideAnimated:YES afterDelay:1];
            
        });
        
        NSLog(@"error%@",error);
    }];

    
//    [manager POST:upload_head parameters:@{@"userID":@"admin12"} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileData:imageData name:@"ImageContent" fileName:@"icon.png" mimeType:@"image/jpeg"];
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"请求成功");
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"请求失败");
//    }];
}

#pragma mark---更换手机view
-(void)addChangePhoneView
{
    _changePhoneView=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_typeView.frame), CGRectGetMaxY(_typeView.frame)+AutoFitHeight(10), CGRectGetWidth(_typeView.frame), SCREEN_HEIGHT-CGRectGetMaxY(_typeView.frame)-AutoFitHeight(50))];
    _changePhoneView.hidden=YES;
//    _changePhoneView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_changePhoneView];
    //绑定手机更换label
    UILabel *changePhoneLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_changePhoneView.frame), AutoFitHeight(115))];
    changePhoneLb.text=@"    绑定手机更换";
    changePhoneLb.textColor=[UIColor colorWithHexString:@"#3e64b4"];
    [_changePhoneView addSubview:changePhoneLb];
    //分割线
    UILabel *separateLineLb=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(changePhoneLb.frame), CGRectGetWidth(_changePhoneView.frame), 1)];
    separateLineLb.backgroundColor=[UIColor colorWithHexString:@"#acacac"];
    [_changePhoneView addSubview:separateLineLb];
    //新手机号/
    UILabel *phoneLb=[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(separateLineLb.frame)+AutoFitHeight(25),lbWidth,AutoFitHeight(65))];
    phoneLb.text=@"新手机号";
    phoneLb.font = [UIFont systemFontOfSize:AutoFitHeight(26)];
    phoneLb.textAlignment=NSTextAlignmentCenter;
    [_changePhoneView addSubview:phoneLb];
    //新手机号输入框
    _phoneTf=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(phoneLb.frame), CGRectGetMinY(phoneLb.frame), CGRectGetWidth(_changePhoneView.frame)-lbWidth-midSpace*2-AutoFitWidth(164), AutoFitHeight(65))];
    _phoneTf.backgroundColor=[UIColor colorWithHexString:@"#d4d4d4"];
    _phoneTf.borderStyle=UITextBorderStyleRoundedRect;
    [_changePhoneView addSubview:_phoneTf];
    //验证码按钮
    UIButton *checkCodeBt=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_changePhoneView.frame)-AutoFitWidth(164) -AutoFitWidth(25), CGRectGetMinY(_phoneTf.frame), AutoFitWidth(164), lbHeight)];
    [checkCodeBt setTitle:@"获取验证码" forState:UIControlStateNormal];
    [checkCodeBt addTarget:self action:@selector(checkCodeBtClick) forControlEvents:UIControlEventTouchUpInside];
    checkCodeBt.titleLabel.font=[UIFont systemFontOfSize:AutoFitFont(16)];
    checkCodeBt.backgroundColor=[UIColor colorWithHexString:@"#3e64b4"];
    checkCodeBt.layer.cornerRadius=5;
    checkCodeBt.layer.masksToBounds=YES;
    [_changePhoneView addSubview:checkCodeBt];
    //分割线
    UILabel *separateLineLb1=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(phoneLb.frame)+AutoFitHeight(25), CGRectGetWidth(_changePhoneView.frame), 1)];
    separateLineLb1.backgroundColor=[UIColor colorWithHexString:@"#acacac"];
    [_changePhoneView addSubview:separateLineLb1];
    //验证码
    UILabel *checkCodelb=[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(separateLineLb1.frame)+AutoFitHeight(25),lbWidth,lbHeight)];
    checkCodelb.text=@"验证码";
    checkCodelb.textAlignment=NSTextAlignmentCenter;
    [_changePhoneView addSubview:checkCodelb];
    //验证码输入框
    _checkCodeTf=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(checkCodelb.frame), CGRectGetMinY(checkCodelb.frame), CGRectGetWidth(_changePhoneView.frame)-midSpace-lbWidth, lbHeight)];
    _checkCodeTf.backgroundColor=[UIColor colorWithHexString:@"#d4d4d4"];
    _checkCodeTf.borderStyle=UITextBorderStyleRoundedRect;
    [_changePhoneView addSubview:_checkCodeTf];
    //分割线
    UILabel *separateLineLb2=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(checkCodelb.frame)+AutoFitHeight(25), CGRectGetWidth(_changePhoneView.frame), 1)];
    separateLineLb2.backgroundColor=[UIColor colorWithHexString:@"#acacac"];
    [_changePhoneView addSubview:separateLineLb2];
    //绑定按钮
    _bindBt=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(_changePhoneView.frame)-lbWidth-midSpace, CGRectGetMaxY(separateLineLb2.frame)+AutoFitHeight(50), AutoFitWidth(164), lbHeight)];
    _bindBt.backgroundColor=[UIColor colorWithHexString:@"#3e64b4"];
    [_bindBt setTitle:@"绑定" forState:UIControlStateNormal];
    [_bindBt addTarget:self action:@selector(bindBtClick) forControlEvents:UIControlEventTouchUpInside];
    _bindBt.layer.cornerRadius=5;
    _bindBt.layer.masksToBounds=YES;
    [_changePhoneView addSubview:_bindBt];
    //保存按钮
//    _saveBt=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(_bindBt.frame), CGRectGetMaxY(_bindBt.frame)+AutoFitHeight(50), AutoFitWidth(164), lbHeight)];
//    _saveBt.backgroundColor=[UIColor colorWithHexString:@"#3e64b4"];
//    [_saveBt setTitle:@"保存" forState:UIControlStateNormal];
//    [_saveBt addTarget:self action:@selector(saveBtClick) forControlEvents:UIControlEventTouchUpInside];
//    _saveBt.layer.cornerRadius=5;
//    _saveBt.layer.masksToBounds=YES;
//    [_changePhoneView addSubview:_saveBt];
}
#pragma mark---验证码按钮点击
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
    NSDictionary *parameterdict = @{@"UserID":[[NSUserDefaults standardUserDefaults] valueForKey:@"userID"],@"PhoneNum":_phoneTf.text};
    
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
#pragma mark---绑定按钮点击
-(void)bindBtClick
{
    //?userID=3&&PhoneNum=123321123
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.tag        = 1002;
    hud.label.text = @"正在加载...";
    //OpCode=admin&&isReadSignNum=0
    AFHTTPSessionManager * mgr            = [AFHTTPSessionManager manager];
    mgr.responseSerializer                = [[AFHTTPResponseSerializer alloc] init];
    mgr.requestSerializer.timeoutInterval = REQUEST_TIMEOUT;
    //    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    
    //?userID=3&&userOrganID=37
    [mgr POST:change_phonenumber parameters:@{@"UserID":[[NSUserDefaults standardUserDefaults] valueForKey:@"userID"],@"PhoneNum":_phoneTf.text,@"PhoneCode":_checkCodeTf.text} progress:^(NSProgress * _Nonnull downloadProgress) {
        //progress
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *err;
        NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];

        if ([[infoDic valueForKey:@"Result"] isEqualToString:@"True"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                MBProgressHUD *hud = (MBProgressHUD *)[self.navigationController.view viewWithTag:1002];
                hud.mode = MBProgressHUDModeCustomView;
                hud.label.text = @"绑定成功！";
                hud.label.numberOfLines = 3;
                [hud hideAnimated:YES afterDelay:1];
                
            });
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                MBProgressHUD *hud = (MBProgressHUD *)[self.navigationController.view viewWithTag:1002];
                hud.mode = MBProgressHUDModeCustomView;
                hud.label.text = @"绑定失败！";
                hud.label.numberOfLines = 3;
                [hud hideAnimated:YES afterDelay:1];
                
            });
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = (MBProgressHUD *)[self.navigationController.view viewWithTag:1002];
            hud.mode = MBProgressHUDModeCustomView;
            hud.label.text = @"绑定失败！\n请检查网络是否通畅！\n(＞﹏＜)";
            hud.label.numberOfLines = 3;
            [hud hideAnimated:YES afterDelay:1];
            
        });
        
        NSLog(@"error%@",error);
    }];

}
#pragma mark---保存按钮点击
-(void)saveBtClick
{
    
}
@end
