//
//  SignUpViewController.m
//  leanCloudTest
//
//  Created by 曾广伦 on 16/9/9.
//  Copyright © 2016年 lun. All rights reserved.
//

#import "SignUpViewController.h"

#import <AVOSCloud/AVOSCloud.h>

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountFile;
@property (weak, nonatomic) IBOutlet UITextField *passWordFile;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"注册页面";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)signUp{
    AVUser *newUser = [AVUser user];// 新建 AVUser 对象实例
    newUser.username = self.accountFile.text;// 设置用户名
    newUser.password =  self.passWordFile.text;// 设置密码
    //newUser.email = @"tom@leancloud.cn";// 设置邮箱
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // 注册成功
            NSLog(@"注册成功");
        } else {
            // 失败的原因可能有多种，常见的是用户名已经存在。
            NSLog(@"注册失败");

        }
    }];
}

- (IBAction)submit:(id)sender {
    
    [self signUp];
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
