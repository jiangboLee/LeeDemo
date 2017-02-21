//
//  GSMineController.m
//  gushici
//
//  Created by 李江波 on 2017/2/13.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSMineController.h"
#import "GSHistoryTableVC.h"

@interface GSMineController ()<UITableViewDelegate ,UITableViewDataSource>

@end

static NSString *cellID = @"cellID";
@implementation GSMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableV = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:tableV];
    
    tableV.delegate = self;
    tableV.dataSource = self;
    
    [tableV registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    
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
                
                cell.textLabel.text = @"我的收藏";
            }else{
            
                cell.textLabel.text = @"浏览记录";
            }
            break;
        }
        case 1:
        {
            if (indexPath.row == 0) {
                
                cell.textLabel.text = @"设置";
            }else{
                
                cell.textLabel.text = @"浏览记录";
            }
            break;
        }
        case 2:
        {
            if (indexPath.row == 0) {
                
                cell.textLabel.text = @"关于我们";
            }else{
                
                cell.textLabel.text = @"反馈与意见";
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
        default:
            break;
    }
}

- (IBAction)smallAction:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setDouble:-5 forKey:@"ziti"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"zitigushi" object:nil];
}
- (IBAction)middleAction:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setDouble:0 forKey:@"ziti"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"zitigushi" object:nil];
}
- (IBAction)bigAction:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setDouble:5 forKey:@"ziti"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"zitigushi" object:nil];
}



@end
