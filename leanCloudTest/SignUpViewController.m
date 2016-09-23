//
//  SignUpViewController.m
//  leanCloudTest
//
//  Created by 曾广伦 on 16/9/9.
//  Copyright © 2016年 lun. All rights reserved.
//

#import "SignUpViewController.h"

#import <AVOSCloud/AVOSCloud.h>

#import "AppDelegate.h"

#import "InfoIdModel.h"


@interface SignUpViewController (){
    AppDelegate *delegate;
}
@property (weak, nonatomic) IBOutlet UITextField *accountFile;
@property (weak, nonatomic) IBOutlet UITextField *passWordFile;

@property (nonatomic, strong) NSMutableArray *idArray;


@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delegate = [[UIApplication sharedApplication] delegate];

    
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

//初始化用户的个人信息
- (void)initInfomation{
    
    AVObject *infoObject = [AVObject objectWithClassName:@"user_Infomation"];
    
    [infoObject setObject:self.accountFile.text forKey:@"name"];
    [infoObject setObject:nil forKey:@"telephone"];
    [infoObject setObject:nil forKey:@"email"];
    [infoObject setObject:nil forKey:@"address"];

    
    [infoObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // 存储成功
            NSLog(@"init user information succeeded");
            
            
            /**
             *  储存用户信息id
             */
            NSString *path = [self getFilePathFromDirectoriesInDomains:[NSString stringWithFormat:@"%@_InfoID.plist", self.accountFile.text]];
            //归档
            if (self.idArray == nil) {
                self.idArray = [NSMutableArray array];
            }else{
                NSLog(@"idArray is not nill");
            };
            
            InfoIdModel *infoIdModel = [[InfoIdModel alloc]init];
            
            infoIdModel.InfoIdName = self.accountFile.text;
            infoIdModel.InfoIdNumber = infoObject.objectId;
            
            [self.idArray addObject:infoIdModel];
            
            // 归档，调用归档方法
            BOOL success = [NSKeyedArchiver archiveRootObject:self.idArray toFile:path];
            //NSLog(@"%d",success);
            if (success == 1) {
                NSLog(@"success");
                NSLog(@"path:%@",[self getFilePathFromDirectoriesInDomains:[NSString stringWithFormat:@"%@_InfoID.plist", self.accountFile.text]]);
            }else{
                NSLog(@"fail");
            }
            
      
            
            
            
            
            
            
            
        } else {
            // 失败的话，请检查网络环境以及 SDK 配置是否正确
            NSLog(@"error:%@",error);
        }
        
        
        
    }];
}

- (IBAction)submit:(id)sender {
    
    [self signUp];
    [self initInfomation];
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
