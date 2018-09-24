//
//  GSClickSearchViewController.m
//  gushici
//
//  Created by 李江波 on 2017/2/18.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSClickSearchViewController.h"

#import "GSSearchGushiController.h"

@interface GSClickSearchViewController ()<UIScrollViewDelegate>

@property(nonatomic ,strong) GSSearchGushiController *gushiwenVC;
@property(nonatomic ,strong) GSSearchGushiController *authorVC;

@property(nonatomic ,weak) UIScrollView *scrollV;
@property(nonatomic ,weak) UIView *btnView;
@property(nonatomic ,weak) UIView *lineView;
@property(nonatomic ,weak) UIButton *preBotton;
@property(nonatomic ,assign) NSInteger tag;

@end

@implementation GSClickSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}
-(void)setupUI{

    UIView *btnView = [[UIView alloc]init];
    btnView.backgroundColor = [UIColor cz_colorWithRed:220 green:220 blue:220];
    [self.view addSubview:btnView];
    
    UIButton *btn1 = [UIButton buttonWithType:0];
    [btn1 setTitle:@"作者" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont fontWithName:_FontName size:18];
    [btn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //8bdcfc
    [btn1 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    btn1.selected = YES;
    [btnView addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:0];
    [btn2 setTitle:@"诗文" forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont fontWithName:_FontName size:18];
    [btn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btnView addSubview:btn2];
    
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
        make.right.equalTo(btnView);
    }];
    
    btn1.tag = 1;
    btn2.tag = 2;
    [btn1 addTarget:self action:@selector(ClickBotton:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(ClickBotton:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    scrollV.contentSize = CGSizeMake(UISCREENW * 2, 0);
    
    _gushiwenVC = [[GSSearchGushiController alloc]init];
    _gushiwenVC.searchStr = self.searchStr;
    _gushiwenVC.type = @"author";
    _authorVC = [[GSSearchGushiController alloc]init];
    _authorVC.searchStr = self.searchStr;
    _authorVC.type = @"title";
    [scrollV addSubview:_gushiwenVC.view];
    [scrollV addSubview:_authorVC.view];
    
    [self addChildViewController:_gushiwenVC];
    [self addChildViewController:_authorVC];
    
    [_gushiwenVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.equalTo(scrollV);
        make.width.offset(UISCREENW);
        make.height.offset(UISCREENH - 64 - 49);
        
    }];
    [_authorVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(scrollV);
        make.left.equalTo(self.gushiwenVC.view.mas_right);
        make.size.equalTo(self.gushiwenVC.view);
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
