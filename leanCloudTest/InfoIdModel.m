//
//  InfoIdModel.m
//  
//
//  Created by 曾广伦 on 16/9/23.
//
//

#import "InfoIdModel.h"

@implementation InfoIdModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.InfoIdName forKey:@"infoIdName"];
    
    [aCoder encodeObject:self.InfoIdNumber forKey:@"infoIdNumber"];
    
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        self.InfoIdName = [aDecoder decodeObjectForKey:@"infoIdName"];
        
        self.InfoIdNumber = [aDecoder decodeObjectForKey:@"infoIdNumber"];
        
        
    }
    
    return self;
}

@end
