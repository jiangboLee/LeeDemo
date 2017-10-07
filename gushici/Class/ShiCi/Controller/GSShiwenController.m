//
//  GSShiwenController.m
//  gushici
//
//  Created by 李江波 on 2017/2/14.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSShiwenController.h"
#import "GSGushiwenController.h"
#import "GSMingjuController.h"
#import "GSAuthorController.h"
#import "GSPickController.h"

@interface GSShiwenController ()<UIScrollViewDelegate,UIPopoverPresentationControllerDelegate>

@property(nonatomic ,weak) UIScrollView *scrollV;
@property(nonatomic ,weak) UIView *btnView;
@property(nonatomic ,weak) UIView *lineView;
@property(nonatomic ,weak) UIButton *preBotton;
@property(nonatomic ,assign) NSInteger tag;

@property(nonatomic ,strong) GSGushiwenController *gushiwenVC;
@property(nonatomic ,strong) GSMingjuController *mingjuVC;
@property(nonatomic ,strong) GSAuthorController *authorVC;
@end

@implementation GSShiwenController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationItem.title = _Str(@"诗文");
    [self setupUI];
    [self setNavBarbutton];


}

-(void)setNavBarbutton{

    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_icon_classify"] style:UIBarButtonItemStylePlain target:self action:@selector(clickPick:)];
    self.navigationItem.rightBarButtonItem = item;
    
}

-(void)clickPick:(UIBarButtonItem *)sender{

    GSPickController *nextVC = [GSPickController new];
    
    nextVC.tag = self.tag;
    //目的: 设置以popover的形式去弹出, 告诉指向谁
    
    //1. 模态视图的呈现样式
    nextVC.modalPresentationStyle = UIModalPresentationPopover;
    
    //2. 设置代理
    nextVC.popoverPresentationController.delegate = self;
    
    //3. 获取Popover控制器的 barButtonItem并设置即可
    nextVC.popoverPresentationController.barButtonItem = sender;
    
    //4. 以模态视图去弹出即可
    [self presentViewController:nextVC animated:YES completion:nil];
}

//设置popover的自适应效果 如果设置的是None, 就代表系统不会帮你做自适应, 所有iPad和iPhone效果是一致的
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    
    return UIModalPresentationNone;
}

-(void)setupUI{
    
    UIView *btnView = [[UIView alloc]init];
    btnView.backgroundColor = [UIColor cz_colorWithRed:220 green:220 blue:220];
    [self.view addSubview:btnView];
    
    UIButton *btn1 = [UIButton buttonWithType:0];
    [btn1 setTitle:_Str(@"诗文") forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont fontWithName:_FontName size:18];
    [btn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //8bdcfc
    [btn1 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    btn1.selected = YES;
    [btnView addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:0];
    [btn2 setTitle:_Str(@"名句") forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont fontWithName:_FontName size:18];
    [btn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btnView addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:0];
    [btn3 setTitle:_Str(@"作者") forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont fontWithName:_FontName size:18];
    [btn3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btnView addSubview:btn3];
    
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.height.offset(42);
    }];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.equalTo(self.view);
        make.height.offset(40);
        make.width.offset(UISCREENW / 3);
    }];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.equalTo(btn1);
        make.top.equalTo(btnView);
        make.left.equalTo(btn1.mas_right);
    }];
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.equalTo(btn2);
        make.top.equalTo(btnView);
        make.left.equalTo(btn2.mas_right);
    }];
    
    btn1.tag = 1;
    btn2.tag = 2;
    btn3.tag = 3;
    [btn1 addTarget:self action:@selector(ClickBotton:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(ClickBotton:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 addTarget:self action:@selector(ClickBotton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor redColor];
    [btnView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.offset(UISCREENW / 3 - 30);
        make.height.offset(2);
        make.bottom.equalTo(btnView);
        make.centerX.equalTo(btn1);
    }];
    

    UIScrollView *scrollV = [[UIScrollView alloc]init];
    [self.view addSubview:scrollV];
    
    scrollV.showsVerticalScrollIndicator = NO;
    scrollV.showsHorizontalScrollIndicator = NO;
    scrollV.pagingEnabled = YES;
    scrollV.bounces = NO;
    scrollV.delegate = self;
    
    [scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(btnView.mas_bottom);
    }];

    scrollV.contentSize = CGSizeMake(UISCREENW * 3, 0);
    
    
    _gushiwenVC = [[GSGushiwenController alloc]init];
    _mingjuVC = [[GSMingjuController alloc]init];
    _authorVC = [[GSAuthorController alloc]init];
    
    [scrollV addSubview:_gushiwenVC.view];
    [scrollV addSubview:_mingjuVC.view];
    [scrollV addSubview:_authorVC.view];
    
    [self addChildViewController:_gushiwenVC];
    [self addChildViewController:_mingjuVC];
    [self addChildViewController:_authorVC];

    [_gushiwenVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.bottom.equalTo(scrollV);
        make.width.offset(UISCREENW);
        make.height.offset(UISCREENH - 64 - 49);
        
    }];
    
    [_mingjuVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(scrollV);
        make.left.equalTo(_gushiwenVC.view.mas_right);
        make.size.equalTo(_gushiwenVC.view);
        
    }];
    
    [_authorVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(scrollV);
        make.left.equalTo(_mingjuVC.view.mas_right);
        make.size.equalTo(_gushiwenVC.view);
        make.right.equalTo(scrollV);
        make.bottom.equalTo(scrollV);
        
    }];
    
    self.scrollV = scrollV;
    self.btnView = btnView;
    self.lineView = lineView;
    [self ClickBotton:btn1];
    
}

-(void)ClickBotton:(UIButton *)btn{

    self.preBotton.selected = NO;
    self.preBotton = btn;
    
    btn.selected = YES;
    
    [UIView animateWithDuration:0.15 animations:^{
        
        self.lineView.ljb_centerX = btn.ljb_centerX;
    }];
    
    [self.scrollV setContentOffset:CGPointMake(UISCREENW * (btn.tag - 1), 0) animated:YES];
    
    self.tag = btn.tag;
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    CGFloat offset = scrollView.contentOffset.x;
    NSInteger page = offset / UISCREENW;
    
    UIButton *btn = [self.btnView viewWithTag:page + 1];
    
    [self ClickBotton:btn];
}


@end
