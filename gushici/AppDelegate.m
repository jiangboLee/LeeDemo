//
//  AppDelegate.m
//  gushici
//
//  Created by 李江波 on 2017/2/11.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "AppDelegate.h"

#import "UMMobClick/MobClick.h"
#import <UMSocialCore/UMSocialCore.h>

#import <CoreSpotlight/CoreSpotlight.h>
#import "GSDetailController.h"
#import "GSTabBarController.h"

@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
//    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = @"58a70c0d65b6d647cb001209";
    UMConfigInstance.channelId = @"App Store";
//    UMConfigInstance.eSType = E_UM_GAME; //仅适用于游戏场景，应用统计不用设置

    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    /* 打开调试日志 */
//    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"58a70c0d65b6d647cb001209"];
    
    [self configUSharePlatforms];
    
    
    UITabBarController *tabBarVc = (UITabBarController *)self.window.rootViewController;
    tabBarVc.delegate = self;
    
    //3d touch
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        
        //        [self creatShortcutItem];
        
        UIApplicationShortcutItem *shortcutItem = [launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];
        if (shortcutItem) {
            
            if ([shortcutItem.type isEqualToString:@"cn.lijiangbo.gushici.search"]) {
                
                tabBarVc.selectedIndex = 2;
            } else if ([shortcutItem.type isEqualToString:@"cn.lijiangbo.gushici.one"]) {
                
                UINavigationController *nav = tabBarVc.childViewControllers[0];
                GSDetailController *detailVC = [[GSDetailController alloc]init];
                detailVC.gushiID = arc4random_uniform(2000);
                [nav pushViewController:detailVC animated:YES];
            }
            
            return NO;
        }
    }

 
    return YES;
}

#pragma mark: - 3dTouch
- (void)creatShortcutItem {
    
    UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare];
    UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc] initWithType:@"cn.lijiangbo.gushici.share" localizedTitle:@"分享"localizedSubtitle:nil icon:icon userInfo:nil];
    
    [UIApplication sharedApplication].shortcutItems = @[item];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    if (shortcutItem) {
        UIViewController *viewController = [self topViewController];
        [viewController.navigationController popToRootViewControllerAnimated:NO];
        UITabBarController *tabBarVc = (UITabBarController *)self.window.rootViewController;
        if ([shortcutItem.type isEqualToString:@"cn.lijiangbo.gushici.one"]) {
            
            tabBarVc.selectedIndex = 0;
            UINavigationController *nav = tabBarVc.childViewControllers[0];
            GSDetailController *detailVC = [[GSDetailController alloc]init];
            detailVC.gushiID = arc4random() % 2000;
            [nav pushViewController:detailVC animated:YES];
        } else if ([shortcutItem.type isEqualToString:@"cn.lijiangbo.gushici.search"]) {
            
            tabBarVc.selectedIndex = 2;
        }
    }
    if (completionHandler) {
        completionHandler(YES);
    }
}
#endif

- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx3972b7c0887ba811" appSecret:@"67a3e332cb85421702a1fb52d8566629" redirectURL:@"http://www.gushiwen.org"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
//    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105999102"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://www.gushiwen.org"];
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"2719477129"  appSecret:@"45b226984dfece64dbb73ef10dfda206" redirectURL:@"https://www.baidu.com"];
    
}
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray * __nullable restorableObjects))restorationHandler {
    
    if ([userActivity.activityType isEqualToString: CSSearchableItemActionType]) {
        NSString *identifier = userActivity.userInfo[CSSearchableItemActivityIdentifier];
        
        if (identifier) {
            
            UIViewController *topVc = [self topViewController];
            
            GSDetailController *detailVC = [[GSDetailController alloc]init];
            detailVC.gushiID = identifier.integerValue;
            [topVc.navigationController pushViewController:detailVC animated:YES];
            
            //            [topVc.navigationController pushViewController:[[UIViewController alloc] init] animated:NO];
            //            NSLog(@"%@",identifier);
            return true;
        }
    }
    return false;
}

#pragma mark: - 寻找最上乘控制器
- (UIViewController *)topViewController {
    
    UIViewController *resultVC;
    resultVC = [self topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}
- (UIViewController *)topViewController:(UIViewController *)vc {
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [(UINavigationController *)vc topViewController];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self topViewController:[(UITabBarController*)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

#pragma mark : - 双击刷新
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(nonnull UIViewController *)viewController {

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"doubleClickDidSelectedNotification" object:nil];
}


@end
