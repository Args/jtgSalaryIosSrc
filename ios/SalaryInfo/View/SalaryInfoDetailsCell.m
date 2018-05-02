//
//  SalaryInfoDetailsCell.m
//  OfficeOA
//
//  Created by sunzhaokai on 2017/7/19.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "SalaryInfoDetailsCell.h"

#define lineWidth 0.5
#define labelWidth  AutoFitHeight(174)

@implementation SalaryInfoDetailsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //左边分割线
        UILabel *leftLineLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, lineWidth, AutoFitHeight(92)-lineWidth)];
        leftLineLb.backgroundColor=[UIColor colorWithHexString:@"#b2b2b2"];
        [self.contentView addSubview:leftLineLb];
        //title
        _titleLb=[[UILabel alloc]initWithFrame:CGRectMake(lineWidth, 0, labelWidth*2, CGRectGetHeight(leftLineLb.frame))];
        _titleLb.textAlignment=NSTextAlignmentCenter;
        _titleLb.font = [UIFont systemFontOfSize:AutoFitHeight(26) ];
        _titleLb.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_titleLb];
        //中间分割线
        UILabel *midLineLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_titleLb.frame), CGRectGetMinY(_titleLb.frame), lineWidth, CGRectGetHeight(_titleLb.frame))];
        midLineLb.backgroundColor=[UIColor colorWithHexString:@"#b2b2b2"];
        [self.contentView addSubview:midLineLb];
        //content
        _contentLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(midLineLb.frame), CGRectGetMinY(midLineLb.frame), labelWidth, CGRectGetHeight(midLineLb.frame))];
        _contentLb.textAlignment=NSTextAlignmentCenter;
        _contentLb.font = [UIFont systemFontOfSize:AutoFitHeight(26) ];
        _contentLb.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_contentLb];
        //右边分割线
        UILabel *rightLineLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_contentLb.frame), CGRectGetMinY(_contentLb.frame), lineWidth, CGRectGetHeight(_contentLb.frame))];
        rightLineLb.backgroundColor=[UIColor colorWithHexString:@"#b2b2b2"];
       // [self.contentView addSubview:rightLineLb];
        //横向分割线
        UILabel *bottomLb=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLb.frame), SCREEN_WIDTH-AutoFitWidth(200), lineWidth)];
        bottomLb.backgroundColor=[UIColor colorWithHexString:@"#b2b2b2"];
        [self.contentView addSubview:bottomLb];
        self.backgroundColor = [UIColor clearColor];


    }
    return self;
}



@end
