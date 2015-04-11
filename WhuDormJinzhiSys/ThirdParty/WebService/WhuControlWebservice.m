//
//  WhuControlWebservice.m
//  webServiceForSchool
//
//  Created by 桂初晴 on 14/10/27.
//  Copyright (c) 2014年 Whu. All rights reserved.
//
#import "WhuControlWebservice.h"
#import "GDataXMLNode.h"

//#define defaultWebServiceUrl @"http://www.suntrans.net:8099/"
#define defaultWebServiceUrl @"http://210.42.122.127:8080/"
#define defaultNameSpace @"http://www.suntrans.net/"

#define logInMethodName         @"LogIn"
#define checkStuName            @"Check_Stu"
#define queryUserInfoName       @"Inquiry_UserInfo"
#define queryChannelStatName    @"Inquiry_Channel_RoomID"
#define queryRoomName           @"Inquiry_Room_RoomID"
#define queryRechargeName       @"Inquiry_ReCharge_RoomID"
#define queryBuildingName       @"Inquiry_Building"
#define queryHisDataName        @"Inquiry_HisData_RoomID"
#define queryStateName          @"Inquiry_States_RoomID"
#define queryChargeBackName     @"Inquiry_Chargeback_RoomID"
#define queryBillMonthName      @"Inquiry_BillMonth_RoomID"


#define queryInfoName           @"Inquery_Roles"
#define queryWeekHistoryName    @"Inquery_Elec"
#define updatePWDName           @"Update_PWD"
#define insertOrderName         @"Insert_Order"
#define insertApplyName         @"Insert_Application"

#define getSRLCDataName @"P_Select_Table"

#define onControlName   @"2"
#define offControlName  @"3"

#define logInResultName @"LogInResult"
#define baseName        @"text"

@implementation WhuControlWebservice
/**
 * 单例模式，初始化，仅存在一个实例对象不过注意在调用的地方只能使用该方法初始化，不然会清空前面的数据
 **/
+ (WhuControlWebservice *)sharedService
{
    static WhuControlWebservice *sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedService = [[self alloc] init];
    });
    return sharedService;
}

///////////////////////
#pragma mark - 类 方法
// 登录
+ (NSString *)logInWithID:(NSString *)userID password:(NSString *)password{
    // 登录
    WhuControlWebservice *sharedService = [WhuControlWebservice sharedService];
    NSString *userLimitNumber = [sharedService logInWithID:userID password:password];
    
    return userLimitNumber;
}
// 检查学生是否具有控制开关的权限
+ (NSString *)checkStu:(NSString *)stuID{
    WhuControlWebservice *sharedService = [WhuControlWebservice sharedService];
    NSString *studentControlLimit = [sharedService checkStu:stuID];
    return studentControlLimit;
}
// 查询用户信息
+ (NSDictionary *)queryUserInfo:(NSString *)userID{
    WhuControlWebservice *sharedService = [WhuControlWebservice sharedService];
    NSDictionary *userInfo = [sharedService queryUserInfo:userID];
    return userInfo;
}
// 查询用电状态
+ (NSDictionary *)queryChannelStat:(NSString *)roomID accountType:(NSString *)accountType{
    WhuControlWebservice *sharedService = [WhuControlWebservice sharedService];
    NSDictionary *channelStateDic = [sharedService queryChannelStat:roomID accountType:accountType];
    return channelStateDic;
}
// 查询某间宿舍学生信息
+ (NSArray *)queryRoom:(NSString *)roomID{
    WhuControlWebservice *sharedService = [WhuControlWebservice sharedService];
    NSArray *studentArr = [sharedService queryRoom:roomID];
    return studentArr;
}
// 查询学生宿舍充值记录
+ (NSArray *)queryRecharge:(NSString *)roomID accountType:(NSString *)accountType startTime:(NSString *)startTime endTime:(NSString *)endTime{
    WhuControlWebservice *sharedService = [WhuControlWebservice sharedService];
    NSArray *rechargeArr = [sharedService queryRecharge:roomID accountType:accountType startTime:startTime endTime:endTime];
    return rechargeArr;
}
// 查询所有学生宿舍信息
+ (NSArray *)queryBuilding{
    WhuControlWebservice *sharedService = [WhuControlWebservice sharedService];
    NSArray *roomArray = [sharedService queryBuilding];
    return roomArray;
}
// 查询宿舍历史用电信息
+ (NSArray *)queryHisData:(NSString *)roomID accountType:(NSString *)accountType field:(NSString *)field startTime:(NSString *)startTime endTime:(NSString *)endTime freq:(NSString *)freq {
    WhuControlWebservice *sharedService = [WhuControlWebservice sharedService];
    NSArray *hisDataArray = [sharedService queryHisData:roomID accountType:accountType field:field startTime:startTime endTime:endTime freq:freq];
    return hisDataArray;
}
// 查询宿舍开关记录信息
+ (NSArray *)queryState:(NSString *)roomID accountType:(NSString *)accountType startTime:(NSString *)startTime endTime:(NSString *)endTime{
    WhuControlWebservice *sharedService = [WhuControlWebservice sharedService];
    NSArray *stateArray = [sharedService queryState:roomID accountType:accountType startTime:startTime endTime:endTime];
    return stateArray;
}
// 查询宿舍支出记录信息
+ (NSArray *)queryChargeBack:(NSString *)roomID accountType:(NSString *)accountType startTime:(NSString *)startTime endTime:(NSString *)endTime freq:(NSString *)freq {
    WhuControlWebservice *sharedService = [WhuControlWebservice sharedService];
    NSArray *chargeBackArray = [sharedService queryChargeBack:roomID accountType:accountType startTime:startTime endTime:endTime freq:freq];
    return chargeBackArray;
}
// 查询宿舍某个月充值消费总计
+ (NSDictionary *)queryBillMonth:(NSString *)roomID accountType:(NSString *)accountType year:(NSString *)year month:(NSString *)month{
    WhuControlWebservice *sharedService = [WhuControlWebservice sharedService];
    NSDictionary *billMonthDic = [sharedService queryBillMonth:roomID accountType:accountType year:year month:month];
    return billMonthDic;
}


+ (NSArray *)getAllSwitchDataWithSIDs:(NSArray *)SIDs{
    NSArray *sswitches = [[WhuControlWebservice sharedService] getAllSwitchDataWithSIDs:SIDs];
    
    return sswitches;
}
// 查询所有角色信息
+ (NSString *)queryRolesInfoWithID:(NSString *)userID password:(NSString *)password{
    WhuControlWebservice *sharedService = [WhuControlWebservice sharedService];
    NSString *rolesInfo = [sharedService queryRolesInfoWithID:userID password:password];
    return rolesInfo;
}


// 周用电历史
+ (NSArray *)queryWeekHistoryWithID:(NSString *)userID password:(NSString *)password stuID:(NSString *)stuID accountType:(NSString *)accountType{
    WhuControlWebservice *sharedService = [WhuControlWebservice sharedService];
    NSArray *weekHistoryArray = [sharedService queryWeekHistoryWithID:userID password:password stuID:stuID accountType:accountType];
    
    return weekHistoryArray;
}

// 修改密码
+ (NSString *)updatePWDWithID:(NSString *)userID password:(NSString *)password newPassword:(NSString *)newPassword role:(NSString *)role{
    WhuControlWebservice *sharedService = [WhuControlWebservice sharedService];
    [sharedService updatePWDWithID:userID password:password newPassword:newPassword role:role];
    return @"2";
}
// 插入控制命令
+ (NSString *)insertOrderWithID:(NSString *)userID password:(NSString *)password stuID:(NSString *)stuID accountType:(NSString *)accountType isOn:(NSNumber *)isOn{
    WhuControlWebservice *sharedService = [WhuControlWebservice sharedService];
    if ([isOn boolValue]) { // 打开
        [sharedService insertOrderWithID:stuID password:password stuID:stuID accountType:accountType orderID:onControlName];
    } else {
        [sharedService insertOrderWithID:stuID password:password stuID:stuID accountType:accountType orderID:offControlName];
    }
    return @"2";
}

// 插入用户申请
+ (NSString *)insertApplyWithID:(NSString *)userID password:(NSString *)password apply:(NSString *)applyInfo{
    WhuControlWebservice *sharedService = [WhuControlWebservice sharedService];
    [sharedService insertApplyWithID:userID password:password apply:applyInfo];
    return @"2";
}


///////////////////////
#pragma mark - 成员 方法
- (NSString *)logInWithID:(NSString *)userID password:(NSString *)password
{
    NSLog(@"=======同步请求开始 登陆======\n");
    
    NSMutableArray *arrMsg=[NSMutableArray array];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:userID,@"UserID", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:password,@"Password", nil]];
    
    NSArray *rootChilds = [self getWebServiceWithMethodName:logInMethodName soapMessage:arrMsg];
    //  NSLog(@"rootChilds is %@",rootChilds);
    if (!rootChilds) { // 如果为空 失败返回0
        return @"0";
    }
    NSString *userLimitNumber = [self convertLogDataFromArray:rootChilds];
    NSLog(@"=======同步请求结束======\n");
    return userLimitNumber;
}

// 检查学生是否具有控制开关的权限
- (NSString *)checkStu:(NSString *)stuID{
    NSLog(@"=======同步请求开始 检查学生是否具有控制开关的权限======\n");
    NSMutableArray *arrMsg=[NSMutableArray array];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:stuID,@"StudentID", nil]];
    
    NSArray *rootChilds = [self getWebServiceWithMethodName:checkStuName soapMessage:arrMsg];
    //    NSLog(@"rootChilds is %@",rootChilds);
    
    NSMutableString *studentControlLimit = [[NSMutableString alloc] init];
    if (!rootChilds) { // 如果为空
        studentControlLimit = (NSMutableString *)@"0";  // 返回没有控制权限
    } else {
        studentControlLimit = (NSMutableString *)[self convertCheckStuDataFromArray:rootChilds];
    }
    //    NSLog(@"result is %@",studentControlLimit);
    NSLog(@"=======同步请求结束======\n");
    return studentControlLimit;
}
// 查询用户信息
- (NSDictionary *)queryUserInfo:(NSString *)userID{
    NSLog(@"=======同步请求开始 查询用户信息======\n");
    NSMutableArray *arrMsg=[NSMutableArray array];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:userID,@"UserID", nil]];
    
    NSArray *rootChilds = [self getWebServiceWithMethodName:queryUserInfoName soapMessage:arrMsg];
    //    NSLog(@"rootChilds is %@",rootChilds);
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    if (!rootChilds) { // 如果为空
        //   userInfo = @"0";  // 返回没有控制权限
    } else {
        userInfo = (NSMutableDictionary *)[self convertUserInfoDataFromArray:rootChilds];
    }
    //    NSLog(@"result is %@",userInfo);
    NSLog(@"=======同步请求结束======\n");
    return (NSDictionary *)userInfo;
}
// 查询用电状态
- (NSDictionary *)queryChannelStat:(NSString *)roomID accountType:(NSString *)accountType{
    NSLog(@"=======同步请求开始 查询用电状态======\n");
    NSMutableArray *arrMsg=[NSMutableArray array];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:roomID,@"RoomID", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:accountType,@"AccountType", nil]];
    
    NSArray *rootChilds = [self getWebServiceWithMethodName:queryChannelStatName soapMessage:arrMsg];
    //NSLog(@"rootChilds is %@",rootChilds);
    NSMutableDictionary *channelState = [[NSMutableDictionary alloc] init];
    if (!rootChilds) { // 如果为空
        // do sth
    } else {
        channelState = (NSMutableDictionary *)[self convertChanelStatDataFromArray:rootChilds];
    }
    //NSLog(@"result is %@",channelState);
    NSLog(@"=======同步请求结束======\n");
    return channelState;
}
// 查询某间宿舍学生信息
- (NSArray *)queryRoom:(NSString *)roomID{
    NSLog(@"=======同步请求开始 查询某间宿舍学生信息======\n");
    
    NSMutableArray *arrMsg=[NSMutableArray array];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:roomID,@"RoomID", nil]];
    
    NSArray *rootChilds = [self getWebServiceWithMethodName:queryRoomName soapMessage:arrMsg];
    //   NSLog(@"rootChilds is %@",rootChilds);
    NSMutableArray *studentArr = [[NSMutableArray alloc] init];
    if (!rootChilds) { // 如果为空
        //     do sth
    } else {
        studentArr = (NSMutableArray *)[self convertRoomDataFromArray:rootChilds];
    }
    //NSLog(@"result is %@",studentArr);
    NSLog(@"=======同步请求结束======\n");
    return studentArr;
}
// 查询学生宿舍充值记录
- (NSArray *)queryRecharge:(NSString *)roomID accountType:(NSString *)accountType startTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSLog(@"=======同步请求开始 查询学生宿舍充值记录======\n");
    NSMutableArray *arrMsg=[NSMutableArray array];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:roomID,@"RoomID", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:accountType,@"AccountType", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:startTime,@"StartTime", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:endTime,@"EndTime", nil]];
    NSArray *rootChilds = [self getWebServiceWithMethodName:queryRechargeName soapMessage:arrMsg];
    
    //    NSLog(@"rootChilds is %@",rootChilds);
    NSMutableArray *rechargeArr = [[NSMutableArray alloc] init];
    if (!rootChilds) { // 如果为空
        // do sth
    } else {
        rechargeArr = (NSMutableArray *)[self convertRechargeDataFromArray:rootChilds];
    }
    //    NSLog(@"result is %@",rechargeArr);
    NSLog(@"=======同步请求结束======\n");
    return rechargeArr;
}
// 查询所有学生宿舍信息
- (NSArray *)queryBuilding{
    NSLog(@"=======同步请求开始 查询所有学生宿舍信息======\n");
    NSMutableArray *arrMsg=[NSMutableArray array];
    
    NSArray *rootChilds = [self getWebServiceWithMethodName:queryBuildingName soapMessage:arrMsg];
    //   NSLog(@"rootChilds is %@",rootChilds);
    if (!rootChilds) { // 如果为空
        return rootChilds;
    }
    
    NSArray *roomArray = [self convertBuildingDataFromArray:rootChilds];
    NSLog(@"=======同步请求结束======\n");
    return roomArray;
}
// 查询宿舍历史用电信息
- (NSArray *)queryHisData:(NSString *)roomID accountType:(NSString *)accountType field:(NSString *)field startTime:(NSString *)startTime endTime:(NSString *)endTime freq:(NSString *)freq {
    NSLog(@"=======同步请求开始 查询宿舍历史用电信息======\n");
    NSMutableArray *arrMsg=[NSMutableArray array];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:roomID,@"RoomID", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:accountType,@"AccountType", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:field,@"Field", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:startTime,@"StartTime", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:endTime,@"EndTime", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:freq,@"Freq", nil]];
    
    NSArray *rootChilds = [self getWebServiceWithMethodName:queryHisDataName soapMessage:arrMsg];
    //   NSLog(@"rootChilds is %@",rootChilds);
    if (!rootChilds) { // 如果为空
        return rootChilds;
    }
    
    NSArray *roomArray = [self convertHisDataFromArray:rootChilds];
    NSLog(@"=======同步请求结束======\n");
    return roomArray;
}
// 查询宿舍开关记录信息
- (NSArray *)queryState:(NSString *)roomID accountType:(NSString *)accountType  startTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSLog(@"=======同步请求开始 查询宿舍开关记录信息======\n");
    NSMutableArray *arrMsg=[NSMutableArray array];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:roomID,@"RoomID", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:accountType,@"AccountType", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:startTime,@"StartTime", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:endTime,@"EndTime", nil]];
    
    NSArray *rootChilds = [self getWebServiceWithMethodName:queryStateName soapMessage:arrMsg];
    //       NSLog(@"rootChilds is %@",rootChilds);
    if (!rootChilds) { // 如果为空
        return rootChilds;
    }
    
    NSArray *roomArray = [self convertStateDataFromArray:rootChilds];
    NSLog(@"=======同步请求结束======\n");
    return roomArray;
}
// 查询宿舍支出记录信息
- (NSArray *)queryChargeBack:(NSString *)roomID accountType:(NSString *)accountType startTime:(NSString *)startTime endTime:(NSString *)endTime freq:(NSString *)freq {
    NSLog(@"=======同步请求开始 查询宿舍支出记录信息======\n");
    NSMutableArray *arrMsg=[NSMutableArray array];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:roomID,@"RoomID", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:accountType,@"AccountType", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:freq,@"Freq", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:startTime,@"StartTime", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:endTime,@"EndTime", nil]];
    
    NSArray *rootChilds = [self getWebServiceWithMethodName:queryChargeBackName soapMessage:arrMsg];
    //           NSLog(@"rootChilds is %@",rootChilds);
    if (!rootChilds) { // 如果为空
        return rootChilds;
    }
    
    NSArray *roomArray = [self convertChargeBackDataFromArray:rootChilds];
    NSLog(@"=======同步请求结束======\n");
    return roomArray;
}

// 查询宿舍某个月充值消费总计
- (NSDictionary *)queryBillMonth:(NSString *)roomID accountType:(NSString *)accountType year:(NSString *)year month:(NSString *)month{
    NSLog(@"=======同步请求开始 查询宿舍某个月充值消费总计======\n");
    NSMutableArray *arrMsg=[NSMutableArray array];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:roomID,@"RoomID", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:accountType,@"AccountType", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:year,@"Year", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:month,@"Month", nil]];
    
    NSArray *rootChilds = [self getWebServiceWithMethodName:queryBillMonthName soapMessage:arrMsg];
    NSMutableDictionary *billMonth = [[NSMutableDictionary alloc] init];
    //    NSLog(@"rootChilds is %@",rootChilds);
    if (!rootChilds) { // 如果为空
        // do sth
    }else {
        billMonth = (NSMutableDictionary *)[self convertBillMonthDataFromArray:rootChilds];
    }
    NSLog(@"=======同步请求结束======\n");
    return billMonth;
}
//// 查询宿舍某个月充值消费总计
//- (NSDictionary *)queryBillMonth:(NSString *)roomID accountType:(NSString *)accountType year:(NSString *)year month:(NSString *)month{
//    NSLog(@"=======同步请求开始 查询宿舍某个月充值消费总计======\n");
//    NSMutableArray *arrMsg=[NSMutableArray array];
//    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:roomID,@"RoomID", nil]];
//    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:accountType,@"AccountType", nil]];
//    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:year,@"Year", nil]];
//    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:month,@"Month", nil]];
//
//    NSArray *rootChilds = [self getWebServiceWithMethodName:queryBillMonthName soapMessage:arrMsg];
//    //    NSLog(@"rootChilds is %@",rootChilds);
//    if (!rootChilds) { // 如果为空
//        return rootChilds;
//    }
//
//    NSArray *billMonthArray = [self convertBillMonthDataFromArray:rootChilds];
//    NSLog(@"=======同步请求结束======\n");
//    return billMonthArray;
//}




/**
 * 获取开关的数据，返回值为 开关的字典数组
 **/
- (NSArray *)getAllSwitchDataWithSIDs:(NSArray *)SIDs
{
    NSLog(@"%s begining",__PRETTY_FUNCTION__);
    NSMutableArray *channelData = [[NSMutableArray alloc] initWithCapacity:30];
    
    NSLog(@"=======同步请求开始 获取开关数据======\n");
    
    for (NSString *SID in SIDs) {
        
        for (int intCID = 1; intCID < 11; intCID++) {
            NSString *CID =[NSString stringWithFormat:@"%d",intCID];
            
            NSMutableArray *arr=[NSMutableArray array];
            [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:SID,@"Sid", nil]];
            [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:CID,@"Cid", nil]];
            //      [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"MACAddr,Cname,Ctype,Rname,Iconnumber,Maxi,Uv,Ov,Vrate,Irate",@"Properties", nil]];
            [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"MACAddr,IPAddr,SSID,Cname,Ctype,Rname,Iconnumber,Maxi,Uv,Ov,Vrate,Irate",@"Properties", nil]];
            
            NSArray *rootChilds = [self getWebServiceWithMethodName:getSRLCDataName soapMessage:arr];
            // webservice 数据修正，待数据库数据好了后 修改
            NSMutableDictionary *aDic = (NSMutableDictionary *)[self convertDataFromArray:rootChilds];
            //      [aDic setObject:@"192.168.1.103" forKey:@"IPAddr"];
            //       [aDic setObject:@"TP-LINK_511" forKey:@"SSID"];
            
            [channelData addObject:aDic];
        }
        
    }
    NSLog(@"=======同步请求结束======\n");
    //   NSLog(@"channel data is %@",channelData);
    
    return channelData;
}
// 查询所有角色信息
- (NSString *)queryRolesInfoWithID:(NSString *)userID password:(NSString *)password
{
    NSLog(@"=======同步请求开始 获取角色信息======\n");
    
    NSMutableArray *arrMsg=[NSMutableArray array];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:userID,@"UserID", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:password,@"Password", nil]];
    
    NSArray *rootChilds = [self getWebServiceWithMethodName:queryInfoName soapMessage:arrMsg];
    //    NSLog(@"rootChilds is %@",rootChilds);
    if (!rootChilds) { // 如果为空
        return @"2";  // 返回学生用户
    }
    
    NSLog(@"=======同步请求结束======\n");
    
    return @"2";
}


// 周用电历史
- (NSArray *)queryWeekHistoryWithID:(NSString *)userID password:(NSString *)password stuID:(NSString *)stuID accountType:(NSString *)accountType{
    NSLog(@"=======同步请求开始 周用电历史======\n");
    
    NSMutableArray *arrMsg=[NSMutableArray array];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:stuID,@"StudentID", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:accountType,@"AccountType", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:userID,@"UserID", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:password,@"Password", nil]];
    
    NSArray *rootChilds = [self getWebServiceWithMethodName:queryWeekHistoryName soapMessage:arrMsg];
    //  NSLog(@"rootChilds is %@",rootChilds);
    if (!rootChilds) { // 如果为空
        return rootChilds;
    }
    
    NSArray *weekHistoryArray = [self convertWeekHistoryDataFromArray:rootChilds];
    NSLog(@"=======同步请求结束======\n");
    return weekHistoryArray;
}
// 修改密码
- (NSString *)updatePWDWithID:(NSString *)userID password:(NSString *)password newPassword:(NSString *)newPassword role:(NSString *)role{
    NSLog(@"=======同步请求开始 修改密码======\n");
    
    NSMutableArray *arrMsg=[NSMutableArray array];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:userID,@"UserID", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:password,@"Password", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:newPassword,@"New_Password", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:role,@"Role", nil]];
    
    NSArray *rootChilds = [self getWebServiceWithMethodName:updatePWDName soapMessage:arrMsg];
    //   NSLog(@"rootChilds is %@",rootChilds);
    if (!rootChilds) { // 如果为空
        return @"0"; // 返回失败
    }
    
    //   NSString *userLimitNumber = [self convertLogDataFromArray:rootChilds];
    NSLog(@"=======同步请求结束======\n");
    return @"2";
}
// 插入控制命令
- (NSString *)insertOrderWithID:(NSString *)userID password:(NSString *)password stuID:(NSString *)stuID accountType:(NSString *)accountType orderID:(NSString *)orderID{
    NSLog(@"=======同步请求开始 插入控制命令======\n");
    
    NSMutableArray *arrMsg=[NSMutableArray array];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:userID,@"UserID", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:password,@"Password", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:stuID,@"StudentID", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:accountType,@"AccountType", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:orderID,@"OrderID", nil]];
    
    NSArray *rootChilds = [self getWebServiceWithMethodName:insertOrderName soapMessage:arrMsg];
    //   NSLog(@"rootChilds is %@",rootChilds);
    if (!rootChilds) { // 如果为空
        return @"0";  // 返回失败
    }
    
    //   NSString *userLimitNumber = [self convertLogDataFromArray:rootChilds];
    NSLog(@"=======同步请求结束======\n");
    return @"2";
}

// 插入用户申请
- (NSString *)insertApplyWithID:(NSString *)userID password:(NSString *)password apply:(NSString *)applyInfo{
    NSLog(@"=======同步请求开始 插入用户申请======\n");
    
    NSMutableArray *arrMsg=[NSMutableArray array];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:userID,@"UserID", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:password,@"Password", nil]];
    [arrMsg addObject:[NSDictionary dictionaryWithObjectsAndKeys:applyInfo,@"Application", nil]];
    
    
    NSArray *rootChilds = [self getWebServiceWithMethodName:insertApplyName soapMessage:arrMsg];
    //  NSLog(@"rootChilds is %@",rootChilds);
    if (!rootChilds) { // 如果为空
        return @"0"; // 返回失败
    }
    
    //   NSString *userLimitNumber = [self convertLogDataFromArray:rootChilds];
    NSLog(@"=======同步请求结束======\n");
    return @"2";
}


/**
 * 将 登陆 返回的初步解析的数据 再解析为字典数组
 **/
- (NSString *)convertLogDataFromArray:(NSArray *)rootchilds
{
    NSMutableDictionary *dataDic= [rootchilds objectAtIndex:0];
    NSString *retunNumber = [dataDic objectForKey:baseName];
    
    /*   dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
     dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
     
     for (NSArray *aArr in [dataDic allValues]) {
     NSDictionary *aDic = [aArr objectAtIndex:0];
     
     NSMutableDictionary *returnDic = [NSMutableDictionary dictionary];
     for (NSString *aKey in [aDic allKeys]) {
     [returnDic setObject:[[[aDic objectForKey:aKey] objectAtIndex:0] objectForKey:baseName] forKey:aKey];
     }
     [returnArray addObject:returnDic];
     }*/
    
    return retunNumber;
}
- (NSString *)convertCheckStuDataFromArray:(NSArray *)rootchilds{
    NSMutableDictionary *dataDic= [rootchilds objectAtIndex:0];
    NSString *retunNumber = [dataDic objectForKey:baseName];
    return retunNumber;
}
- (NSDictionary *)convertUserInfoDataFromArray:(NSArray *)rootchilds{
    NSMutableDictionary *dataDic= [rootchilds objectAtIndex:1];
    if ([[[dataDic allValues] objectAtIndex:0] isKindOfClass:[NSString class]]) { // 返回的数组为空值 则该处为 字符串类型 判断出来 返回空数组
        return nil;
    }
    dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
    dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
    dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    NSArray *userInfoKeys = [dataDic allKeys];
    for (NSString *aKey in userInfoKeys) {
        if ([[dataDic objectForKey:aKey] isKindOfClass:[NSArray class]]) { // 如果属性不为空
            NSString *aContent = [[[dataDic objectForKey:aKey] objectAtIndex:0] objectForKey:baseName];
            [userInfo setObject:aContent forKey:aKey];
        } else {
            [userInfo setObject:@"" forKey:aKey];
        }
    }
    return (NSDictionary *)userInfo;
}
- (NSDictionary *)convertChanelStatDataFromArray:(NSArray *)rootchilds{
    NSMutableDictionary *dataDic= [rootchilds objectAtIndex:1];
    if ([[[dataDic allValues] objectAtIndex:0] isKindOfClass:[NSString class]]) { // 返回的数组为空值 则该处为 字符串类型 判断出来 返回空数组
        return nil;
    }
    dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
    dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
    dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
    
    NSMutableDictionary *channelState = [[NSMutableDictionary alloc] init];
    NSArray *channelStateKeys = [dataDic allKeys];
    for (NSString *aKey in channelStateKeys) {
        if ([[dataDic objectForKey:aKey] isKindOfClass:[NSArray class]]) { // 如果属性不为空
            NSString *aContent = [[[dataDic objectForKey:aKey] objectAtIndex:0] objectForKey:baseName];
            [channelState setObject:aContent forKey:aKey];
        } else {
            [channelState setObject:@"" forKey:aKey];
        }
    }
    return (NSDictionary *)channelState;
}
- (NSArray *)convertRoomDataFromArray:(NSArray *)rootchilds{
    NSMutableDictionary *dataDic= [rootchilds objectAtIndex:1];
    if ([[[dataDic allValues] objectAtIndex:0] isKindOfClass:[NSString class]]) { // 返回的数组为空值 则该处为 字符串类型 判断出来 返回空数组
        return nil;
    }
    dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
    dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
    
    NSMutableArray *students = [[NSMutableArray alloc] init];
    for (NSArray *aArr in [dataDic allValues]) {
        NSDictionary *aDic = [aArr objectAtIndex:0];
        NSMutableDictionary *aStudent = [[NSMutableDictionary alloc] init];
        NSArray *studentKeys = [aDic allKeys];
        for (NSString *aKey in studentKeys) {
            if ([[aDic objectForKey:aKey] isKindOfClass:[NSArray class]]) { // 如果属性不为空
                NSString *aContent = [[[aDic objectForKey:aKey] objectAtIndex:0] objectForKey:baseName];
                [aStudent setObject:aContent forKey:aKey];
            } else {
                [aStudent setObject:@"" forKey:aKey];
            }
        }
        [students addObject:aStudent];
    }
    return (NSArray *)students;
}

- (NSArray *)convertRechargeDataFromArray:(NSArray *)rootchilds{
    NSMutableDictionary *dataDic= [rootchilds objectAtIndex:1];
    if ([[[dataDic allValues] objectAtIndex:0] isKindOfClass:[NSString class]]) { // 返回的数组为空值 则该处为 字符串类型 判断出来 返回空数组
        return nil;
    }
    //    NSLog(@"datadic is :%@ value is%@ value count:%d",dataDic,[dataDic allValues],[[[dataDic allValues] objectAtIndex:0] isKindOfClass:[NSString class]] );
    dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
    dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
    NSMutableArray *recharges = [[NSMutableArray alloc] init];
    for (NSArray *aArr in [dataDic allValues]) {
        NSDictionary *aDic = [aArr objectAtIndex:0];
        NSMutableDictionary *aRecharge = [[NSMutableDictionary alloc] init];
        NSArray *rechargeKeys = [aDic allKeys];
        for (NSString *aKey in rechargeKeys) {
            if ([[aDic objectForKey:aKey] isKindOfClass:[NSArray class]]) { // 如果属性不为空
                NSString *aContent = [[[aDic objectForKey:aKey] objectAtIndex:0] objectForKey:baseName];
                [aRecharge setObject:aContent forKey:aKey];
            } else {
                [aRecharge setObject:@"" forKey:aKey];
            }
        }
        [recharges addObject:aRecharge];
    }
    return (NSArray *)recharges;
}
- (NSArray *)convertBuildingDataFromArray:(NSArray *)rootchilds{
    NSMutableDictionary *dataDic= [rootchilds objectAtIndex:1];
    if ([[[dataDic allValues] objectAtIndex:0] isKindOfClass:[NSString class]]) { // 返回的数组为空值 则该处为 字符串类型 判断出来 返回空数组
        return nil;
    }
    dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
    dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
    
    NSMutableArray *rooms = [[NSMutableArray alloc] init];
    for (NSArray *aArr in [dataDic allValues]) {
        NSDictionary *aDic = [aArr objectAtIndex:0];
        NSMutableDictionary *aRoom = [[NSMutableDictionary alloc] init];
        NSArray *keys = [aDic allKeys];
        for (NSString *aKey in keys) {
            if ([[aDic objectForKey:aKey] isKindOfClass:[NSArray class]]) { // 如果属性不为空
                NSString *aContent = [[[aDic objectForKey:aKey] objectAtIndex:0] objectForKey:baseName];
                [aRoom setObject:aContent forKey:aKey];
            } else {
                [aRoom setObject:@"" forKey:aKey];
            }
        }
        [rooms addObject:aRoom];
    }
    return (NSArray *)rooms;
}
- (NSArray *)convertHisDataFromArray:(NSArray *)rootchilds{
    NSMutableDictionary *dataDic= [rootchilds objectAtIndex:1];
    if ([[[dataDic allValues] objectAtIndex:0] isKindOfClass:[NSString class]]) { // 返回的数组为空值 则该处为 字符串类型 判断出来 返回空数组
        return nil;
    }
    dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
    dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
    
    NSMutableArray *hisDatas = [[NSMutableArray alloc] init];
    for (NSArray *aArr in [dataDic allValues]) {
        NSDictionary *aDic = [aArr objectAtIndex:0];
        NSMutableDictionary *aHisData = [[NSMutableDictionary alloc] init];
        NSArray *roomKeys = [aDic allKeys];
        for (NSString *aKey in roomKeys) {
            if ([[aDic objectForKey:aKey] isKindOfClass:[NSArray class]]) { // 如果属性不为空
                NSString *aContent = [[[aDic objectForKey:aKey] objectAtIndex:0] objectForKey:baseName];
                [aHisData setObject:aContent forKey:aKey];
            } else {
                [aHisData setObject:@"" forKey:aKey];
            }
        }
        [hisDatas addObject:aHisData];
    }
    return (NSArray *)hisDatas;
}
- (NSArray *)convertStateDataFromArray:(NSArray *)rootchilds{
    NSMutableDictionary *dataDic= [rootchilds objectAtIndex:1];
    if ([[[dataDic allValues] objectAtIndex:0] isKindOfClass:[NSString class]]) { // 返回的数组为空值 则该处为 字符串类型 判断出来 返回空数组
        return nil;
    }
    dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
    dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
    
    NSMutableArray *stateDatas = [[NSMutableArray alloc] init];
    for (NSArray *aArr in [dataDic allValues]) {
        NSDictionary *aDic = [aArr objectAtIndex:0];
        NSMutableDictionary *aHisData = [[NSMutableDictionary alloc] init];
        NSArray *roomKeys = [aDic allKeys];
        for (NSString *aKey in roomKeys) {
            if ([[aDic objectForKey:aKey] isKindOfClass:[NSArray class]]) { // 如果属性不为空
                NSString *aContent = [[[aDic objectForKey:aKey] objectAtIndex:0] objectForKey:baseName];
                [aHisData setObject:aContent forKey:aKey];
            } else {
                [aHisData setObject:@"" forKey:aKey];
            }
        }
        [stateDatas addObject:aHisData];
    }
    return (NSArray *)stateDatas;
}
- (NSArray *)convertChargeBackDataFromArray:(NSArray *)rootchilds{
    NSMutableDictionary *dataDic= [rootchilds objectAtIndex:1];
    if ([[[dataDic allValues] objectAtIndex:0] isKindOfClass:[NSString class]]) { // 返回的数组为空值 则该处为 字符串类型 判断出来 返回空数组
        return nil;
    }
    dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
    dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
    
    NSMutableArray *chargeBacksDatas = [[NSMutableArray alloc] init];
    for (NSArray *aArr in [dataDic allValues]) {
        NSDictionary *aDic = [aArr objectAtIndex:0];
        NSMutableDictionary *aHisData = [[NSMutableDictionary alloc] init];
        NSArray *roomKeys = [aDic allKeys];
        for (NSString *aKey in roomKeys) {
            if ([[aDic objectForKey:aKey] isKindOfClass:[NSArray class]]) { // 如果属性不为空
                NSString *aContent = [[[aDic objectForKey:aKey] objectAtIndex:0] objectForKey:baseName];
                [aHisData setObject:aContent forKey:aKey];
            } else {
                [aHisData setObject:@"" forKey:aKey];
            }
        }
        [chargeBacksDatas addObject:aHisData];
    }
    return (NSArray *)chargeBacksDatas;
}
// 查询宿舍某个月充值消费总计
- (NSDictionary *)convertBillMonthDataFromArray:(NSArray *)rootchilds{
    NSMutableDictionary *dataDic= [rootchilds objectAtIndex:1];
    if ([[[dataDic allValues] objectAtIndex:0] isKindOfClass:[NSString class]]) { // 返回的数组为空值 则该处为 字符串类型 判断出来 返回空数组
        return nil;
    }
    dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
    dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
    dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
    
    NSMutableDictionary *channelState = [[NSMutableDictionary alloc] init];
    NSArray *channelStateKeys = [dataDic allKeys];
    for (NSString *aKey in channelStateKeys) {
        if ([[dataDic objectForKey:aKey] isKindOfClass:[NSArray class]]) { // 如果属性不为空
            NSString *aContent = [[[dataDic objectForKey:aKey] objectAtIndex:0] objectForKey:baseName];
            [channelState setObject:aContent forKey:aKey];
        } else {
            [channelState setObject:@"" forKey:aKey];
        }
    }
    return (NSDictionary *)channelState;
    
}
//// 查询宿舍某个月充值消费总计
//- (NSArray *)convertBillMonthDataFromArray:(NSArray *)rootchilds{
//    NSMutableDictionary *dataDic= [rootchilds objectAtIndex:1];
//    if ([[[dataDic allValues] objectAtIndex:0] isKindOfClass:[NSString class]]) { // 返回的数组为空值 则该处为 字符串类型 判断出来 返回空数组
//        return nil;
//    }
//    dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
//    dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
//
//    NSMutableArray *chargeBacksDatas = [[NSMutableArray alloc] init];
//    for (NSArray *aArr in [dataDic allValues]) {
//        NSDictionary *aDic = [aArr objectAtIndex:0];
//        NSMutableDictionary *aHisData = [[NSMutableDictionary alloc] init];
//        NSArray *roomKeys = [aDic allKeys];
//        for (NSString *aKey in roomKeys) {
//            if ([[aDic objectForKey:aKey] isKindOfClass:[NSArray class]]) { // 如果属性不为空
//                NSString *aContent = [[[aDic objectForKey:aKey] objectAtIndex:0] objectForKey:baseName];
//                [aHisData setObject:aContent forKey:aKey];
//            } else {
//                [aHisData setObject:@"" forKey:aKey];
//            }
//        }
//        [chargeBacksDatas addObject:aHisData];
//    }
//    return (NSArray *)chargeBacksDatas;
//}


- (NSArray *)convertWeekHistoryDataFromArray:(NSArray *)rootchilds{
    NSMutableDictionary *dataDic= [rootchilds objectAtIndex:1];
    dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
    dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:2];
    
    for (NSArray *aArr in [dataDic allValues]) {
        NSDictionary *aDic = [aArr objectAtIndex:0];
        NSString *returnStr = [[[[aDic allValues] objectAtIndex:2] objectAtIndex:0] objectForKey:baseName];
        [returnArray addObject:returnStr];
    }
    // 排序数组
    NSMutableArray *sortArray = [[NSMutableArray alloc] initWithCapacity:30];
    NSInteger arrayCount = [returnArray count];
    for (int i = 0; i<arrayCount; i++) {
        [sortArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[returnArray objectAtIndex:i], @"content", [[dataDic allKeys] objectAtIndex:i], @"name", nil]];
    }
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *resultArray = [sortArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sorter, nil]];
    
    for (int i = 0; i<arrayCount; i++) {
        [returnArray setObject:[[resultArray objectAtIndex:i] objectForKey:@"content"]  atIndexedSubscript:i];
    }
    //    NSLog(@"returnarray is %@",returnArray);
    return [NSArray arrayWithArray:returnArray];
}

- (NSArray *)convertUpdatePWDDataFromArray:(NSArray *)rootchilds{
    return [NSArray arrayWithObject:@"0"];
}
- (NSArray *)convertInsertOrderDataFromArray:(NSArray *)rootchilds{
    return [NSArray arrayWithObject:@"0"];
}


- (NSArray *)convertInsertApplyDataFromArray:(NSArray *)rootchilds{
    return [NSArray arrayWithObject:@"0"];
}



/**
 * 将 请求开关数据 返回的初步解析的数据 再解析为字典数组
 **/
- (NSDictionary *)convertDataFromArray:(NSArray *)rootchilds
{
    NSMutableDictionary *dataDic= [rootchilds objectAtIndex:1];
    for (int i = 0; i < 3; i++) {
        dataDic = [[[dataDic allValues] objectAtIndex:0] objectAtIndex:0];
    }
    NSMutableDictionary *returnDic = [NSMutableDictionary dictionary];
    
    for (NSString *aKey in [dataDic allKeys]) {
        [returnDic setObject:[[[dataDic objectForKey:aKey] objectAtIndex:0] objectForKey:baseName] forKey:aKey];
    }
    return (NSDictionary *)returnDic;
}

/**
 * 通过WebService传递方法名和参数向公司网站请求数据
 **/
- (NSArray *)getWebServiceWithMethodName:(NSString *)methodName soapMessage:(NSArray *)arr
{
    // 用SOAP封装 webservice请求
    NSString *soapMsg=[self arrayToSoapMessage:arr methodName:methodName];
    //ASIHTTP 同步请求 信息
    NSArray *requestArray = [self getSyncRequestWithMethodName:methodName soapMessage:soapMsg];
    //   NSLog(@"request Array is %@",requestArray);
    return requestArray;
}

#pragma mark - 生成 SoapMessage
- (NSString*)arrayToSoapMessage:(NSArray*)arr methodName:(NSString*)methodName{
    
    NSMutableString *soap=[NSMutableString stringWithFormat:@"<%@ xmlns=\"%@\">",methodName,defaultNameSpace];
    for (NSDictionary *item in arr) {
        NSString *key=[[item allKeys] objectAtIndex:0];
        [soap appendFormat:@"<%@>",key];
        [soap appendString:[item objectForKey:key]];
        [soap appendFormat:@"</%@>",key];
    }
    [soap appendFormat:@"</%@>",methodName];
    
    NSString *soapBody=@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
    "<soap:Body>%@</soap:Body>"
    "</soap:Envelope>";
    
    NSString *soapResult = [NSString stringWithFormat:soapBody,soap];
    
    //   NSLog(@"%s request xml is %@",__PRETTY_FUNCTION__, soapResult);
    return soapResult;
}

#pragma mark - 同步ASIHTTP请求

- (NSArray *)getSyncRequestWithMethodName:(NSString *)methodName soapMessage:(NSString *)soapMsg
{
    NSString *webServiceUrl = defaultWebServiceUrl;
    
    NSString *nameSpace = defaultNameSpace;
    
    if (self.httpRequest.delegate) {
        [self.httpRequest setDelegate:nil];
    }
    [self.httpRequest cancel];
    NSURL *webUrl=[NSURL URLWithString:webServiceUrl];
    //   NSLog(@"url is %@\n converturl is %@\n soap message is %@",webServiceUrl,webUrl,soapMsg);
    
    
    [self setHttpRequest:[ASIHTTPRequest requestWithURL:webUrl]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
    
    //以下对请求信息添加属性前四句是必有的，第五句是soap信息。
    
    //   NSLog(@"weburl host is %@ msglength is %@",[webUrl host],msgLength);
    //   [self.httpRequest addRequestHeader:@"Host" value:[webUrl host]];
    [self.httpRequest addRequestHeader:@"Host" value:[webUrl host]];
    [self.httpRequest addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [self.httpRequest addRequestHeader:@"Content-Length" value:msgLength];
    [self.httpRequest addRequestHeader:@"SOAPAction" value:[NSString stringWithFormat:@"%@%@",nameSpace,methodName]];
    [self.httpRequest setRequestMethod:@"POST"];
    //设置用户信息
    [self.httpRequest setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:methodName,@"name", nil]];
    //传soap信息
    [self.httpRequest appendPostData:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    [self.httpRequest setValidatesSecureCertificate:NO];
    [self.httpRequest setTimeOutSeconds:30.0];//表示30秒请求超时
    [self.httpRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    
    //设置同步
    [self.httpRequest startSynchronous];
    //处理返回的结果
    
    
    NSArray *resultArray = [self soapResultArray:self.httpRequest];
    return resultArray;
}

#pragma mark 对于返回soap信息的处理
/********对于返回soap信息的处理**********/
-(NSArray *)soapResultArray:(ASIHTTPRequest*)request{
    int statusCode = [request responseStatusCode];
    NSError *error=[request error];
    //如果发生错误，就返回空
    if (error||statusCode!=200) {
        NSString *errorInfo = [NSString stringWithFormat:@"error statusCode is %d",statusCode];
        NSLog(@"%@",errorInfo);
        return nil;
    }
    NSString *soapAction=[[request requestHeaders] objectForKey:@"SOAPAction"];
    NSString *methodName=@"";
    NSRange range = [soapAction  rangeOfString:@"/" options:NSBackwardsSearch];
    if(range.location!=NSNotFound){
        int pos=range.location;
        methodName=[soapAction stringByReplacingCharactersInRange:NSMakeRange(0, pos+1) withString:@""];
    }
    // Use when fetching text data
    NSString *responseString = [request responseString];
    //    NSLog(@"respone string is %@",responseString);
    
    error=nil;
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:responseString options:0 error:&error];
    if (error) {
        return nil;
    }
    
    GDataXMLElement* rootNode = [document rootElement];
    NSString *searchStr=[NSString stringWithFormat:@"%@Result",methodName];
    NSArray *result=[rootNode children];
    //   NSLog(@"result is %@",result);
    
    // 找出methodNameResult所在的GDataXMLNode数组
    while ([result count] > 0) {
        NSString *nodeName=[[result objectAtIndex:0] name];
        if ([nodeName isEqualToString: searchStr]) {
            result=[[result objectAtIndex:0] children];
            
            break;
            
        }
        result=[[result objectAtIndex:0] children];
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    for (GDataXMLNode *node in result) {
        //   NSLog(@"node is %@",node);
        NSString *nodeName=node.name;
        if ([node.children count]>0) {
            //  NSLog(@" > 0count is %lu",(unsigned long)[node.children count]);
            //  NSLog(@"nodename is %@ nodechild is %d",nodeName,[node.children count]);
            [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[self nodeChilds:node],nodeName, nil]];
        }else{
            //   NSLog(@"count is %lu",(unsigned long)[node.children count]);
            
            //      NSLog(@"nodename is %@ value is %@",nodeName,[node stringValue]);
            [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[node stringValue],nodeName, nil]];
        }
    }
    return arr;
}

- (NSArray *)nodeChilds:(GDataXMLNode*)node{
    // 因为字典同名不能存在所以需要更改名字
    NSMutableArray *arr=[NSMutableArray array];
    NSArray *childs=[node children];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    NSMutableString *firstNodeName = [[NSMutableString alloc] init];
    int enterCount = 0;
    
    for (GDataXMLNode* child in childs){
        enterCount++;
        NSMutableString *nodeName = (NSMutableString *)child.name;//获取节点名称
        if(enterCount == 1) { // 第一次进入
            firstNodeName = [NSMutableString stringWithString:nodeName];
        } else {
            if([nodeName isEqualToString:firstNodeName]) {
                nodeName = [NSMutableString stringWithFormat:@"%@%d",nodeName,enterCount];
            }
        }
        
        NSArray  *childNode=[child children];
        if ([childNode count]>0) {//存在子节点
            [dic setValue:[self nodeChilds:child] forKey:nodeName];
        }else{
            [dic setValue:[child stringValue] forKey:nodeName];
        }
    }
    [arr addObject:dic];
    
    return (NSArray *)arr;
}


@end
