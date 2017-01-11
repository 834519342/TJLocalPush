//
//  TJLocalPush.h
//  TJLocalPush
//
//  Created by 谭杰 on 2017/1/11.
//  Copyright © 2017年 谭杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

#define REPEATINTERVAL NSCalendarUnitMinute //间隔一分钟重复提示

@interface TJLocalPush : NSObject

/*
 * iOS10及以上通知方法 ************************************************************
 */
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= IPHONE_10_0

/** 获取通知中心权限
 *  @return 通知中心对象
 */
+ (UNUserNotificationCenter *)PushCenter;

/** 注册通知中心
 *  @param delegate 代理回调
 *  @param completionHandler 回调授权结果
 */
+ (void)registLocalNotificationWithDelegate:(id<UNUserNotificationCenterDelegate>)delegate withCompletionHandler:(void(^)(BOOL granted, NSError *error))completionHandler;

/** 发起推送
 *  @param title 推送标题
 *  @param body 推送内容
 *  @param sound 推送声音文件
 *  @param alertTime 推送时间
 *  @param completionHandler 结果
 */
+ (void)PushLocalNotificationTitle:(NSString *)title Body:(NSString *)body Sound:(NSString *)sound AlertTime:(NSInteger)alertTime withCompletionHandler:(void(^)(NSError *error))completionHandler;

/** 获取当前推送对象属性设置，只读，不能更改。
 */
+ (void)getNotificationSettingsWithCompletionHandler:(void(^)(UNNotificationSettings *settings))completionHandler;


#endif
//endif ************************************************************



/*
 * iOS10以下通知方法 ************************************************************
 */
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_10_0

/** 注册本地通知
 *  @param success 注册结果
 */
+ (BOOL)registLocalNotificationSuccess:(void(^)(BOOL success, NSError *error))success;


/** 添加本地通知
 *  @param message 推送内容
 *  @param info 添加结果
 */
+ (void)PushLocalNotificationMessage:(NSString *)message FireDate:(NSDate *)fireDate UserInfo:(NSDictionary *)userInfo NotificationInfo:(void(^)(BOOL success, UILocalNotification *localNotification))info;


/** 移除指定的本地通知
 */
+ (void)removeLocalNotification:(UILocalNotification *)sender;

/** 移除所有本地通知
 */
+ (void)removeAllLocalNotification;

#endif
//endif ************************************************************


@end
