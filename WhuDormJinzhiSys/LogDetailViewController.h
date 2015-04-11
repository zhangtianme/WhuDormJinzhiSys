//
//  LogDetailViewController.h
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/4/2.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogDetailViewController : UIViewController

@property (nonatomic, strong) NSString *details; // 需要显示的详情
@property (nonatomic, strong) NSString *accountType; // 查询的类型

@property (strong, nonatomic) IBOutlet UITextView *logDetailTextView;

@end
