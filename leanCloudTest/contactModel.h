//
//  contactModel.h
//  leanCloudTest
//
//  Created by 曾广伦 on 16/9/9.
//  Copyright © 2016年 lun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface contactModel : NSObject<NSCoding>


@property (nonatomic, strong) NSString *contactName;
@property (nonatomic, strong) NSString *contactTel;
@property (nonatomic, strong) NSString *contactCountry;



@end
