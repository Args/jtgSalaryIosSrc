//
//  SalaryInfoCell.h
//  OfficeOA
//
//  Created by sunzhaokai on 2017/7/18.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalaryInfoModel.h"

@interface SalaryInfoCellNoSign : UITableViewCell

@property (nonatomic, copy)  void(^signBlock) ();
@property (nonatomic, copy)  void(^detailBlock) ();

@property (nonatomic,retain)SalaryInfoModel * item;
//内容值
@property(nonatomic,retain)UILabel *valueLb;
//明细按钮
@property(nonatomic,retain)UIButton *detailsBt;
//签收按钮
@property(nonatomic,retain)UIButton *signBt;

@end
