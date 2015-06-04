//
//  HisDataViewController.m
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/4/2.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import "HisDataViewController.h"
#import "MacroDefinition.h"

@interface HisDataViewController (){
    StudentAccount *manager; // 账户管理
    MBProgressHUD *mbHud;

    UIImageView *headBackgroundImageView;   // 头的蓝色背景图片
    UISegmentedControl *segmentedControl; //选择查询历史数据的范围
    BEMSimpleLineGraphView *hisDataGraph; // 数据曲线
    UITableView   *hisDataTableView; // 历史记录tableview
    
    NSArray *dayHisData,*weekHisData,*monthHisData; // 日周月历史数据
    NSArray *curDisplayData;                        // 当前要显示的数据
    NSString *popUpPrefix;                          // 偷摸时的前缀
//    NSInteger curSelectedHisIndex;   // 导航

}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation HisDataViewController
@synthesize accountType,hisDataType,hisDataField,hisDataUnit;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"load hisdata");
    manager = [StudentAccount sharedStudentAccount];
    self.view.backgroundColor = lightBlueColor; // 淡蓝色背景色
    self.navigationItem.title = hisDataType;
    // 去掉导航栏下的黑框
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    // 初始化
    CGFloat widthZoom = self.view.frame.size.width/320;// 缩放比例
    CGFloat heightZoom = self.view.frame.size.height/568;
    // 背景图片
    CGRect headBackgroundImageRect = CGRectMake(0*widthZoom, 0*heightZoom, 320*widthZoom, 44*heightZoom);
    // 日期范围选择
    CGRect segmentedControlRect = CGRectMake(10*widthZoom, 7*heightZoom, 300*widthZoom, 30*heightZoom);
    // 历史数据曲线
    CGRect hisDataGraphRect = CGRectMake(0*widthZoom, 44*heightZoom, 320*widthZoom, 150*heightZoom);
    // 历史数据列表 减去导航栏
    CGRect tableViewRect = CGRectMake(0*widthZoom, 194*heightZoom, 320*widthZoom, 374*heightZoom-64);

    // 背景图片
    headBackgroundImageView = [[UIImageView alloc] initWithFrame:headBackgroundImageRect];
    headBackgroundImageView.backgroundColor = mainBlueColor; // 背景蓝色
    [self.view addSubview:headBackgroundImageView];
    
    // 日期范围选择
    segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"日", @"周",@"月"]];
    [segmentedControl setFrame:segmentedControlRect];  //
    [segmentedControl setSelectedSegmentIndex:1]; // 选择第二项
    [segmentedControl setTintColor:[UIColor whiteColor]]; //
    [self.view addSubview:segmentedControl];
    // 添加分段触发函数
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    // 历史数据曲线
    hisDataGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:hisDataGraphRect];
    hisDataGraph.delegate = self;
    hisDataGraph.dataSource = self;
    [self.view addSubview:hisDataGraph];
    // Customization of the graph
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0
    };
    hisDataGraph.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    hisDataGraph.enableTouchReport = YES;
    hisDataGraph.enablePopUpReport = YES;
    hisDataGraph.enableYAxisLabel = YES;
    hisDataGraph.enableXAxisLabel = YES;
    hisDataGraph.autoScaleYAxis = YES;
    hisDataGraph.alwaysDisplayDots = NO;
    hisDataGraph.enableReferenceXAxisLines = YES;
    hisDataGraph.enableReferenceYAxisLines = YES;
    hisDataGraph.enableReferenceAxisFrame = YES;
    hisDataGraph.colorBottom = mainBlueColor; // 背景蓝色
    hisDataGraph.colorTop = mainBlueColor; // 背景蓝色
    hisDataGraph.colorLine = UIColorFromRGB(0xFFFFFF); // 曲线白色
    hisDataGraph.colorYaxisLabel = UIColorFromRGB(0xFFFFFF); // YLabel白色
    hisDataGraph.colorXaxisLabel = UIColorFromRGB(0xFFFFFF); // XLabel白色

    hisDataGraph.animationGraphStyle = BEMLineAnimationNone;
    // Dash the y reference lines
    hisDataGraph.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
    // Show the y axis values with this format string
    hisDataGraph.formatStringForValues = @"%.2f";
    
    
    //历史数据的tableview
    hisDataTableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    //    [logTableView setRowHeight:44.0];
    hisDataTableView.delegate = self;
    hisDataTableView.dataSource = self;
    // Register cell classes
    //    [logTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    hisDataTableView.backgroundColor = lightBlueColor; // 淡蓝色背景色
    hisDataTableView.tableFooterView = [[UIView alloc] init]; // 去除多余空白行
    [self.view addSubview:hisDataTableView];
    
}
- (void)segmentedControlChangedValue:(UISegmentedControl *)aSegmentedControl {
        NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)aSegmentedControl.selectedSegmentIndex);
    [self updateInterface];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!mbHud) {  // 初始化指示器
        mbHud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:mbHud];
        mbHud.dimBackground = YES;
    }
    if(dayHisData == nil) { // 如果为空则重新请求数据
        NSLog(@"hah nil");
        [self queryDataAndShowHud]; // 请求数据
    }
}

- (void)queryDataAndShowHud {
    [mbHud showWithTitle:@"数据加载中..." detail:nil];
    [self performSelector:@selector(requestTimeout:) withObject:nil afterDelay:timeoutRequest];// 5秒的超时
    // 异步线程调用接口
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        [self queryHisData];
        // 返回主线程 处理结果
        dispatch_sync(dispatch_get_main_queue(), ^{
            [mbHud showWithTitle:@"数据加载成功!" detail:nil];
            [mbHud hide:YES afterDelay:0.5];
            [NSObject cancelPreviousPerformRequestsWithTarget:self]; // 取消前面的定时函数
            // 更新界面
            [self updateInterface];
        });
    });
}

- (void)requestTimeout:(UISwitch *)sender
{
    // 没有收到数据 显示错误指示5秒钟
    [mbHud showWithTitle:@"错误" detail:@"请求失败，请确认网络连接状态是否正常"];
    [mbHud hide:YES afterDelay:1];
}

// 获取历史数据
- (void)queryHisData {
    NSDate *dayStartDay = [NSDate dateWithTimeIntervalSinceNow:-1*23*60*60];
    NSDate *dayEndDay = [NSDate dateWithTimeIntervalSinceNow:1*1*60*60];
    NSDate *monthStartDay = [NSDate dateWithTimeIntervalSinceNow:-29*24*60*60];
    NSDate *monthEndDay = [NSDate dateWithTimeIntervalSinceNow:1*24*60*60];
    NSDate *weekStartDay = [NSDate dateWithTimeIntervalSinceNow:-6*24*60*60];
    NSDate *weekEndDay = [NSDate dateWithTimeIntervalSinceNow:1*24*60*60];

    // 设置输出日期字符串 年-月-日 时 为系统时区 查询天历史数据 只要精确到小时
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat =@"yyyy-MM-dd HH";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    // 日历史数据
    NSString *dayStartTimeStr =[dateFormatter stringFromDate:dayStartDay];
    NSString *dayEndTimeStr =[dateFormatter stringFromDate:dayEndDay];
    NSString *dayStartTime = [NSString stringWithFormat:@"%@:00",dayStartTimeStr];
    NSString *dayEndTime = [NSString stringWithFormat:@"%@:00",dayEndTimeStr];
    // 请求数据
    NSArray *nonSortArray = [WhuControlWebservice queryHisData:manager.roomID accountType:accountType field:hisDataField startTime:dayStartTime endTime:dayEndTime freq:@"1"];
    NSLog(@"roomid:%@ accounttype:%@ field:%@ starttime:%@ endtime:%@",manager.roomID,accountType,hisDataField,dayStartTime,dayEndTime);
    dayHisData = [nonSortArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj2 valueForKey:getTimeName] compare:[obj1 valueForKey:getTimeName]];
    }];
    
    // 设置输出日期字符串 年-月-日 时 为系统时区 查询周月历史数据 只要精确到天
    NSDateFormatter*dateFormatter1 = [[NSDateFormatter alloc] init];
    dateFormatter1.dateFormat =@"yyyy-MM-dd";
    [dateFormatter1 setTimeZone:[NSTimeZone systemTimeZone]];
    // 周历史数据
    NSString *weekStartTime =[dateFormatter1 stringFromDate:weekStartDay];
    NSString *weekEndTime =[dateFormatter1 stringFromDate:weekEndDay];
//    NSString *weekStartTime = [NSString stringWithFormat:@"%@",weekStartTimeStr];
//    NSString *weekEndTime = [NSString stringWithFormat:@"%@",weekEndTimeStr];
    // 请求数据
    NSArray *nonSortArray1 = [WhuControlWebservice queryHisData:manager.roomID accountType:accountType field:hisDataField startTime:weekStartTime endTime:weekEndTime freq:@"24"];
    weekHisData = [nonSortArray1 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj2 valueForKey:getTimeName] compare:[obj1 valueForKey:getTimeName]];
    }];
    // 月历史数据
    NSString *monthStartTime =[dateFormatter1 stringFromDate:monthStartDay];
    NSString *monthEndTime =[dateFormatter1 stringFromDate:monthEndDay];
    // 请求数据
    NSArray *nonSortArray2 = [WhuControlWebservice queryHisData:manager.roomID accountType:accountType field:hisDataField startTime:monthStartTime endTime:monthEndTime freq:@"24"];
    monthHisData = [nonSortArray2 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj2 valueForKey:getTimeName] compare:[obj1 valueForKey:getTimeName]];
    }];
}
- (void)updateInterface {
    // 根据当前选的分栏决定要显示的内容
    switch (segmentedControl.selectedSegmentIndex) {
        case 0: curDisplayData = dayHisData; break;     // 日
        case 1: curDisplayData = weekHisData; break;    // 周
        case 2: curDisplayData = monthHisData; break;   // 月
        default:break;
    }
    [hisDataTableView reloadData];
//    [hisDataTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES]; // 滚动到顶部
    [hisDataGraph reloadGraph];

}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    // 分为操作记录和 断电记录
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return curDisplayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: cellIdentifier];
        }
    // Configure the cell
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *aValue = [curDisplayData objectAtIndex:indexPath.row];
    NSArray *allKeys = [aValue allKeys];
    NSString *value,*date;
    if ([allKeys containsObject:valueName]) value = [aValue valueForKey:valueName];
    if ([allKeys containsObject:getTimeName]){
        date = [[aValue valueForKey:getTimeName] substringToIndex:16];
        if (segmentedControl.selectedSegmentIndex!=0)date = [[aValue valueForKey:getTimeName] substringToIndex:10];// 周和月的时间只显示到天
    }

    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",value,hisDataUnit];
    cell.detailTextLabel.text = date;
 }

#pragma mark - SimpleLineGraph Data Source
- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[curDisplayData count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    NSDictionary *aValue = [curDisplayData objectAtIndex:index];
    NSArray *allKeys = [aValue allKeys];
    NSString *value;
    if ([allKeys containsObject:valueName]) value = [aValue valueForKey:valueName];
    return [value doubleValue];
}

#pragma mark - SimpleLineGraph Delegate
- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 1;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    return [self stringDateFromIndex:index];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
//    [segmentedControl setUserInteractionEnabled:NO]; // 不允许点击
    
    popUpPrefix = [NSString stringWithFormat:@"%@ ",[self stringDateFromIndex:index]];
 //   self.labelValues.text = [NSString stringWithFormat:@"%@", [self.arrayOfValues objectAtIndex:index]];
//    self.labelDates.text = [NSString stringWithFormat:@"in %@", [self labelForDateAtIndex:index]];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
    [segmentedControl setUserInteractionEnabled:YES]; // 允许点击

//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.labelValues.alpha = 0.0;
//        self.labelDates.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
//        self.labelDates.text = [NSString stringWithFormat:@"between %@ and %@", [self labelForDateAtIndex:0], [self labelForDateAtIndex:self.arrayOfDates.count - 1]];
//        
//        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            self.labelValues.alpha = 1.0;
//            self.labelDates.alpha = 1.0;
//        } completion:nil];
//    }];
}

- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph {
//    self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
//    self.labelDates.text = [NSString stringWithFormat:@"between %@ and %@", [self labelForDateAtIndex:0], [self labelForDateAtIndex:self.arrayOfDates.count - 1]];
}

/* - (void)lineGraphDidFinishDrawing:(BEMSimpleLineGraphView *)graph {
 // Use this method for tasks after the graph has finished drawing
 } */
// 点击图标显示的附加后缀
- (NSString *)popUpSuffixForlineGraph:(BEMSimpleLineGraphView *)graph {
    return [NSString stringWithFormat:@" %@",hisDataUnit];
}
// 点击图标显示的附加前缀
- (NSString *)popUpPrefixForlineGraph:(BEMSimpleLineGraphView *)graph {
    if (!popUpPrefix) { // 为空
        popUpPrefix = @"00000";// 要先确定触摸显示的前缀的大概字符

    }
    return popUpPrefix;
}

// 根据索引显示日期 周日月不一样
- (NSString *)stringDateFromIndex:(NSInteger)index {
    NSDictionary *aValue = [curDisplayData objectAtIndex:index];
    NSArray *allKeys = [aValue allKeys];
    NSString *date;
    if ([allKeys containsObject:getTimeName]){
        date = [[aValue valueForKey:getTimeName] substringToIndex:16];
        if (segmentedControl.selectedSegmentIndex!=0)// 周和月的时间Label
            date = [date substringWithRange:NSMakeRange(5, 5)];
        else
            date = [date substringWithRange:NSMakeRange(11, 5)];
    }
    return date;
}



@end
