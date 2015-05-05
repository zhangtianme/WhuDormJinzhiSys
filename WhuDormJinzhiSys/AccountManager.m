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
#define passwordName  @"password"
#define roomSearchHisName  @"roomSearchHis"
#define studentSearchHisName  @"studentSearchHis"

#define hisNums 5 // 搜索记录限制5条

@implementation AccountManager
@synthesize isLogin=_isLogin,userID=_userID,role=_role,password=_password,roomSearchHis=_roomSearchHis,studentSearchHis=_studentSearchHis;

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

- (void)setPassword:(NSString *)password {
    _password = password;
    [[NSUserDefaults standardUserDefaults]setObject:_password forKey:passwordName];
}
- (NSString *)password {
    _password =[[NSUserDefaults standardUserDefaults] stringForKey:passwordName];
    return _password;
}

- (void)setRole:(NSString *)role {
    _role = role;
    [[NSUserDefaults standardUserDefaults]setObject:_role forKey:roleName];
}
- (NSString *)role {
    _role =[[NSUserDefaults standardUserDefaults] stringForKey:roleName];
    return _role;
}

- (void)setRoomSearchHis:(NSArray *)roomSearchHis {
    _roomSearchHis = roomSearchHis;
    [[NSUserDefaults standardUserDefaults]setObject:_roomSearchHis forKey:roomSearchHisName];
}
- (NSArray *)roomSearchHis {
    _roomSearchHis =[[NSUserDefaults standardUserDefaults] arrayForKey:roomSearchHisName];
//    // 去重 加排序
//    _roomSearchHis = [[NSSet setWithArray:_roomSearchHis] allObjects];
//    if (_roomSearchHis.count>hisNums) { // 超过范围
//        NSMutableArray *mutableArr = [_roomSearchHis mutableCopy];
//        [mutableArr removeObjectsInRange:NSMakeRange(hisNums-1, _roomSearchHis.count-hisNums)];
//        _roomSearchHis = (NSArray *)mutableArr;
//    }
//    [self setRoomSearchHis:_roomSearchHis];
    return _roomSearchHis;
}
- (void)insertObject:(NSDictionary *)object inRoomSearchHisAtIndex:(NSUInteger)index {
    NSMutableArray *tempRoomSearchHis = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:roomSearchHisName]];
    if (!tempRoomSearchHis) { // if nil
        NSLog(@"roomsearchnil");
        tempRoomSearchHis = [NSMutableArray arrayWithCapacity:1];
    }
    // 插入前先去重
    [tempRoomSearchHis removeObject:object];
    [tempRoomSearchHis insertObject:object atIndex:index];
    if (tempRoomSearchHis.count>hisNums) { // 超过范围
        [tempRoomSearchHis removeObjectsInRange:NSMakeRange(hisNums-1, tempRoomSearchHis.count-hisNums)];
    }
    [[NSUserDefaults standardUserDefaults]setObject:tempRoomSearchHis forKey:roomSearchHisName];
}

- (void)setStudentSearchHis:(NSArray *)studentSearchHis{
    _studentSearchHis = studentSearchHis;
    [[NSUserDefaults standardUserDefaults]setObject:_studentSearchHis forKey:studentSearchHisName];
}
- (NSArray *)studentSearchHis{
    _studentSearchHis =[[NSUserDefaults standardUserDefaults] arrayForKey:studentSearchHisName];
    return _studentSearchHis;
}
- (void)insertObject:(NSDictionary *)object inStudentSearchHisAtIndex:(NSUInteger)index{
    NSMutableArray *tempStudentSearchHis = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:studentSearchHisName]];
    if (!tempStudentSearchHis) { // if nil
        tempStudentSearchHis = [NSMutableArray arrayWithCapacity:1];
    }
    // 插入前先去重
    [tempStudentSearchHis removeObject:object];
    [tempStudentSearchHis insertObject:object atIndex:index];
    if (tempStudentSearchHis.count>hisNums) { // 超过范围
        [tempStudentSearchHis removeObjectsInRange:NSMakeRange(hisNums-1, tempStudentSearchHis.count-hisNums)];
    }
    [[NSUserDefaults standardUserDefaults]setObject:tempStudentSearchHis forKey:studentSearchHisName];
}

- (NSString *)logInWithUserID:(NSString *)userID password:(NSString *)password {
    self.role = [WhuControlWebservice logInWithID:userID password:password];

    if ([self.role isEqualToString:@"0"]||[self.role isEqualToString:loginRequestError]) { // 登陆失败
        self.isLogin = NO;
    } else {
        self.userID =userID;
        self.password =password;
        self.isLogin = YES;
    }
    return self.role;
}

//- (BOOL)modifyPasswordWithUserID:(NSString *)userID curPassword:(NSString *)curPassword updatePassword:(NSString *)updatePassword role:(NSString *)role {
//    NSString *isSuccess = [WhuControlWebservice modifyPasswordWithUserID:userID oldPassword:curPassword modifyPassword:updatePassword role:rol];
//    if (isSuccess) {// 修改密码成功
//        self.password =
//    }
//    return isSuccess.boolValue;
//}

- (BOOL)modifyPasswordWithUserID:(NSString *)userID curPassword:(NSString *)curPassword updatePassword:(NSString *)updatePassword role:(NSString *)role {
    NSString *isSuccess = [WhuControlWebservice modifyPasswordWithUserID:userID oldPassword:curPassword modifyPassword:updatePassword role:role];
    if (isSuccess.boolValue) {// 修改密码成功
        self.password = updatePassword;
        NSLog(@"success");
    }
    return isSuccess.boolValue;
}

- (BOOL)modifyPhoneNumWithUserID:(NSString *)userID updatePhoneNum:(NSString *)updatePhoneNum role:(NSString *)role {
    NSString *isSuccess = [WhuControlWebservice modifyPhoneNumWithUserID:userID phoneNum:updatePhoneNum role:role];
    return isSuccess.boolValue;
}

- (BOOL)logOut {
    AdminAccount *adminAccount = [AdminAccount sharedAdminAccount];
    StudentAccount *studentAccount = [StudentAccount sharedStudentAccount];
    self.userID = nil;
    self.isLogin = NO;
//    self = nil; 推出前 先把某些信息 删除
    if (self.role.integerValue==1||self.role.integerValue==2) {// 学生
        studentAccount.phoneNum = nil;
        studentAccount.userID = nil;
        studentAccount.stuID = nil;

    } else {
        adminAccount.area = nil;
        adminAccount.building = nil;
        adminAccount.unit = nil;
        adminAccount.phoneNum = nil;
    }
    // 退出的时候把搜索历史记录清空
    self.studentSearchHis = nil;
    self.roomSearchHis = nil;
    NSLog(@"stu:%@ room:%@",self.studentSearchHis,self.roomSearchHis);
    NSLog(@"adminaccount role:%@",adminAccount.role);
    return YES;
}


@end
