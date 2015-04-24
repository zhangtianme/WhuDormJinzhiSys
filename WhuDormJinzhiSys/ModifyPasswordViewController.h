//
//  ModifyPasswordViewController.h
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/4/23.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyPasswordViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *modifyPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmModifyPasswordTextField;
@property (strong, nonatomic) IBOutlet UIButton *confirmModifyButton;

@end
