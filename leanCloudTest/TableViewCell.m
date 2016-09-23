//
//  TableViewCell.m
//  leanCloudTest
//
//  Created by 曾广伦 on 16/9/9.
//  Copyright © 2016年 lun. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.zhanghaoTextFile.placeholder = @"请输入账号名称";
    //self.zhanghaoTextFile.backgroundColor = [UIColor yellowColor];
    self.mimaTextFile.placeholder = @"请输入密码";


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
