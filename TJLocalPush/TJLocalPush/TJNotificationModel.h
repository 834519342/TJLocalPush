//
//  TJNotificationModel.h
//  TJLocalPush
//
//  Created by 谭杰 on 2017/1/13.
//  Copyright © 2017年 谭杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

@interface TJNotificationModel : NSObject

//推送标题
@property (nonatomic, copy) NSString *title;

//推送内容
@property (nonatomic, copy) NSString *body;

//推送详细内容
@property (nonatomic, copy) NSString *subtitle;

//推送时间
@property (nonatomic, assign) int timeInterval;

//拓展ID
@property (nonatomic, copy) NSString *categoryIdentifier;

//启动图
@property (nonatomic, copy) NSString *launchImageName;

//推送声音
@property (nonatomic, copy) NSString *sound;

//通知数量
@property (nonatomic, assign) int badge;

//附带自定义信息
@property (nonatomic, copy) NSDictionary *userInfo;

//附带媒体信息
@property (nonatomic, copy) NSArray <UNNotificationAttachment *> *attachments;

@end
