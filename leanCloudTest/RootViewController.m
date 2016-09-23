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
    //[self performSegueWithIdentifier:@"goToContact" sender:self];


    [AVUser logInWithUsernameInBackground:self.cell1.zhanghaoTextFile.text
                                 password:self.cell2.mimaTextFile.text
                                 block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            NSLog(@"密码正确");
            
            //获取对应用户object名称
            delegate.objectName = self.cell1.zhanghaoTextFile.text;
            
            [self performSegueWithIdentifier:@"goToContact" sender:self];
            

        } else {
            NSLog(@"无法登录，原因：%@",error);
        }
    }];
    
  
    NSLog(@"账号：%@",self.cell1.zhanghaoTextFile.text);

    NSLog(@"密码：%@",self.cell2.mimaTextFile.text);
}

- (IBAction)signUp:(id)sender{
    
     [self performSegueWithIdentifier:@"goToSignUp" sender:self];
}

- (IBAction)goToTestViewContrller:(id)sender{
    
    [self performSegueWithIdentifier:@"goToTestView" sender:self];
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
