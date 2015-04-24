//
//  ModifyPhoneViewController.h
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/4/23.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyPhoneViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *userIDLabel;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (strong, nonatomic) IBOutlet UIButton *confirmModifyButton;

@end
