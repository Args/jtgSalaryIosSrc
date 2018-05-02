//
//  SalaryInfoModel.h
//  OfficeOA
//
//  Created by tih on 2017/8/2.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SalaryInfoModel : NSObject
@property (nonatomic,assign)BOOL isSigned;
@property(nonatomic,copy) NSString * title;
@property(nonatomic,copy) NSString * salaryID;
@property(nonatomic,copy) NSString * date;
@property(nonatomic,copy) NSString * value;
@property (nonatomic,assign)BOOL needDetailShow;
@property (nonatomic,assign)BOOL needSignShow;
+(instancetype)modelWithDic:(NSDictionary* )dic;
+(instancetype)modelWithTitle:(NSString* )title AndValue:(NSString *)value;
@end
