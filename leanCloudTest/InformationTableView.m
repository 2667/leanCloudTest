//
//  InformationTableView.m
//  leanCloudTest
//
//  Created by 曾广伦 on 16/9/23.
//  Copyright © 2016年 lun. All rights reserved.
//

#import "InformationTableView.h"

#import "InformationCell.h"

#import <AVOSCloud/AVOSCloud.h>


#import "AppDelegate.h"


@interface InformationTableView (){
    AppDelegate *delegate;
}


@property (nonatomic, strong) NSMutableArray *idArray;
@property (nonatomic, strong) NSMutableArray *infoArray;


@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) InformationCell *infocell;


@end

@implementation InformationTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    delegate = [[UIApplication sharedApplication] delegate];
    
    //[self loadData];

    
}


- (void)viewWillAppear:(BOOL)animated{
    [self loadData];

    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    
    // 反归档，调用反归档方法
 
    NSString *path = [self getFilePathFromDirectoriesInDomains:[NSString stringWithFormat:@"%@_InfoID.plist", delegate.objectName]];

    self.infoArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSLog(@"array:%@",self.infoArray);
    
    
    
  /*
    //获取对应id
    InfoIdModel *infoIdModel = [[InfoIdModel alloc]init];
    infoIdModel = array[0];
    NSLog(@"!!!!___________%@",infoIdModel.InfoIdNumber);
    
    
    AVQuery *query = [AVQuery queryWithClassName:@"user_Infomation"];
    [query getObjectInBackgroundWithId:infoIdModel.InfoIdNumber block:^(AVObject *object, NSError *error) {
        
        self.infoArray = [NSMutableArray array];
        [self.infoArray addObject: [object objectForKey:@"name"]];
        [self.infoArray addObject: [object objectForKey:@"telephone"]];
        [self.infoArray addObject: [object objectForKey:@"email"]];
        [self.infoArray addObject: [object objectForKey:@"address"]];
        
        NSLog(@"infoArray:%@",self.infoArray);

        self.infocell.InfoNameFile.text = self.infoArray[0];
        self.infocell.InfotelephoneFile.text = self.infoArray[1];
        self.infocell.InfoEmailFile.text = self.infoArray[2];
        self.infocell.InfoAddressFile.text = self.infoArray[3];
        //[self.tableView reloadData];
        
        // 获取三个特殊属性
        //NSString *objectId = object.objectId;
        //NSDate *updatedAt = object.updatedAt;
        //NSDate *createdAt = object.createdAt;
     
    
        
        
    }];
*/
    
}

- (IBAction)save:(id)sender{
    
  
    
    
    
    AVObject *updateInfo = [AVObject objectWithClassName:@"user_Infomation" objectId:self.infoArray[0]];
    
    [updateInfo setObject:self.infocell.InfoNameFile.text forKey:@"name"];
    [updateInfo setObject:self.infocell.InfotelephoneFile.text forKey:@"telephone"];
    [updateInfo setObject:self.infocell.InfoEmailFile.text forKey:@"email"];
    [updateInfo setObject:self.infocell.InfoAddressFile.text forKey:@"address"];
    
    
    [updateInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // 存储成功
            NSLog(@"update user information succeeded");
            
          
            
            [self.infoArray replaceObjectAtIndex:1 withObject:self.infocell.InfoNameFile.text];
            [self.infoArray replaceObjectAtIndex:2 withObject:self.infocell.InfotelephoneFile.text];
            [self.infoArray replaceObjectAtIndex:3 withObject:self.infocell.InfoEmailFile.text];
            [self.infoArray replaceObjectAtIndex:4 withObject:self.infocell.InfoAddressFile.text];
            
            NSString *path = [self getFilePathFromDirectoriesInDomains:[NSString stringWithFormat:@"%@_InfoID.plist", delegate.objectName]];
            
            [NSKeyedArchiver archiveRootObject:self.infoArray toFile:path];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
            
            
            
            
        } else {
            // 失败的话，请检查网络环境以及 SDK 配置是否正确
            NSLog(@"error:%@",error);
        }
        
        
        
    }];


}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //InformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell" forIndexPath:indexPath];
    //NSInteger row = indexPath.row;
    
    self.infocell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell" forIndexPath:indexPath];

    self.infocell.InfoNameFile.text = self.infoArray[1];
    self.infocell.InfotelephoneFile.text = self.infoArray[2];
    self.infocell.InfoEmailFile.text = self.infoArray[3];
    self.infocell.InfoAddressFile.text = self.infoArray[4];
    
    return self.infocell;
}


//获取沙盒路径，并与文件名合并为完整的路径
- (NSString *)getFilePathFromDirectoriesInDomains:(NSString *)fileName {
    
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *domainsPath = [paths objectAtIndex:0];
    
    NSString *fullPath = [domainsPath stringByAppendingPathComponent:fileName];
    
    return fullPath;
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
