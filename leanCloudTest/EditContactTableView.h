//
//  EditContactTableView.h
//  leanCloudTest
//
//  Created by 曾广伦 on 16/9/18.
//  Copyright © 2016年 lun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditTableViewCell.h"


@interface EditContactTableView : UITableViewController

@property (nonatomic, strong) NSString *editName;
@property (nonatomic, strong) NSString *editTel;
@property (nonatomic, strong) NSString *editCountry;

@property (nonatomic ,strong) EditTableViewCell *editCell;

@property (nonatomic, assign) NSInteger arrayRow;




@end
