//
//  AccountManager.m
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/4/8.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import "AccountManager.h"
#import "MacroDefinition.h"

// 是否登陆名字
#define isLoginName @"isLogin"
#define userIDName  @"useID"
#define roleName    @"role"

@implementation AccountManager
@synthesize isLogin=_isLogin,userID=_userID,role=_role;

+ (AccountManager *)sharedAccountManager
{
    static AccountManager *sharedAccountManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAccountManager = [[self alloc] init];
    });
    return sharedAccountManager;
}


//- (id)init {
//    NSLog(@"init Account Manager");
//    // 当前密码
//    NSString *curPassword;
//    if (self = [super init]) {
//        
//        curPassword = [[NSUserDefaults standardUserDefaults] stringForKey:userIDName];
//        if (!curPassword) { // 如果为空 则从原始密码初始化 并写进
//            curPassword = userIDName;
//            [[NSUserDefaults standardUserDefaults]setObject:userIDName forKey:userIDName];
//        }
//    }
//    return self;
//}

- (void)setIsLogin:(BOOL)isLogin {
    _isLogin = isLogin;
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:_isLogin] forKey:isLoginName];
}
- (BOOL)isLogin {
    _isLogin =[[NSUserDefaults standardUserDefaults] boolForKey:isLoginName];
    return _isLogin;
}

- (void)setUserID:(NSString *)userID {
    _userID = userID;
    [[NSUserDefaults standardUserDefaults]setObject:_userID forKey:userIDName];
}
- (NSString *)userID {
    _userID =[[NSUserDefaults standardUserDefaults] stringForKey:userIDName];
    return _userID;
}

- (void)setRole:(NSString *)role {
    _role = role;
    [[NSUserDefaults standardUserDefaults]setObject:_role forKey:roleName];
}
- (NSString *)role {
    _role =[[NSUserDefaults standardUserDefaults] stringForKey:roleName];
    return _role;
}

- (BOOL)logInWithUserID:(NSString *)userID password:(NSString *)password {
    self.role = [WhuControlWebservice logInWithID:userID password:password];
    self.userID =userID;
    
    if ([self.role isEqualToString:@"0"]) {
        self.isLogin = NO;
        return NO;
    }
    self.isLogin = YES;
    return YES;
}

- (BOOL)modifyPasswordWithUserID:(NSString *)userID curPassword:(NSString *)curPassword updatePassword:(NSString *)updatePassword {
    return YES;
}



@end
