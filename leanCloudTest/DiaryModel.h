//
//  DiaryModel.h
//  leanCloudTest
//
//  Created by 曾广伦 on 16/9/26.
//  Copyright © 2016年 lun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiaryModel : NSObject<NSCoding>

@property (nonatomic, strong) NSString *diaryName;
@property (nonatomic, strong) NSString *diary;

@end
