//
//  ViewController.m
//  leanCloudTest
//
//  Created by 曾广伦 on 16/8/19.
//  Copyright © 2016年 lun. All rights reserved.
//

#import "ViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "contactTableViewCell.h"
#import "contactModel.h"
#import "IdModel.h"

#import "EditContactTableView.h"

#import "AppDelegate.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>{
    AppDelegate *delegate;

}

@property (nonatomic, assign) NSInteger contactRow;

@property (nonatomic, strong) NSMutableDictionary *idDictionary;

@property (nonatomic, strong) NSMutableArray *idArray;
@property (nonatomic, strong) NSMutableArray *contactArray;





@property (nonatomic, weak) IBOutlet UITextField *test;

@property (nonatomic, strong) contactTableViewCell *cell;

@property (weak, nonatomic) IBOutlet UITextField *nameFile;

@property (weak, nonatomic) IBOutlet UITextField *telephoneFile;
@property (weak, nonatomic) IBOutlet UITextField *countryFile;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    delegate = [[UIApplication sharedApplication] delegate];

    
    self.contactTableView.dataSource = self;
    self.contactTableView.delegate = self;
    
    self.title = @"个人通讯录";
    
    self.nameFile.placeholder = @"请输入名字";
    self.telephoneFile.placeholder =@"请输入电话号码";
    self.countryFile.placeholder = @"请输入国家地区";

    NSLog(@"账号：%@",delegate.objectName);



    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadData];
    NSLog(@"1");
    [self.contactTableView reloadData];

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
    //return self.idArray.count;
    return self.contactArray.count;
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        static NSString *cellID = @"contactCell";
        self.cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        

    contactModel *contact = [[contactModel alloc]init];
    contact = self.contactArray[indexPath.row];
    
    
    
    self.cell.nameLabel.text = contact.contactName;
    self.cell.telephoneLabel.text = contact.contactTel;
/*
    //id
    IdModel *idModel = self.idArray[indexPath.row];
    //联络人资料
    contactModel *contactModel = self.contactArray[indexPath.row];
    
    AVQuery *query = [AVQuery queryWithClassName:@"TestObject"];
    [query getObjectInBackgroundWithId:idModel.idNumber block:^(AVObject *object, NSError *error) {
        
        self.cell.nameLabel.text = [object objectForKey:@"name"];
        
        self.cell.telephoneLabel.text = [object objectForKey:@"telephone"];
        
        //int priority = [[object objectForKey:@"priority"] intValue];
        //NSString *name = [object objectForKey:@"name"];
        //NSString *country = object[@"country"];
        
        // 获取三个特殊属性
        //NSString *objectId = object.objectId;
        //NSDate *updatedAt = object.updatedAt;
        //NSDate *createdAt = object.createdAt;
        
        NSLog(@"infomation:%@",object);
        //NSLog(@"%@",objectId);
        //NSLog(@"%@",updatedAt);
        //NSLog(@"%@",createdAt);
 
        
    }];
*/
    
    
    
        return self.cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.contactRow = indexPath.row;
    NSLog(@"row:%ld",(long)self.contactRow);

    
    contactModel *contact = [[contactModel alloc]init];
    contact = self.contactArray[self.contactRow];
    
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    EditContactTableView *editContactTableView = [main instantiateViewControllerWithIdentifier:@"editContactTable"];
    

    
    editContactTableView.editName = contact.contactName;
    editContactTableView.editTel = contact.contactTel;
    editContactTableView.editCountry = contact.contactCountry;
    editContactTableView.arrayRow = indexPath.row;
    


    [self.navigationController pushViewController:editContactTableView animated:YES];



}

- (IBAction)createObject:(id)sender{
    [self create];
}




- (void)create {

    
        AVObject *createObject = [AVObject objectWithClassName:delegate.objectName];

            [createObject setObject:self.nameFile.text forKey:@"name"];
            [createObject setObject:self.telephoneFile.text forKey:@"telephone"];
    
            [createObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    // 存储成功
                    NSLog(@"succeeded");
                    
                 
                    /**
                     *  储存id
                     */
                    //NSString *path = [self getFilePathFromDirectoriesInDomains:@"contactID.plist"];
                    NSString *path = [self getFilePathFromDirectoriesInDomains:[NSString stringWithFormat:@"%@_contactID.plist", delegate.objectName]];
                    //归档
                    if (self.idArray == nil) {
                        self.idArray = [NSMutableArray array];
                    }else{
                        NSLog(@"idArray is not nill");
                    };
                    
                    IdModel *idModel = [[IdModel alloc]init];
                    
                    idModel.idName = self.nameFile.text;
                    idModel.idNumber = createObject.objectId;
                    
                    [self.idArray addObject:idModel];
                    
                    // 归档，调用归档方法
                    BOOL success = [NSKeyedArchiver archiveRootObject:self.idArray toFile:path];
                    //NSLog(@"%d",success);
                    if (success == 1) {
                        NSLog(@"success");
                    }else{
                        NSLog(@"fail");
                    }
                    
                    // 反归档，调用反归档方法
                    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
                    NSLog(@"%@",array);
                    
                    
                    /**
                     *  储存通讯录内容
                     */
                    //NSString *path2 = [self getFilePathFromDirectoriesInDomains:@"contactDetail.plist"];
                    NSString *path2 = [self getFilePathFromDirectoriesInDomains:[NSString stringWithFormat:@"%@_contactDetail.plist", delegate.objectName]];

                    //归档
                    if (self.contactArray == nil) {
                        self.contactArray = [NSMutableArray array];
                    }else{
                        NSLog(@"contactArray is not nill");
                    };
                    
                    contactModel *contact = [[contactModel alloc]init];
                    contact.contactName = self.nameFile.text;
                    contact.contactTel = self.telephoneFile.text;
                    
                    [self.contactArray addObject:contact];
                    
                    // 归档，调用归档方法
                    BOOL success2 = [NSKeyedArchiver archiveRootObject:self.contactArray toFile:path2];
                    //NSLog(@"%d",success);
                    if (success2 == 1) {
                        NSLog(@"success");
                    }else{
                        NSLog(@"fail");
                    }
                    
                    // 反归档，调用反归档方法
                    NSArray *array2 = [NSKeyedUnarchiver unarchiveObjectWithFile:path2];
                    NSLog(@"%@",array2);
                    

                    [self.contactTableView reloadData];
                    
                    
                
                    
                } else {
                    // 失败的话，请检查网络环境以及 SDK 配置是否正确
                    NSLog(@"error:%@",error);
                }
                
                

            }];

     

  
}



/*
- (void)addObject {
    // NSArray *objectID = [NSArray arrayWithContentsOfFile:[self getFilePathFromDirectoriesInDomains:@"objectID"]];
self.idDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[self getFilePathFromDirectoriesInDomains:@"contactID.plist"]];

    
    if (self.idDictionary == nil){
     
        NSLog(@"there is no date");
    }else{
        
        
        //

       
            AVObject *addObject =[AVObject objectWithClassName:@"TestObject" objectId:self.array[self.row]];

            // 修改属性
            [addObject setObject:@"China" forKey:@"country"];
            // 保存到云端
            [addObject saveInBackground];
 
    }
    
    
    
}
*/



/*
- (void)queryObject{
    self.array = [NSMutableArray arrayWithContentsOfFile:[self getFilePathFromDirectoriesInDomains:@"objectID"]];
    
    
    if (self.array == nil){
        
        NSLog(@"there is no date");
    }else{
        

  
        
      AVQuery *query = [AVQuery queryWithClassName:@"TestObject"];
      [query getObjectInBackgroundWithId:self.array[self.row] block:^(AVObject *object, NSError *error) {

        
        //int priority = [[object objectForKey:@"priority"] intValue];
        //NSString *name = [object objectForKey:@"name"];
        //NSString *country = object[@"country"];
        
        // 获取三个特殊属性
        //NSString *objectId = object.objectId;
        //NSDate *updatedAt = object.updatedAt;
        //NSDate *createdAt = object.createdAt;
        
        NSLog(@"infomation:%@",object);
        //NSLog(@"%@",objectId);
        //NSLog(@"%@",updatedAt);
        //NSLog(@"%@",createdAt);

      
    }];
      
        
    }
}
*/

//获取沙盒路径，并与文件名合并为完整的路径
- (NSString *)getFilePathFromDirectoriesInDomains:(NSString *)fileName {
    
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *domainsPath = [paths objectAtIndex:0];
    
    NSString *fullPath = [domainsPath stringByAppendingPathComponent:fileName];
    
    return fullPath;
    
}



- (void)testArray{
    
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"2", nil];
    [arr addObject:@"1"];
    NSLog(@"%@",arr);
    

}



@end

