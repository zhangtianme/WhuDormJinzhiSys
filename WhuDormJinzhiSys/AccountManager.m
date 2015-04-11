//
//  AccountManager.m
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/4/8.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import "AccountManager.h"

// 是否登陆名字
#define isLoginName         @"isLogin"
#define userIDName          @"useID"

@implementation AccountManager
@synthesize isLogin=_isLogin;

+ (AccountManager *)sharedAccountManager
{
    static AccountManager *sharedAccountManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAccountManager = [[self alloc] init];
    });
    return sharedAccountManager;
}


- (id)init {
    NSLog(@"init Account Manager");
    // 当前密码
    NSString *curPassword;
    if (self = [super init]) {
        
        curPassword = [[NSUserDefaults standardUserDefaults] stringForKey:userIDName];
        if (!curPassword) { // 如果为空 则从原始密码初始化 并写进
            curPassword = userIDName;
            [[NSUserDefaults standardUserDefaults]setObject:userIDName forKey:userIDName];
        }
    }
    return self;
}

- (void)setIsLogin:(BOOL)isLogin {
    NSLog(@"执行setIsLogin方法 before%d after%d",_isLogin,isLogin);
    _isLogin = isLogin;
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:_isLogin] forKey:isLoginName];
}
- (BOOL)isLogin {
    _isLogin =[[NSUserDefaults standardUserDefaults] boolForKey:isLoginName];
    NSLog(@"执行islogin方法%d",_isLogin);
    return _isLogin;
}



@end
