//
//  AppDelegate.m
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/3/19.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import "AppDelegate.h"
#import "MacroDefinition.h"

@interface AppDelegate (){
    StudentAccount *studentAccount;
    AccountManager *accountManager;
}

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 每次启动之前把 属性读出来 如果需要登陆 则在登陆 函数里面再次读取
    studentAccount = [StudentAccount sharedStudentAccount];
    accountManager = [AccountManager sharedAccountManager];
    
    studentAccount.stuID = accountManager.userID;
    studentAccount.userID = accountManager.userID;
    studentAccount.role = accountManager.role;
    
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x50A0D2)]; // 不适用半透明的话是原色
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]]; // 导航栏标题颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]]; // 导航栏各种按钮颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; // 导航栏亮色 需要配合plist viewcontroller 某项属性设置为NO
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    navController.navigationBar.translucent = NO; // 设置为非透明
    if (accountManager.isLogin) { // 已经登录 则跳过登陆页面 根据role决定 push 到学生还是管理员页面
        if (accountManager.role.integerValue==1||accountManager.role.integerValue==2) {// 学生
            [navController pushViewController:[storyboard instantiateViewControllerWithIdentifier:dormInfoIdentity] animated:NO];
        }
    }

    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:80]; // 距离，是否能调到中间位置
    sleep(1);  //
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
