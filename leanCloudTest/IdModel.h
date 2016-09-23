//
//  IdModel.h
//  leanCloudTest
//
//  Created by 曾广伦 on 16/9/14.
//  Copyright © 2016年 lun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdModel : NSObject<NSCoding>

@property (nonatomic, strong) NSString *idName;
@property (nonatomic, strong) NSString *idNumber;

@end
