//
//  EditContactTableView.m
//  leanCloudTest
//
//  Created by 曾广伦 on 16/9/18.
//  Copyright © 2016年 lun. All rights reserved.
//

#import "EditContactTableView.h"
#import <AVOSCloud/AVOSCloud.h>

#import "IdModel.h"
#import "contactModel.h"

#import "AppDelegate.h"



@interface EditContactTableView (){
    AppDelegate *delegate;
}

@property (nonatomic, strong) NSMutableArray *idArray;
@property (nonatomic, strong) NSMutableArray *contactArray;


@end

@implementation EditContactTableView

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
    
    

    
    //加载id
    self.idArray = [NSMutableArray array];
    self.idArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getFilePathFromDirectoriesInDomains:[NSString stringWithFormat:@"%@_contactID.plist", delegate.objectName]]];
    
    if (self.idArray == nil) {
        self.idArray = [NSMutableArray array];
    }else{
        NSLog(@"idArray is not nill");
    };
    NSLog(@"idArray:%@",self.idArray);
    
    //NSLog(@"id路径:%@",[self getFilePathFromDirectoriesInDomains:@"contactID.plist"]);
    //NSLog(@"contact路径:%@",[self getFilePathFromDirectoriesInDomains:@"contactDetail.plist"]);
    
    
    //加载通讯录
    self.contactArray =[NSKeyedUnarchiver unarchiveObjectWithFile:[self getFilePathFromDirectoriesInDomains:[NSString stringWithFormat:@"%@_contactDetail.plist", delegate.objectName]]];
    if (self.contactArray == nil) {
        self.contactArray = [NSMutableArray array];
    }else{
        NSLog(@"contactArray is not nill");
    };
    NSLog(@"contactArray:%@",self.contactArray);
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *cellID = @"editCell";
    self.editCell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    self.editCell.EditName.text = self.editName;
    self.editCell.EditTel.text = self.editTel;
    self.editCell.EditCountry.text = self.editCountry;
    
    
    
    return self.editCell;
}


- (IBAction)save:(id)sender{
    
    //获取对应id
    IdModel *idModel = [[IdModel alloc]init];
    idModel = self.idArray[self.arrayRow];
    
    
    AVObject *updateObject =[AVObject objectWithClassName:delegate.objectName objectId:idModel.idNumber];
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

- (IBAction)deleteId:(id)sender{
    
    //获取对应id
    IdModel *idModel = [[IdModel alloc]init];
    idModel = self.idArray[self.arrayRow];

    AVObject *deleteObject =[AVObject objectWithClassName:delegate.objectName objectId:idModel.idNumber];
    
    //删除云端数据
    [deleteObject deleteInBackground];
    
    //删除本地id数据并更新
    [self.idArray removeObjectAtIndex:self.arrayRow];
    
    NSString *path = [self getFilePathFromDirectoriesInDomains:[NSString stringWithFormat:@"%@_contactID.plist", delegate.objectName]];
    BOOL success = [NSKeyedArchiver archiveRootObject:self.idArray toFile:path];

    //删除本地contact数据并更新
    [self.contactArray removeObjectAtIndex:self.arrayRow];
    
    NSString *path2 = [self getFilePathFromDirectoriesInDomains:[NSString stringWithFormat:@"%@_contactDetail.plist", delegate.objectName]];
    BOOL success2 = [NSKeyedArchiver archiveRootObject:self.contactArray toFile:path2];


    [self.navigationController popViewControllerAnimated:YES];


    
    

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
