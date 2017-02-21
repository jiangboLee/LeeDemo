//
//  GSEveryDayViewController.m
//  gushici
//
//  Created by 李江波 on 2017/2/11.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSEveryDayViewController.h"
#import "CCDraggableContainer.h"
#import "GSGushiContentModel.h"
#import "GSCustomCardView.h"
#import "GSDetailController.h"


@interface GSEveryDayViewController ()<CCDraggableContainerDelegate,CCDraggableContainerDataSource>

@property (weak, nonatomic) IBOutlet CCDraggableContainer *container;

@property(nonatomic ,strong) NSMutableArray<GSGushiContentModel *> *contentModels;
@property(nonatomic ,strong) NSMutableArray *dataArrays;

@property(nonatomic ,assign) BOOL isReload;
@property(nonatomic ,assign) NSInteger count;
@property (weak, nonatomic) IBOutlet UIButton *clickChangeBotton;

@end

@implementation GSEveryDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentModels = [NSMutableArray array];
    self.dataArrays = [NSMutableArray array];
    
    //设置按钮下划线
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:@"换一波看看" attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),NSForegroundColorAttributeName : [UIColor redColor]}];
    [self.clickChangeBotton setAttributedTitle:attributedStr forState:UIControlStateNormal];
    
    self.count = 3;
    
    for (int i = 0; i <3; i++) {

        [self loadData];
    }
    [self showHudInView:self.view hint:@"~正在刷新~"];
}

-(void)loadData{
    
    
//    NSMutableArray *arrays = [NSMutableArray array];
    NSInteger iid = arc4random_uniform(50000);
    NSDictionary *parmeters = @{@"id":@(iid),@"token":@"gswapi",@"random":@(2672180210)};
    NSString *urlStr = @"http://app.gushiwen.org/api/shiwen/view.aspx";
    __weak typeof(self) weakSelf = self;
    [[LEEHTTPManager share] request:GET UrlString:urlStr parameters:parmeters finshed:
       ^(NSDictionary *responseObject, NSError *error) {
           
           if (error != nil) {
               [weakSelf hideHud];
               return ;
           }
           
           GSGushiContentModel *model = [GSGushiContentModel yy_modelWithDictionary:responseObject[@"tb_gushiwen"]];

           NSArray *fanyiArray = [NSArray yy_modelArrayWithClass:[GSGushiContentModel class] json:responseObject[@"tb_fanyis"][@"fanyis"]];
           
           NSArray *shangxiArray = [NSArray yy_modelArrayWithClass:[GSGushiContentModel class] json:responseObject[@"tb_shangxis"][@"shangxis"]];
           
           GSGushiContentModel *authorModel = [GSGushiContentModel yy_modelWithDictionary:responseObject[@"tb_author"]];
           //可能参数返回没有数据
           if (model.nameStr == nil) {
               self.count --;
               return;
           }
           NSMutableArray *array = [NSMutableArray arrayWithObject:model];
           if (((GSGushiContentModel *)(fanyiArray.firstObject)).nameStr != nil) {
               ((GSGushiContentModel *)(fanyiArray.firstObject)).cankao = @"fanyi";
               [array addObject:fanyiArray.firstObject];
           }
           if (((GSGushiContentModel *)(shangxiArray.firstObject)).cont != nil) {
               ((GSGushiContentModel *)(shangxiArray.firstObject)).cankao = @"shangxi";
               [array addObject:shangxiArray.firstObject];
           }
           if (authorModel.nameStr != nil) {
               
               [array addObject:authorModel];
           }

           
           [weakSelf.contentModels addObject:model];
           [weakSelf.dataArrays addObject:array];
           
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.contentModels.count == self.count) {
                [weakSelf hideHud];
                [weakSelf loadUI:0];
            }
                
            });
           
       }];
}

-(void)loadUI:(NSInteger)index{
    [self.container reloadDataWithIndex:index];
}

#pragma mark : - CCDraggableContainerDataSource
-(CCDraggableCardView *)draggableContainer:(CCDraggableContainer *)draggableContainer viewForIndex:(NSInteger)index{
    
    GSCustomCardView *cardView = [[GSCustomCardView alloc]initWithFrame:draggableContainer.bounds];
    [cardView installData:self.contentModels.copy[index]];
   
    return cardView;
}
-(NSInteger)numberOfIndexs{
    return self.contentModels.count;
}

#pragma mark : - CCDraggableContainerDelegate
-(void)draggableContainer:(CCDraggableContainer *)draggableContainer draggableDirection:(CCDraggableDirection)draggableDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio{

    
   
}

-(void)draggableContainer:(CCDraggableContainer *)draggableContainer cardView:(CCDraggableCardView *)cardView didSelectIndex:(NSInteger)didSelectIndex{
    
    GSDetailController *detailVc = [[GSDetailController alloc]init];
    
    detailVc.dataArray = self.dataArrays[didSelectIndex];
    [self.navigationController pushViewController:detailVc animated:YES];
}
-(void)draggableContainer:(CCDraggableContainer *)draggableContainer finishedDraggableLastCard:(BOOL)finishedDraggableLastCard{
    
     [self.container reloadDataWithIndex:0];
}

#pragma mark : - action
- (IBAction)reloadDataAction:(id)sender {
    [self.contentModels removeAllObjects];
    [self.dataArrays removeAllObjects];
    [self viewDidLoad];
    
}
- (IBAction)nextGushiAction:(id)sender {
    
    [self.container removeForDirection:CCDraggableDirectionRight];
    
}
- (IBAction)likeGushiAction:(id)sender {
    
    [self.container removeForDirection:CCDraggableDirectionLeft];
}


@end



















