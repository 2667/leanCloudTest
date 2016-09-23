//
//  TestViewController.m
//  leanCloudTest
//
//  Created by 曾广伦 on 16/9/23.
//  Copyright © 2016年 lun. All rights reserved.
//

#import "TestViewController.h"

#import <AVOSCloud/AVOSCloud.h>


@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    AVFile *file = [AVFile fileWithName:@"test.plist" contentsAtPath:[self getFilePathFromDirectoriesInDomains:@"test_contactDetail.plist"]];
 /*
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"url:%@",file.url);//返回一个唯一的 Url 地址
    }];
  */
    
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        // data 就是文件的数据流
        NSLog(@"data:%@",data);
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSLog(@"array:%@",array);
        
    } progressBlock:^(NSInteger percentDone) {
        //下载的进度数据，percentDone 介于 0 和 100。
        //NSLog(@"进度：%ld",(long)percentDone);
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








//获取沙盒路径，并与文件名合并为完整的路径
- (NSString *)getFilePathFromDirectoriesInDomains:(NSString *)fileName {
    
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *domainsPath = [paths objectAtIndex:0];
    
    NSString *fullPath = [domainsPath stringByAppendingPathComponent:fileName];
    
    return fullPath;
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
