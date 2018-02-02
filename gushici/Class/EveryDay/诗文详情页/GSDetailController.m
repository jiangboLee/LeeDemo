//
//  GSDetailController.m
//  gushici
//
//  Created by 李江波 on 2017/2/13.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSDetailController.h"
#import "GSGushiContentModel.h"
#import "GSDetailContent.h"
#import <UShareUI/UShareUI.h>
#import <AVFoundation/AVFoundation.h>
#import "GSSQLiteTools.h"
#import <StoreKit/StoreKit.h>
#import "GSAuthorTableViewCell.h"

@interface GSDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic ,strong) UITableView *tableV;
@property(nonatomic ,strong) GSDetailContent *headerView;

// 存放cell视图展开状态的字典
@property (nonatomic, strong) NSMutableDictionary *cellIsShowAll;

@property(nonatomic ,copy) NSString *cont;

//播放器
@property(nonatomic,strong) AVPlayer *player;
//分享按钮
@property(nonatomic ,strong) UIBarButtonItem *share;

@property(nonatomic, strong) NSMutableArray *shiwenHeights;
@property(nonatomic, strong) NSMutableArray *shiwenLessHeights;
@property(nonatomic, assign) CGFloat lessHeight;

@end

static NSString *GSAuthorTableViewCellId = @"GSAuthorTableViewCellId";
@implementation GSDetailController

-(GSDetailContent *)headerView{

    if (_headerView == nil) {
        
        _headerView = [[[UINib nibWithNibName:@"GSDetailContent" bundle:nil] instantiateWithOwner:nil options:nil] lastObject];
        _headerView.mingju = self.mingju;
    }
    return _headerView;
}

-(UITableView *)tableV{

    if (_tableV == nil) {
        _tableV = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableV registerNib:[UINib nibWithNibName:@"GSAuthorTableViewCell" bundle:nil] forCellReuseIdentifier:GSAuthorTableViewCellId];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.tableFooterView = [[UIView alloc]init];
        [self.view addSubview:_tableV];
    }
    return _tableV;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.shiwenHeights = [NSMutableArray array];
    self.shiwenLessHeights = [NSMutableArray array];
    self.lessHeight = [UIFont fontWithName:_FontName size:_Font(20)].lineHeight + [UIFont fontWithName:_FontName size:_Font(18)].lineHeight * 5 + 16 + 15;
    self.cellIsShowAll = [NSMutableDictionary dictionary];
    
    _share = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_share"] style:UIBarButtonItemStyleDone target:self action:@selector(shareGushi)];
    
//    [self clickLike];
    GSGushiContentModel *model = self.dataArray[0];

    //查找数据库
        //@"SELECT * FROM t_likegushi WHERE gushiID = ?;", @(model.gushiID)
        [[GSSQLiteTools shared].queue inDatabase:^(FMDatabase *db) {
           
            FMResultSet *reult = [db executeQuery:@"SELECT * FROM t_likegushi WHERE gushiID = ?;", @(model == nil ? self.gushiID : model.gushiID)];
            if (reult.next) {
                
                UIBarButtonItem *unlike = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_share_highlighted"] style:UIBarButtonItemStyleDone target:self action:@selector(clickunLike)];
                self.navigationItem.rightBarButtonItems = @[_share,unlike];
            }else{
            
                UIBarButtonItem *like = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_like"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLike)];
                self.navigationItem.rightBarButtonItems = @[_share,like];
            }
        }];
     
    
}
//分享
- (void)shareGushi{

    //配置上面需求的参数
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = YES;
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.shareTitleViewTitleString = _Str(@"分享至");
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType =
    UMSocialSharePageGroupViewPositionType_Bottom;
//    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageMaxColumnCountForPortraitAndBottom = 2;i
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageMaxColumnCountForPortraitAndBottom = 3;
    [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.isShow = NO;
    //去掉毛玻璃效果
    [UMSocialShareUIConfig shareInstance].shareContainerConfig.isShareContainerHaveGradient = NO;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType,NSDictionary *userInfo) {
    
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc]init];
        //如果有缩略图，则设置缩略图
        shareObject.thumbImage = [UIImage imageNamed:@"AppIcon"];

        UIGraphicsBeginImageContextWithOptions(self.headerView.bounds.size, NO, 0);
        [self.headerView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [shareObject setShareImage:image];
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
//                NSLog(@"************Share fail with error %@*********",error);
            }else{
//                NSLog(@"response data is %@",data);
            }
        }];
    }];//打开分享面板
}
#pragma mark: - 收藏
- (void)clickLike{
    UIBarButtonItem *unlike = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_share_highlighted"] style:UIBarButtonItemStyleDone target:self action:@selector(clickunLike)];
    self.navigationItem.rightBarButtonItems = @[_share,unlike];
    
    GSGushiContentModel *model = self.dataArray[0];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    double time = [[NSDate date] timeIntervalSince1970];
    [[GSSQLiteTools shared].queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        BOOL isSuccess = [db executeUpdate:@"INSERT OR REPLACE INTO t_likegushi (gushiID, name, time) VALUES (?, ?, ?);", @(model.gushiID), data, @(time)];
        
        if (isSuccess) {
//            NSLog(@"插入成功");
            //好评
            if ([UIDevice currentDevice].systemVersion.doubleValue >= 10.3) {
                [SKStoreReviewController requestReview];
            }
            
        }else{
            
            *rollback = YES;
        }
    }];
    
}
-(void)clickunLike{
    
    UIBarButtonItem *like = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_like"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLike)];
    self.navigationItem.rightBarButtonItems = @[_share,like];
    
    //删除这个古诗
    GSGushiContentModel *model = self.dataArray[0];
    
    [[GSSQLiteTools shared].queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        BOOL isSuccess = [db executeUpdate:@"DELETE FROM t_likegushi WHERE gushiID = ?;", @(model.gushiID)];
        
        if (isSuccess) {
//            NSLog(@"删除成功");
        }else{
            
            *rollback = YES;
        }
    }];
}

//*****************************************************************//
//*****************************************************************//
-(void)setGushiID:(NSInteger)gushiID{

    _gushiID = gushiID;
    self.tableV.hidden = NO;
    [self loadData:gushiID];
}
-(void)loadData:(NSInteger)iid {
    
    [SVProgressHUD show];
    NSDictionary *parmeters = @{@"id":@(iid),@"token":@"gswapi",@"random":@(2672180210)};
    NSString *urlStr;
    if (self.isMingjuSearch) {
        
        urlStr = @"http://app.gushiwen.org/api/mingju/ju.aspx";
    }else{
    
        urlStr = @"http://app.gushiwen.org/api/shiwen/view.aspx";
    }
    //    __weak typeof(self) weakSelf = self;
    [[LEEHTTPManager share] request:GET UrlString:urlStr parameters:parmeters finshed:
     ^(NSDictionary *responseObject, NSError *error) {
         
         [SVProgressHUD dismiss];
         if (error != nil) {
             return ;
         }
         
         GSGushiContentModel *model = [GSGushiContentModel yy_modelWithDictionary:responseObject[@"tb_gushiwen"]];
         
         NSArray<GSGushiContentModel *> *fanyiArray = [NSArray yy_modelArrayWithClass:[GSGushiContentModel class] json:responseObject[@"tb_fanyis"][@"fanyis"]];
         
         NSArray<GSGushiContentModel *> *shangxiArray = [NSArray yy_modelArrayWithClass:[GSGushiContentModel class] json:responseObject[@"tb_shangxis"][@"shangxis"]];
         
         GSGushiContentModel *authorModel = [GSGushiContentModel yy_modelWithDictionary:responseObject[@"tb_author"]];
         //可能参数返回没有数据
         if (model.nameStr == nil) {
             return;
         }
         NSMutableArray *array = [NSMutableArray arrayWithObject:model];
         if (fanyiArray[0].nameStr != nil) {
             fanyiArray[0].cankao = @"fanyi";
             [array addObject:fanyiArray[0]];
             CGFloat fanyiHeight = [self getLableHeight:fanyiArray[0].cont];
             [self.shiwenHeights addObject:@(fanyiHeight)];
             fanyiHeight > self.lessHeight ? [self.shiwenLessHeights addObject:@(self.lessHeight)] : [self.shiwenLessHeights addObject:@(fanyiHeight + 10)];
         }
         if (shangxiArray[0].cont != nil) {
             shangxiArray[0].cankao = @"shangxi";
             [array addObject:shangxiArray[0]];
             CGFloat shangxiHeight = [self getLableHeight:shangxiArray[0].cont];
             [self.shiwenHeights addObject:@(shangxiHeight)];
             shangxiHeight > self.lessHeight ? [self.shiwenLessHeights addObject:@(self.lessHeight)] : [self.shiwenLessHeights addObject:@(shangxiHeight + 10)];
         }
         if (authorModel.nameStr != nil) {
             [array addObject:authorModel];
             CGFloat authorHeight = [self getLableHeight:authorModel.cont];
             [self.shiwenHeights addObject:@(authorHeight)];
             authorHeight > self.lessHeight ? [self.shiwenLessHeights addObject:@(self.lessHeight)] : [self.shiwenLessHeights addObject:@(authorHeight + 10)];
         }
         
         dispatch_async(dispatch_get_main_queue(), ^{
             self.dataArray = array;
             [self.tableV reloadData];
         });
         
     }];
}

- (CGFloat)getLableHeight:(NSString *)contentStr {
    
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"</strong><br />" withString:@": "];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"<strong>" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"</strong>" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"<span style=\"font-family:SimSun;\">" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"<br />" withString:@":"];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"<span style=\"font-family:FangSong_GB2312;\">" withString:@""];
    NSLog(@"%@",contentStr);
    
    CGRect rect = [UILabel getLableRect:contentStr Size:CGSizeMake(UISCREENW-30, 999999) Font:[UIFont fontWithName:_FontName size:_Font(18)] LineSpace:5 WordSpace:2];
    
    CGFloat wucha = rect.size.height / 200.0 * 3;
    return rect.size.height + [UIFont fontWithName:_FontName size:_Font(20)].lineHeight + 16 + wucha;
}

-(void)setDataArray:(NSArray *)dataArray{

    _dataArray = dataArray;
    
    __weak typeof(self) weakSelf = self;
    [self.headerView setHeightBlock:^(CGFloat x) {
        
        weakSelf.headerView.ljb_height = x ;
        weakSelf.tableV.tableHeaderView = weakSelf.headerView;
    }];
    self.headerView.gushi = dataArray[0];
    [self.headerView setVideoPlayBlock:^(videoPlayType type) {
       
        switch (type) {
            case videoPlayTypeFirst:
            {
                [weakSelf playWithUrl];
            }
                break;
            case videoPlayTypePause:
                [weakSelf.player pause];
                break;
            case videoPlayTypeGoOn:
                [weakSelf.player play];
                break;
                
            default:
                break;
        }
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return self.dataArray.count - 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

/** 2018-02-02 16:46:07
    static NSString *cellName = @"meTableViewCell";
    RemarksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[RemarksTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    GSGushiContentModel *model = [self.dataArray objectAtIndex:indexPath.row + 1];
    
    if (model.shiID) {
        cell.infolable.text = model.nameStr;
    }else{
    
        cell.infolable.text = @"作者";
    }
    
    NSLog(@"%@",model.nameStr);
    NSLog(@"%@",model.cont);
    
    [cell setCellContent:model.cont andIsShow:[[self.cellIsShowAll objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]] boolValue]  andCellIndexPath:indexPath];
    
    return cell;
*/
    GSAuthorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GSAuthorTableViewCellId forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row + 1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.needMoreButton.hidden = [self.shiwenLessHeights[indexPath.row] floatValue] < self.lessHeight;
    cell.needMoreButton.selected = [self.shiwenLessHeights[indexPath.row] floatValue] != self.lessHeight;
    __weak typeof(self) weakSelf = self;
    cell.lookMoreClickBlock = ^(BOOL more) {
        
        if (more) {
            weakSelf.shiwenLessHeights[indexPath.row] = @([self.shiwenHeights[indexPath.row] floatValue] + 20);
        } else {
            weakSelf.shiwenLessHeights[indexPath.row] = @(weakSelf.lessHeight);
        }
        [weakSelf.tableV beginUpdates];
        [weakSelf.tableV endUpdates];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回Cell高度
    return [self.shiwenLessHeights[indexPath.row] floatValue];
/** 2018-02-02 17:08:46
    GSGushiContentModel *model = [self.dataArray objectAtIndex:indexPath.row + 1];
    
    if (!model.isAreadlyRefresh && model.cankao != nil) {
        
        model.isAreadlyRefresh = YES;
        [self loadcont:model.gushiID type:model.cankao completed:^(NSString *cont) {
            
           cont = [cont stringByReplacingOccurrencesOfString:@"</strong><br />" withString:@": "];
            cont = [cont stringByReplacingOccurrencesOfString:@"<strong>" withString:@""];
            cont = [cont stringByReplacingOccurrencesOfString:@"</strong>" withString:@""];
            cont = [cont stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
            cont = [cont stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
            cont = [cont stringByReplacingOccurrencesOfString:@"<span style=\"font-family:FangSong_GB2312;\">" withString:@""];
            
            cont = [cont stringByReplacingOccurrencesOfString:@"<span style=\"font-family:SimSun;\">" withString:@""];
            
            model.cont = cont;
            
            [self.tableV reloadData];
         }];
       
    }
    
    return [RemarksCellHeightModel cellHeightWith:model.cont andIsShow:[[self.cellIsShowAll objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]] boolValue] andLableWidth:[UIScreen mainScreen].bounds.size.width-30 andFont:_Font(18) andDefaultHeight:72 andFixedHeight:45 andIsShowBtn:8];
*/
}

#pragma mark -- Dalegate
- (void)remarksCellShowContrntWithDic:(NSDictionary *)dic andCellIndexPath:(NSIndexPath *)indexPath
{
    [self.cellIsShowAll setObject:[dic objectForKey:@"isShow"] forKey:[NSString stringWithFormat:@"%@",[dic objectForKey:@"row"]]];
    
    [_tableV reloadData];
}

-(void)loadcont:(NSInteger)shiID type:(NSString *)typeStr completed:(void(^)(NSString *cont))completed{

    NSDictionary *parmeters = @{@"id":@(shiID),@"token":@"gswapi",@"random":@(2672180110)};
    NSString *urlStr = [NSString stringWithFormat:@"http://app.gushiwen.org/api/shiwen/%@.aspx",typeStr];//@"http://app.gushiwen.org/api/shiwen/%@.aspx";
//    __weak typeof(self) weakSelf = self;
    [[LEEHTTPManager share] request:GET UrlString:urlStr parameters:parmeters finshed:
     ^(NSDictionary *responseObject, NSError *error) {
         
         if (error != nil) {
             
             return ;
         }
         
         GSGushiContentModel *model = [GSGushiContentModel yy_modelWithDictionary:responseObject];
        
         completed(model.cont);
        
     }];

}

#pragma mark- 音乐播放相关
//播放音乐
-(void)playWithUrl
{
    GSGushiContentModel *model = self.dataArray[0];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://song.gushiwen.org/mp3/%@/%zd.mp3",model.langsongAuthorPY,model.gushiID]]];
    
    [self.player replaceCurrentItemWithPlayerItem:item];
    //监听音乐播放完成通知
    [self addNSNotificationForPlayMusicFinish];
    
    //开始播放
    [self.player play];
    
}
#pragma mark - NSNotification
-(void)addNSNotificationForPlayMusicFinish
{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
}
-(void)playFinished:(NSNotification*)notification
{
    self.headerView.videoBotton.selected = NO;
}

#pragma mark - 监听音乐各种状态

-(AVPlayer *)player
{
    if (_player == nil) {
        //初始化_player
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:@""]];
        _player = [[AVPlayer alloc] initWithPlayerItem:item];
    }
    
    return _player;
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [self.player pause];
    self.player = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    [self instertSql];
}
- (void)instertSql{

    GSGushiContentModel *model = self.dataArray[0];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    double time = [[NSDate date] timeIntervalSince1970];
    [[GSSQLiteTools shared].queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        BOOL isSuccess = [db executeUpdate:@"INSERT OR REPLACE INTO t_gushi (gushiID, name,time) VALUES (?, ?, ?);", @(model.gushiID), data,@(time)];
        
        if (isSuccess) {
//            NSLog(@"插入成功");
        }else{
        
            *rollback = YES;
        }
    }];
}
#pragma mark: - 3dTouch
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"收藏" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        [self clickLike];
    }];
//    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"action2" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//        NSLog(@"Action2");
//    }];
//    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"action3" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//        NSLog(@"Action3");
//    }];
    return @[action1];
}


@end
