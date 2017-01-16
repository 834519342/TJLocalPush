//
//  AppDelegate.m
//  TJLocalPush
//
//  Created by 谭杰 on 2017/1/11.
//  Copyright © 2017年 谭杰. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#import "TJLocalPush.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    
    [TJLocalPush registLocalNotificationWithDelegate:self withCompletionHandler:^(BOOL granted, NSError *error) {
        
        NSLog(@"iOS10:granted:%i error:%@",granted,error);
    }];

//    [TJLocalPush registLocalNotificationSuccess:^(BOOL success, NSError *error) {
//        
//        NSLog(@"iOS9:success:%i",success);
//    }];


    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    NSLog(@"iOS9Push注册成功");
}

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"iOS9Push:%@",notification.alertBody);
    
    [TJLocalPush removeLocalNotification:notification];
}


#pragma mark - UNUserNotificationCenterDelegate
//前台即将显示推送
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler __IOS_AVAILABLE(10.0) __TVOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0)
{
    //1. 处理通知
    
    //2. 处理完成后条用 completionHandler ，用于指示在前台显示通知的形式
    completionHandler(UNNotificationPresentationOptionBadge |
                      UNNotificationPresentationOptionSound |
                      UNNotificationPresentationOptionAlert);
}

//后台推送点击通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler __IOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0) __TVOS_PROHIBITED
{
    if ([response.actionIdentifier isEqualToString:@"foregroundActionIdentifier"])
    {
        //可以弹出Alert提示一下
        [self performSelector:NSSelectorFromString(@"__showAlert:") withObject:@"我是第一个策略动作,收到了" afterDelay:0];
        
        completionHandler();return;
    }
    
    else if([response.actionIdentifier isEqualToString:@"destructiveTextActionIdentifier"])
    {
        [self performSelector:NSSelectorFromString(@"__showAlert:") withObject:[NSString stringWithFormat:@"我是第二个文本动作，我输入的文字是:%@",((UNTextInputNotificationResponse *)response).userText] afterDelay:0];
        
        completionHandler();return;
    }
    
    completionHandler(UNNotificationPresentationOptionBadge |
                      UNNotificationPresentationOptionSound |
                      UNNotificationPresentationOptionAlert);
    NSLog(@"iOS10及以上版本推送");
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//进入前台清除消息数
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//进入前台清除消息数
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
