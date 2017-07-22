//
//  GSMineController.m
//  gushici
//
//  Created by 李江波 on 2017/2/13.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSMineController.h"
#import "GSHistoryTableVC.h"
#import "GSAboutMeController.h"
#import <StoreKit/StoreKit.h>


@interface GSMineController ()<UITableViewDelegate ,UITableViewDataSource>

@property(nonatomic ,weak) UITableView *tableV;
@property(nonatomic ,strong) UILabel *lab;

@end

static NSString *cellID = @"cellID";
@implementation GSMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _Str(@"个人信息");
    UITableView *tableV = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:tableV];
    
    tableV.delegate = self;
    tableV.dataSource = self;
    
    [tableV registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    self.tableV = tableV;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.textLabel.font = [UIFont fontWithName:_FontName size:_Font(17)];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                
                cell.textLabel.text = _Str(@"我的收藏");
            }else{
            
                cell.textLabel.text = _Str(@"浏览记录");
            }
            break;
        }
        case 1:
        {
            if (indexPath.row == 0) {
        
                cell.textLabel.text = _Str(@"清除缓存");
                
                self.lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
                self.lab.text = [NSString stringWithFormat:@"%.1f M",[self filePathCache]];
                self.lab.textAlignment = NSTextAlignmentRight;
                self.lab.font = [UIFont systemFontOfSize:19];
                cell.accessoryView = self.lab;
            
            }else{
                
                cell.textLabel.text = _Str(@"字体大小");
                UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:@[_Str(@"小"),_Str(@"中"),_Str(@"大")]];
                [segment setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:_FontName size:_Font(15)]} forState:UIControlStateNormal];
                [segment addTarget:self action:@selector(changeDayOrNightModel:) forControlEvents:UIControlEventValueChanged];
                if ([[NSUserDefaults standardUserDefaults] doubleForKey:@"ziti"] == 3){
                    
                    segment.selectedSegmentIndex = 2;
                }else if ([[NSUserDefaults standardUserDefaults] doubleForKey:@"ziti"] == 0){
                    segment.selectedSegmentIndex = 1;
                }else{
                    segment.selectedSegmentIndex = 0;
                }
                cell.accessoryView = segment;
            }
            break;
        }
        case 2:
        {
            if (indexPath.row == 0) {
                
                cell.textLabel.text = _Str(@"去好评");
            }else{
                
                cell.textLabel.text = _Str(@"反馈与意见");
            }
            break;
        }
            
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case 0:
        {  if (indexPath.row == 0) {
            [SKStoreReviewController requestReview];
            GSHistoryTableVC *likeVC = [[GSHistoryTableVC alloc]init];
            likeVC.isLikeHistory = YES;
            [self.navigationController pushViewController:likeVC animated:YES];
            
            } else {
                GSHistoryTableVC *likeVC = [[GSHistoryTableVC alloc]init];
                likeVC.isLikeHistory = NO;
                [self.navigationController pushViewController:likeVC animated:YES];
            }
            break;
        }
        case 1:
        {
            if (indexPath.row == 0) {
                if ([self filePathCache] != 0) {
                    
                    [self clearFile];
                }
            }
            break;
       }
        case 2:
        {
            if (indexPath.row == 0) {
                
                
                
                NSString *url = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1209480381&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8";
                
                // 实现跳转
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }else{
            
                GSAboutMeController *aboutMe = [[GSAboutMeController alloc]init];
                [self.navigationController pushViewController:aboutMe animated:YES];
                
            }
            break;
        }
}

}

#pragma mark : - 日夜模式
-(void)changeDayOrNightModel:(UISegmentedControl *)sender{

    if (sender.selectedSegmentIndex == 0) {
        
        if ([[NSUserDefaults standardUserDefaults] doubleForKey:@"ziti"] == 3) {
            
            [[NSUserDefaults standardUserDefaults] setDouble:-6 forKey:@"ziti"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"zitigushi" object:nil];
            [[NSUserDefaults standardUserDefaults] setDouble:-3 forKey:@"ziti"];
        }else if ([[NSUserDefaults standardUserDefaults] doubleForKey:@"ziti"] == 0){
            [[NSUserDefaults standardUserDefaults] setDouble:-3 forKey:@"ziti"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"zitigushi" object:nil];
        }
        
        
    }else if(sender.selectedSegmentIndex == 1){
        if ([[NSUserDefaults standardUserDefaults] doubleForKey:@"ziti"] == 3) {
            
            [[NSUserDefaults standardUserDefaults] setDouble:-3 forKey:@"ziti"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"zitigushi" object:nil];
            [[NSUserDefaults standardUserDefaults] setDouble:0 forKey:@"ziti"];
        }else if ([[NSUserDefaults standardUserDefaults] doubleForKey:@"ziti"] == -3){
            [[NSUserDefaults standardUserDefaults] setDouble:3 forKey:@"ziti"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"zitigushi" object:nil];
            [[NSUserDefaults standardUserDefaults] setDouble:0 forKey:@"ziti"];
        }
        
    }else{
        if ([[NSUserDefaults standardUserDefaults] doubleForKey:@"ziti"] == -3) {
            
            [[NSUserDefaults standardUserDefaults] setDouble:6 forKey:@"ziti"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"zitigushi" object:nil];
            [[NSUserDefaults standardUserDefaults] setDouble:3 forKey:@"ziti"];
        }else if ([[NSUserDefaults standardUserDefaults] doubleForKey:@"ziti"] == 0){
            [[NSUserDefaults standardUserDefaults] setDouble:3 forKey:@"ziti"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"zitigushi" object:nil];
           
        }
        
    
    }
    
}
// --------------------- 清理缓存 ------------------ //
// 显示缓存大小

- (float)filePathCache {
    
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    return [self folderSizeAtPath :cachPath];
    
}


// 1. 首先计算单个文件的大小

- (long long)fileSizeAtPath:(NSString *)filePath {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    
    return 0;
    
}


// 2.遍历文件获得文件大小,返回的单位是M

- (float)folderSizeAtPath:(NSString *)folderPath {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString *fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    return folderSize / (1024.0 * 1024.0);
}


// 清理缓存

- (void)clearFile {
    
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    
    // NSLog(@"cachPath = %@",cachPath);
    
    [files enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSError *error = nil;
        
        NSString *path = [cachPath stringByAppendingPathComponent:obj];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
        
    }];
    
    [self performSelectorOnMainThread:@selector(clearCachSuccess) withObject:nil waitUntilDone:YES];
    
}

// 清理成功

- (void)clearCachSuccess {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:_Str(@"提示") message:_Str(@"清理成功") preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:_Str(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableV reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}



@end
