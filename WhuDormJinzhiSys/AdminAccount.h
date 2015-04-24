//
//  AdminAccount.h
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/4/18.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdminAccount : NSObject


/**
 *  单例模式，初始化，仅存在一个实例对象不过注意在调用的地方只能使用该方法初始化，不然会清空前面的数据
 *
 *  @return 返回的为单例 实例
 */
+ (AdminAccount *)sharedAdminAccount;


@property (nonatomic, strong) NSString *userID;  // 用户号
@property (nonatomic, strong) NSString *role;    // 角色号


@property (nonatomic, strong) NSString *phoneNum;// 电话
@property (nonatomic, strong) NSString *area;    // 区域
@property (nonatomic, strong) NSString *building;// 建筑
@property (nonatomic, strong) NSString *unit;    // 单元

@property (nonatomic, strong) NSString *licensor;// 授权人


@end
