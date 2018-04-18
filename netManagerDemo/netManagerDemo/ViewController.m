//
//  ViewController.m
//  netManagerDemo
//
//  Created by onlinei2 on 2018/4/18.
//  Copyright © 2018年 onlinei2. All rights reserved.
//

#import "ViewController.h"
#import "RequestManager.h"
#import <MBProgressHUD.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *bt_load = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt_load setTitle:@"load" forState:UIControlStateNormal];
    [bt_load setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    bt_load.frame = CGRectMake(200, 200, 50, 50);
    [bt_load addTarget:self action:@selector(clickLoad) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt_load];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)clickLoad{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RequestManager sharedManager] requestURL:@"http://app.howtocook.com.tw/user/info" parameters:@{@"author":@"0",@"category":@"Base,Follow,Exp"} completionHandler:^(BOOL isSuccess, int code, NSDictionary *resultDic) {
        if (isSuccess) {
            NSLog(@"result : %@",resultDic);
        }else{
            NSLog(@"failure : %@",resultDic);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


@end
