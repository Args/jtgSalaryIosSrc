//
//  PersonInfoCell.m
//  OfficeOA
//
//  Created by sunzhaokai on 2017/7/17.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "PersonInfoCell.h"

@implementation PersonInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //上传按钮图片
        _uploadImgBt=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-AutoFitWidth(200), AutoFitHeight(25), AutoFitWidth(160), AutoFitHeight(60))];
        _uploadImgBt.backgroundColor=[UIColor colorWithHexString:@"#3e64b4"];
        _uploadImgBt.hidden=YES;
        _uploadImgBt.titleLabel.font=[UIFont systemFontOfSize:AutoFitHeight(26)];
        [_uploadImgBt setTitle:@"上传图片" forState:UIControlStateNormal];
        _uploadImgBt.layer.cornerRadius=5;
        _uploadImgBt.layer.masksToBounds=YES;
        [self addSubview:_uploadImgBt];
    }
    return self;
}

@end
