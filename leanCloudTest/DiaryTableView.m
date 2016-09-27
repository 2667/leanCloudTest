//
//  DiaryTableView.m
//  leanCloudTest
//
//  Created by 曾广伦 on 16/9/26.
//  Copyright © 2016年 lun. All rights reserved.
//

#import "DiaryTableView.h"

#import "DiaryTableViewCell.h"

#import <AVOSCloud/AVOSCloud.h>

#import "AppDelegate.h"
#import "DiaryModel.h"
#import "EditDiaryView.h"



@interface DiaryTableView (){
    AppDelegate *delegate;
}
@property (nonatomic, strong) NSArray *name;
@property (nonatomic, strong) NSArray *detail;

@property (nonatomic, strong) NSMutableArray *diaryArray;
@property (nonatomic, strong) DiaryTableViewCell *cell;

@end

@implementation DiaryTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    delegate = [[UIApplication sharedApplication] delegate];

    
    self.name = [NSArray arrayWithObjects:@"Jack",@"Petter",@"Allen", nil];
    self.detail = [NSArray arrayWithObjects:
                   @"asdjiiiiiiaslfjsdjfdfsd",
                   
                   @"asjlfkkkklskkkf;jsdifokjnkhbjeiojosgjlsjogijejowjgjooofof odslfjdsosjois",
                   @"sdfjoneonbtnbtorenbtuerotuouturituirutiutiuiuiuefdkflskofksfokofowkowowkdokokfofjgoigowuwwuduedueudheuhdhudehduehduehudheudhuehdueduhehduehduehudeudhuehduehduehudeudhuehduehudehudehdueueencncidnicndincindincindicnidncidncidicndcnidincidcidnicdncidncidncdn", nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    
    NSString *path = [self getFilePathFromDirectoriesInDomains:[NSString stringWithFormat:@"%@_diaryUrl.plist", delegate.objectName]];
    NSArray *urlArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];

    
    if (urlArray == nil) {
        self.diaryArray = [NSMutableArray array];
    }else{
    
    
    
    AVFile *file = [AVFile fileWithURL:urlArray[0]];
    
        NSLog(@"URL:%@",urlArray);
    
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        //NSLog(@"data:%@",data);
        
        self.diaryArray = [NSMutableArray array];
        self.diaryArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSLog(@"array:%@",self.diaryArray);
 /*
        DiaryModel *model =[[DiaryModel alloc]init];
        model = self.diaryArray[0];
        

        self.cell.diaryTitleLabel.text = model.diaryName;
        NSLog(@"%@",self.cell.diaryTitleLabel.text);
        
        self.cell.diaryLabel.text = model.diary;
        NSLog(@"%@",self.cell.diaryLabel.text);
*/
        [self.tableView reloadData];

    } progressBlock:^(NSInteger percentDone) {
        //下载的进度数据，percentDone 介于 0 和 100。
        //NSLog(@"进度：%ld",(long)percentDone);
    }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.diaryArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.cell = [tableView dequeueReusableCellWithIdentifier:@"diaryCell" forIndexPath:indexPath];
  
    NSInteger row = indexPath.row;
    
    DiaryModel *model =[[DiaryModel alloc]init];
    //倒叙
    model = self.diaryArray[self.diaryArray.count-1-row];
    //顺叙
    //model = self.diaryArray[self.diaryArray.count-1-row];


  
    self.cell.diaryTitleLabel.text = model.diaryName;
    //NSLog(@"%@",self.cell.diaryTitleLabel.text);
    
    self.cell.diaryLabel.text = model.diary;
    //NSLog(@"%@",self.cell.diaryLabel.text);

    
    //这里是设置单元格默认的行高，就是会根据自己的计算来获得实际高度;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //这里是设置单元格的预判高度，根据自己的预估单元格的平均高度随便填写一个就行。
    self.tableView.estimatedRowHeight = 100;
    
    return self.cell;
}

- (IBAction)addDiary:(id)sender {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    EditDiaryView *editDiaryView = [main instantiateViewControllerWithIdentifier:@"editDiaryView"];
    
    editDiaryView.isNill = YES;
    
  
    
    
    
    [self.navigationController pushViewController:editDiaryView animated:YES];
    
    //[self performSegueWithIdentifier:@"goToEditDiary" sender:self];

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
