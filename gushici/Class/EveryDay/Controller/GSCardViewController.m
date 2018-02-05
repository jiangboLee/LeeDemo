//
//  GSCardViewController.m
//  gushici
//
//  Created by ljb48229 on 2018/2/5.
//  Copyright © 2018年 lijiangbo. All rights reserved.
//

#import "GSCardViewController.h"
#import "GSDetailController.h"

@interface GSCardViewController ()<UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *clickChangeBotton;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *authorLable;
@property (weak, nonatomic) IBOutlet UITextView *cont1;
@end

@implementation GSCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.delegate = self;
    [self setupUI];
}

- (void)setupUI {
    
    [UITextView changeLineSpaceForLabel:self.cont1 WithSpace:10];
    [_cont1 layoutIfNeeded];
    _cont1.layoutManager.allowsNonContiguousLayout = false;
    [_cont1 scrollRangeToVisible:NSMakeRange(0, 1)];
    
    self.titleLable.font = [UIFont fontWithName:_FontName size:_Font(28)];
    self.authorLable.font = [UIFont fontWithName:_FontName size:_Font(16)];
    self.cont1.font = [UIFont fontWithName:_FontName size:_Font(20)];
    [self setModel];
    //设置按钮下划线
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:_Str(@"换一波看看") attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),NSForegroundColorAttributeName : [UIColor redColor]}];
    [self.clickChangeBotton setAttributedTitle:attributedStr forState:UIControlStateNormal];
}

- (void)setModel{
    
    //标题处理
    self.titleLable.text = self.model.nameStr;
    self.authorLable.text = [NSString stringWithFormat:@"作者: %@",self.model.author];
    //内容处理
    //    [self.cont1 setContentOffset:CGPointZero animated:NO];
    NSString *cont0 = [self.model.cont stringByReplacingOccurrencesOfString:@"\n\n" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"\n<br />\n" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"。" withString:@"。\n"];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"." withString:@"。\n"];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"¤" withString:@"。"];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"<span style=\"font-family:SimSun;\">" withString:@""];
    self.cont1.text = cont0;
}

- (IBAction)reloadGushiAction:(id)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:RELOADGUSHINotificationName object:nil];
}

- (IBAction)handleAction:(UITapGestureRecognizer *)sender {
    
    GSDetailController *detailVc = [[GSDetailController alloc] init];
    detailVc.responseObject = self.dataDic;
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    return  nil;
}

@end









