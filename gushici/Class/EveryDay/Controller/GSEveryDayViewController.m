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


@interface GSEveryDayViewController ()<CCDraggableContainerDelegate,CCDraggableContainerDataSource>

@property (weak, nonatomic) IBOutlet CCDraggableContainer *container;

@property(nonatomic ,strong) NSMutableArray<GSGushiContentModel *> *contentModels;

@property(nonatomic ,assign) BOOL isReload;

@end

@implementation GSEveryDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentModels = [NSMutableArray array];
    
    for (int i = 0; i <5; i++) {

        [self loadData];
    }

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
               
               return ;
           }
           
           GSGushiContentModel *model = [GSGushiContentModel yy_modelWithDictionary:responseObject[@"tb_gushiwen"]];
           //可能参数返回没有数据
           if (model.nameStr == nil) {
               return;
           }
           
           
           [weakSelf.contentModels addObject:model];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.contentModels.count == 5) {
                
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
}
-(void)draggableContainer:(CCDraggableContainer *)draggableContainer finishedDraggableLastCard:(BOOL)finishedDraggableLastCard{
    
     [self.container reloadDataWithIndex:0];
}

#pragma mark : - action
- (IBAction)reloadDataAction:(id)sender {
    [self.contentModels removeAllObjects];
    [self viewDidLoad];
    
}
- (IBAction)nextGushiAction:(id)sender {
    
    [self.container removeForDirection:CCDraggableDirectionRight];
    
}
- (IBAction)likeGushiAction:(id)sender {
    
    [self.container removeForDirection:CCDraggableDirectionLeft];
}


@end




















