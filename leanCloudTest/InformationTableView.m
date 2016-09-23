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

#import "InfoIdModel.h"

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

@property (nonatomic, strong) InformationCell *cell;


@end

@implementation InformationTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    delegate = [[UIApplication sharedApplication] delegate];
    
    [self loadData];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    
    // 反归档，调用反归档方法
 
    NSString *path = [self getFilePathFromDirectoriesInDomains:[NSString stringWithFormat:@"%@_InfoID.plist", delegate.objectName]];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSLog(@"%@",array);
    
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

        self.cell.InfoNameFile.text = self.infoArray[0];
        self.cell.InfotelephoneFile.text = self.infoArray[1];
        self.cell.InfoEmailFile.text = self.infoArray[2];
        self.cell.InfoAddressFile.text = self.infoArray[3];
        [self.tableView reloadData];
        
        // 获取三个特殊属性
        //NSString *objectId = object.objectId;
        //NSDate *updatedAt = object.updatedAt;
        //NSDate *createdAt = object.createdAt;
        
    
        
        
    }];

    
}
/*
- (void)save{
    // 反归档，调用反归档方法
    
    NSString *path = [self getFilePathFromDirectoriesInDomains:[NSString stringWithFormat:@"%@_InfoID.plist", delegate.objectName]];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    //NSLog(@"%@",array);
    
    //获取对应id
    InfoIdModel *infoIdModel = [[InfoIdModel alloc]init];
    infoIdModel = array[0];
    
    
    AVObject *updateObject =[AVObject objectWithClassName:delegate.objectName objectId:infoIdModel.InfoIdNumber];
    // 修改属性
    [updateObject setObject:self.editCell.EditName.text forKey:@"name"];
    [updateObject setObject:self.editCell.EditName.text forKey:@"telephone"];
    
    
    
    // 保存到云端
    [updateObject saveInBackground];
    
    //跟新通讯录并归档
    contactModel *model = [[contactModel alloc]init];
    model.contactName = self.editCell.EditName.text;
    model.contactTel = self.editCell.EditTel.text;
    
    [self.contactArray replaceObjectAtIndex:self.arrayRow withObject:model];
    
    NSString *path2 = [self getFilePathFromDirectoriesInDomains:[NSString stringWithFormat:@"%@_contactDetail.plist", delegate.objectName]];
    
    // 归档，调用归档方法
    BOOL success2 = [NSKeyedArchiver archiveRootObject:self.contactArray toFile:path2];
    
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell" forIndexPath:indexPath];
    //NSInteger row = indexPath.row;
    
 

    
    
  /*
    if (row == 0) {
        cell.InfoLabel.text = @"名称";
    }
    else if (row == 1) {
        cell.InfoLabel.text = @"电话";
    }
    else if (row == 2) {
        cell.InfoLabel.text = @"邮箱";
    }
    else if (row == 3) {
        cell.InfoLabel.text = @"住址";
    }
   */
    return cell;
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
