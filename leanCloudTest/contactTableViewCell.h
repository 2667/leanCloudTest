//
//  contactTableViewCell.h
//  leanCloudTest
//
//  Created by 曾广伦 on 16/9/9.
//  Copyright © 2016年 lun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface contactTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;

@end
