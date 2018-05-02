//
//  NotificationInfoVC.m
//  OfficeOA
//
//  Created by sunzhaokai on 2017/7/6.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "NotificationInfoVC.h"
#import "NotificationDetailsVC.h"

@interface NotificationInfoVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain)UITableView *myTableView;
@property (nonatomic,retain)NSMutableArray * listArr;
@end

@implementation NotificationInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithHexString:@"#f7f7f7"];
    //添加我的信息
    _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(AutoFitWidth(20), AutoFitHeight(55)+AutoFitHeight(96), SCREEN_WIDTH-AutoFitWidth(40), SCREEN_HEIGHT-AutoFitHeight(96)-AutoFitHeight(55)-AutoFitHeight(150)) style:UITableViewStylePlain];
    _myTableView.dataSource=self;
    _myTableView.delegate=self;
    
    UIView *titleView=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_myTableView.frame), AutoFitHeight(153))];
//    titleView.backgroundColor=[UIColor colorWithHexString:@"#3e64b4"];
    titleView.userInteractionEnabled=YES;
    //标题
    UILabel *titleLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_myTableView.frame), AutoFitHeight(153))];
    titleLb.backgroundColor=[UIColor colorWithHexString:@"#3e64b4"];
    titleLb.text=@"我的消息";
    titleLb.textAlignment=NSTextAlignmentCenter;
    titleLb.textColor=[UIColor whiteColor];
    titleLb.font=[UIFont systemFontOfSize:AutoFitFont(18)];
    [titleView addSubview:titleLb];
    //logo图标
    CGFloat space=AutoFitHeight(28);
    CGFloat imgWidth=AutoFitHeight(98);
    UIImageView *logoImg=[[UIImageView alloc]initWithFrame:CGRectMake(space, space, imgWidth, imgWidth)];
    logoImg.image = [UIImage imageNamed:@"title"];
    logoImg.backgroundColor=[UIColor orangeColor];
    logoImg.layer.cornerRadius=imgWidth/2;
    logoImg.layer.masksToBounds=YES;
    [titleView addSubview:logoImg];
    logoImg.hidden = YES;
    //搜索按钮
    CGFloat space1=AutoFitHeight(15);
    CGFloat imgWidth1=CGRectGetHeight(titleLb.frame)-space*2;
    UIButton *searchBt=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(titleView.frame)-space1-imgWidth1, space, imgWidth, imgWidth)];
//    searchBt.backgroundColor=[UIColor orangeColor];
    [searchBt setImage:[UIImage imageNamed:@"search1"] forState:UIControlStateNormal];
    [searchBt addTarget:self action:@selector(searchBtClick) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:searchBt];
    _myTableView.tableHeaderView=titleView;
    _myTableView.tableFooterView=[UIView new];
    _myTableView.bounces=NO;
    _myTableView.backgroundColor = [UIColor clearColor];
    _myTableView.layer.cornerRadius = 5;
    _myTableView.layer.masksToBounds = YES;
    [self.view addSubview:_myTableView];
    [self loadData];
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImage.image = [UIImage imageNamed:@"背景1"];
    [self.view insertSubview:backImage atIndex:0];
    UIView *whiteView = [[UIView alloc]initWithFrame:_myTableView.frame];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.alpha = 0.8;
    whiteView.layer.cornerRadius = 5;
    whiteView.layer.masksToBounds = YES;
    [self.view insertSubview:whiteView belowSubview:_myTableView];

}
-(NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr = [NSMutableArray array];
    }
    return _listArr;
}
#pragma mark---tableview表头view
-(UIView *)tableviewTitleView
{
    UIView *titleView=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_myTableView.frame), AutoFitHeight(153))];
    titleView.backgroundColor=[UIColor colorWithHexString:@"#3e64b4"];
    titleView.userInteractionEnabled=YES;
    //标题
    UILabel *titleLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_myTableView.frame), AutoFitHeight(153))];
    titleLb.backgroundColor=[UIColor colorWithHexString:@"#3e64b4"];
    titleLb.text=@"我的消息";
    titleLb.textAlignment=NSTextAlignmentCenter;
    titleLb.textColor=[UIColor whiteColor];
    titleLb.font=[UIFont systemFontOfSize:AutoFitFont(18)];
    [titleView addSubview:titleLb];
    //logo图标
    CGFloat space=AutoFitHeight(28);
    CGFloat imgWidth=AutoFitHeight(98);
    UIImageView *logoImg=[[UIImageView alloc]initWithFrame:CGRectMake(space, space, imgWidth, imgWidth)];
    logoImg.backgroundColor=[UIColor orangeColor];
    logoImg.layer.cornerRadius=imgWidth/2;
    logoImg.layer.masksToBounds=YES;
   // [titleView addSubview:logoImg];
    //搜索按钮
    CGFloat space1=AutoFitHeight(15);
    CGFloat imgWidth1=CGRectGetHeight(titleLb.frame)-space*2;
    UIButton *searchBt=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(titleView.frame)-space1-imgWidth1, space1, imgWidth1, imgWidth1)];
    searchBt.backgroundColor=[UIColor orangeColor];
    [searchBt addTarget:self action:@selector(searchBtClick) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:searchBt];
    return titleView;
}
-(void)viewWillDisappear:(BOOL)animated{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
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
    NSUserDefaults * df = [NSUserDefaults standardUserDefaults];
    
    self.userID = [df valueForKey:@"userID"]?[df valueForKey:@"userID"]:@"";
    self.userOrganID = [df valueForKey:@"OrganID"]?[df valueForKey:@"OrganID"]:@"";
    NSDictionary *parameterDict = @{@"userID":self.userID,@"userOrganID":self.userOrganID};
    [mgr POST:get_notification parameters:parameterDict progress:^(NSProgress * _Nonnull downloadProgress) {
        //progress
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *err;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        _listArr = [dic valueForKey:@"Table"];
        if (!_listArr) {
            _listArr = [NSMutableArray array];
        }
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

#pragma mark---搜索按钮点击
-(void)searchBtClick
{
    NSLog(@"搜索");
}
#pragma mark---cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AutoFitHeight(155);
}
#pragma mark---cell行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArr.count;
    return 10;
}
#pragma mark---加载cell数据
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text=[self.listArr[indexPath.row] valueForKey:@"NoticeTitle"];
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
//    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark---加载置顶和删除按钮
#pragma mark---滑动删除
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除按钮
    UITableViewRowAction *deleteAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"删除第%ld行",indexPath.row);
        [self.listArr removeObjectAtIndex:indexPath.row];
//        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [tableView reloadSections:[NSSet setWithObject:@0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadData];
    }];
    deleteAction.backgroundColor=[UIColor colorWithHexString:@"#3e64b4"];
    //置顶按钮
    UITableViewRowAction *topAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"置顶");
    }];
    topAction.backgroundColor=[UIColor colorWithHexString:@"#c8c7cd"];
    
    return @[deleteAction];
}
#pragma mark---cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationDetailsVC *notificationDetails=[[NotificationDetailsVC alloc]init];
    notificationDetails.noticeID = [self.listArr[indexPath.row] valueForKey:@"ID"];
    notificationDetails.noticeDict = self.listArr[indexPath.row] ;
    [self.navigationController pushViewController:notificationDetails animated:YES];
}
/*
{
    Table =     (
                 {
                     ChargeUserID = 0;
                     ClickNum = 12;
                     ClickUserNum = 1;
                     CreateUserID = 3;
                     CreatedTime = "2014/9/9 14:29:39";
                     EditTime = "2014/9/9 14:29:39";
                     HasAttach = 0;
                     ID = 3;
                     NoticeBody = 234;
                     NoticeStatus = 0;
                     NoticeTitle = 23432;
                     OpName = admin;
                     OrganID = 11;
                     PassTime = "";
                     PassUserID = 0;
                     RecGuid = d89f346411a7411897684118a12d240e;
                     SelfClickNum = 11;
                     SortID = 0;
                     Status = 0;
                 },
                 {
                     ChargeUserID = 0;
                     ClickNum = 8;
                     ClickUserNum = 3;
                     CreateUserID = 3;
                     CreatedTime = "2014/9/9 14:23:17";
                     EditTime = "2014/9/9 14:23:17";
                     HasAttach = 0;
                     ID = 2;
                     NoticeBody = 435;
                     NoticeStatus = 0;
                     NoticeTitle = 345435;
                     OpName = admin;
                     OrganID = 11;
                     PassTime = "";
                     PassUserID = 0;
                     RecGuid = 13e0ff9bf0834b2489ae3a0113e79dc9;
                     SelfClickNum = 3;
                     SortID = 0;
                     Status = 0;
                 },
                 {
                     ChargeUserID = 0;
                     ClickNum = 19;
                     ClickUserNum = 7;
                     CreateUserID = 3;
                     CreatedTime = "2014/8/20 13:18:06";
                     EditTime = "2014/8/20 13:18:06";
                     HasAttach = 0;
                     ID = 1;
                     NoticeBody = 1;
                     NoticeStatus = 0;
                     NoticeTitle = 1;
                     OpName = admin;
                     OrganID = 11;
                     PassTime = "";
                     PassUserID = 0;
                     RecGuid = "";
                     SelfClickNum = 10;
                     SortID = 0;
                     Status = 0;
                 }
                 );
}
*/
@end
