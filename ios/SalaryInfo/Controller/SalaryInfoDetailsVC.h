//
//  SalaryInfoDetailsVC.h
//  OfficeOA
//
//  Created by sunzhaokai on 2017/7/19.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "CommonTitleVC.h"

@interface SalaryInfoDetailsVC : CommonTitleVC
@property(nonatomic,copy)NSString * salaryID;
//@property(nonatomic,copy)NSString * SalaryRecGuid;
@property(nonatomic,copy)NSString * SalaryYears;
@property(nonatomic,retain)NSArray *signDateAndClient;
@property (nonatomic,copy)NSString *titleStr;
@end
