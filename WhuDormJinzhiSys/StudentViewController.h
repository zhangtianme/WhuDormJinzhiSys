//
//  StudentViewController.h
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/3/23.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentViewController : UITableViewController

@property (nonatomic, strong) NSDictionary *student; // 学生
@property (nonatomic, strong) NSString *roomDetail; // 房间信息

@property (weak, nonatomic) IBOutlet UILabel *stuIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *facultyLabel;
@property (weak, nonatomic) IBOutlet UILabel *professionaLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *controlLimitLabel;
@property (strong, nonatomic) IBOutlet UILabel *roomDetailLabel;


@end
