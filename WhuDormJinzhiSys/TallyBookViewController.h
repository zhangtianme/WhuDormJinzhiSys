//
//  TallyBookViewController.h
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/3/24.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TallyBookViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) NSString *accountType; // 查询的类型


@end
