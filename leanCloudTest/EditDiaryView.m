//
//  EditDiaryView.m
//  leanCloudTest
//
//  Created by 曾广伦 on 16/9/26.
//  Copyright © 2016年 lun. All rights reserved.
//

#import "EditDiaryView.h"
#import <AVOSCloud/AVOSCloud.h>
#import "AppDelegate.h"
#import "DiaryModel.h"



@interface EditDiaryView (){
    AppDelegate *delegate;
}
@property (weak, nonatomic) IBOutlet UITextField *editDiaryName;
@property (weak, nonatomic) IBOutlet UITextView *editDiary;

@property (nonatomic, strong) NSMutableArray *diaryUrl;
@property (nonatomic, strong) NSMutableArray *diaryArray;

@end

@implementation EditDiaryView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delegate = [[UIApplication sharedApplication] delegate];
    
    self.editDiaryName.backgroundColor = [UIColor grayColor];
    self.editDiary.backgroundColor = [UIColor grayColor];

    
    //判断是否存在日记
    NSString *path = [self getFilePathFromDirectoriesInDomains:[NSString stringWithFormat:@"%@_diaryUrl.plist", delegate.objectName]];
    NSLog(@"%@",path);

    self.diaryUrl = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSLog(@"URL:%@",self.diaryUrl);
    
    if (self.diaryUrl == nil) {
        NSLog(@"日记本为空");
        self.diaryUrl = [NSMutableArray arrayWithObjects:@"diaryUrlIsNil", nil];
        self.diaryArray = [NSMutableArray array];
    }else{
        NSLog(@"日记本不为空");

        [self downLoadDiary];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    //NSLog(@"%d",self.isNill);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender {
    
    [self createDiary];

}

- (void)deleteDiary{
    
    
    AVFile *file = [AVFile fileWithURL:self.diaryUrl[0]];

    [file deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"%d",succeeded);
        NSLog(@"%@",error);
    }];
}

- (IBAction)test:(id)sender{

    AVFile *file = [AVFile fileWithURL:@"http://ac-5UnVvl2q.clouddn.com/BSeYAeDe76bDyHnHNZuTR1B.plist"];
    
    [file deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"%d",succeeded);
        NSLog(@"%@",error);
    }];
}




- (void)downLoadDiary{

    
    AVFile *file = [AVFile fileWithURL:self.diaryUrl[0]];
    
    
    
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        //NSLog(@"data:%@",data);
        
        self.diaryArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSLog(@"diaryArray:%@",self.diaryArray);
        
        
    } progressBlock:^(NSInteger percentDone) {
        //下载的进度数据，percentDone 介于 0 和 100。
        //NSLog(@"进度：%ld",(long)percentDone);
    }];
}


//创建日记本
- (void)createDiary{
    
     //添加日记内容到数组
     DiaryModel *model =[[DiaryModel alloc]init];
     model.diaryName = self.editDiaryName.text;
     model.diary = self.editDiary.text;
    
    [self.diaryArray addObject:model];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.diaryArray];
    //NSLog(@"data:%@",data);
    
    //在云端创建日记文件
    AVFile *file = [AVFile fileWithName:[NSString stringWithFormat:@"%@_diary.plist", delegate.objectName] data:data];
    
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        AVACL *acl = [AVACL ACL];
        [acl setPublicReadAccess:YES];// 设置公开的「读」权限，任何人都可阅读
        [acl setWriteAccess:YES forUser:[AVUser currentUser]];// 为当前用户赋予「写」权限，有且仅有当前用户可以修改这条
        file.ACL = acl;
        //NSLog(@"%@",[AVUser currentUser].username);
        
        NSLog(@"url:%@",file.url);//返回一个唯一的 Url 地址
        
        //成功创建日记，删除原有日记file
        [self deleteDiary];
        
        //保存日记本url
        [self.diaryUrl replaceObjectAtIndex:0 withObject:file.url];
        
        NSString *path = [self getFilePathFromDirectoriesInDomains:[NSString stringWithFormat:@"%@_diaryUrl.plist", delegate.objectName]];
        
        // 归档，调用归档方法
        BOOL success = [NSKeyedArchiver archiveRootObject:self.diaryUrl toFile:path];
        //NSLog(@"%d",success);
        if (success == 1) {
            NSLog(@"success");
        }else{
            NSLog(@"fail");
        }
        
     

        
        
    }];
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
