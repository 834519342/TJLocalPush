//
//  ViewController.m
//  TJLocalPush
//
//  Created by 谭杰 on 2017/1/11.
//  Copyright © 2017年 谭杰. All rights reserved.
//

#import "ViewController.h"
#import "TJLocalPush.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"本地推送";
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn1.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    [btn1 setTitle:@"iOS9推送" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(iOS9Push:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.frame = CGRectMake(0, 60, self.view.frame.size.width, 40);
    [btn2 setTitle:@"iOS10推送" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(iOS10Push:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
}

- (void)iOS9Push:(UIButton *)btn
{
    TJNotificationModel *model = [[TJNotificationModel alloc] init];
    model.title = @"iOS9Push";
    model.body = @"iOS9PushMessage";
    model.timeInterval = 10;
    model.userInfo = @{@"a":@"a"};
    
    [TJLocalPush pushLocalNotificationModel:model NotificationInfo:^(BOOL success, UILocalNotification *localNotification) {
        
        NSLog(@"iOS9Push:error = %i",success);
    }];
}

- (void)iOS10Push:(UIButton *)btn
{
    TJNotificationModel *model = [[TJNotificationModel alloc] init];
    model.title = @"iOS10Push";
    model.body = @"iOS10PushMessage";
    model.timeInterval = 10;
    model.userInfo = @{@"b":@"b"};
//    model.categoryIdentifier = @"RequestIdentifier";
    
    [TJLocalPush pushLocalNotificationModel:model NotificationModel:^(TJNotificationModel *model) {
        if (model) {
            //清除响应
            [TJLocalPush removeNotificationCategories:model.categoryIdentifier withCompletionHandler:^(NSError *error) {
                NSLog(@"%@",error);
                [self addDefaultCategorys:model.categoryIdentifier];
            }];
        }
    } withCompletionHandler:^(NSError *error) {
        NSLog(@"iOS10Push:error = %@",error);
    }];
}

//添加响应
- (void)addDefaultCategorys:(NSString *)requestIdentifier
{
    // 设置响应
    UNNotificationAction * foregroundAction = [UNNotificationAction actionWithIdentifier:@"foregroundActionIdentifier" title:@"收到了" options:UNNotificationActionOptionForeground];
    
    // 设置文本响应
    UNTextInputNotificationAction * destructiveTextAction = [UNTextInputNotificationAction actionWithIdentifier:@"destructiveTextActionIdentifier" title:@"我想说两句" options:UNNotificationActionOptionDestructive|UNNotificationActionOptionForeground textInputButtonTitle:@"发送" textInputPlaceholder:@"想说什么?"];
    
    // 初始化策略对象,这里的categoryWithIdentifier一定要与需要使用Category的UNNotificationRequest的identifier匹配(相同)才可触发
    UNNotificationCategory * category = [UNNotificationCategory categoryWithIdentifier:requestIdentifier actions:@[foregroundAction,destructiveTextAction] intentIdentifiers:@[@"foregroundActionIdentifier",@"foregroundActionIdentifier"] options:UNNotificationCategoryOptionNone];
    
    //直接通过UNUserNotificationCenter设置策略即可
    [[TJLocalPush PushCenter] setNotificationCategories:[NSSet setWithObjects:category, nil]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
