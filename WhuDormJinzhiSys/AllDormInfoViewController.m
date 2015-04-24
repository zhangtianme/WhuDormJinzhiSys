//
//  AllDormInfoViewController.m
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/4/18.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import "AllDormInfoViewController.h"
#import "MacroDefinition.h"

#define roomTableViewHeaderHeight   20
#define studentTableViewHeaderHeight   20
//#define headerLabelTagBegin          101     // header 里面的label的tag


#define allFloorName    @"全部楼层"
@interface AllDormInfoViewController () {
    MBProgressHUD    *mbHud;           // hud
    StudentAccount   *studentAccount;  // 账户管理
    AccountManager   *accountManager;  //总账户
    AdminAccount     *adminAccount;    // 管理员账户.

    DropDownListView *dropDownView;    // 下拉菜单
    NSMutableArray   *dropDownDataArr; // 下拉菜单的数组 4个nsarray组成 area/building/unit/floor
    NSMutableArray   *managedUnits;    // 可以管理的楼栋
    NSMutableArray   *allRooms;        // 所有的房间
    NSMutableArray   *displayRooms;    // 显示的房间
    NSMutableArray   *roomFloors;      // 楼层 用来分区

    NSArray          *allStudents;     // 所有学生
    NSMutableArray   *displayStudents; // 显示的学生
    NSMutableArray   *studentRoomNums;   // 房间号 用来分区

    NSMutableString  *selectedArea;    // 当前选择的学部
    NSMutableString  *selectedBuilding;// 当前选择的楼栋
    NSMutableString  *selectedUnit;    // 当前选择的单元
    NSMutableString  *selectedFloor;   //当前选择的楼层
}

@property (nonatomic, strong) UIScrollView       *scrollView;      // 滚动视图
@property (nonatomic, strong) UISegmentedControl *segmentedControl;// 选择控制
@property (nonatomic, strong) UITableView        *roomTableView;   // 宿舍分页
@property (nonatomic, strong) UITableView        *studentTableView;// 学生分页

@end

@implementation AllDormInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO; // 不透明
    
    studentAccount = [StudentAccount sharedStudentAccount];
    accountManager = [AccountManager sharedAccountManager];
    adminAccount   = [AdminAccount sharedAdminAccount];
    
    
    [self.navigationItem setHidesBackButton:YES]; // 隐藏返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickSettingButton:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(didClickSearchButton:)];
    
    // 导航条添加 segment control
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[dormName, studentName]];
    [self.segmentedControl setFrame:CGRectMake(96, 7, 128, 30)];  //
    [self.segmentedControl setSelectedSegmentIndex:0]; // 选择第一项
    [self.navigationItem setTitleView:self.segmentedControl];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged]; // 添加分段选择触发函数
    // 去掉导航栏下的黑框
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigaationBar.shadowImage = [[UIImage alloc] init];
    dropDownDataArr = [NSMutableArray arrayWithArray:
                       @[
                         @[@"信息学部",@"医学部"],
                         @[@"2舍",@"5舍",@"6舍"],
                         @[@"",@"",@""],
                         @[@"全部楼层",@"1层",@"2层",@"3层"]
                         ]];
    dropDownView = [[DropDownListView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 40) dataSource:self delegate:self];
    dropDownView.backgroundColor = mainBlueColor;// 主蓝色
    dropDownView.mSuperView = self.view;
    [self.view addSubview:dropDownView];
    //
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = self.view.frame.size.height - 20 - 44 - 40;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, viewWidth, viewHeight)]; //20+44+40 (status+nav+segcontrol)
    self.scrollView.backgroundColor = lightBlueColor;// 淡蓝色背景
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(2*viewWidth, viewHeight);
    self.scrollView.delegate = self;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, viewWidth, viewHeight) animated:YES];
    [self.view addSubview:self.scrollView];
    
    // 添加宿舍和学生俩个视图
    // 宿舍
    _roomTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight) style:UITableViewStylePlain];
    _roomTableView.dataSource = self;
    _roomTableView.delegate = self;
    _roomTableView.backgroundColor = lightBlueColor;
    _roomTableView.rowHeight = 60.0f;
    _roomTableView.sectionHeaderHeight = roomTableViewHeaderHeight;
    [_scrollView addSubview:_roomTableView];
    // 学生
    _studentTableView = [[UITableView alloc] initWithFrame:CGRectMake(viewWidth, 0, viewWidth, viewHeight) style:UITableViewStylePlain];
    _studentTableView.dataSource = self;
    _studentTableView.delegate = self;
    _studentTableView.backgroundColor = lightBlueColor;
    _studentTableView.rowHeight = 44.0f;
    _studentTableView.sectionHeaderHeight = studentTableViewHeaderHeight;
    [_scrollView addSubview:_studentTableView];
//    if (!mbHud) {  // 初始化指示器
//        mbHud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//        [self.navigationController.view addSubview:mbHud];
//        mbHud.dimBackground = YES;
//    }
    
    NSLog(@"hahahhahahahdidload");

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [dropDownView hideExtendedChooseView]; // 隐藏下拉菜单
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!mbHud) {  // 初始化指示器
        mbHud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:mbHud];
        mbHud.dimBackground = YES;
    }

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self queryDataAndShowHud]; // 请求数据
}

/**
 *  第一次请求数据
 */
- (void)queryDataAndShowHud {
    [mbHud showWithTitle:@"Loading..." detail:nil];
    [self performSelector:@selector(requestTimeout:) withObject:nil afterDelay:timeoutRequest];// 5秒的超时
    // 异步线程调用接口
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        [self queryUserAndBuildingData];
        // 返回主线程 处理结果
        dispatch_sync(dispatch_get_main_queue(), ^{
            [mbHud hide:YES];
            [NSObject cancelPreviousPerformRequestsWithTarget:self]; // 取消前面的定时函数
            // 更新界面
            [self chooseAtSection:0 index:0];
        });
    });
}

- (void)requestTimeout:(UISwitch *)sender
{
    // 没有收到数据 显示错误指示5秒钟
    [mbHud showWithTitle:@"错误" detail:@"请求失败，请确认网络连接状态是否正常"];
    [mbHud hide:YES afterDelay:1];
}

- (void)queryUserAndBuildingData {
    // 用户信息查询 与解析
    NSDictionary *userInfo = [WhuControlWebservice queryUserInfo:adminAccount.userID];
    [NSObject cancelPreviousPerformRequestsWithTarget:self]; // 取消前面的定时函数
    [self performSelector:@selector(requestTimeout:) withObject:nil afterDelay:timeoutRequest];// 5秒的超时
    NSArray *allKeys = [userInfo allKeys];
    if ([allKeys containsObject:areaName]) adminAccount.area = [userInfo valueForKey:areaName];
    if ([allKeys containsObject:buildingName]) adminAccount.building = [userInfo valueForKey:buildingName];
    if ([allKeys containsObject:unitName]) adminAccount.unit = [userInfo valueForKey:unitName];
    if ([allKeys containsObject:phoneNumName]) adminAccount.phoneNum = [userInfo valueForKey:phoneNumName];
    if ([allKeys containsObject:licensorName]) adminAccount.licensor = [userInfo valueForKey:licensorName];
    
    // 查询所有学生信息
    allStudents = [WhuControlWebservice queryStudents];
    [NSObject cancelPreviousPerformRequestsWithTarget:self]; // 取消前面的定时函数
    [self performSelector:@selector(requestTimeout:) withObject:nil afterDelay:timeoutRequest];// 5秒的超时
    NSLog(@"allstudentscout:%lu",(unsigned long)allStudents.count);
    // 管理系统楼栋结构查询与解析
    NSArray *rooms = [WhuControlWebservice queryBuilding];
    for (NSMutableDictionary *aroom in rooms) {
        [aroom removeObjectsForKeys:@[roomIDName,roomNumName,floorName]];
    }
    // 去重加排序
    NSArray *allUnits = [[NSSet setWithArray:rooms] allObjects];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:areaName ascending:YES]; //升序
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:buildingName ascending:YES]; //升序
    NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:unitName ascending:YES]; //升序
    NSArray *sortDescriptors = @[sortDescriptor1,sortDescriptor2,sortDescriptor3];
    allUnits =[allUnits sortedArrayUsingDescriptors:sortDescriptors];
//    [self dropDownArrFromUnits:allUnits];
    // 获取管理员可以管理的楼栋 方法超级管理员也适用
    managedUnits = (NSMutableArray *)[self managedUnitsFromAllUnit:allUnits Area:adminAccount.area building:adminAccount.building unit:adminAccount.unit];
    [NSObject cancelPreviousPerformRequestsWithTarget:self]; // 取消前面的定时函数
    [self performSelector:@selector(requestTimeout:) withObject:nil afterDelay:timeoutRequest];// 5秒的超时
    if (managedUnits) {// 如果不为空
        NSDictionary *firstUnit = [NSDictionary dictionaryWithDictionary:managedUnits[0]];
        selectedArea = [firstUnit valueForKey:areaName];
        selectedBuilding = [firstUnit valueForKey:buildingName];
        selectedUnit = [firstUnit valueForKey:unitName];
    }
    // 计算出区域数组
    NSMutableArray *areas = [[NSMutableArray alloc]  initWithCapacity:10];
    for (NSDictionary *aUnit in managedUnits) {
        [areas addObject:[aUnit valueForKey:areaName]];
    }
    areas = (NSMutableArray *)[[NSSet setWithArray:areas] allObjects];
    dropDownDataArr[0] = areas;
    
    // 请求第一次数据
    allRooms =[NSMutableArray arrayWithArray:[WhuControlWebservice queryBuildingDetailWithArea:selectedArea building:selectedBuilding unit:selectedUnit]];
    [NSObject cancelPreviousPerformRequestsWithTarget:self]; // 取消前面的定时函数
    [self performSelector:@selector(requestTimeout:) withObject:nil afterDelay:timeoutRequest];// 5秒的超时
}
- (void)updateInterface {
    // 根据选择的area/building/unit/floor 更新数据
    if (_segmentedControl.selectedSegmentIndex ==0) { // 选择的是宿舍这一项
        // 计算出要显示的房间
        displayRooms = [[NSMutableArray alloc] initWithCapacity:10];
        roomFloors = [[NSMutableArray alloc] initWithCapacity:10];
        for (NSDictionary *aRoom in allRooms) {
            if ([selectedArea isEqualToString:[aRoom valueForKey:areaName]]&&[selectedBuilding isEqualToString:[aRoom valueForKey:buildingName]]&&[selectedUnit isEqualToString:[aRoom valueForKey:unitName]]) {
                if ([selectedFloor isEqualToString:allFloorName]||[selectedFloor isEqualToString:[aRoom valueForKey:floorName]]) { // 楼层等于或者楼层的名字是全部
                    [displayRooms addObject:aRoom];
                    [roomFloors addObject:[aRoom valueForKey:floorName]];
                }
            }
        }
        
        // 楼层索引去重
        roomFloors = [NSMutableArray arrayWithArray:[[NSSet setWithArray:roomFloors] allObjects]];
        // 排序
        NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES]; //升序
        roomFloors = [NSMutableArray arrayWithArray:[roomFloors sortedArrayUsingDescriptors:@[sortDescriptor1]]];
        
        // 显示的房间排序
        NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:roomNumName ascending:YES]; //升序
        displayRooms = [NSMutableArray arrayWithArray:[displayRooms sortedArrayUsingDescriptors:@[sortDescriptor2]]];
        // 给显示的房间分区
        NSMutableArray *tempDisplayRooms = [[NSMutableArray alloc] initWithCapacity:10];
        for (int i = 0; i<roomFloors.count; i++) {
            NSArray *predicatedArr = [displayRooms filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Floor == %@", roomFloors[i]]]; //筛选指定的元素
            [tempDisplayRooms addObject:predicatedArr];
        }
        displayRooms = [NSMutableArray arrayWithArray:tempDisplayRooms];
        NSLog(@"displayroomscount:%lu selectedarea:%@ build:%@ unit:%@ floor：%@",(unsigned long)displayRooms.count,selectedArea,selectedBuilding,selectedUnit,selectedFloor);
        [_roomTableView reloadData];

    } else {
        // 计算出要显示的人员信息
        displayStudents = [[NSMutableArray alloc] initWithCapacity:10];
        studentRoomNums = [[NSMutableArray alloc] initWithCapacity:10];
        for (NSDictionary *aStudent in allStudents) {
            if ([selectedArea isEqualToString:[aStudent valueForKey:areaName]]&&[selectedBuilding isEqualToString:[aStudent valueForKey:buildingName]]&&[selectedUnit isEqualToString:[aStudent valueForKey:unitName]]) {
                if ([selectedFloor isEqualToString:allFloorName]||[selectedFloor isEqualToString:[aStudent valueForKey:floorName]]) { // 楼层等于或者楼层的名字是全部
                    [displayStudents addObject:aStudent];
                    [studentRoomNums addObject:[aStudent valueForKey:roomNumName]];
                }
            }
        }
        // 楼层索引去重
        studentRoomNums = [NSMutableArray arrayWithArray:[[NSSet setWithArray:studentRoomNums] allObjects]];
        // 排序
        NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES]; //升序
        studentRoomNums = [NSMutableArray arrayWithArray:[studentRoomNums sortedArrayUsingDescriptors:@[sortDescriptor1]]];

        // 显示的人员排序
        NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:roomNumName ascending:YES]; //升序
        displayStudents = [NSMutableArray arrayWithArray:[displayStudents sortedArrayUsingDescriptors:@[sortDescriptor2]]];
        // 给显示的人员分区
        NSMutableArray *tempDisplayStudents = [[NSMutableArray alloc] initWithCapacity:10];
        for (int i = 0; i<studentRoomNums.count; i++) {
            NSArray *predicatedArr = [displayStudents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"RoomNum == %@", studentRoomNums[i]]]; //筛选指定的元素
            [tempDisplayStudents addObject:predicatedArr];
        }
        displayStudents = [NSMutableArray arrayWithArray:tempDisplayStudents];
        NSLog(@"displaystudentscount:%lu selectedarea:%@ build:%@ unit:%@ floor：%@",(unsigned long)displayStudents.count,selectedArea,selectedBuilding,selectedUnit,selectedFloor);
        [_studentTableView reloadData];
    }
    
    NSLog(@"updated interface");
    if (_segmentedControl.selectedSegmentIndex == 0) {// 宿舍
    } else if (_segmentedControl.selectedSegmentIndex == 1) {// 学生
    }
}
/**
 *  后续请求数据
 */
- (void)querySelectedDataAndShowHud {
    // 判断是否已经请求过数据 如果没有请求则再次请求并且合并数据
    for (NSDictionary *aRoom in allRooms) {
        if ([selectedArea isEqualToString:[aRoom valueForKey:areaName]]&&[selectedBuilding isEqualToString:[aRoom valueForKey:buildingName]]&&[selectedUnit isEqualToString:[aRoom valueForKey:unitName]]) {
            // 计算出楼层数组 继续跳转到dropdownmenu上面
            NSMutableArray *floors = [[NSMutableArray alloc]  initWithCapacity:10];
            for (NSDictionary *aRoom in allRooms) {
                if ([selectedArea isEqualToString:[aRoom valueForKey:areaName]]&&[selectedBuilding isEqualToString:[aRoom valueForKey:buildingName]]&&[selectedUnit isEqualToString:[aRoom valueForKey:unitName]]) {
                    [floors addObject:[aRoom valueForKey:floorName]];
                }
            }
            floors = [NSMutableArray arrayWithArray:[[NSSet setWithArray:floors] allObjects]];
            [floors insertObject:@"全部楼层" atIndex:0];
            dropDownDataArr[3] = floors;
            [self chooseAtSection:2 index:0]; // 选择了楼栋之后选择第一行楼层 即全部楼层
            return;
        }
    }
    [mbHud showWithTitle:@"Loading..." detail:nil];
    [self performSelector:@selector(requestTimeout:) withObject:nil afterDelay:timeoutRequest];// 5秒的超时
    // 异步线程调用接口
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        [self querySelectedData];
        // 返回主线程 处理结果
        dispatch_sync(dispatch_get_main_queue(), ^{
            [mbHud hide:YES];
            [NSObject cancelPreviousPerformRequestsWithTarget:self]; // 取消前面的定时函数
            // 计算出楼层数组 继续跳转到dropdownmenu上面
            NSMutableArray *floors = [[NSMutableArray alloc]  initWithCapacity:10];
            for (NSDictionary *aRoom in allRooms) {
                if ([selectedArea isEqualToString:[aRoom valueForKey:areaName]]&&[selectedBuilding isEqualToString:[aRoom valueForKey:buildingName]]&&[selectedUnit isEqualToString:[aRoom valueForKey:unitName]]) {
                    [floors addObject:[aRoom valueForKey:floorName]];
                }
            }
            floors = [NSMutableArray arrayWithArray:[[NSSet setWithArray:floors] allObjects]];
            [floors insertObject:@"全部楼层" atIndex:0];
            dropDownDataArr[3] = floors;
            [self chooseAtSection:2 index:0]; // 选择了楼栋之后选择第一行楼层 即全部楼层
        });
    });
}
/**
 *  根据当前选择的单元楼栋等请求数据
 */
- (void)querySelectedData {
    // 判断是否已经请求过数据 如果没有请求则再次请求并且合并数据
//    for (NSDictionary *aRoom in allRooms) {
//        if ([selectedArea isEqualToString:[aRoom valueForKey:areaName]]&&[selectedBuilding isEqualToString:[aRoom valueForKey:buildingName]]&&[selectedUnit isEqualToString:[aRoom valueForKey:unitName]]) {
//            return;
//        }
//    }
    NSArray *tempRooms = [WhuControlWebservice queryBuildingDetailWithArea:selectedArea building:selectedBuilding unit:selectedUnit];
    [allRooms addObjectsFromArray:tempRooms];
    NSLog(@"allroomscounts:%lu",(unsigned long)allRooms.count);
}

// 根据权限 获取可以管理的楼栋
- (NSArray *)managedUnitsFromAllUnit:(NSArray *)allUnits Area:(NSString *)area building:(NSString *)building unit:(NSString *)unit {
    NSMutableArray *tempManagedUnits = [NSMutableArray arrayWithArray:allUnits];
    NSMutableArray *tempUnits = [NSMutableArray arrayWithArray:tempManagedUnits];
    if (!(!area || [area isEqualToString:@""])) {// 不为空 或者不为空字符 把不符合的都删除
        NSLog(@"area enterin");
        for (NSDictionary *aUnit in tempManagedUnits) {
            if (![[aUnit valueForKey:areaName] isEqualToString:area]) {
                [tempUnits removeObject:aUnit];
            };
        }
    }
    tempManagedUnits = [NSMutableArray arrayWithArray:tempUnits];
    if (!(!building || [building isEqualToString:@""])) {// 不为空 或者不为空字符 把不符合的都删除
        NSLog(@"building enterin");

        for (NSDictionary *aUnit in tempManagedUnits) {
            if (![[aUnit valueForKey:buildingName] isEqualToString:building]) {
                [tempUnits removeObject:aUnit];
            };
        }
    }

    tempManagedUnits = [NSMutableArray arrayWithArray:tempUnits];
    if (!(!unit || [unit isEqualToString:@""])) {// 不为空 或者不为空字符 把不符合的都删除
        NSLog(@"unit enterin");

        for (NSDictionary *aUnit in tempManagedUnits) {
            if (![[aUnit valueForKey:unitName] isEqualToString:unit]) {
                [tempUnits removeObject:aUnit];
            };
        }
    }
    tempManagedUnits = [NSMutableArray arrayWithArray:tempUnits];

    return tempManagedUnits;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_roomTableView]) { // 宿舍视图
        NSDictionary *aRoom = displayRooms[indexPath.section][indexPath.row];
        
        NSArray *predicatedArr = [allStudents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"RoomID == %@", [aRoom valueForKey:roomIDName]]]; //筛选指定的元素
        NSLog(@"aRoomis:%@ students:%@",aRoom,predicatedArr);
        if (predicatedArr.count) { // 有人
            NSDictionary *aStudent = predicatedArr[0];
            studentAccount.stuID  = [aStudent valueForKey:stuIDName];
            studentAccount.userID = [aStudent valueForKey:stuIDName];
            studentAccount.role   = [aStudent valueForKey:roleName];
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:dormInfoIdentity] animated:YES];
            NSLog(@"youren");
        } else {
            NSLog(@"meiren");
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"该房间无人居住!" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }


    } else if ([tableView isEqual:_studentTableView]) { // 学生视图
        NSDictionary *aStudent = displayStudents[indexPath.section][indexPath.row];
        StudentViewController *studentViewController = [self.storyboard instantiateViewControllerWithIdentifier:studentInfoIdentity];
        studentAccount.stuID  = [aStudent valueForKey:stuIDName];
        [self.navigationController pushViewController:studentViewController animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat heightForRow = 60;
    if ([tableView isEqual:_roomTableView]) { // 宿舍视图
        heightForRow = 60;
    } else if ([tableView isEqual:_studentTableView]) { // 学生视图
        heightForRow = 44;
    }
    return heightForRow;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    
//    CGFloat height = roomTableViewHeaderHeight;
//    if ([tableView isEqual:_roomTableView]) { // 宿舍视图
//        height = roomTableViewHeaderHeight;
//        NSLog(@"set height %d",roomTableViewHeaderHeight);
//    } else if ([tableView isEqual:_studentTableView]) { // 学生视图
//        height = studentTableViewHeaderHeight;
//    }
//    return height;
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:_roomTableView]) { // 宿舍视图
        static NSString *roomHeaderIdentifier = @"roomHeaderView";
        RoomHeader *roomHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:roomHeaderIdentifier];
        if(!roomHeader) {
            roomHeader = [[RoomHeader alloc] initWithReuseIdentifier:roomHeaderIdentifier];
        }
        roomHeader.detailLabel.text = [NSString stringWithFormat:@"%@-%@%@-%@层",selectedArea,selectedBuilding,selectedUnit,roomFloors[section]];
        return roomHeader;
    } else if ([tableView isEqual:_studentTableView]) { // 学生视图
        static NSString *studentHeaderIdentifier = @"studentHeaderView";
        RoomHeader *studentHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:studentHeaderIdentifier];
        if(!studentHeader) {
            studentHeader = [[RoomHeader alloc] initWithReuseIdentifier:studentHeaderIdentifier];
        }
        studentHeader.detailLabel.text = [NSString stringWithFormat:@"%@-%@-%@-%@房间",selectedArea,selectedBuilding,selectedUnit,studentRoomNums[section]];
        return studentHeader;
    }
    UIView *myHeader;
    return myHeader;
}
#pragma mark - Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSInteger sectionNumber = 0;
    if ([tableView isEqual:_roomTableView]) { // 宿舍视图
        sectionNumber = displayRooms.count;
    } else if ([tableView isEqual:_studentTableView]) { // 学生视图
        sectionNumber = displayStudents.count;
    }
    return sectionNumber;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    NSString *headString = [[NSString alloc] init];
//    if ([tableView isEqual:_roomTableView]) { // 宿舍视图
//        headString = [NSString stringWithFormat:@"%@-%@-%@-%@",selectedArea,selectedBuilding,selectedUnit,roomFloors[section]];
//    } else if ([tableView isEqual:_studentTableView]) { // 学生视图
//        headString = [NSString stringWithFormat:@"%@-%@-%@-%@",selectedArea,selectedBuilding,selectedUnit,studentRoomNums[section]];
//    }
//    return headString;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberInsection = 0;
    // Return the number of rows in the section.
    if ([tableView isEqual:_roomTableView]) { // 宿舍视图
        numberInsection = [displayRooms[section] count];
    } else if ([tableView isEqual:_studentTableView]) {
        numberInsection = [displayStudents[section] count];
    }
//    NSLog(@"howmanyinsections:%d",numberInsection);
    return numberInsection;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *roomCellIdentifier = @"RoomCell";
    static NSString *studentCellIdentifier = @"StudentCell";
//    UITableViewCell *cell;
    if ([tableView isEqual:_roomTableView]) { // 宿舍视图
        RoomCell *cell = [tableView dequeueReusableCellWithIdentifier:roomCellIdentifier];
        if (cell == nil) {
           // NSLog(@"init room tableview");
            cell = [[RoomCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: roomCellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        [self tableView:tableView configureCell:cell atIndexPath:indexPath];
        return cell;
    } else if ([tableView isEqual:_studentTableView]) { // 学生视图
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:studentCellIdentifier];
        if (cell == nil) {
           // NSLog(@"init student tableview");
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: studentCellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        [self tableView:tableView configureCell:cell atIndexPath:indexPath];
        return cell;
    }
    UITableViewCell *cell;
    return cell;
}
- (void)tableView:(UITableView *)tableView configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_roomTableView]) { // 宿舍视图
        NSDictionary *aRoom = displayRooms[indexPath.section][indexPath.row];
        RoomCell *roomCell = (RoomCell *)cell;
        roomCell.iconImageView.image = [UIImage imageNamed:@"roomIcon"];
        roomCell.nameLabel.text = [aRoom valueForKey:roomNumName];
        // status 0123 分别代表 正常 恶性负载 电表锁定 等待
        NSString *lightningStatus,*airConStatus;
        switch ( [[aRoom valueForKey:lightningStatusName] integerValue]) {
            case 0:lightningStatus = @"正常";break;
            case 1:lightningStatus = @"恶性负载";break;
            case 2:lightningStatus = @"电表锁定";break;
            case 3:lightningStatus = @"等待";break;
            default: break;
        }
        roomCell.lightningStatusLabel.text = [NSString stringWithFormat:@"照明:%@",lightningStatus];
        switch ( [[aRoom valueForKey:airConStatusName] integerValue]) {
            case 0:airConStatus = @"正常";break;
            case 1:airConStatus = @"恶性负载";break;
            case 2:airConStatus = @"电表锁定";break;
            case 3:airConStatus = @"等待";break;
            default: break;
        }
        roomCell.airConStatusLabel.text = [NSString stringWithFormat:@"空调:%@",airConStatus];
        
        roomCell.lightningStateSwitch.on = [[aRoom valueForKey:lightningStateName] boolValue];
        roomCell.airConStateSwitch.on = [[aRoom valueForKey:airConStateName] boolValue];


//        roomCell.lightningStatusLabel.text = [NSString stringWithFormat:@"照明:%@",[[displayStudents objectAtIndex:indexPath.row]valueForKey:stuNameName]];
        
    } else if ([tableView isEqual:_studentTableView]) { // 学生视图
        NSDictionary *aStudent = displayStudents[indexPath.section][indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"manPhotoIcon"];
        cell.textLabel.text = [aStudent valueForKey:stuNameName];
        cell.detailTextLabel.text = [aStudent valueForKey:facultyName];
    }
}

#pragma mark -- dropDownListDelegate
-(void)chooseAtSection:(NSInteger)section index:(NSInteger)index
{
    switch (section) {
        case 0: { // 学部
            selectedArea = dropDownDataArr[section][index];
            [dropDownView setTitle:selectedArea inSection:section];
            // 计算出楼栋和单元数组
            NSMutableArray *buildings = [[NSMutableArray alloc]  initWithCapacity:10];
            NSMutableArray *units = [[NSMutableArray alloc]  initWithCapacity:10];
            for (NSDictionary *aUnit in managedUnits) {
                if ([selectedArea isEqualToString:[aUnit valueForKey:areaName]]) {
                    [buildings addObject:[aUnit valueForKey:buildingName]];
                    [units addObject:[aUnit valueForKey:unitName]];
                }
            }
            dropDownDataArr[1] = buildings;
            dropDownDataArr[2] = units;
            [self chooseAtSection:1 index:0]; // 选择了区域之后默认选择第一行的楼栋和单元
        }break;
        case 1: { // building和unit
            selectedBuilding = dropDownDataArr[1][index];
            selectedUnit = dropDownDataArr[2][index];
            [dropDownView setTitle:[NSString stringWithFormat:@"%@%@",selectedBuilding,selectedUnit] inSection:section];
            // 请求数据
            if (_segmentedControl.selectedSegmentIndex ==0) { // 选择的是宿舍这一项则查询数据
                [self querySelectedDataAndShowHud]; // 请求数据 请求完数据后要继续跳转到下面
            } else {  // 选择的是学生
                // 计算出楼层数组
                NSMutableArray *floors = [[NSMutableArray alloc]  initWithCapacity:10];
                for (NSDictionary *aStudent in allStudents) {
                    if ([selectedArea isEqualToString:[aStudent valueForKey:areaName]]&&[selectedBuilding isEqualToString:[aStudent valueForKey:buildingName]]&&[selectedUnit isEqualToString:[aStudent valueForKey:unitName]]) {
                        [floors addObject:[aStudent valueForKey:floorName]];
                    }
                }
                floors = [NSMutableArray arrayWithArray:[[NSSet setWithArray:floors] allObjects]];
                [floors insertObject:@"全部楼层" atIndex:0];
                dropDownDataArr[3] = floors;
                [self chooseAtSection:2 index:0]; // 选择了楼栋之后选择第一行楼层 即全部楼层
            }
        }break;
        case 2: { // 楼层
            selectedFloor = dropDownDataArr[3][index];
            [dropDownView setTitle:selectedFloor inSection:section];
            [self updateInterface];
            
        }break;
        default:
            break;
    }
}

#pragma mark -- dropdownList DataSource
-(NSInteger)numberOfSections
{
    return 3;
}
-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    NSInteger numbersInsection = 0;
    switch (section) {
        case 0: { // 学部
            numbersInsection =[dropDownDataArr[0] count];
        }break;
        case 1: { // building和unit
            numbersInsection = [dropDownDataArr[1] count];
        }break;
        case 2: { // 楼层
            numbersInsection = [dropDownDataArr[3] count];

        }break;
        default:
            break;
    }
    return numbersInsection;
}
-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index
{
    NSMutableString * titleInsection = [[NSMutableString alloc]init];
    switch (section) {
        case 0: { // 学部
            titleInsection = dropDownDataArr[0][index];
        }break;
        case 1: { // building和unit
            titleInsection = [NSMutableString stringWithFormat:@"%@%@",dropDownDataArr[1][index],dropDownDataArr[2][index]];
            
        }break;
        case 2: { // 楼层
            titleInsection = dropDownDataArr[3][index];
        }break;
        default:
            break;
    }
    return titleInsection;
}
-(NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
}

// 进入设置页面
- (void)didClickSettingButton:(UIBarButtonItem *)sender {
    NSLog(@"didclick setting sender:%@",sender);
    [self performSegueWithIdentifier:showSettingsIdentifier sender:self]; // 跳转到设置页面
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    //    [self performSegueWithIdentifier:showSettingIdentifier sender:self];
}
// 进入搜索页面
- (void)didClickSearchButton:(UIBarButtonItem *)sender {
    NSLog(@"didclick search sender:%@",sender);
//    [self performSegueWithIdentifier:showSettingsIdentifier sender:self]; // 跳转到设置页面
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    //    [self performSegueWithIdentifier:showSettingIdentifier sender:self];
}


#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_scrollView]) { // 表示不对uitablewview的scrollview生效
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        [self.segmentedControl setSelectedSegmentIndex:page];
        [self scrollToSegmentIndex:page];
    }

}
- (void)segmentedControlChangedValue:(UISegmentedControl *)segmentedControl {
    //    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    [self scrollToSegmentIndex:segmentedControl.selectedSegmentIndex];
}
- (void)scrollToSegmentIndex:(NSInteger)index {
    NSLog(@"scroll to index: %ld",(long)index);
    [dropDownView hideExtendedChooseView]; // 隐藏下拉菜单
    // 因为 有几层宿舍没人 所以宿舍和学生的数据 楼层部分有些不一样
//    selectedBuilding = dropDownDataArr[1][index];
//    selectedUnit = dropDownDataArr[2][index];
    [self chooseAtSection:1 index:[[dropDownDataArr objectAtIndex:1] indexOfObject:selectedBuilding]];
    ;
//    [[dropDownDataArr objectAtIndex:2] indexOfObject:selectedUnit];
//
//    [self chooseAtSection:2 index:0];
    [self.scrollView scrollRectToVisible:CGRectMake(index * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height - 20 - 44) animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
