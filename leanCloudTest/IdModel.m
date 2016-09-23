//
//  IdModel.m
//  leanCloudTest
//
//  Created by 曾广伦 on 16/9/14.
//  Copyright © 2016年 lun. All rights reserved.
//

#import "IdModel.h"

@implementation IdModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.idName forKey:@"idname"];
    
    [aCoder encodeObject:self.idNumber forKey:@"idnumber"];
    
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        self.idName = [aDecoder decodeObjectForKey:@"idname"];
        
        self.idNumber = [aDecoder decodeObjectForKey:@"idnumber"];
        
        
    }
    
    return self;
}

@end
