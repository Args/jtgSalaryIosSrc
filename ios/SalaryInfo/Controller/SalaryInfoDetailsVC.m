//
//  SalaryInfoDetailsVC.m
//  OfficeOA
//
//  Created by sunzhaokai on 2017/7/19.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "SalaryInfoDetailsVC.h"
#import "SalaryInfoDetailsCell.h"

#define leftSpace AutoFitWidth(50)
#define topSpace  AutoFitWidth(35)

@interface SalaryInfoDetailsVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain)UITableView *myTableView;
@property(nonatomic,retain)UIView *whiteView;
@property(nonatomic,retain)UIButton *returnBt;//返回按钮

@property(nonatomic,retain)NSMutableArray *listArr;

@end

@implementation SalaryInfoDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithHexString:@"#f7f7f7"];
    //添加tableview
    [self addMyTableView];
    //添加返回按钮
    [self addReturnBt];
    [self loadData];
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImage.image = [UIImage imageNamed:@"背景1"];
    [self.view insertSubview:backImage atIndex:0];
}
#pragma mark---添加tableview
-(void)addMyTableView
{
    self.whiteView = [[UIView alloc]initWithFrame:CGRectMake(leftSpace, AutoFitHeight(96)+topSpace, SCREEN_WIDTH-leftSpace*2, SCREEN_HEIGHT-AutoFitHeight(96)-AutoFitHeight(35)-AutoFitHeight(164))];
    self.whiteView.backgroundColor = [UIColor clearColor ];
    
    self.whiteView.layer.cornerRadius = 3;
    self.whiteView.layer.masksToBounds = YES;
    [self.view addSubview:self.whiteView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.whiteView.bounds.size.width, AutoFitHeight(75))];
    label.text = @"工 资";
    if (self.title) {
        NSMutableDictionary *attDic = [NSMutableDictionary dictionary];
        [attDic setValue:[UIFont systemFontOfSize:AutoFitHeight(36)] forKey:NSFontAttributeName];      // 字体大小
        [attDic setValue:@5 forKey:NSKernAttributeName];                                // 字间距
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self.title attributes:attDic];
        label.attributedText = attStr;
    }
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:AutoFitHeight(36)];
    [self.whiteView addSubview:label];
    _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(leftSpace, AutoFitHeight(75), SCREEN_WIDTH-leftSpace*4, self.whiteView.bounds.size.height- AutoFitHeight(125)) style:UITableViewStylePlain];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    _myTableView.backgroundColor=[UIColor clearColor];
    _myTableView.tableFooterView=[UIView new];
    _myTableView.bounces=NO;
    _myTableView.layer.borderWidth = 1;
    _myTableView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.8].CGColor;
    _myTableView.showsVerticalScrollIndicator=NO;
    _myTableView.tableFooterView=[UIView new];
    _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.whiteView addSubview:_myTableView];
    //表头view
    UILabel *titleLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,CGRectGetWidth(_myTableView.frame) , AutoFitHeight(60))];
    titleLb.textAlignment=NSTextAlignmentCenter;
    titleLb.text=@"工资";
    //顶部分割线
    UILabel *topLb=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLb.frame), CGRectGetWidth(titleLb.frame), AutoFitWidth(0.5))];
    topLb.backgroundColor=[UIColor colorWithHexString:@"#b2b2b2"];
    [titleLb addSubview:topLb];
    UIView *whiteView = [[UIView alloc]initWithFrame:self.whiteView.frame];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.alpha = 0.8;
    whiteView.layer.cornerRadius = 3;
    whiteView.layer.masksToBounds = YES;
    [self.view insertSubview:whiteView belowSubview:_whiteView];
//    _myTableView.tableHeaderView=titleLb;
}
#pragma mark---推送历史获取
-(void)loadData{
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.tag        = 1002;
    hud.label.text = @"正在加载...";
    AFHTTPSessionManager * mgr            = [AFHTTPSessionManager manager];
    mgr.responseSerializer                = [[AFHTTPResponseSerializer alloc] init];
    mgr.requestSerializer.timeoutInterval = REQUEST_TIMEOUT;
    //    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    
    //?userID=3&&userOrganID=37
    NSDictionary *parameterDict = @{@"SalaryID":self.salaryID,@"SalaryYears":self.SalaryYears,@"UserID":[[NSUserDefaults standardUserDefaults] valueForKey:@"userID"]};
    [mgr POST:get_payroll_detail parameters:parameterDict progress:^(NSProgress * _Nonnull downloadProgress) {
        //progress
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *err;
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];

        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
//        _listArr = [dic valueForKey:@"DetailResult"];
        NSMutableArray *tempArr = [dic valueForKey:@"DetailResult"];
//        if (!_listArr) {
            _listArr = [NSMutableArray array];
//        }
       
        int sum = 0;
        
        for (int i=0;i<tempArr.count;i++) {
            NSString*value = [tempArr[i] allValues][0];
            int intValue = [value integerValue];
            if (intValue ==0) {
            }else{
                [_listArr addObject:tempArr[i]];

            }
            sum +=intValue;
        }
        NSString *sumStr = [NSString stringWithFormat:@"%d",sum];
        if (_signDateAndClient) {
            [_listArr addObjectsFromArray:_signDateAndClient];
        }
//        [_listArr addObject:@{@"总计":sumStr}];
        [self.myTableView reloadData];
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

#pragma mark---cell行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArr.count+1;
    return 10;
}
#pragma mark---cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AutoFitHeight(92);
}
#pragma mark---加载cell数据
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellID";
    SalaryInfoDetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[SalaryInfoDetailsCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
        cell.titleLb.text=@"项目";
        cell.contentLb.text=@"金额";
    }else{
        cell.titleLb.text=[self.listArr[indexPath.row-1] allKeys][0];
        cell.contentLb.text=[self.listArr[indexPath.row-1] allValues][0];
    }
    return cell;
}
#pragma mark---添加返回按钮
-(void)addReturnBt
{
    CGFloat returnBtWidth=AutoFitWidth(166);
    _returnBt=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-returnBtWidth-leftSpace, CGRectGetMaxY(_whiteView.frame)+AutoFitHeight(47), returnBtWidth, AutoFitHeight(66))];
    [_returnBt setTitle:@"返回" forState:UIControlStateNormal];
    _returnBt.backgroundColor=[UIColor colorWithHexString:@"#3e64b4"];
    [_returnBt addTarget:self action:@selector(returnBtClick) forControlEvents:UIControlEventTouchUpInside];
    _returnBt.layer.cornerRadius=5;
    _returnBt.layer.masksToBounds=YES;
    _returnBt.hidden = YES;
    [self.view addSubview:_returnBt];
}
#pragma mark---返回按钮点击
-(void)returnBtClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
