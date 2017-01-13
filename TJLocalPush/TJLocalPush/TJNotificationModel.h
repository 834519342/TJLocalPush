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

//19:共同参数，10:iOS的参数，9:iOS9的参数

//推送标题 19
@property (nonatomic, copy) NSString *title;

//推送内容 19
@property (nonatomic, copy) NSString *body;

//推送详细内容 10
@property (nonatomic, copy) NSString *subtitle;

//附带自定义信息 19
@property (nonatomic, copy) NSDictionary *userInfo;

//附带媒体信息 10
@property (nonatomic, copy) NSArray <UNNotificationAttachment *> *attachments;

//启动图 19
@property (nonatomic, copy) NSString *launchImageName;

//推送声音 19
@property (nonatomic, copy) NSString *sound;

//拓展ID 10
@property (nonatomic, copy) NSString *categoryIdentifier;

//通知数量 19
@property (nonatomic, assign) int badge;

//推送时间 19
@property (nonatomic, assign) int timeInterval;

@end
