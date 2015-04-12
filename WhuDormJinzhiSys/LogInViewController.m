//
//  LogInViewController.m
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/4/7.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import "LogInViewController.h"
#import "MacroDefinition.h"


@interface LogInViewController () {
    UIAlertController  *alertController;
    AccountManager *accountManager;
    StudentAccount *studentAccount;
    MBProgressHUD *mbHud;

}

@end

@implementation LogInViewController
@synthesize accountTextField,passwordTextField,logInButton,headIconImage,buttomIconImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"login  viewdidload");
    accountManager = [AccountManager sharedAccountManager];
    studentAccount = [StudentAccount sharedStudentAccount];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0x50A0D2);// 蓝主色
    // 初始化
    CGFloat widthZoom         = self.view.frame.size.width/320;// 缩放比例
    CGFloat heightZoom        = self.view.frame.size.height/568;
    // 标题图标
    CGRect headIconImageRect  = CGRectMake(20*widthZoom, 85*heightZoom, 280*widthZoom, 90*heightZoom);
    // 账号栏
    CGRect accountRect        = CGRectMake(0*widthZoom, 190*heightZoom, 320*widthZoom, 50*heightZoom);
    // 密码栏
    CGRect passwordRect       = CGRectMake(0*widthZoom, 241*heightZoom, 320*widthZoom, 50*heightZoom);
    // textfield 左边偏移量
    CGFloat textFieldOffset   = 15*widthZoom;
    // textfield 字体大小
    CGFloat textFieldFontSize = 17.0;
    // 登录按钮
    CGRect logInRect          = CGRectMake(20*widthZoom, (291+30)*heightZoom, 280*widthZoom, 45*heightZoom);
    // 底部图标 包括公司图标和权限说明
    CGRect buttomIconRect     = CGRectMake(45*widthZoom, 444*heightZoom, 231*widthZoom, 104*heightZoom);

    // placeHolder 字体状态
    UIFont *font                 = [UIFont systemFontOfSize:textFieldFontSize];
    UIColor *fontColor           = [UIColor colorWithWhite:1.0 alpha:0.6];// 白色 透明0.6
    NSDictionary *attrsDic       = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, fontColor, NSForegroundColorAttributeName, nil];
    // logInButton 字体状态
    CGFloat buttonFontSize       = 19.0;
    UIFont *buttonFont           = [UIFont systemFontOfSize:buttonFontSize];

    UIColor *buttonFontColor     = UIColorFromRGBAlpha(0, 0.7);// 黑色 透明0.7
    NSDictionary *buttonAttrsDic = [NSDictionary dictionaryWithObjectsAndKeys:buttonFont, NSFontAttributeName, buttonFontColor, NSForegroundColorAttributeName, nil];
    
    // 标题图标
    if (!headIconImage) {
        headIconImage = [[UIImageView alloc] initWithFrame:headIconImageRect];
    }
    [headIconImage setImage:[UIImage imageNamed:@"headLine"]];
    [self.view addSubview:headIconImage];
    // 账号栏
    if (!accountTextField) {
        accountTextField = [[UITextField alloc] initWithFrame:accountRect];
    }
    accountTextField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2]; // 白色 0.2透明
    [accountTextField setBorderStyle:UITextBorderStyleNone]; // 无框
    accountTextField.font = [UIFont systemFontOfSize:textFieldFontSize];
    accountTextField.textColor = UIColorFromRGBAlpha(0, 0.7); // 黑色 0.7透明
    accountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入工号或学号"attributes:attrsDic];
    accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, textFieldOffset, 20)]; // 左部偏移量
    accountTextField.leftView = imageView;
    accountTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:accountTextField];
    // 密码栏
    if (!passwordTextField) {
        passwordTextField = [[UITextField alloc] initWithFrame:passwordRect];
    }
    passwordTextField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2]; // 白色 0.2透明
    [passwordTextField setBorderStyle:UITextBorderStyleNone]; // 无框
    passwordTextField.font = [UIFont systemFontOfSize:textFieldFontSize];
    passwordTextField.textColor = UIColorFromRGBAlpha(0, 0.7); // 黑色 0.7透明
    passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码"attributes:attrsDic];
    passwordTextField.secureTextEntry = YES;  // 密码模式
    passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, textFieldOffset, 20)]; // 左部偏移量
    passwordTextField.leftView = imageView2;
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:passwordTextField];
    // 登录按钮
    if (!logInButton) {
        logInButton =[[UIButton alloc] initWithFrame:logInRect];
    }
    [logInButton setBackgroundImage:[UIImage imageNamed:@"logInBackground"] forState:UIControlStateNormal];
    [logInButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"登 录" attributes:buttonAttrsDic] forState:UIControlStateNormal];
    [logInButton addTarget:self action:@selector(didClickLogInButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logInButton];
    // 公司图标
    if (!buttomIconImage) {
        buttomIconImage = [[UIImageView alloc] initWithFrame:buttomIconRect];
    }
    [buttomIconImage setImage:[UIImage imageNamed:@"bottomLine"]];
    [self.view addSubview:buttomIconImage];
    
//    UIBarButtonItem *nilBackItem = nil;
//    
//    self.navigationItem.backBarButtonItem = nilBackItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES]; // 隐藏导航栏
    if (!mbHud) {  // 初始化指示器
        mbHud = [[MBProgressHUD alloc] initWithView:self.view];
        
        [self.view addSubview:mbHud];
        mbHud.dimBackground = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewwill disappear");
    [self.navigationController setNavigationBarHidden:NO]; //显示导航栏
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)requestTimeout:(UISwitch *)sender
{
    NSLog(@"changestate");
    // 没有收到数据 显示错误指示2秒钟
    [mbHud showWithTitle:@"错误" detail:@"请求失败，请确认网络连接状态是否正常"];
    [mbHud hide:YES afterDelay:1];
}

- (void)didClickLogInButton:(UIButton *)sender {
    __block BOOL isCorrect = NO;
    [mbHud showWithTitle:@"Login..." detail:nil];
    [self performSelector:@selector(requestTimeout:) withObject:nil afterDelay:timeoutRequest];// 5秒的超时
    
    // 异步线程调用接口
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        isCorrect = [accountManager logInWithUserID:accountTextField.text password:passwordTextField.text];
        // 返回主线程 处理结果
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (isCorrect) { // 登陆成功
                [mbHud showWithTitle:@"登陆成功" detail:nil];
                [mbHud hide:YES];
                NSLog(@"role is :%@",accountManager.role);
                [NSObject cancelPreviousPerformRequestsWithTarget:self]; // 取消前面的定时函数
                // 页面跳转
                if (accountManager.role.integerValue==1||accountManager.role.integerValue==2) {// 学生
                    studentAccount.stuID = accountManager.userID;
                    studentAccount.userID = accountManager.userID;
                    studentAccount.role = accountManager.role;
                    [self performSegueWithIdentifier:showDormInfoIdentifier sender:self];
                } else {
                    
                }
                
            } else {
                [NSObject cancelPreviousPerformRequestsWithTarget:self]; // 取消前面的定时函数
                [mbHud showWithTitle:@"用户名或密码错误" detail:nil];
                [mbHud hide:YES afterDelay:1];
            }
        });
    });



    NSLog(@"did click button");

//    isCorrect = [[AccountManager sharedAccountManager] logInWithAccount:accountTextField.text password:passwordTextField.text];
//    if (isCorrect) { // 登录成功 返回控制页面
//        //        [self dismissViewControllerAnimated:YES completion:nil];
//        [self dismissKeyboard];
//        // 判断是否首次成功登陆，如果首次成功登陆则提示是否使用默认设置
//        // 判断是否第一次成功登陆程序
//        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstSuccessLaunch"]) {
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstSuccessLaunch"];
//            NSLog(@"第一次成功登陆");
//            // 提示是否默认配置
//            alertController = [UIAlertController alertControllerWithTitle:@"是否使用默认配置" message:nil preferredStyle:UIAlertControllerStyleAlert];
//            [alertController addAction:[UIAlertAction actionWithTitle:@"使用" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//                AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//                [appDelegate defaultSettingForHouse]; // 使用默认配置
//                //                [self defaultSettingForHouse]; // 使用默认配置
//                
//                [self dismissViewControllerAnimated:YES completion:nil];
//            }]];
//            [alertController addAction:[UIAlertAction actionWithTitle:@"不使用" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                [self dismissViewControllerAnimated:YES completion:nil];
//                
//            }]];
//            [self presentViewController:alertController animated:YES completion:nil];
//        }
//        else{
//            [self dismissViewControllerAnimated:YES completion:nil];
//            NSLog(@"不是第一次成功登陆");
//        }
//        
//        // UITabBarController *initViewController = [self.storyboard instantiateInitialViewController];
//        //    [self presentViewController:initViewController animated:YES completion:nil];
//        //
//    } else {
//        //alert controller init
//        alertController = [UIAlertController alertControllerWithTitle:@"账号或密码错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
//        [alertController addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:nil]];
//        [alertController addAction:[UIAlertAction actionWithTitle:@"重设密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [self performSegueWithIdentifier:resetPasswordIdentifier sender:self];
//        }]];
//        
//        [self presentViewController:alertController animated:YES completion:nil]; // 失败
//    }
}
- (void)dismissKeyboard {
    //    [self.view endEditing:YES];
    [accountTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    if ([[segue identifier] isEqualToString:logInIdentifier]) { // 登录
//        
//    }
}

@end
