//
//  ModifyPasswordViewController.m
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/4/23.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "MacroDefinition.h"

@interface ModifyPasswordViewController () {
    AccountManager *accountManager;
    MBProgressHUD *mbHud;
}

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    accountManager = [AccountManager sharedAccountManager];
    
    self.tableView.backgroundColor = lightBlueColor;
    self.navigationItem.title      = @"修改密码";
    self.tableView.scrollEnabled   = NO;
//    _userIDLabel.text  = accountManager˜.userID;
    
    // 初始化
    CGFloat widthZoom         = self.view.frame.size.width/320;// 缩放比例
    // textfield 字体大小
    CGFloat textFieldFontSize = 16.0;
    // textfield 左边偏移量
    CGFloat textFieldOffset   = 8;
    
    
    // 旧手机号
    _oldPasswordTextField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];// 白色 0.2透明
    [_oldPasswordTextField setBorderStyle:UITextBorderStyleNone]; // 无框
    _oldPasswordTextField.font            = [UIFont systemFontOfSize:textFieldFontSize];
    _oldPasswordTextField.placeholder     = @"请输入旧密码";
    _oldPasswordTextField.secureTextEntry = YES;// 密码模式
    _oldPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIImageView *imageView1                = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, textFieldOffset, 20)];// 左部偏移量
    _oldPasswordTextField.leftView        = imageView1;
    _oldPasswordTextField.leftViewMode    = UITextFieldViewModeAlways;

    // 新手机号
    _modifyPasswordTextField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];// 白色 0.2透明
    [_modifyPasswordTextField setBorderStyle:UITextBorderStyleNone]; // 无框
    _modifyPasswordTextField.font            = [UIFont systemFontOfSize:textFieldFontSize];
    _modifyPasswordTextField.placeholder     = @"请输入新密码";
    _modifyPasswordTextField.secureTextEntry = YES;// 密码模式
    _modifyPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIImageView *imageView2                = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, textFieldOffset, 20)];// 左部偏移量
    _modifyPasswordTextField.leftView        = imageView2;
    _modifyPasswordTextField.leftViewMode    = UITextFieldViewModeAlways;

    // 确认新手机号
    _confirmModifyPasswordTextField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];// 白色 0.2透明
    [_confirmModifyPasswordTextField setBorderStyle:UITextBorderStyleNone]; // 无框
    _confirmModifyPasswordTextField.font            = [UIFont systemFontOfSize:textFieldFontSize];
    _confirmModifyPasswordTextField.placeholder     = @"确认新密码";
    _confirmModifyPasswordTextField.secureTextEntry = YES;// 密码模式
    _confirmModifyPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIImageView *imageView3                = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, textFieldOffset, 20)];// 左部偏移量
    _confirmModifyPasswordTextField.leftView        = imageView3;
    _confirmModifyPasswordTextField.leftViewMode    = UITextFieldViewModeAlways;
    
    _confirmModifyButton.backgroundColor = mainBlueColor;
    [_confirmModifyButton setTitle:@"确认修改" forState:UIControlStateNormal];
    [_confirmModifyButton addTarget:self action:@selector(didClickConfirmModifyButton:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!mbHud) {  // 初始化指示器
        mbHud = [[MBProgressHUD alloc] initWithView:self.view];
        
        [self.view addSubview:mbHud];
        mbHud.dimBackground = YES;
    }
}
- (void)requestTimeout:(UISwitch *)sender
{
    // 没有收到数据 显示错误指示2秒钟
    [mbHud showWithTitle:@"错误" detail:@"请求失败，请确认网络连接状态是否正常"];
    [mbHud hide:YES afterDelay:1];
}
- (void)didClickConfirmModifyButton:(UIButton *)sender {
    NSLog(@"click modify");
    [self dismissKeyboard];
    BOOL isOldPassowrdCorrect = NO; // 旧密码是否正确
    NSLog(@"old password:%@",accountManager.password);
    isOldPassowrdCorrect = [accountManager.password isEqualToString:_oldPasswordTextField.text];
    if (!isOldPassowrdCorrect) { // 旧密码不对
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"旧密码输入错误!" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    BOOL isPassowrdMatch = NO; // 俩次新密码是否一致
    isPassowrdMatch = [_modifyPasswordTextField.text isEqualToString:_confirmModifyPasswordTextField.text];
    if (!isPassowrdMatch) { // 俩次新密码不一致
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"新密码输入不匹配!" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if ([_modifyPasswordTextField.text isEqualToString:@""]) { // 如果为空
        UIAlertController *alertController1 = [UIAlertController alertControllerWithTitle:@"密码不能为空!" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController1 addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController1 animated:YES completion:nil];
        return;
    }
    
    __block BOOL isSuccess = NO;  // 修改是否成功
    [mbHud showWithTitle:@"修改密码..." detail:nil];
    [self performSelector:@selector(requestTimeout:) withObject:nil afterDelay:timeoutRequest];// 5秒的超时
    // 异步线程调用接口
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        isSuccess = [accountManager modifyPasswordWithUserID:accountManager.userID curPassword:_oldPasswordTextField.text updatePassword:_modifyPasswordTextField.text role:accountManager.role];
        // 返回主线程 处理结果
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (isSuccess) { // 修改手机号成功
                [mbHud showWithTitle:@"修改密码成功" detail:nil];
                [mbHud hide:YES afterDelay:0.5];
                [NSObject cancelPreviousPerformRequestsWithTarget:self]; // 取消前面的定时函数
                // 页面跳转 延迟1.5秒
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } else { // 修改密码失败
                [NSObject cancelPreviousPerformRequestsWithTarget:self]; // 取消前面的定时函数
                [mbHud showWithTitle:@"修改密码出错" detail:nil];
                [mbHud hide:YES afterDelay:1];
            }
        });
    });
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入正确的手机号!" message:nil preferredStyle:UIAlertControllerStyleAlert];
//        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
//        [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)dismissKeyboard {
    [_oldPasswordTextField resignFirstResponder];
    [_modifyPasswordTextField   resignFirstResponder];
    [_confirmModifyPasswordTextField resignFirstResponder];

}
#pragma mark - Table view dedegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
