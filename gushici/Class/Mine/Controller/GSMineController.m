//
//  GSMineController.m
//  gushici
//
//  Created by 李江波 on 2017/2/13.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSMineController.h"

@interface GSMineController ()

@end

@implementation GSMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 300, 100)];
    lab.text = @"你么安安那你还发电费就不能";
    lab.font = [UIFont systemFontOfSize:_Font(15)];
    [self.view addSubview:lab];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
