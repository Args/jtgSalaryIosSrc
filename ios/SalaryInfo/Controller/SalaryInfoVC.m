//
//  SalaryInfoVC.m
//  OfficeOA
//
//  Created by sunzhaokai on 2017/7/6.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "SalaryInfoVC.h"
#import "SalaryInfoCellSign.h"
#import "SalaryInfoCellNoSign.h"
#import "SalaryInfoDetailsVC.h"
#import "MonthPickerViewController.h"

#define topSpace AutoFitHeight(15)
#define leftSpace AutoFitWidth(50)
#define lbWidth   (SCREEN_WIDTH-leftSpace*2)*2/5
#define tfWidth   lbWidth*2
#define lbHeight  AutoFitHeight(82)

@interface SalaryInfoVC ()<UITableViewDelegate,UITableViewDataSource,MonthPickerViewControllerDelegate>

@property(nonatomic,retain)UIButton * salaryMonthBt;
@property(nonatomic,copy)NSString *isSignStr;//是否签收
@property(nonatomic,retain)UITableView *myTableView;
@property (nonatomic,retain)NSArray *signDateAndClient;//应要求把签收时间和签收端放到明细
@property (strong,nonatomic) MonthPickerViewController *monthPickerViewController;

@property(nonatomic,copy)NSArray *dataTitleArrWithSign;
@property(nonatomic,copy)NSArray *dataContentArrWithSign;
@property(nonatomic,copy)NSArray *showDetailsBtArrSign;//用来记录是否展示详情按钮
@property(nonatomic,copy)NSArray *dataTitleArrWithNoSign;
@property(nonatomic,copy)NSArray *dataContentArrWithNoSign;
@property(nonatomic,copy)NSArray *showDetailsBtArrNoSign;//用来记录是否展示详情按钮


@property(nonatomic,copy)NSArray *dataTitleArr;
@property(nonatomic,copy)NSArray *dataContentArr;
@property(nonatomic,retain)NSMutableArray *listArr;

@end

@implementation SalaryInfoVC

-(NSArray *)showDetailsBtArrSign
{
    if (_showDetailsBtArrSign==nil) {
        _showDetailsBtArrSign=@[@"hidden",@"hidden",@"hidden",@"show",@"show",@"show",@"no",@"no"];
    }
    return _showDetailsBtArrSign;
}
-(NSArray *)showDetailsBtArrNoSign
{
    if (_showDetailsBtArrNoSign==nil) {
        _showDetailsBtArrNoSign=@[@"hidden",@"hidden",@"hidden",@"show",@"show",@"show"];
    }
    return _showDetailsBtArrNoSign;
}

-(NSArray *)dataTitleArrWithSign
{
    if (_dataTitleArrWithSign==nil) {
        _dataTitleArrWithSign=@[@"工号：",@"姓名：",@"发放时间：",@"工资总额：",@"奖金总额：",@"报销总额：",@"签收时间：",@"签收端："];
    }
    return _dataTitleArrWithSign;
}
-(NSArray *)dataContentArrWithSign
{
    if (_dataContentArrWithSign==nil) {
        _dataContentArrWithSign=@[@"121404060124",@"诸葛亮",@"2017-07-07",@"180000",@"25000",@"3000",@"2017-07-07",@"iOS手机端"];
    }
    return _dataContentArrWithSign;
}
-(NSArray *)dataTitleArrWithNoSign
{
    if (_dataTitleArrWithNoSign==nil) {
        _dataTitleArrWithNoSign=@[@"工号：",@"姓名：",@"发放时间：",@"工资总额：",@"奖金总额：",@"报销总额："];
    }
    return _dataTitleArrWithNoSign;
}
-(NSArray *)dataContentArrWithNoSign
{
    if (_dataContentArrWithNoSign==nil) {
        _dataContentArrWithNoSign=@[@"121404060124",@"诸葛亮",@"2017-07-07",@"180000",@"25000",@"3000"];
    }
    return _dataContentArrWithNoSign;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithHexString:@"#f7f7f7"];
    //添加工资信息view
    [self addSalaryInfoView];
    //测试数据表示签收
    _monthPickerViewController = [[MonthPickerViewController alloc] initWithNibName:@"MonthPickerViewController" bundle:nil];
    _isSignStr=@"yes";
    self.dataTitleArr=self.dataTitleArrWithSign;
    self.dataContentArr=self.dataContentArrWithSign;
    //添加tableview
    self.listArr = [NSMutableArray array];

    [self addMyTableView];
    [self loadDataWith:[self getCurrentTime]];
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImage.image = [UIImage imageNamed:@"背景1"];
    [self.view insertSubview:backImage atIndex:0];
}
#pragma mark---工资信息view
-(void)addSalaryInfoView
{
    //工资月份label
    UILabel *salaryMonthLb=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace,AutoFitHeight(100)+ AutoFitHeight(35),lbWidth,lbHeight)];
    salaryMonthLb.text=@"工资月份：";
    salaryMonthLb.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:salaryMonthLb];
    //工资月份按钮
    _salaryMonthBt=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(salaryMonthLb.frame), CGRectGetMinY(salaryMonthLb.frame), SCREEN_WIDTH - AutoFitWidth(100) - lbWidth, lbHeight)];
    _salaryMonthBt.layer.masksToBounds=YES;
    _salaryMonthBt.layer.borderWidth=0.8;
    _salaryMonthBt.layer.cornerRadius = 3;
    _salaryMonthBt.layer.borderColor=[UIColor blackColor].CGColor;
    [_salaryMonthBt setTitle:[self getCurrentTime] forState:UIControlStateNormal];
    [_salaryMonthBt setTitleColor:[UIColor colorWithHexString:@"#3e64b4"] forState:UIControlStateNormal];
    [_salaryMonthBt addTarget:self action:@selector(salaryMonthBtClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_salaryMonthBt];
}
#pragma mark---工资获取
-(void)loadDataWith:(NSString *)date{
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.tag        = 1002;
    hud.label.text = @"正在加载...";
    //OpCode=admin&&isReadSignNum=0
    AFHTTPSessionManager * mgr            = [AFHTTPSessionManager manager];
    mgr.responseSerializer                = [[AFHTTPResponseSerializer alloc] init];
    mgr.requestSerializer.timeoutInterval = REQUEST_TIMEOUT;
    //    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    AFSecurityPolicy *secu = [[AFSecurityPolicy alloc]init];
    [secu setAllowInvalidCertificates:true];
    [mgr setSecurityPolicy:secu];
    __weak typeof(self) weakself = self;
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSString *op = [df valueForKey:@"OpCode"];
    if (!op) {
        op = @"";
    }
    NSDictionary *parameterDict = @{@"OpCode":op,@"isReadSignNum":(_isSigned?@1:@0),@"SalaryYears":date,@"UserID":[[NSUserDefaults standardUserDefaults] valueForKey:@"userID"]};
    [mgr POST:get_payroll parameters:parameterDict progress:^(NSProgress * _Nonnull downloadProgress) {
        //progress
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *err;
        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        if ([[infoDic valueForKey:@"Table"] count]<=0) {
            [self.listArr removeAllObjects];
            [weakself.listArr addObject:[SalaryInfoModel modelWithTitle:@"提示" AndValue:@"暂无数据"]];
        }else{
            [self.listArr removeAllObjects];

            NSDictionary *dic = [infoDic valueForKey:@"Table"][0];
            [weakself.listArr addObject:[SalaryInfoModel modelWithTitle:@"工号" AndValue:[dic valueForKey:@"OpCode"] ]];
            [weakself.listArr addObject:[SalaryInfoModel modelWithTitle:@"姓名" AndValue:[dic valueForKey:@"OpName"]]];
            [weakself.listArr addObject:[SalaryInfoModel modelWithTitle:@"上传时间" AndValue:[dic valueForKey:@"SalaryDate"]]];
            for (NSDictionary *dic in [infoDic valueForKey:@"Table"]) {
                [weakself.listArr addObject:[SalaryInfoModel modelWithDic:dic]];
            }
            if (_isSigned) {
                NSString *signPlatform = [[dic valueForKey:@"SignPlatform"] integerValue] == 1?@"手机端":@"PC端";
                self.signDateAndClient = @[@{@"签收时间":[dic valueForKey:@"SignDate"]},@{@"签收端":signPlatform}];
//                [weakself.listArr addObject:[SalaryInfoModel modelWithTitle:@"签收时间" AndValue:[dic valueForKey:@"SignDate"]]];
//               
//                [weakself.listArr addObject:[SalaryInfoModel modelWithTitle:@"签收端" AndValue:signPlatform]];
            }
            
            
        }
        [weakself.myTableView reloadData];

        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = (MBProgressHUD *)[self.navigationController.view viewWithTag:1002];
            hud.mode = MBProgressHUDModeCustomView;
            hud.label.text = @"载入失败！\n请检查网络是否通畅！\n(＞﹏＜)";
            hud.label.numberOfLines = 3;
            [hud hideAnimated:YES afterDelay:1];
            [self.listArr removeAllObjects];
            [weakself.listArr addObject:[SalaryInfoModel modelWithTitle:@"提示" AndValue:@"暂无数据"]];
            [weakself.myTableView reloadData];

            
        });
        
        NSLog(@"error%@",error);
    }];
}
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMM"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:-1];
    
    [adcomps setDay:0];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];

    NSString *dateTime = [formatter stringFromDate:newdate];
    return dateTime;
}

#pragma mark---工资月份按钮
-(void)salaryMonthBtClick
{
    self.monthPickerViewController.delegate = self;
    self.monthPickerViewController.currentYearAndMonth = @"";
    //显示月份选择器
    [self.monthPickerViewController presentInParentViewController:self];
//    if ([_isSignStr isEqualToString:@"yes"]) {
//        _isSignStr=@"no";
//        self.dataTitleArr=self.dataTitleArrWithNoSign;
//        self.dataContentArr=self.dataContentArrWithNoSign;
//        [_myTableView setContentOffset:CGPointMake(0,0) animated:NO];
//        [_myTableView reloadData];
//    }else if ([_isSignStr isEqualToString:@"no"]){
//        _isSignStr=@"yes";
//        self.dataTitleArr=self.dataTitleArrWithSign;
//        self.dataContentArr=self.dataContentArrWithSign;
//        [_myTableView setContentOffset:CGPointMake(0,0) animated:NO];
//        [_myTableView reloadData];
//    }
}

#pragma mark - MonthPickerViewControllerDelegate

-(void)chooseMonthAndYear:(NSString *)yearAndMonth
{
    //更新标签
    [_salaryMonthBt setTitle:yearAndMonth forState:UIControlStateNormal];
    [self loadDataWith:yearAndMonth];
}
#pragma mark---添加tableview
-(void)addMyTableView
{
    _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(leftSpace, CGRectGetMaxY(_salaryMonthBt.frame)+AutoFitHeight(35), SCREEN_WIDTH-AutoFitWidth(50)*2, SCREEN_HEIGHT-AutoFitHeight(250)-AutoFitHeight(170)) style:UITableViewStylePlain];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    _myTableView.bounces=NO;
    _myTableView.layer.cornerRadius = 3;
    _myTableView.layer.masksToBounds = YES;
    _myTableView.tableFooterView=[UIView new];
    _myTableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_myTableView];
    _myTableView.backgroundColor = [UIColor clearColor];
    UIView *whiteView = [[UIView alloc]initWithFrame:_myTableView.frame];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.alpha = 0.8;
    whiteView.layer.cornerRadius = 3;
    whiteView.layer.masksToBounds = YES;

    [self.view insertSubview:whiteView belowSubview:_myTableView];
}
#pragma mark---cell行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArr.count;
    return self.dataTitleArr.count;
}
#pragma mark---cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AutoFitHeight(150);
}
#pragma mark---加载cell数据
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *allCell;
    typeof(self) weakSelf = self;

    if (_isSigned) {
        static NSString *cellID=@"cellIDWithSign";
        SalaryInfoCellSign *cell=[tableView cellForRowAtIndexPath:indexPath];
//        SalaryInfoCellSign *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell=[[SalaryInfoCellSign alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.item = self.listArr[indexPath.row];
        NSString *title = [self.listArr[indexPath.row] title];
        if (cell.item.needDetailShow) {
            //cell.detailsBt.hidden=NO;
            cell.detailBlock = ^{
                
                [weakSelf detailWith:[weakSelf.listArr[indexPath.row] salaryID] AndDate:[weakSelf.listArr[indexPath.row] date] AndSalaryRecGuid:@"" AndTitle:title];
                
            };
        }
//        cell.textLabel.text=self.dataTitleArr[indexPath.row];
//        cell.valueLb.text=self.dataContentArr[indexPath.row];
//        if ([self.showDetailsBtArrSign[indexPath.row] isEqualToString:@"show"]) {
//            cell.detailsBt.hidden=NO;
//            cell.detailsBt.tag=6440+indexPath.row;
//            [cell.detailsBt addTarget:self action:@selector(detailsBtClickSign:) forControlEvents:UIControlEventTouchUpInside];
//        }
        allCell=cell;
    }else{
        static NSString *cellID=@"cellIDWithNoSign";
        SalaryInfoCellNoSign *cell=[tableView cellForRowAtIndexPath:indexPath];
//        SalaryInfoCellNoSign *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell=[[SalaryInfoCellNoSign alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.item = self.listArr[indexPath.row];
        NSString *title = [self.listArr[indexPath.row] title];

//        cell.textLabel.text=self.dataTitleArr[indexPath.row];
//        cell.valueLb.text=self.dataContentArr[indexPath.row];
        if (cell.item.needDetailShow) {
            cell.signBlock = ^{
                [weakSelf signWith:[weakSelf.listArr[indexPath.row] salaryID]];
            };
            cell.detailBlock = ^{
                [weakSelf detailWith:[weakSelf.listArr[indexPath.row] salaryID] AndDate:[weakSelf.listArr[indexPath.row] date] AndSalaryRecGuid:@"" AndTitle:title];

            };
            cell.detailsBt.hidden=NO;
            cell.signBt.hidden=NO;
            cell.detailsBt.tag=7440+indexPath.row;
//            [cell.detailsBt addTarget:self action:@selector(detailsBtClickNoSign:) forControlEvents:UIControlEventTouchUpInside];
            cell.detailsBt.tag=8440+indexPath.row;
//            [cell.signBt addTarget:self action:@selector(signBtClickNoSign:) forControlEvents:UIControlEventTouchUpInside];
        }
        allCell=cell;
    }
    return allCell;
}
#pragma mark---签收页面详情按钮点击
-(void)detailsBtClickSign:(UIButton *)sender
{
    SalaryInfoDetailsVC *salaryInfoDetails=[[SalaryInfoDetailsVC alloc]init];
    [self.navigationController pushViewController:salaryInfoDetails animated:YES];
    
    switch (sender.tag) {
        //工资总额详情
        case 6443:{
            NSLog(@"%ld",sender.tag);
        }
            break;
        //奖金总额详情
        case 6444:{
            NSLog(@"%ld",sender.tag);
        }
            break;
        //报销总额详情
        case 6445:{
            NSLog(@"%ld",sender.tag);
        }
            break;
        default:
            break;
    }
}
#pragma mark---未签收页面详情按钮点击
-(void)detailWith:(UIButton *)idNumber AndDate:(NSString *)date AndSalaryRecGuid:(NSString *)recGuid AndTitle:(NSString *)title
{
    SalaryInfoDetailsVC *salaryInfoDetails=[[SalaryInfoDetailsVC alloc]init];
    salaryInfoDetails.salaryID = idNumber;
    salaryInfoDetails.title = title;
    if (_isSigned && _signDateAndClient) {
        salaryInfoDetails.signDateAndClient = [NSArray arrayWithArray:self.signDateAndClient];
       
    }
//    salaryInfoDetails.SalaryRecGuid = @"5936bc6ea5744edb8b2f45d9a542b4fc";
    salaryInfoDetails.SalaryYears = date;
    [self.navigationController pushViewController:salaryInfoDetails animated:YES];
   
}
#pragma mark---未签收页面签收按钮点击
-(void)signWith:(NSString *)idNumber
{

    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.tag        = 1002;
    hud.label.text = @"正在加载...";
    //OpCode=admin&&isReadSignNum=0
    AFHTTPSessionManager * mgr            = [AFHTTPSessionManager manager];
    mgr.responseSerializer                = [[AFHTTPResponseSerializer alloc] init];
    mgr.requestSerializer.timeoutInterval = REQUEST_TIMEOUT;
//    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //UpdateID=94221&&isToSignNum=1&&Description=这是在测试

    AFSecurityPolicy *secu = [[AFSecurityPolicy alloc]init];
    [secu setAllowInvalidCertificates:true];
    [mgr setSecurityPolicy:secu];
    NSDictionary *parameterDict = @{@"UpdateID":idNumber,@"isToSignNum":@1,@"Description":@"这是测试",@"UserID":[[NSUserDefaults standardUserDefaults] valueForKey:@"userID"]};
    [mgr POST:sign_pay parameters:parameterDict progress:^(NSProgress * _Nonnull downloadProgress) {
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
                hud.label.text = @"签收失败！\n请检查网络是否通畅！\n(＞﹏＜)";
                hud.label.numberOfLines = 3;
                [hud hideAnimated:YES afterDelay:1];
                
            });
        }
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = (MBProgressHUD *)[self.navigationController.view viewWithTag:1002];
            hud.mode = MBProgressHUDModeCustomView;
            hud.label.text = @"签收失败！\n请检查网络是否通畅！\n(＞﹏＜)";
            hud.label.numberOfLines = 3;
            [hud hideAnimated:YES afterDelay:1];
            
        });
        
        NSLog(@"error%@",error);
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}
@end
