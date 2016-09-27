//
//  RootViewController.m
//  leanCloudTest
//
//  Created by 曾广伦 on 16/9/9.
//  Copyright © 2016年 lun. All rights reserved.
//

#import "RootViewController.h"

#import <AVOSCloud/AVOSCloud.h>

#import "TableViewCell.h"

#import "AppDelegate.h"


@interface RootViewController ()<UITableViewDelegate,UITableViewDataSource>{
    AppDelegate *delegate;

    
}


@property (strong,nonatomic) TableViewCell *cell1;
@property (strong,nonatomic) TableViewCell *cell2;

@property (nonatomic, strong) NSMutableArray *infoArray;


//@property (strong,nonatomic) UITableViewCell *cell2;



@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delegate = [[UIApplication sharedApplication] delegate];

    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.title = @"登陆界面";
    self.view.backgroundColor = [UIColor grayColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 2;
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        static NSString *cellID = @"cell1";
        self.cell1 = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        
        self.cell1.backgroundColor = [UIColor whiteColor];
        
        return self.cell1;

    }
    else{
        static NSString *cellID = @"cell2";
        self.cell2 = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        
        self.cell2.backgroundColor = [UIColor whiteColor];
        
        
        return self.cell2;

        
    }
    
}

- (IBAction)lognIn:(id)sender{
    //[self performSegueWithIdentifier:@"goToMainView" sender:self];


    [AVUser logInWithUsernameInBackground:self.cell1.zhanghaoTextFile.text
                                 password:self.cell2.mimaTextFile.text
                                 block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            NSLog(@"密码正确");
            
            //获取对应用户object名称
            delegate.objectName = self.cell1.zhanghaoTextFile.text;
            
            //列出云端的用户信息
            [self listUserInfo];
            
            [self performSegueWithIdentifier:@"goToMainView" sender:self];
 

        } else {
            NSLog(@"无法登录，原因：%@",error);
        }
    }];
 
  
    //NSLog(@"账号：%@",self.cell1.zhanghaoTextFile.text);

    //NSLog(@"密码：%@",self.cell2.mimaTextFile.text);
}

- (void)listUserInfo{
    //获取对应id
    NSString *path = [self getFilePathFromDirectoriesInDomains:[NSString stringWithFormat:@"%@_InfoID.plist", delegate.objectName]];
    
    self.infoArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    //NSLog(@"array:%@",self.infoArray);
    
    if (self.infoArray == nil) {
        NSLog(@"error");
    }else{
    
    AVQuery *query = [AVQuery queryWithClassName:@"user_Infomation"];
    [query getObjectInBackgroundWithId:self.infoArray[0] block:^(AVObject *object, NSError *error) {
        
        self.infoArray = [NSMutableArray array];
        [self.infoArray addObject: [object objectForKey:@"name"]];
        [self.infoArray addObject: [object objectForKey:@"telephone"]];
        [self.infoArray addObject: [object objectForKey:@"email"]];
        [self.infoArray addObject: [object objectForKey:@"address"]];
       /*
        NSLog(@"name:%@",[object objectForKey:@"name"]);
        NSLog(@"telephone:%@",[object objectForKey:@"telephone"]);
        NSLog(@"email:%@",[object objectForKey:@"email"]);
        NSLog(@"address:%@",[object objectForKey:@"address"]);
       */ 
        
    }];
    }
}


- (IBAction)signUp:(id)sender{
    
     [self performSegueWithIdentifier:@"goToSignUp" sender:self];
}

- (IBAction)goToTestViewContrller:(id)sender{
    
    [self performSegueWithIdentifier:@"goToTestView" sender:self];
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
