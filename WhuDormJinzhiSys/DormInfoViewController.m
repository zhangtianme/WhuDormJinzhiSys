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
    DormTypeViewController *dormAirCon;    // 空调子视图
    DormTypeViewController *dormLighting;  // 照明子视图
    MBProgressHUD          *mbHud;
    StudentAccount         *studentAccount;// 账户管理
    AccountManager         *accountManager;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation DormInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"doeminfo view did load");
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO; // 不透明
    
    studentAccount = [StudentAccount sharedStudentAccount];
    accountManager = [AccountManager sharedAccountManager];
    if (accountManager.role.integerValue==1||accountManager.role.integerValue==2) {// 如果身份是学生 则右侧为设置 隐藏掉返回按钮
        [self.navigationItem setHidesBackButton:YES];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickSettingButton:)];
        if ([accountManager.wakeUpAppBundle isEqualToString:jinzhiBundle1]||[accountManager.wakeUpAppBundle isEqualToString:jinzhiBundle2]) { // 从金智平台唤醒则添加返回按钮
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回平台" style:UIBarButtonItemStylePlain target:self action:@selector(didClickReturnButton:)];
        }

    } else {
        [self.navigationItem setHidesBackButton:NO];
    }

    // 导航条添加 segment control
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[airConName, lightingName]];
    [self.segmentedControl setFrame:CGRectMake(96, 7, 128, 30)];  //
    [self.segmentedControl setSelectedSegmentIndex:0]; // 选择第一项
    [self.navigationItem setTitleView:self.segmentedControl];

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
    [self.scrollView addSubview:dormAirCon.tableView];
    [self addChildViewController:dormAirCon];
    [dormAirCon didMoveToParentViewController:self];
    
    //dorm lighting list
    dormLighting.view.frame = CGRectMake(viewWidth, 0, viewWidth, viewHeight);
    [dormLighting willMoveToParentViewController:self];
    [self.scrollView addSubview:dormLighting.tableView];
    [self addChildViewController:dormLighting];
    [dormLighting didMoveToParentViewController:self];
    NSLog(@"%s begining",__PRETTY_FUNCTION__);

    [dormAirCon.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [dormLighting.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!mbHud) {  // 初始化指示器
        mbHud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:mbHud];
        mbHud.dimBackground = YES;
    }
    NSLog(@"studentAccount.roomID:%@",studentAccount.roomID);
    if ([studentAccount.roomID isEqualToString:@""]) { // 没有数据请求
        [self queryDataAndShowHud]; // 请求数据
    }
    [dormAirCon updateInterfaceWithWebserviceData];
    [dormLighting updateInterfaceWithWebserviceData];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)headerRereshing
{
    [self queryDataAndShowHud]; // 手动刷新无条件请求数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [dormAirCon.tableView headerEndRefreshing];
        [dormLighting.tableView headerEndRefreshing];
        //        [_studentTableView headerEndRefreshing];
        
    });
}
- (void)requestTimeout:(UISwitch *)sender
{
    // 没有收到数据 显示错误指示2秒钟
    [mbHud showWithTitle:@"错误" detail:@"请求失败，请确认网络连接状态是否正常"];
    [mbHud hide:YES afterDelay:1];
}
// 进入设置页面
- (void)didClickSettingButton:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:showSettingsIdentifier sender:self]; // 跳转到设置页面
}

// 返回金智平台
- (void)didClickReturnButton:(UIBarButtonItem *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:jinzhiScheme]];
}
/**
 *  请求数据
 */
- (void)queryDataAndShowHud {
    [mbHud showWithTitle:@"数据加载中..." detail:nil];
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
        controlLimit = [WhuControlWebservice checkStu:studentAccount.stuID];
        [self getDataFromControlLimit:controlLimit];
        NSLog(@"limit %@",controlLimit);
        // 查询学生信息
        userInfo = [WhuControlWebservice queryUserInfo:studentAccount.stuID];
        [self getDataFromUserInfo:userInfo];
        [NSObject cancelPreviousPerformRequestsWithTarget:self]; // 取消前面的定时函数
        [self performSelector:@selector(requestTimeout:) withObject:nil afterDelay:timeoutRequest];// 5秒的超时
        // 查询空调用电状态
        airConChannelState = [WhuControlWebservice queryChannelStat:studentAccount.roomID accountType:airConName];
        [self getDataFromChannelState:airConChannelState accountType:airConName];
        [NSObject cancelPreviousPerformRequestsWithTarget:self]; // 取消前面的定时函数
        [self performSelector:@selector(requestTimeout:) withObject:nil afterDelay:timeoutRequest];// 5秒的超时
        // 查询照明用电状态
        lightChannelState = [WhuControlWebservice queryChannelStat:studentAccount.roomID accountType:lightingName];
        [self getDataFromChannelState:lightChannelState accountType:lightingName];
        [NSObject cancelPreviousPerformRequestsWithTarget:self]; // 取消前面的定时函数
        [self performSelector:@selector(requestTimeout:) withObject:nil afterDelay:timeoutRequest];// 5秒的超时
        // 查询某间宿舍学生信息
        students = [WhuControlWebservice queryRoom:studentAccount.roomID];
        [self getDataFromStudents:students];
        [NSObject cancelPreviousPerformRequestsWithTarget:self]; // 取消前面的定时函数
        [self performSelector:@selector(requestTimeout:) withObject:nil afterDelay:timeoutRequest];// 5秒的超时
        // 返回主线程 处理结果
        dispatch_sync(dispatch_get_main_queue(), ^{
            [mbHud showWithTitle:@"数据加载成功!" detail:nil];
            [mbHud hide:YES afterDelay:0.5];
            [NSObject cancelPreviousPerformRequestsWithTarget:self]; // 取消前面的定时函数
            // 更新界面
            [dormAirCon updateInterfaceWithWebserviceData];
            [dormLighting updateInterfaceWithWebserviceData];
        });
    });
}
- (void)getDataFromControlLimit:(NSString *)controlLimit {
    studentAccount.controlLimit = controlLimit;
}

- (void)getDataFromUserInfo:(NSDictionary *)userInfo {
    NSArray *allKeys = [userInfo allKeys];
    if ([allKeys containsObject:roomIDName]) studentAccount.roomID = [userInfo valueForKey:roomIDName];
    if ([allKeys containsObject:facultyName]) studentAccount.faculty = [userInfo valueForKey:facultyName];
    if ([allKeys containsObject:professionalName]) studentAccount.professional = [userInfo valueForKey:professionalName];
    if ([allKeys containsObject:roleName]) studentAccount.role = [userInfo valueForKey:roleName];
    if ([allKeys containsObject:stuNameName]) studentAccount.stuName = [userInfo valueForKey:stuNameName];
    if ([allKeys containsObject:phoneNumName]) {
        if ([allKeys containsObject:phoneNumName]) studentAccount.phoneNum = [userInfo valueForKey:phoneNumName];
    }

    if ([allKeys containsObject:areaName]) studentAccount.area = [userInfo valueForKey:areaName];
    if ([allKeys containsObject:buildingName]) studentAccount.building = [userInfo valueForKey:buildingName];
    if ([allKeys containsObject:unitName]) studentAccount.unit =[userInfo valueForKey:unitName];
    if ([allKeys containsObject:roomNumName]) studentAccount.roomNum = [userInfo valueForKey:roomNumName];
    
    if ([allKeys containsObject:subsidyDegreeAirConName]) studentAccount.subsidyDegreeAirCon = [userInfo valueForKey:subsidyDegreeAirConName];
    if ([allKeys containsObject:chargebackDegreeAirConName]) studentAccount.chargebackDegreeAirCon = [userInfo valueForKey:chargebackDegreeAirConName];
    if ([allKeys containsObject:chargebackAirConName]) studentAccount.chargebackAirCon = [userInfo valueForKey:chargebackAirConName];
    if ([allKeys containsObject:subsidyAirConName]) studentAccount.subsidyAirCon = [userInfo valueForKey:subsidyAirConName];
    if ([allKeys containsObject:priceAirConName]) studentAccount.priceAirCon = [userInfo valueForKey:priceAirConName];
    if ([allKeys containsObject:subsidyDegreeLightName]) studentAccount.subsidyDegreeLight = [userInfo valueForKey:subsidyDegreeLightName];
    if ([allKeys containsObject:chargebackDegreeLightName]) studentAccount.chargebackDegreeLight = [userInfo valueForKey:chargebackDegreeLightName];
    if ([allKeys containsObject:chargebackLightName]) studentAccount.chargebackLight = [userInfo valueForKey:chargebackLightName];
    if ([allKeys containsObject:subsidyLightName]) studentAccount.subsidyLight = [userInfo valueForKey:subsidyLightName];
    if ([allKeys containsObject:priceLightName]) studentAccount.priceLight = [userInfo valueForKey:priceLightName];
}
- (void)getDataFromChannelState:(NSDictionary *)channelState accountType:(NSString *)accountType {
    NSArray *allKeys = [channelState allKeys];
    if ([accountType isEqualToString:airConName]) { // 空调
        if ([allKeys containsObject:electricityName]) studentAccount.electricityAirCon = [channelState valueForKey:electricityName];
        if ([allKeys containsObject:voltageName]) studentAccount.voltageAirCon = [channelState valueForKey:voltageName];
        if ([allKeys containsObject:currentName]) studentAccount.currentAirCon = [channelState valueForKey:currentName];
        if ([allKeys containsObject:powerName]) studentAccount.powerAirCon = [channelState valueForKey:powerName];
        if ([allKeys containsObject:powerRateName]) studentAccount.powerRateAirCon = [channelState valueForKey:powerRateName];
        if ([allKeys containsObject:elecDayName]) studentAccount.elecDayAirCon = [channelState valueForKey:elecDayName];
        if ([allKeys containsObject:elecMonName]) studentAccount.elecMonAirCon = [channelState valueForKey:elecMonName];
        if ([allKeys containsObject:stateName]) studentAccount.stateAirCon = [channelState valueForKey:stateName];
        if ([allKeys containsObject:statusName]) studentAccount.statusAirCon = [self status:[channelState valueForKey:statusName]];
        if ([allKeys containsObject:accountStatusName]) studentAccount.accountStatusAirCon = [self accountStatus:[channelState valueForKey:accountStatusName]];
    } else if ([accountType isEqualToString:lightingName]) { // 照明
        if ([allKeys containsObject:electricityName]) studentAccount.electricityLight = [channelState valueForKey:electricityName];
        if ([allKeys containsObject:voltageName]) studentAccount.voltageLight = [channelState valueForKey:voltageName];
        if ([allKeys containsObject:currentName]) studentAccount.currentLight = [channelState valueForKey:currentName];
        if ([allKeys containsObject:powerName]) studentAccount.powerLight = [channelState valueForKey:powerName];
        if ([allKeys containsObject:powerRateName]) studentAccount.powerRateLight = [channelState valueForKey:powerRateName];
        if ([allKeys containsObject:elecDayName]) studentAccount.elecDayLight = [channelState valueForKey:elecDayName];
        if ([allKeys containsObject:elecMonName]) studentAccount.elecMonLight = [channelState valueForKey:elecMonName];
        if ([allKeys containsObject:stateName]) studentAccount.stateLight = [channelState valueForKey:stateName];
        if ([allKeys containsObject:statusName]) studentAccount.statusLight = [self status:[channelState valueForKey:statusName]];
        if ([allKeys containsObject:accountStatusName]) studentAccount.accountStatusLight = [self accountStatus:[channelState valueForKey:accountStatusName]];
    }
}
- (void)getDataFromStudents:(NSArray *)students {
    studentAccount.students = students;
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
