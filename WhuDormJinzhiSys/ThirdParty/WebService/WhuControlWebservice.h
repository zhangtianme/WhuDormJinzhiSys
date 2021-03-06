//
//  WhuControlWebservice.h
//  webServiceForSchool
//
//  Created by 桂初晴 on 14/10/27.
//  Copyright (c) 2014年 Whu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
//#import "Student.h"
//#import "Room.h"

@interface WhuControlWebservice : NSObject

@property(nonatomic,retain) ASIHTTPRequest *httpRequest;

/**
 * 单例模式，初始化，仅存在一个实例对象不过注意在调用的地方只能使用该方法初始化，不然会清空前面的数据
 **/
+ (WhuControlWebservice *)sharedService;

// 登录 返回角色号 0 1-9
+ (NSString *)logInWithID:(NSString *)userID password:(NSString *)password;
// 检查学生是否具有控制开关的权限 0/1
+ (NSString *)checkStu:(NSString *)stuID;
// 查询用户信息
+ (NSDictionary *)queryUserInfo:(NSString *)userID;
// 查询用电状态 GetTime、Status、State、U、I、Power、PowerRate、Eletricity、roomID
+ (NSDictionary *)queryChannelStat:(NSString *)roomID accountType:(NSString *)accountType;
// 查询某间宿舍学生信息
+ (NSArray *)queryRoom:(NSString *)roomID;
// 查询学生宿舍充值记录
+ (NSArray *)queryRecharge:(NSString *)roomID accountType:(NSString *)accountType startTime:(NSString *)startTime endTime:(NSString *)endTime;
// 查询所有学生宿舍信息
+ (NSArray *)queryBuilding;
// 查询宿舍历史用电信息
+ (NSArray *)queryHisData:(NSString *)roomID accountType:(NSString *)accountType field:(NSString *)field startTime:(NSString *)startTime endTime:(NSString *)endTime freq:(NSString *)freq;
// 查询宿舍开关记录信息
+ (NSArray *)queryState:(NSString *)roomID accountType:(NSString *)accountType startTime:(NSString *)startTime endTime:(NSString *)endTime;
// 查询宿舍支出记录信息
+ (NSArray *)queryChargeBack:(NSString *)roomID accountType:(NSString *)accountType startTime:(NSString *)startTime endTime:(NSString *)endTime freq:(NSString *)freq;
// 查询宿舍某个月充值消费总计
+ (NSDictionary *)queryBillMonth:(NSString *)roomID accountType:(NSString *)accountType year:(NSString *)year month:(NSString *)month;
// 查询某栋宿舍的房间详细信息
+ (NSArray *)queryBuildingDetailWithArea:(NSString *)area building:(NSString *)building unit:(NSString *)unit;
// 查询所有学生信息
+ (NSArray *)queryStudents;
// 修改手机号 返回0/1
+ (NSString *)modifyPhoneNumWithUserID:(NSString *)userID phoneNum:(NSString *)phoneNum role:(NSString *)role;
// 修改密码 返回0/1
+ (NSString *)modifyPasswordWithUserID:(NSString *)userID oldPassword:(NSString *)oldPassword modifyPassword:(NSString *)modifyPassword role:(NSString *)role;
// 插入控制命令 01 返回0/1
+ (NSString *)insertOrderWithUserID:(NSString *)userID roomID:(NSString *)roomID accountType:(NSString *)accountType orderID:(NSString *)orderID;
// 检查版本 iOS 返回dictionary
+ (NSDictionary *)queryVersionWithType:(NSString *)type;

// 查询某栋宿舍的三相电表的当前状态
+ (NSDictionary *)queryCurrentThreePhaseStateWithArea:(NSString *)area building:(NSString *)building unit:(NSString *)unit accountType:(NSString *)accountType;
// 查询某栋宿舍的三相电表的历史状态
+ (NSArray *)queryHisThreePhaseStateWithArea:(NSString *)area building:(NSString *)building unit:(NSString *)unit accountType:(NSString *)accountType field:(NSString *)field startTime:(NSString *)startTime endTime:(NSString *)endTime freq:(NSString *)freq;



/*Inquiry_BillMonth_RoomID
 <?xml version="1.0" encoding="utf-8"?>
 <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
 <soap:Body>
 <Inquiry_BillMonth_RoomID xmlns="http://www.suntrans.net/">
 <RoomID>string</RoomID>
 <AccountType>string</AccountType>
 <Year>string</Year>
 <Month>string</Month>
 </Inquiry_BillMonth_RoomID>
 </soap:Body>
 </soap:Envelope>
 
 
 */

// 暂时做到这里 还有一部分webservice功能暂时不用添加

@end