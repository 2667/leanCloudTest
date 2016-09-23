//
//  contactModel.m
//  leanCloudTest
//
//  Created by 曾广伦 on 16/9/9.
//  Copyright © 2016年 lun. All rights reserved.
//

#import "contactModel.h"

@implementation contactModel



- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.contactName forKey:@"contactname"];
    
    [aCoder encodeObject:self.contactTel forKey:@"contacttel"];
    
    [aCoder encodeObject:self.contactCountry forKey:@"contactcountry"];
    
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        self.contactName = [aDecoder decodeObjectForKey:@"contactname"];
        
        self.contactTel = [aDecoder decodeObjectForKey:@"contacttel"];
        
        self.contactCountry = [aDecoder decodeObjectForKey:@"contactcountry"];
        
    }
    
    return self;
}

@end
