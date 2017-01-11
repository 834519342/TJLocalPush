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
    self.title = @"本地推送";
    
    [TJLocalPush PushLocalNotificationTitle:@"zxy" Body:@"zzxxyy" Sound:nil AlertTime:10 withCompletionHandler:^(NSError *error) {
        
        NSLog(@"error:%@",error);
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
