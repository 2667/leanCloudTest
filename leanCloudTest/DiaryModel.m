//
//  DiaryModel.m
//  leanCloudTest
//
//  Created by 曾广伦 on 16/9/26.
//  Copyright © 2016年 lun. All rights reserved.
//

#import "DiaryModel.h"

@implementation DiaryModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.diaryName forKey:@"diaryName"];
    
    [aCoder encodeObject:self.diary forKey:@"diary"];
    
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        self.diaryName = [aDecoder decodeObjectForKey:@"diaryName"];
        
        self.diary = [aDecoder decodeObjectForKey:@"diary"];
        
        
    }
    
    return self;
}

@end
