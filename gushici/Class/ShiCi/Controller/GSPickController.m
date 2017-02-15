//
//  GSPickController.m
//  gushici
//
//  Created by 李江波 on 2017/2/15.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSPickController.h"
#import "LEECellModel.h"
#import "ThreeTableView.h"

@interface GSPickController ()<UITableViewDelegate ,UITableViewDataSource>

@property(nonatomic ,weak) UITableView *tableV1;
@property(nonatomic ,strong) NSArray *caodaiArray;
@property(nonatomic ,strong) NSArray *themeArray;
@property(nonatomic ,strong) NSMutableArray<LEECellModel *> *tempArray;

@property(nonatomic ,strong) NSArray *gushitypeArray;
@property(nonatomic ,strong) NSArray *formArray;

@end

static NSString *table1CellID = @"table1CellID";
@implementation GSPickController

-(NSArray *)caodaiArray{

    if (nil == _caodaiArray) {
        
        NSString *pathFile = [[NSBundle mainBundle] pathForResource:@"chaodai.plist" ofType:nil];
        
        _caodaiArray = [NSArray arrayWithContentsOfFile:pathFile];
    }
    return _caodaiArray;
}

-(NSArray *)themeArray{

    if (nil == _themeArray) {
        
        NSString *pathFile = [[NSBundle mainBundle] pathForResource:@"mingjuTheme.plist" ofType:nil];
        
        _themeArray = [NSArray arrayWithContentsOfFile:pathFile];
        
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSDictionary *dic in _themeArray) {
            
            LEECellModel *model = [[LEECellModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [arrayM addObject:model];
        }
        _themeArray = arrayM.copy;
        
    }
    return _themeArray;
}
-(NSArray *)gushitypeArray{
    
    if (nil == _gushitypeArray) {
        
        NSString *pathFile = [[NSBundle mainBundle] pathForResource:@"Gushitype.plist" ofType:nil];
        
        _gushitypeArray = [NSArray arrayWithContentsOfFile:pathFile];
    }
    return _gushitypeArray;
}
-(NSArray *)formArray{
    
    if (nil == _formArray) {
        
        NSString *pathFile = [[NSBundle mainBundle] pathForResource:@"form.plist" ofType:nil];
        
        _formArray = [NSArray arrayWithContentsOfFile:pathFile];
    }
    return _formArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.tag) {
        case 1:
            [self setThreeTable];
            self.preferredContentSize = CGSizeMake(300, 450);
            break;
        case 2:
            [self setupUI];
            [self createTempData];
            self.preferredContentSize = CGSizeMake(150, self.tempArray.count * 44);
            break;
        case 3:
            [self setupUI];
            self.preferredContentSize = CGSizeMake(150, self.caodaiArray.count * 44);
            break;
        default:
            break;
    }
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissVC) name:TRUECLICKNotificationName object:nil];
}
-(void)dismissVC{

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setupUI{

    UITableView *tableV1 = [[UITableView alloc]initWithFrame:self.view.bounds];
    tableV1.dataSource = self;
    tableV1.delegate = self;
    
    [tableV1 registerClass:[UITableViewCell class] forCellReuseIdentifier:table1CellID];
    
    tableV1.tableFooterView = [[UIView alloc]init];
    
    [self.view addSubview:tableV1];
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 44 * 3)];
    
    tableV1.tableFooterView = v;
    self.tableV1 = tableV1;
}
#pragma mark - 初始化数据源方法
-(void)createTempData{
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i<self.themeArray.count; i++) {
        
        LEECellModel *model = [self.themeArray objectAtIndex:i];
        
        if (model.expand) {
            
            [tempArray addObject:model];
        }
    }
    
    _tempArray = tempArray;
}

#pragma mark : - 3个tableview
-(void)setThreeTable{

    ThreeTableView *threeTableV = [[[UINib nibWithNibName:@"ThreeTableView" bundle:nil] instantiateWithOwner:nil options:nil] lastObject];
    
    threeTableV.frame = self.view.bounds;
    threeTableV.table1Array = self.gushitypeArray;
    threeTableV.table2Array = self.caodaiArray;
    threeTableV.table3Array = self.formArray;
    
    [self.view addSubview:threeTableV];
    
}

#pragma mark : - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    switch (self.tag) {
        case 1:
            return 1;
        case 2:
            return self.tempArray.count;
            break;
        case 3:
            return self.caodaiArray.count;
            break;
        default:
            return 0;
    }
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (self.tag) {
        case 1:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:table1CellID forIndexPath:indexPath];
            
            return cell;
            break;
        }
        case 2:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:table1CellID forIndexPath:indexPath];
            LEECellModel *model = self.tempArray[indexPath.row];
            
            cell.indentationLevel = model.depth;
            cell.indentationWidth = 30;
            
            cell.textLabel.text = model.name;
            
            return cell;
            break;
        }
        case 3:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:table1CellID forIndexPath:indexPath];
        
            cell.textLabel.text = self.caodaiArray[indexPath.row];
            return cell;
            break;
        }
        default:
            return nil;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LEECellModel *fatherModel = [_tempArray objectAtIndex:indexPath.row];
    
    NSInteger startPosition = indexPath.row + 1;
    NSInteger endPosition = startPosition;
    BOOL expand = NO;
    for (int i = 0; i<_themeArray.count; i++) {
        
        LEECellModel *model = [_themeArray objectAtIndex:i];
        if (model.fatherID == fatherModel.nodeID) {
            
            model.expand = !model.expand;
            
            if (model.expand) {
                
                [_tempArray insertObject:model atIndex:endPosition];
                expand = YES;
                endPosition ++;
                
            }else{
                expand = NO;
                endPosition = [self removeAllModelAtFatherModel:fatherModel];
                break;
            }
        }
    }
    
    //获得需要修正的indexPath
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (NSUInteger i = startPosition; i < endPosition; i++) {
        
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        [indexPathArray addObject:tempIndexPath];
    }
    
    //刷新加入或删除的节点
    if(expand){
        
        [self.tableV1 insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
    }else{
        
        [self.tableV1 deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationRight];
    }
    
}


/**
 删除该父节点下的所有子节点（包括孙子节点）
 
 @param fatherModel 父模型
 
 @return 该父节点下一个相邻的统一级别的节点的位置
 */
-(NSInteger)removeAllModelAtFatherModel:(LEECellModel *)fatherModel{
    
    NSInteger startPosition = [_tempArray indexOfObject:fatherModel];
    NSInteger endPosition = startPosition;
    
    for (NSInteger i = startPosition + 1; i < _tempArray.count; i++) {
        
        LEECellModel *model =[_tempArray objectAtIndex:i];
        endPosition ++;
        if (model.depth <= fatherModel.depth) {
            break;
        }
        if (endPosition == _tempArray.count - 1) {
            endPosition ++;
            model.expand = NO;
            break;
        }
        model.expand = NO;
    }
    if (endPosition > startPosition) {
        
        [_tempArray removeObjectsInRange:NSMakeRange(startPosition + 1, endPosition - startPosition -1)];
    }
    
    return endPosition ;
}





@end
