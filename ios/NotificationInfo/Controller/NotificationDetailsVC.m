//
//  NotificationDetailsVC.m
//  OfficeOA
//
//  Created by sunzhaokai on 2017/7/18.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "NotificationDetailsVC.h"

#define leftSpace AutoFitWidth(50)
#define topSpace  AutoFitWidth(20)


@interface NotificationDetailsVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain)UITableView *myTableView;
@property(nonatomic,copy)NSArray *titleArr;
//测试数据
@property(nonatomic,copy)NSArray *contentArr;

@property(nonatomic,retain)UIButton *returnBt;//返回按钮


@end

@implementation NotificationDetailsVC

-(NSArray *)titleArr
{
    if(_titleArr==nil){
        _titleArr=@[@"通知人：",@"通知标题：",@"通知时间："];
    }
    return _titleArr;
}
-(NSArray *)contentArr
{
    if(_contentArr==nil){
        NSString *name = [self.noticeDict valueForKey:@"OpName"];
        NSString *title = [self.noticeDict valueForKey:@"NoticeTitle"];
        NSString *time = [self.noticeDict valueForKey:@"CreatedTime"];
        if (!name) {
            name = @"";
        }
        if (!title) {
            title = @"";
        }
        if (!time) {
            time = @"";
        }
        _contentArr=@[name,title,time];
    }
    return _contentArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithHexString:@"#f7f7f7"];
    //添加tableview
    [self addMyTableView];
    //添加返回按钮
    [self addReturnBt];
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImage.image = [UIImage imageNamed:@"背景1"];
    [self.view insertSubview:backImage atIndex:0];
//    [self loadData];
}
//?userID=3&&noticeID=2
/*
 
 {
 CreatedTime = "2014/9/9 14:23:17";
 NoticeBody = 435;
 NoticeTitle = 345435;
 }
 */
-(void)loadData{
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.tag        = 1002;
    hud.label.text = @"正在加载...";
    //OpCode=admin&&isReadSignNum=0
    AFHTTPSessionManager * mgr            = [AFHTTPSessionManager manager];
    mgr.responseSerializer                = [[AFHTTPResponseSerializer alloc] init];
    mgr.requestSerializer.timeoutInterval = REQUEST_TIMEOUT;
    //    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] valueForKey:@"userID"];
    if (!userID) {
        userID = @"";
    }
    //?userID=3&&userOrganID=37
    [mgr POST:get_notification_detail parameters:@{@"UserID":userID,@"noticeID":self.noticeID} progress:^(NSProgress * _Nonnull downloadProgress) {
        //progress
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *err;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        if ([dic valueForKey:@"ID"]) {
            
        }
        
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

#pragma mark---添加tableview
-(void)addMyTableView
{
    
    _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(leftSpace, AutoFitHeight(150), SCREEN_WIDTH-leftSpace*2, SCREEN_HEIGHT-AutoFitHeight(150)-AutoFitHeight(100)-AutoFitHeight(60)) style:UITableViewStylePlain];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    _myTableView.backgroundColor=[UIColor clearColor];
    _myTableView.tableFooterView=[UIView new];
    _myTableView.bounces=NO;
    _myTableView.layer.cornerRadius = 4;
    _myTableView.layer.masksToBounds =YES;
    [self.view addSubview:_myTableView];
    //添加tableview
    [self addTableViewFooterView];
    UIView *whiteView = [[UIView alloc]initWithFrame:_myTableView.frame];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.alpha = 0.8;
    whiteView.layer.cornerRadius = 4;
    whiteView.layer.masksToBounds =YES;
    [self.view insertSubview:whiteView belowSubview:_myTableView];
}
#pragma mark---添加tableview表尾view
-(void)addTableViewFooterView
{
    //表尾view
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0,0, CGRectGetWidth(_myTableView.frame), AutoFitHeight(300))];
    //分割线
    UILabel *separateLineLb=[[UILabel alloc]initWithFrame:CGRectMake(AutoFitWidth(20), 0, CGRectGetWidth(_myTableView.frame)-AutoFitWidth(20), 0.6)];
    separateLineLb.backgroundColor=[UIColor colorWithHexString:@"#dddde0"];
    [footerView addSubview:separateLineLb];
    //表尾title
    CGFloat titleLbWidth=AutoFitWidth(184);
    UILabel *titleLb=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(separateLineLb.frame)+AutoFitHeight(25), titleLbWidth, AutoFitHeight(60))];
    titleLb.text=@"    通知内容：";
    titleLb.adjustsFontSizeToFitWidth = YES;
    [footerView addSubview:titleLb];
    //表尾内容view
    UIView *contentView=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLb.frame), CGRectGetMinY(titleLb.frame)+AutoFitHeight(20), CGRectGetWidth(footerView.frame)-AutoFitWidth(180)- AutoFitWidth(50), AutoFitHeight(241))];
    contentView.layer.cornerRadius=5;
    contentView.layer.masksToBounds=YES;
    contentView.layer.borderWidth=0.5;
    contentView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [footerView addSubview:contentView];
    //表尾内容viewtitle
    UILabel *contentTitleLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(contentView.frame), AutoFitHeight(10))];
    contentTitleLb.backgroundColor=[UIColor colorWithHexString:@"#3e64b4"];
    [contentView addSubview:contentTitleLb];
    //表尾内容值label
    UILabel *contentLb=[[UILabel alloc]initWithFrame:CGRectMake(AutoFitWidth(20), CGRectGetMaxY(contentTitleLb.frame), CGRectGetWidth(contentView.frame)-AutoFitWidth(40), AutoFitHeight(150))];
    contentLb.text=[self.noticeDict valueForKey:@"NoticeBody"];
    contentLb.textAlignment=NSTextAlignmentCenter;
    contentLb.numberOfLines=0;
    [contentView addSubview:contentLb];
    //表尾view添加到tableview上面
    _myTableView.tableFooterView=footerView;
}
#pragma mark---cell行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.text=self.titleArr[indexPath.row];
    cell.detailTextLabel.text=self.contentArr[indexPath.row];
    return cell;
}
#pragma mark---添加返回按钮
-(void)addReturnBt
{
    CGFloat returnBtWidth=AutoFitWidth(165);
    _returnBt=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-returnBtWidth-leftSpace, CGRectGetMaxY(_myTableView.frame)+AutoFitHeight(50), returnBtWidth, AutoFitHeight(63))];
    [_returnBt setTitle:@"返回" forState:UIControlStateNormal];
    _returnBt.backgroundColor=[UIColor colorWithHexString:@"#3e64b4"];
    [_returnBt addTarget:self action:@selector(returnBtClick) forControlEvents:UIControlEventTouchUpInside];
    _returnBt.layer.cornerRadius=5;
    _returnBt.titleLabel.font = [UIFont systemFontOfSize:AutoFitHeight(26)];
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
