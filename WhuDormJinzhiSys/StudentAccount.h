//
//  StudentAccount.h
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/3/21.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentAccount : NSObject{
}

@property (nonatomic, strong) NSString *userID;                // 用户号

@property (nonatomic, strong) NSString *stuID;                 // 学号
//  querycheckStu 内各参数
@property (nonatomic, strong) NSString *controlLimit;          // 学生是否有控制权限
//  queryUserInfo 内各参数
@property (nonatomic, strong) NSString *roomID;                // 房间标号
@property (nonatomic, strong) NSString *faculty;               // 院系
@property (nonatomic, strong) NSString *professional;          // 专业
@property (nonatomic, strong) NSString *role;                  // 角色号
@property (nonatomic, strong) NSString *stuName;               // 学生名字

@property (nonatomic, strong) NSString *phoneNum;

@property (nonatomic, strong) NSString *area;                  // 区域
@property (nonatomic, strong) NSString *building;              // 建筑
@property (nonatomic, strong) NSString *unit;                  // 单元
@property (nonatomic, strong) NSString *roomNum;               // 房间号
// 空调部分
@property (nonatomic, strong) NSString *subsidyDegreeAirCon;
// 剩余补贴 度数
@property (nonatomic, strong) NSString *chargebackDegreeAirCon;// 余额 度数
@property (nonatomic, strong) NSString *chargebackAirCon;      // 余额
@property (nonatomic, strong) NSString *subsidyAirCon;         // 剩余补贴
@property (nonatomic, strong) NSString *priceAirCon;           // 电价
// 照明部分
@property (nonatomic, strong) NSString *subsidyDegreeLight;    // 剩余补贴 度数
@property (nonatomic, strong) NSString *chargebackDegreeLight; // 余额 度数
@property (nonatomic, strong) NSString *chargebackLight;       // 余额
@property (nonatomic, strong) NSString *subsidyLight;          // 剩余补贴
@property (nonatomic, strong) NSString *priceLight;            // 电价

//  queryChannelStat 内各参数
// 人工分为俩部分 根据输入参数的 accounttype决定 空调
@property (nonatomic, strong) NSString *electricityAirCon;     // 总电量
@property (nonatomic, strong) NSString *voltageAirCon;         // 电压
@property (nonatomic, strong) NSString *currentAirCon;         // 电流
@property (nonatomic, strong) NSString *powerAirCon;           // 功率
@property (nonatomic, strong) NSString *powerRateAirCon;       // 功率因数
@property (nonatomic, strong) NSString *elecMonAirCon;         // 当月用电量 度数
@property (nonatomic, strong) NSString *elecDayAirCon;         // 当天用电量
@property (nonatomic, strong) NSString *stateAirCon;           // 状态 01 表示开关
@property (nonatomic, strong) NSString *statusAirCon;          // 状态描述 正常、恶性负载、电表锁定、等待
@property (nonatomic, strong) NSString *accountStatusAirCon;   // 账户状态 正常、余额不足、冻结
// 人工分为俩部分 根据输入参数的 accounttype决定 照明
@property (nonatomic, strong) NSString *electricityLight;      // 总电量
@property (nonatomic, strong) NSString *voltageLight;          // 电压
@property (nonatomic, strong) NSString *currentLight;          // 电流
@property (nonatomic, strong) NSString *powerLight;            // 功率
@property (nonatomic, strong) NSString *powerRateLight;        // 功率因数
@property (nonatomic, strong) NSString *elecMonLight;          // 当月用电量
@property (nonatomic, strong) NSString *elecDayLight;          // 当天用电量
@property (nonatomic, strong) NSString *stateLight;            // 状态 01 表示开关
@property (nonatomic, strong) NSString *statusLight;           // 状态描述 正常、恶性负载、电表锁定、等待
@property (nonatomic, strong) NSString *accountStatusLight;    // 账户状态 正常、余额不足、冻结

//  queryRoom 内各参数   直接NSArray读取
@property (nonatomic, strong) NSArray  *students;              // 房间内的学生


/**
 * 单例模式，初始化，仅存在一个实例对象不过注意在调用的地方只能使用该方法初始化，不然会清空前面的数据
 **/
+ (StudentAccount *)sharedStudentAccount;

/**
 * 设置账号
 **/
//+ (void)setAccount:(NSString *)account;
///**
// * 获取账号
// **/
//+ (NSString *)account;


@end
