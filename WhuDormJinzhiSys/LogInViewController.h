//
//  LogInViewController.h
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/4/7.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogInViewController : UIViewController

@property (strong, nonatomic) UITextField *accountTextField;  // 账号
@property (strong, nonatomic) UITextField *passwordTextField; // 密码
@property (strong, nonatomic) UIButton *logInButton;          // 登录

@property (strong, nonatomic) UIImageView *headIconImage;       // 标题图标

@property (strong, nonatomic) UIImageView *buttomIconImage;    // 底部图标
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end