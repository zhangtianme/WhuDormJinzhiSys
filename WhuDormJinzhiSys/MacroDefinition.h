//
//  MacroDefinition.h
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/3/20.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#ifndef WhuDormJinzhiSys_MacroDefinition_h
#define WhuDormJinzhiSys_MacroDefinition_h

#import "WhuControlWebservice.h"
#import "AccountManager.h"
#import "StudentAccount.h"
#import "AdminAccount.h"
#import "MBProgressHUD.h"
#import "BillCell.h"
#import "RoomCell.h"
#import "RoomHeader.h"
#import "BEMSimpleLineGraphView.h"  // 曲线绘制
#import "IQKeyboardManager.h"       // 键盘居中加左右方向键
#import "DropDownListView.h"        // 下拉菜单
#import "MJRefresh.h"               // 下拉刷新
#import "StudentViewController.h"
#import "PHJTransformPinyin.h"      // 汉字转拼音
#import "LogInViewController.h"  //登陆界面

//#import "UILabel+VerticalAlign.h"

#define isDemoVersion  0       // 是否demo版本


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBAlpha(rgbValue,alphaa) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaa]



#define mainBlueColor [UIColor colorWithRed:0X50/255.0 green:0XA0/255.0 blue:0XD2/255.0 alpha:1.0]  // 主蓝色
#define lightBlueColor [UIColor colorWithRed:0XDC/255.0 green:0XEC/255.0 blue:0XF6/255.0 alpha:1.0] // 淡蓝色
#define darkBlueColor [UIColor colorWithRed:0X38/255.0 green:0X74/255.0 blue:0X9B/255.0 alpha:1.0] // 更浓的蓝色

// 请求超时 时间
#define timeoutRequest  10       // 10秒超时
#define loginRequestError    @"1000" // 登陆请求失败

// 与金智系统有关
#define jinzhiBundle1  @"com.wisedu.WuHanDaXueIN" // 金智企业版的bundleid
#define jinzhiBundle2  @"com.wisedu.ZhangShangWuDa" // 金智个人版的bundleid
#define jinzhiScheme   @"mcpWhuHan://" // 调用金智软件的scheme
#define rechargeUrl    @"http://10.100.0.4:8001" // 充值网站

#define versionUpdateUrl @"http://10.100.0.4:8001" // 软件升级网站
#define iOSTypeName     @"iOS"  //
#define versionNameName @"VersionName"  //
#define urlName     @"URL" //读取出来的url

// 视图控制器的标识
#define dormAirConIdentity      @"dormAirCon"
#define dormLightingIdentity    @"dormLighting"

#define loginIndentity          @"loginView"

#define dormInfoNavIdentity     @"dormInfoNav"    // dorm info navigationcontroller
#define dormInfoIdentity        @"dormInfoView"
#define allDormInfoViewIdentity @"allDormInfoView"// 管理员界面storyboardidentity
#define studentInfoIdentity     @"studentInfo"    // 学生信息页面storyboardidentity

#define airConName              @"空调"
#define lightingName            @"照明"
#define hotWaterName            @"热水"

#define dormName                @"宿舍"
#define studentName             @"学生"
#define threePhaseName          @"综合"
#define floorName               @"Floor"


// 视图控制器跳转的标识
#define showStudentDetailIdentifier  @"showStudent"       // 进入学生详情页面
#define showTallyBookIdentifier      @"showTallyBook"     // show资费记录
#define showStatusLogIdentifier      @"showStatusLog"     // show状态日志
#define showLogDetailIdentifier      @"showLogDetail"     // show状态日志的详细页面
#define showHisDataIdentifier        @"showHisData"       // show历史数据
#define showDormInfoIdentifier       @"showDormInfo"      // show学生宿舍页面
#define showSettingsIdentifier       @"showSettings"      // show设置页面

#define showAllDormInfoIdentifier    @"showAllDormInfo"   // show管理员页面
#define showModifyPhoneIdentifier    @"showModifyPhone"   // show修改手机号
#define showModifyPasswordIdentifier @"showModifyPassword"// show修改密码
#define showAboutIdentifier          @"showAbout"         // show关于页面
#define showSearchIdentifier         @"showSearch"        // show搜索页面


#define stuPYNameName                @"StuPYName"         // 学生拼音名字


// accountManager 的各参数名字
#define userIDName                   @"useID"             // 用户账号
#define roleName                     @"Role"              // 角色号
#define stuIDName                    @"StudentID"         // 学号
//  querycheckStu 内各参数
// 直接返回nsstring类型不是nsdictionary无需解析
//  queryUserInfo 各参数的名字
#define roomIDName                 @"RoomID"         // 房间标号
#define facultyName                @"Faculty"        // 院系
#define professionalName           @"Professional"   // 专业
//#define roleName                   @"Role"           // 角色号
#define stuNameName                @"SName"          // 学生名字


#define areaName                   @"Area"           // 区域
#define buildingName               @"Building"       // 建筑
#define unitName                   @"Unit"           // 单元
#define roomNumName                @"RoomNum"        // 房间号

#define licensorName               @"Licensor"       // 授权人
// 空调部分
#define subsidyDegreeAirConName    @"Subsidykt"      // 剩余补贴 度数
#define chargebackDegreeAirConName @"eleckt"         // 余额 度数
#define chargebackAirConName       @"ktPreChargeback"// 余额
#define subsidyAirConName          @"ktPreSubsidy"   // 剩余补贴
#define priceAirConName            @"ktPrice"        // 空调电价
// 照明部分
#define subsidyDegreeLightName     @"Subsidyzm"      // 剩余补贴 度数
#define chargebackDegreeLightName  @"eleczm"         // 余额 度数
#define chargebackLightName        @"zmPreChargeback"// 余额
#define subsidyLightName           @"zmPreSubsidy"   // 剩余补贴
#define priceLightName             @"zmPrice"        // 空调电价

//  queryChannelStat 各参数的名字
#define electricityName   @"Eletricity"   // 总电量
#define voltageName       @"U"            // 电压
#define currentName       @"I"            // 电流
#define powerName         @"Power"        // 功率
#define powerRateName     @"PowerRate"    // 功率因数
#define elecMonName       @"ElecMonth"    // 当月用电量
#define elecDayName       @"ElecDay"      // 当天用电量
#define stateName         @"State"        // 状态 01 表示开关
#define statusName        @"Status"       // 状态描述 正常、恶性负载、电表锁定、等待
#define accountStatusName @"AccountStatus"// 账户状态 正常、余额不足、冻结

//  queryRoom 内各参数  NSArray下是NSDictionary读取
//#define stuNameName             @"SName"      // 学生名字 上面已有
//#define stuIDName               @"StudentID"  // 学号  上面已有
//#define facultyName             @"Faculty"    // 院系 上面已有
//#define professionalName        @"Professional"  // 专业 上面已有
#define phoneNumName     @"PhoneNum"  // 电话
#define isHeadName       @"YesorNo"   // 是否寝室长
#define isPermissionName @"Permission"// 是否有控制权限

//  queryBillMonth 各参数的名字
//#define roomIDName              @"RoomID"           // 房间标号 房间id上面已有
#define accountTypeName @"AccountType"// 账户类型
#define inDegreeName    @"InDegree"   // 月充值换算度数
#define inRMBName       @"InRMB"      // 月充值总计
#define outDegreeName   @"OutDegree"  // 月支出换算度数
#define outRMBName      @"OutRMB"     // 月支出总计

//  queryChargeBack 各参数的名字
//#define electricityName         @"Eletricity"       // 总电量 上面有
#define chargebackName  @"Chargeback"     // 支出总计 钱
#define getTimeName     @"GetTime"        // 获取时间

//  queryRecharge 各参数的名字
//#define getTimeName               @"GetTime"          // 获取时间
#define rechargeName    @"Recharge"       // 充值金额

//  queryState 各参数的名字
//#define getTimeName               @"GetTime"          // 获取时间
//#define roomIDName              @"RoomID"             // 房间标号
//#define accountTypeName         @"AccountType"        // 账户类型
#define typeName        @"Type"           // 操作类型 用电操作/恶性负载/余额不足/过载
#define contentsName    @"Contents"       // 详细信息 在用电操作时 2/3 代表开/关
#define operateName     @"用电操作"        // 用来辨别type里面的操作归属问题

//  queryHisdata 各参数的名字
#define elecValueName       @"EletricityValue"// 间隔时间的电量
#define valueName           @"Value"          // 历史数据的值

//  queryBuildingDetail 各参数的名字
#define lightningStatusName @"zmStatus"       // 照明的异常状态
#define lightningStateName  @"zmState"        // 照明的开关状态
#define airConStatusName    @"ktStatus"       // 空调的异常状态
#define airConStateName     @"ktState"        // 空调的开关状态

//  queryThreephase_R 各参数的名字
#define activePowerName     @"ActivePower"    // 三相电表的有功功率
#define reactivePowerName   @"ReactivePower"  // 三相电表的无功功率
#define currentAName        @"IA"             // A相电流
#define currentBName        @"IB"             // B相电流
#define currentCName        @"IC"             // C相电流
#define voltageAName        @"VolA"           // A相电压
#define voltageBName        @"VolB"           // B相电压
#define voltageCName        @"VolC"           // C相电压
#define electricityThreePhaseName   @"Electricity"   // 总电量



















#endif
