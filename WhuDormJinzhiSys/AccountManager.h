//
//  AccountManager.h
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/4/8.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountManager : NSObject

/**
*  用户账号
*/
@property (nonatomic, strong)NSString *userID;
/**
 *  角色号 管理员还是学生
 */
@property (nonatomic, strong)NSString *role;

/**
 *  登陆状态 bool类型
 */
@property (assign)BOOL isLogin;



/**
 *  单例模式，初始化，仅存在一个实例对象不过注意在调用的地方只能使用该方法初始化，不然会清空前面的数据
 *
 *  @return 返回的为单例 实例
 */
+ (AccountManager *)sharedAccountManager;


/**
 *  用户登录
 *
 *  @param userID   用户ID
 *  @param password 用户密码
 *
 *  @return 用户的角色号 0 为登陆失败 1 2 4 5 6 9 12 13为角色号
 */
- (NSString *)logInWithUserID:(NSString *)userID password:(NSString *)password;
/**
 *  修改密码
 *
 *  @param userID         用户ID
 *  @param curPassword    用户当前密码
 *  @param updatePassword 用户修改的密码
 *
 *  @return 修改是否成功
 */
- (BOOL)modifyPasswordWithUserID:(NSString *)userID curPassword:(NSString *)curPassword updatePassword:(NSString *)updatePassword;



@end












