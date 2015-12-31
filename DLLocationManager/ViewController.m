//
//  ViewController.m
//  DLLocationManager
//
//  Created by Jone on 15/12/31.
//  Copyright © 2015年 Jone. All rights reserved.
//

#import "ViewController.h"
#import "DLLocationManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[DLLocationManager managerLocation] locateSuccess:^(DLLocation *location) {
        NSLog(@"省：%@ 市：%@ 县：%@", location.province, location.city, location.district);
    } error:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
    }];
}

@end
