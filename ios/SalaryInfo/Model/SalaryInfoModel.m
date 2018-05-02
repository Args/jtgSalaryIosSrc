//
//  SalaryInfoModel.m
//  OfficeOA
//
//  Created by tih on 2017/8/2.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "SalaryInfoModel.h"

@interface SalaryInfoModel()


@end
@implementation SalaryInfoModel
+(instancetype)modelWithDic:(NSDictionary* )dic{
    SalaryInfoModel *item = [[SalaryInfoModel alloc]init];
    item.title = [dic valueForKey:@"Description"];
    item.value = [dic valueForKey:@"TotalSalary"];
    item.salaryID = [dic valueForKey:@"ID"];
    item.date = [dic valueForKey:@"SalaryYears"];
    item.isSigned = [[dic valueForKey:@"SignStatus"] integerValue] == 1;
    item.needDetailShow = YES;
    item.needSignShow = !item.isSigned;
    return item;
}
+(instancetype)modelWithTitle:(NSString* )title AndValue:(NSString *)value{
    SalaryInfoModel *item = [[SalaryInfoModel alloc]init];
    item.title = title;
    item.value = value;
    item.needDetailShow = NO;
    item.needSignShow = NO;
    return item;
}
@end
