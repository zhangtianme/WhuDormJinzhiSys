//
//  DormInfoViewController.m
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/3/19.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import "DormInfoViewController.h"
#import "DormTypeViewController.h"
#import "MacroDefinition.h"


@interface DormInfoViewController ()<UIScrollViewDelegate> {
    DormTypeViewController *dormAirCon;     // 空调子视图
    DormTypeViewController *dormLighting;   // 照明子视图
    MBProgressHUD *mbHud;
    StudentAccount *manager; // 账户管理
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation DormInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"doeminfo view did load");
    // Do any additional setup after loading the view.

    // 导航条添加 segment control
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[airConName, lightingName]];
    [self.segmentedControl setFrame:CGRectMake(96, 7, 128, 30)];  //
    [self.segmentedControl setSelectedSegmentIndex:0]; // 选择第一项
    [self.navigationItem setTitleView:self.segmentedControl];
    [self.navigationItem setHidesBackButton:YES];
    
    //
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = self.view.frame.size.height - 20 - 44;
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged]; // 添加分段选择触发函数
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)]; //20+44+40 (status+nav+segcontrol)
    self.scrollView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(2*viewWidth, viewHeight);
    self.scrollView.delegate = self;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, viewWidth, viewHeight) animated:YES];
    [self.view addSubview:self.scrollView];
    
    // 空调照明 俩个控制器
    dormAirCon = [self.storyboard instantiateViewControllerWithIdentifier:dormAirConIdentity];
    dormAirCon.accountType = airConName;
    dormLighting = [self.storyboard instantiateViewControllerWithIdentifier:dormLightingIdentity];
    dormLighting.accountType = lightingName;
    
    //dorm airconditioner list
    dormAirCon.view.frame = CGRectMake(0, 0, viewWidth, viewHeight );
    [dormAirCon willMoveToParentViewController:self];
    [self.scrollView addSubview:dormAirCon.view];
    [self addChildViewController:dormAirCon];
    [dormAirCon didMoveToParentViewController:self];
    
    //dorm lighting list
    dormLighting.view.frame = CGRectMake(viewWidth, 0, viewWidth, viewHeight);
    [dormLighting willMoveToParentViewController:self];
    [self.scrollView addSubview:dormLighting.view];
    [self addChildViewController:dormLighting];
    [dormLighting didMoveToParentViewController:self];
    

    manager = [StudentAccount sharedStudentAccount];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)requestTimeout:(UISwitch *)sender
{
    NSLog(@"changestate");
    // 没有收到数据 显示错误指示2秒钟
    [mbHud showWithTitle:@"错误" detail:@"请求失败，请确认网络连接状态是否正常"];
    [mbHud hide:YES afterDelay:1];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!mbHud) {  // 初始化指示器
        mbHud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        
        [self.navigationController.view addSubview:mbHud];
        mbHud.dimBackground = YES;
    }
    [mbHud showWithTitle:@"Loading..." detail:nil];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"info view did appear");

    [self performSelector:@selector(requestTimeout:) withObject:nil afterDelay:timeoutRequest];// 5秒的超时

    // 加了block 才能在block里面有写的权限
    __block NSString *controlLimit = [[NSString alloc] init]; //
    __block NSDictionary *userInfo = [[NSDictionary alloc] init]; //
    __block NSDictionary *airConChannelState = [[NSDictionary alloc] init];
    __block NSDictionary *lightChannelState = [[NSDictionary alloc] init];
    __block NSArray *students = [[NSArray alloc] init];

    // 异步线程调用接口
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        // 检查学生是否具有控制开关的权限 0/1
        controlLimit = [WhuControlWebservice checkStu:manager.stuID];
        [self getDataFromControlLimit:controlLimit];
        NSLog(@"limit %@",controlLimit);
        // 查询学生信息
        userInfo = [WhuControlWebservice queryUserInfo:manager.stuID];
        [self getDataFromUserInfo:userInfo];
        // 查询空调用电状态
        airConChannelState = [WhuControlWebservice queryChannelStat:manager.roomID accountType:airConName];
        [self getDataFromChannelState:airConChannelState accountType:airConName];
        // 查询照明用电状态
        lightChannelState = [WhuControlWebservice queryChannelStat:manager.roomID accountType:lightingName];
        [self getDataFromChannelState:lightChannelState accountType:lightingName];
        // 查询某间宿舍学生信息
        students = [WhuControlWebservice queryRoom:manager.roomID];
        [self getDataFromStudents:students];
        // 返回主线程 处理结果
        dispatch_sync(dispatch_get_main_queue(), ^{
            [mbHud hide:YES];
            [NSObject cancelPreviousPerformRequestsWithTarget:self]; // 取消前面的定时函数
            NSLog(@"deal with finish");
            // 更新界面
            [dormAirCon updateInterfaceWithWebserviceData];
            [dormLighting updateInterfaceWithWebserviceData];

        });
    });

}
- (void)getDataFromControlLimit:(NSString *)controlLimit {
    manager.controlLimit = controlLimit;
}

- (void)getDataFromUserInfo:(NSDictionary *)userInfo {
    NSArray *allKeys = [userInfo allKeys];
    if ([allKeys containsObject:roomIDName]) manager.roomID = [userInfo valueForKey:roomIDName];
    if ([allKeys containsObject:facultyName]) manager.faculty = [userInfo valueForKey:facultyName];
    if ([allKeys containsObject:professionalName]) manager.professional = [userInfo valueForKey:professionalName];
    if ([allKeys containsObject:roleName]) manager.role = [userInfo valueForKey:roleName];
    if ([allKeys containsObject:stuNameName]) manager.stuName = [userInfo valueForKey:stuNameName];
    
    if ([allKeys containsObject:areaName]) manager.area = [userInfo valueForKey:areaName];
    if ([allKeys containsObject:buildingName]) manager.building = [userInfo valueForKey:buildingName];
    if ([allKeys containsObject:unitName]) manager.unit = [userInfo valueForKey:unitName];
    if ([allKeys containsObject:roomNumName]) manager.roomNum = [userInfo valueForKey:roomNumName];
    
    if ([allKeys containsObject:subsidyDegreeAirConName]) manager.subsidyDegreeAirCon = [userInfo valueForKey:subsidyDegreeAirConName];
    if ([allKeys containsObject:chargebackDegreeAirConName]) manager.chargebackDegreeAirCon = [userInfo valueForKey:chargebackDegreeAirConName];
    if ([allKeys containsObject:chargebackAirConName]) manager.chargebackAirCon = [userInfo valueForKey:chargebackAirConName];
    if ([allKeys containsObject:subsidyAirConName]) manager.subsidyAirCon = [userInfo valueForKey:subsidyAirConName];
    if ([allKeys containsObject:priceAirConName]) manager.priceAirCon = [userInfo valueForKey:priceAirConName];
    if ([allKeys containsObject:subsidyDegreeLightName]) manager.subsidyDegreeLight = [userInfo valueForKey:subsidyDegreeLightName];
    if ([allKeys containsObject:chargebackDegreeLightName]) manager.chargebackDegreeLight = [userInfo valueForKey:chargebackDegreeLightName];
    if ([allKeys containsObject:chargebackLightName]) manager.chargebackLight = [userInfo valueForKey:chargebackLightName];
    if ([allKeys containsObject:subsidyLightName]) manager.subsidyLight = [userInfo valueForKey:subsidyLightName];
    if ([allKeys containsObject:priceLightName]) manager.priceLight = [userInfo valueForKey:priceLightName];
}
- (void)getDataFromChannelState:(NSDictionary *)channelState accountType:(NSString *)accountType {
    NSArray *allKeys = [channelState allKeys];
    if ([accountType isEqualToString:airConName]) { // 空调
        if ([allKeys containsObject:electricityName]) manager.electricityAirCon = [channelState valueForKey:electricityName];
        if ([allKeys containsObject:voltageName]) manager.voltageAirCon = [channelState valueForKey:voltageName];
        if ([allKeys containsObject:currentName]) manager.currentAirCon = [channelState valueForKey:currentName];
        if ([allKeys containsObject:powerName]) manager.powerAirCon = [channelState valueForKey:powerName];
        if ([allKeys containsObject:powerRateName]) manager.powerRateAirCon = [channelState valueForKey:powerRateName];
        if ([allKeys containsObject:elecDayName]) manager.elecDayAirCon = [channelState valueForKey:elecDayName];
        if ([allKeys containsObject:elecMonName]) manager.elecMonAirCon = [channelState valueForKey:elecMonName];
        if ([allKeys containsObject:stateName]) manager.stateAirCon = [channelState valueForKey:stateName];
        if ([allKeys containsObject:statusName]) manager.statusAirCon = [self status:[channelState valueForKey:statusName]];
        if ([allKeys containsObject:accountStatusName]) manager.accountStatusAirCon = [self accountStatus:[channelState valueForKey:accountStatusName]];
    } else if ([accountType isEqualToString:lightingName]) { // 照明
        if ([allKeys containsObject:electricityName]) manager.electricityLight = [channelState valueForKey:electricityName];
        if ([allKeys containsObject:voltageName]) manager.voltageLight = [channelState valueForKey:voltageName];
        if ([allKeys containsObject:currentName]) manager.currentLight = [channelState valueForKey:currentName];
        if ([allKeys containsObject:powerName]) manager.powerLight = [channelState valueForKey:powerName];
        if ([allKeys containsObject:powerRateName]) manager.powerRateLight = [channelState valueForKey:powerRateName];
        if ([allKeys containsObject:elecDayName]) manager.elecDayLight = [channelState valueForKey:elecDayName];
        if ([allKeys containsObject:elecMonName]) manager.elecMonLight = [channelState valueForKey:elecMonName];
        if ([allKeys containsObject:stateName]) manager.stateLight = [channelState valueForKey:stateName];
        if ([allKeys containsObject:statusName]) manager.statusLight = [self status:[channelState valueForKey:statusName]];
        if ([allKeys containsObject:accountStatusName]) manager.accountStatusLight = [self accountStatus:[channelState valueForKey:accountStatusName]];
    }
}
- (void)getDataFromStudents:(NSArray *)students {
    manager.students = students;
}

- (NSString *)status:(NSString *)getStatus {
    NSArray *statusArr = @[@"正常",@"恶性负载",@"电表锁定",@"等待"];
    return statusArr[getStatus.intValue];
}
- (NSString *)accountStatus:(NSString *)getStatus {
    NSArray *accountStatusArr = @[@"正常",@"余额不足",@"冻结"];
    return accountStatusArr[getStatus.intValue];
}


#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segmentedControl setSelectedSegmentIndex:page];
    [self scrollToSegmentIndex:page];
}
- (void)segmentedControlChangedValue:(UISegmentedControl *)segmentedControl {
//    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    [self scrollToSegmentIndex:segmentedControl.selectedSegmentIndex];
//    [self.scrollView scrollRectToVisible:CGRectMake(segmentedControl.selectedSegmentIndex*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height - 20 - 44) animated:YES];
}
- (void)scrollToSegmentIndex:(NSInteger)index {
    NSLog(@"scroll to index: %ld",(long)index);
    [self.scrollView scrollRectToVisible:CGRectMake(index * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height - 20 - 44) animated:YES];
    // 下面添加子控制器 的反应
//    // 更新界面
//    [dormAirCon updateInterfaceWithWebserviceData];
//    [dormLighting updateInterfaceWithWebserviceData];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
