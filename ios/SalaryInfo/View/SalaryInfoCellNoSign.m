//
//  SalaryInfoCell.m
//  OfficeOA
//
//  Created by sunzhaokai on 2017/7/18.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "SalaryInfoCellNoSign.h"

@implementation SalaryInfoCellNoSign

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //分割线
        UILabel *separateLineLb=[[UILabel alloc]initWithFrame:CGRectMake(AutoFitWidth(190), AutoFitHeight(37), 1, AutoFitHeight(75))];
        separateLineLb.backgroundColor=[UIColor colorWithHexString:@"#b2b2b2"];
        [self.contentView addSubview:separateLineLb];
        //valueLb
        _valueLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(separateLineLb.frame)+AutoFitWidth(10), CGRectGetMinY(separateLineLb.frame), SCREEN_WIDTH-AutoFitWidth(180)-AutoFitWidth(100)-AutoFitWidth(180), CGRectGetHeight(separateLineLb.frame))];
        [self.contentView addSubview:_valueLb];
        //明细按钮
        _detailsBt=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-AutoFitWidth(180)-AutoFitWidth(100), AutoFitHeight(13), AutoFitWidth(139), AutoFitHeight(55))];
        _detailsBt.backgroundColor=[UIColor colorWithHexString:@"#3e64b4"];
        [_detailsBt setTitle:@"明细" forState:UIControlStateNormal];
        [_detailsBt addTarget:self action:@selector(detailsBtClickNoSign:) forControlEvents:UIControlEventTouchUpInside];

        _detailsBt.hidden=YES;
        _detailsBt.layer.cornerRadius=3;
        _detailsBt.layer.masksToBounds=YES;
        [self.contentView addSubview:_detailsBt];
        //签收按钮
        _signBt=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(_detailsBt.frame), CGRectGetMaxY(_detailsBt.frame)+AutoFitHeight(13), CGRectGetWidth(_detailsBt.frame), CGRectGetHeight(_detailsBt.frame))];
        _signBt.backgroundColor=[UIColor colorWithHexString:@"#3e64b4"];
        [_signBt setTitle:@"签收" forState:UIControlStateNormal];
        _signBt.hidden=YES;
        _signBt.layer.cornerRadius=3;
        _signBt.layer.masksToBounds=YES;
        [_signBt addTarget:self action:@selector(signBtClickNoSign:) forControlEvents:UIControlEventTouchUpInside];

        [self.contentView addSubview:_signBt];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)signBtClickNoSign:(UIButton *)btn{
    if (self.signBlock) {
        self.signBlock();
        btn.enabled = NO;
        btn.backgroundColor = [UIColor grayColor ];
    }
}
-(void)detailsBtClickNoSign:(UIButton*)btn{
    if (self.detailBlock) {
        self.detailBlock();
//        btn.enabled = NO;
//        btn.backgroundColor = [UIColor grayColor ];

    }
}
-(void)setItem:(SalaryInfoModel *)item{
    _item = item;
    self.textLabel.text = item.title;
    self.valueLb.text = item.value;
    self.detailsBt.hidden = !item.needDetailShow;
    self.signBt.hidden = !item.needSignShow;
}
@end
