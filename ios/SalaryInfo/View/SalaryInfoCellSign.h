//
//  SalaryInfoCellSign.h
//  OfficeOA
//
//  Created by sunzhaokai on 2017/7/19.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalaryInfoModel.h"
@interface SalaryInfoCellSign : UITableViewCell
@property (nonatomic,retain)SalaryInfoModel * item;
@property (nonatomic, copy)  void(^detailBlock) ();

//内容值
@property(nonatomic,retain)UILabel *valueLb;
//明细按钮
@property(nonatomic,retain)UIButton *detailsBt;

@end
