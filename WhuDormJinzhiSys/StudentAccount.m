//
//  StudentAccount.m
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/3/21.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import "StudentAccount.h"

@interface StudentAccount () 

@end

@implementation StudentAccount


/**
 * 单例模式，初始化，仅存在一个实例对象不过注意在调用的地方只能使用该方法初始化，不然会清空前面的数据
 **/
+ (StudentAccount *)sharedStudentAccount
{
    static StudentAccount *sharedStudentAccount = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStudentAccount = [[self alloc] init];
    });
    return sharedStudentAccount;
}

- (id)init {
    NSLog(@"init Account Manager");
    

    // 给账户分配空间
    if (self = [super init]) {
        _userID = [[NSString alloc] init];
        _stuID   = [[NSString alloc] init];
        _roomID  = [[NSString alloc] init];
    }

    return self;
}

//- (NSString*)description {
//    return [NSString stringWithFormat:@"%@ 0x%@", [self class], self];
//
//}



@end
