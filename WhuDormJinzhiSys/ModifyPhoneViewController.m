//
//  ModifyPhoneViewController.m
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/4/23.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import "ModifyPhoneViewController.h"
#import "MacroDefinition.h"

@interface ModifyPhoneViewController () {
    AccountManager *accountManager;
    MBProgressHUD *mbHud;
}

@end

@implementation ModifyPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    accountManager = [AccountManager sharedAccountManager];

    self.tableView.backgroundColor = lightBlueColor;
    self.navigationItem.title = @"修改手机号";
    self.tableView.scrollEnabled = NO;
    _userIDLabel.text  = accountManager.userID;

    // 初始化
    CGFloat widthZoom         = self.view.frame.size.width/320;// 缩放比例
    // textfield 字体大小
    CGFloat textFieldFontSize = 16.0;
    // textfield 左边偏移量
    CGFloat textFieldOffset   = 8;

    _phoneNumTextField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2]; // 白色 0.2透明
    [_phoneNumTextField setBorderStyle:UITextBorderStyleNone]; // 无框
    _phoneNumTextField.font = [UIFont systemFontOfSize:textFieldFontSize];

    _phoneNumTextField.placeholder = @"请输入手机号";
    //    _phoneNumTextField.secureTextEntry = YES;  // 密码模式
    _phoneNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, textFieldOffset, 20)]; // 左部偏移量
    _phoneNumTextField.leftView = imageView2;
    _phoneNumTextField.leftViewMode = UITextFieldViewModeAlways;
    _phoneNumTextField.keyboardType = UIKeyboardTypePhonePad;
    
    
//    [_confirmModifyButton setBackgroundImage:[UIImage imageNamed:@"logInBackground"] forState:UIControlStateNormal];
    _confirmModifyButton.backgroundColor = mainBlueColor;
//    [_confirmModifyButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"登 录" attributes:buttonAttrsDic] forState:UIControlStateNormal];
    [_confirmModifyButton setTitle:@"确认修改" forState:UIControlStateNormal];
    [_confirmModifyButton addTarget:self action:@selector(didClickConfirmModifyButton:) forControlEvents:UIControlEventTouchUpInside];
    
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
    NSLog(@"click modefy");
    [self dismissKeyboard];
    BOOL isPhoneNum = [self isMobileNumber:_phoneNumTextField.text];
    NSLog(@"is phone :%D",isPhoneNum);
    if (isPhoneNum) { // 是正确的手机号
        __block BOOL isSuccess = NO;  // 修改是否成功
        [mbHud showWithTitle:@"修改手机号..." detail:nil];
        [self performSelector:@selector(requestTimeout:) withObject:nil afterDelay:timeoutRequest];// 5秒的超时
        // 异步线程调用接口
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            isSuccess = [accountManager modifyPhoneNumWithUserID:accountManager.userID updatePhoneNum:_phoneNumTextField.text role:accountManager.role];
            // 返回主线程 处理结果
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (isSuccess) { // 修改手机号成功
                    [mbHud showWithTitle:@"修改手机号成功" detail:nil];
                    [mbHud hide:YES afterDelay:0.5];
                    [NSObject cancelPreviousPerformRequestsWithTarget:self]; // 取消前面的定时函数
                    // 页面跳转 延迟1.5秒
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                } else { // 修改手机号失败
                    [NSObject cancelPreviousPerformRequestsWithTarget:self]; // 取消前面的定时函数
                    [mbHud showWithTitle:@"修改手机号出错" detail:nil];
                    [mbHud hide:YES afterDelay:1];
                }
            });
        });
    } else { // 非手机号码
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入正确的手机号!" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

- (void)dismissKeyboard {
    [_phoneNumTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view dedegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/**
 *  正则判断手机号码地址格式
 *
 *  @param mobileNum 手机号字符串
 *
 *  @return 是否手机号
 */
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)){
        return YES;
    }else {
        return NO;
    }
}


//#pragma mark - Table view data source
//
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
