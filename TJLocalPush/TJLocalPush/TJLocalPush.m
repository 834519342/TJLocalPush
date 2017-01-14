//
//  TJLocalPush.m
//  TJLocalPush
//
//  Created by 谭杰 on 2017/1/11.
//  Copyright © 2017年 谭杰. All rights reserved.
//

#import "TJLocalPush.h"

@implementation TJLocalPush
/*
 * iOS10及以上通知方法 ************************************************************
 */
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= IPHONE_10_0

//使用 UNUserNotificationCenter 来管理通知
+ (UNUserNotificationCenter *)PushCenter
{
    return [UNUserNotificationCenter currentNotificationCenter];
}

+ (void)registLocalNotificationWithDelegate:(id<UNUserNotificationCenterDelegate>)delegate withCompletionHandler:(void(^)(BOOL granted, NSError *error))completionHandler;
{
    if (delegate) {
        //监听回调事件
        [TJLocalPush PushCenter].delegate = delegate;
        
        //iOS10 使用以下注册方法，才能得到授权
        UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge;
        
        [[TJLocalPush PushCenter] requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            if (completionHandler) {
                completionHandler(granted, error);
            }
        }];
    }else {
        if (completionHandler) {
            completionHandler(NO, nil);
        }
    }
}

+ (void)pushLocalNotificationModel:(TJNotificationModel *)model withCompletionHandler:(void(^)(NSError *error))completionHandler;
{
    //创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是UNNotificationContent，此对象为不可变对象。
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    //推送标题
    if (model.title) {
        content.title = [NSString localizedUserNotificationStringForKey:model.title arguments:nil];
    }
    
    //推送内容
    if (model.body) {
        content.body = [NSString localizedUserNotificationStringForKey:model.body arguments:nil];
    }
    
    //详细内容
    if (model.subtitle) {
        content.subtitle = model.subtitle;
    }
    
    //附带信息
    if (model.userInfo) {
        content.userInfo = model.userInfo;
    }
    
    //附带媒体信息
    if (model.attachments) {
        content.attachments = model.attachments;
    }
    
    //启动图
    if (model.launchImageName) {
        content.launchImageName = model.launchImageName;
    }
    
    //推送声音
    if (model.sound) {
        content.sound = [UNNotificationSound soundNamed:model.sound];
    }else {
        content.sound = [UNNotificationSound defaultSound];
    }
    
    //设置拓展ID
    if (model.launchImageName) {
        content.launchImageName = model.launchImageName;
    }
    
    //应用角标+1
    content.badge = [NSNumber numberWithInt:model.badge];
    
    //在alertTime后推送本地通知,repeats:是否重复
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:model.timeInterval repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:(model.categoryIdentifier == nil ? model.title :model.categoryIdentifier) content:content trigger:trigger];
    
    ////如果是更新，先移除
    if (model.type == TJPushMessageTypeUpdate) {
        [[TJLocalPush PushCenter] removeDeliveredNotificationsWithIdentifiers:@[(model.categoryIdentifier == nil ? model.title :model.categoryIdentifier)]];
    }
    
    //添加推送成功后处理
    [[TJLocalPush PushCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(error);
        }
    }];
}

//获得推送设置
+ (void)getNotificationSettingsWithCompletionHandler:(void (^)(UNNotificationSettings *))completionHandler
{
    [[TJLocalPush PushCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (completionHandler) {
            completionHandler(settings);
        }
    }];
}

//默认的延时推送触发时机
+(UNTimeIntervalNotificationTrigger *)defaultTimeIntervalNotificationTrigger
{
    return [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:false];
}

// 默认的日历推送触发时机
+(UNCalendarNotificationTrigger *)defaultCalendarNotificationTrigger
{
    
    NSDateComponents * dateCompents = [NSDateComponents new];
    dateCompents.hour = 7;//表示每天的7点进行推送
    return [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateCompents repeats:true];
}

//该过程通过类别UNNotificationAttachment+RITLConceniceInitialize实现
/**
+(NSArray<UNNotificationAttachment *> *)defaultNotificationAttachmentsWithImage:(UIImage *)image
{
    if (image == nil) return nil;
    
    NSMutableArray <UNNotificationAttachment *> * attachments = [NSMutableArray arrayWithCapacity:1];
    
    //将image存到本地
    [RITLPushFilesManager saveImage:image key:imageTransformPathKey];
    
    NSError * error;
    
    UNNotificationAttachment * attachment = [UNNotificationAttachment attachmentWithIdentifier:attachmentIdentifier URL:[RITLPushFilesManager imageUrlPathWithKey:imageTransformPathKey] options:nil error:&error];
    
    NSAssert(error == nil, error.localizedDescription);
    
    [attachments addObject:attachment];
    
    return [attachments mutableCopy];
}
 */

//#endif
//endif ************************************************************




/*
 * iOS10以下通知方法 ************************************************************
 */
//#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_10_0

//注册本地通知
+ (BOOL)registLocalNotificationSuccess:(void(^)(BOOL success, NSError * error))success
{
    //如果已经获得发送通知的授权则创建本地通知，否则请求授权(注意：如果不请求授权在设置中是没有对应的通知设置项的，也就是说如果从来没有发送过请求，即使通过设置也打不开消息允许设置)
    if ([UIApplication sharedApplication].currentUserNotificationSettings.types == UIUserNotificationTypeNone) {
        
        UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        if (success) {
            success(YES,nil);
        }
        return YES;
    }
    if (success) {
        success(NO,nil);
    }
    return NO;
}

//添加本地通知
+ (void)pushLocalNotificationModel:(TJNotificationModel *)model NotificationInfo:(void(^)(BOOL success, UILocalNotification *localNotification))info;
{
    //推送对象
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {
        //定义本地通知对象
        //通知时间
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:model.timeInterval];
        //设置重复提示间隔
        notification.repeatInterval = REPEATINTERVAL;
        // 使用本地时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        //当前日历，使用前要设置好时区等信息，以便能够自动同步时间
        notification.repeatCalendar = [NSCalendar currentCalendar];
        
        //设置通知属性
        //推送标题
        if (model.title) {
            notification.alertTitle = model.title;
        }
        
        //消息内容
        if (model.body) {
            notification.alertBody = model.body;
        }
        
        //应用程序消息数++
        notification.applicationIconBadgeNumber += model.badge;
        
        //待机界面的滑动动作提示
//        notification.alertAction = @"打开应用";
        
        //通过点击通知打开应用时的启动图，这里使用程序启动图片
        if (model.launchImageName) {
            notification.alertLaunchImage = model.launchImageName;
        }
        
        //收到通知时播放的声音，默认消息声音
        if (model.sound) {
            notification.soundName = model.sound;
        }else {
            notification.soundName = UILocalNotificationDefaultSoundName;
        }
        
        //设置用户信息
        if (model.userInfo) {
            notification.userInfo = model.userInfo; //绑定到通知上的其他附加信息
        }
        
        //调用通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
        if (info) {
            info(YES,notification);
        }
    }else {
        info(NO,nil);
    }
    
}

//移除指定的本地通知
+ (void)removeLocalNotification:(UILocalNotification *)notification
{
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
    notification = nil;
}

//移除所有本地通知
+ (void)removeAllLocalNotification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

//#endif
//endif ************************************************************


@end
