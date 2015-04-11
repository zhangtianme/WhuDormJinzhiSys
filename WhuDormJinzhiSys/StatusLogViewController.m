//
//  StatusLogViewController.m
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/3/28.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import "StatusLogViewController.h"
#import "MacroDefinition.h"
#import "LogDetailViewController.h"

#define tableViewHeaderHeight   20


@interface StatusLogViewController (){
    StudentAccount *manager; // 账户管理
    MBProgressHUD *mbHud;
    
    UIImageView *headBackgroundImageView;  // 头的蓝色背景图片
    UIImageView *clickImageView;           // 点击选择日期图片
    UILabel *yearLabel;
    UILabel *monthLabel;
    UILabel *constMonthLabel;
    UIImageView *downArrayImageView;
    
    UILabel *constMonOperateLabel;      // 月操作标签
    UILabel *monOperateLabel;
    
    UILabel *constMonExceptionLabel;    // 月断电标签
    UILabel *monExceptionLabel;
    
    UITableView   *logTableView;        // 日志记录的tableview
    
    NSString *monTotalOperate;          // 月操作总数
    NSString *monTotalException;        // 月断电总数
    
    NSArray  *monOperate;               // 月操作明细
    NSArray  *monException;             // 月断电明细
    
    NSInteger selectedYear;             // 选择要查询的年月
    NSInteger selectedMonth;
    
    UIPickerView *myPickerView;         // 日期选择器
    UIToolbar *toolBar;                 // 确定取消按钮
    NSArray *yearArray;                 // 年选择数组
    NSArray *monthArray;                // 月选择数组
    NSInteger pickerSelectedYear;       // 选择器上选择的年
    NSInteger pickerSelectedMonth;      // 选择器上选择的月

}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation StatusLogViewController
static NSString * const reuseIdentifier = @"logCell";
@synthesize accountType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    NSLog(@"load tallybook");
    manager = [StudentAccount sharedStudentAccount];
    
    self.view.backgroundColor = UIColorFromRGB(0XE9F2F9); // 淡蓝色背景色
    
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"状态日志";
    // 去掉导航栏的黑线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    // 初始化
    CGFloat widthZoom = self.view.frame.size.width/320;// 缩放比例
    CGFloat heightZoom = self.view.frame.size.height/568;
    NSLog(@"view.frame%@ bounds frame%@",NSStringFromCGRect(self.view.frame),NSStringFromCGRect(self.view.bounds));
    // 背景图片
    CGRect headBackgroundImageRect = CGRectMake(0*widthZoom, 0*heightZoom, 320*widthZoom, 70*heightZoom);
    // 点击选择日期的image
    CGRect clickRect = CGRectMake(0*widthZoom, 0*heightZoom, 90*widthZoom, 70*heightZoom);
    
    CGRect yearLabelRect = CGRectMake(15*widthZoom, 10*heightZoom, 60*widthZoom, 15*heightZoom);
    CGRect monthLabelRect = CGRectMake(15*widthZoom, 25*heightZoom, 35*widthZoom, 40*heightZoom);


    CGRect constMonthLabelRect = CGRectMake(52*widthZoom, 44*heightZoom, 14*widthZoom, 14*heightZoom);
    CGRect downArrayImageRect  = CGRectMake(66*widthZoom, 45*heightZoom, 14*widthZoom, 14*heightZoom);
    CGFloat yearFontSize       = 12.0*widthZoom;
    CGFloat monthFontSize      = 32.0*widthZoom;
    CGFloat constMonthFontSize = 12.0*widthZoom;
    
    CGRect constMonOperateLabelRect = CGRectMake(105*widthZoom, 10*heightZoom, 85*widthZoom, 15*heightZoom);
    CGRect monOperateLabelRect      = CGRectMake(105*widthZoom, 38*heightZoom, 85*widthZoom, 20*heightZoom);
    CGFloat constMonOperateFontSize = 12.0*widthZoom;
    CGFloat monOperateFontSize      = 20.0*widthZoom;
    
    CGRect constMonExceptionLabelRect = CGRectMake(220*widthZoom, 10*heightZoom, 85*widthZoom, 15*heightZoom);
    CGRect monExceptionLabelRect      = CGRectMake(220*widthZoom, 38*heightZoom, 85*widthZoom, 20*heightZoom);
    CGFloat constMonExceptionFontSize = 12.0*widthZoom;
    CGFloat monExceptionFontSize      = 20.0*widthZoom;

    CGRect tableViewRect              = CGRectMake(0*widthZoom, 70*heightZoom, 320*widthZoom, 498*heightZoom-64);// 减去导航栏
    
    // 背景图片
    headBackgroundImageView = [[UIImageView alloc] initWithFrame:headBackgroundImageRect];
    headBackgroundImageView.backgroundColor = UIColorFromRGB(0x50A0D2);
    [headBackgroundImageView setImage:[UIImage imageNamed:@"dashline.png"]];
    [self.view addSubview:headBackgroundImageView];
    // 选择日期图片
    clickImageView = [[UIImageView alloc] initWithFrame:clickRect];
    clickImageView.userInteractionEnabled = YES;
    [self.view addSubview:clickImageView];
    // 添加点击识别手势
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didChooseDate:)];
    [clickImageView addGestureRecognizer:tapRecognizer];
    
    // 年 标签
    yearLabel = [[UILabel alloc] initWithFrame:yearLabelRect];
    yearLabel.font = [UIFont systemFontOfSize:yearFontSize];
    yearLabel.textAlignment = NSTextAlignmentLeft;
    yearLabel.textColor = [UIColor whiteColor];
    yearLabel.text = @"0000年";
    [self.view addSubview:yearLabel];
    // 月 标签
    monthLabel = [[UILabel alloc] initWithFrame:monthLabelRect];
    monthLabel.font = [UIFont systemFontOfSize:monthFontSize];
    monthLabel.textAlignment = NSTextAlignmentLeft;
    monthLabel.textColor = [UIColor whiteColor];
    monthLabel.text = @"00";
    [self.view addSubview:monthLabel];
    // 月字
    constMonthLabel = [[UILabel alloc] initWithFrame:constMonthLabelRect];
    constMonthLabel.font = [UIFont systemFontOfSize:constMonthFontSize];
    constMonthLabel.textAlignment = NSTextAlignmentLeft;
    constMonthLabel.textColor = [UIColor whiteColor];
    constMonthLabel.text = @"月";
    [self.view addSubview:constMonthLabel];
    // 倒三角 下拉图案
    downArrayImageView = [[UIImageView alloc] initWithFrame:downArrayImageRect];
    [downArrayImageView setImage:[UIImage imageNamed:@"downArrow.png"]];
    //    downArrayImageView.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:downArrayImageView];
    // 操作次数总计 字样
    constMonOperateLabel = [[UILabel alloc] initWithFrame:constMonOperateLabelRect];
    constMonOperateLabel.font = [UIFont systemFontOfSize:constMonOperateFontSize];
    constMonOperateLabel.textAlignment = NSTextAlignmentLeft;
    constMonOperateLabel.textColor = [UIColor whiteColor];
    constMonOperateLabel.text = @"操作次数(次)";
    [self.view addSubview:constMonOperateLabel];
    // 操作次数总计 数字
    monOperateLabel = [[UILabel alloc] initWithFrame:monOperateLabelRect];
    monOperateLabel.font = [UIFont systemFontOfSize:monOperateFontSize];
    monOperateLabel.textAlignment = NSTextAlignmentLeft;
    monOperateLabel.textColor = [UIColor whiteColor];
    monOperateLabel.text = @"0";
    [self.view addSubview:monOperateLabel];
    // 断电次数 字样
    constMonExceptionLabel = [[UILabel alloc] initWithFrame:constMonExceptionLabelRect];
    constMonExceptionLabel.font = [UIFont systemFontOfSize:constMonExceptionFontSize];
    constMonExceptionLabel.textAlignment = NSTextAlignmentLeft;
    constMonExceptionLabel.textColor = [UIColor whiteColor];
    constMonExceptionLabel.text = @"断电次数(次)";
    [self.view addSubview:constMonExceptionLabel];
    // 断电次数总计 数字
    monExceptionLabel = [[UILabel alloc] initWithFrame:monExceptionLabelRect];
    monExceptionLabel.font = [UIFont systemFontOfSize:monExceptionFontSize];
    monExceptionLabel.textAlignment = NSTextAlignmentLeft;
    monExceptionLabel.textColor = [UIColor whiteColor];
    monExceptionLabel.text = @"0.00元";
    [self.view addSubview:monExceptionLabel];
    //状态日志的tableview
    logTableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
//    [logTableView setRowHeight:44.0];
    logTableView.delegate = self;
    logTableView.dataSource = self;
    // Register cell classes
//    [logTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    logTableView.backgroundColor = UIColorFromRGB(0XE9F2F9); // 淡蓝色背景色
    [self.view addSubview:logTableView];
    
    
    // 获取当前时间
    NSDate *dateNow=[NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//这句我也不明白具体时用来做什么。。。
    NSDateComponents *comps = [calendar components:unitFlags fromDate:dateNow];
    selectedYear=[comps year];//获取年对应的长整形字符串
    selectedMonth=[comps month];//获取月对应的长整形字符串
    pickerSelectedYear = selectedYear;
    pickerSelectedMonth = selectedMonth;
    
    if (!mbHud) {  // 初始化指示器
        mbHud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:mbHud];
        mbHud.dimBackground = YES;
    }
    
    //
    CGFloat navWidth = self.navigationController.view.frame.size.width;
    CGFloat navHeight = self.navigationController.view.frame.size.height;
    // 选择器初始化
    myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, navHeight/2+44 , navWidth, navHeight/2 -44  )]; // 默认的高度 只能阶梯式下降 所以需要再次设置框架
    [myPickerView setFrame:CGRectMake(0, navHeight-myPickerView.frame.size.height , navWidth, myPickerView.frame.size.height)];
    myPickerView.backgroundColor = UIColorFromRGB(0XE9F2F9); // 淡蓝色
    myPickerView.delegate = self;
    myPickerView.dataSource = self;
    myPickerView.showsSelectionIndicator = YES;
    [self.navigationController.view addSubview:myPickerView];
    // 选择器上的俩个按钮
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, navHeight-myPickerView.frame.size.height -44, navWidth, 44)];
    [toolBar setTintColor:UIColorFromRGB(0x50A0D2)]; // 主淡蓝色
    [self.navigationController.view addSubview:toolBar];
    NSLog(@"view:%@ naviView:%@",NSStringFromCGRect(self.view.frame),NSStringFromCGRect(self.view.frame));
    //  [pickerView addSubview:toolBar];
    UIBarButtonItem *doneToolItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didClickDoneButton)];
    UIBarButtonItem *cancelToolItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didClickCancelButton)];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:cancelToolItem, flexible, doneToolItem, nil] animated:YES];
    [self setDateSelectHidden:YES];
    // 年月数据 初始化
    monthArray = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12];
    NSMutableArray *tempYearArr = [[NSMutableArray alloc]init];
    for (int i = 99; i>=0; i--) {
        [tempYearArr addObject:[NSNumber numberWithInteger:selectedYear-i]];
    }
    yearArray = tempYearArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self setDateSelectHidden:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if(monException == nil) { // 
        NSLog(@"hah nil");
        [self queryDataAndShowHud]; // 请求数据

    }
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = tableViewHeaderHeight;
    if (section == 0) { // 操作明细
        if(monOperate.count == 0) height = 0;
    } else if (section == 1) { // 断电明细
        if(monException.count == 0) height = 0;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"how high in indexpath:%@",indexPath);
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //    static NSString *headerIdentifier = @"headerView";
    //    UITableViewHeaderFooterView *myHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    //    if(!myHeader) {
    //        myHeader = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerIdentifier];
    //    }
    //    [myHeader setFrame:CGRectMake(0, 0, logTableView.frame.size.height, tableViewHeaderHeight)];
    UIView *myHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, logTableView.frame.size.height, tableViewHeaderHeight)];
    myHeader.backgroundColor = UIColorFromRGB(0XE9F2F9); // 淡蓝色背景色
    
    CGFloat width = myHeader.frame.size.width;
    CGFloat height = myHeader.frame.size.height;
    CGRect detailFrame  = CGRectMake(15, 0, width, height);
    CGFloat detailTextSize = detailFrame.size.height/1.5;
    // detail label
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:detailFrame];
    detailLabel.textAlignment = NSTextAlignmentLeft;
    detailLabel.font = [UIFont systemFontOfSize:detailTextSize];
    detailLabel.textColor = [UIColor grayColor];
    detailLabel.text = @"default";
    //   [label setAdjustsFontSizeToFitWidth:YES];
    [myHeader addSubview:detailLabel];
    switch (section) {
        case 0: // 操作明细
            detailLabel.text = @"操作明细:";
            break;
        case 1: // 断电明细
            detailLabel.text = @"断电明细:";
            break;
        default:
            break;
    }
    return myHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setDateSelectHidden:YES]; //
    if (indexPath.section == 1) { // 断电记录 才可以 进入下一页面
        // 进入 日志详细页面
        [self performSegueWithIdentifier:showLogDetailIdentifier sender:self];
    //    [self performSegueWithIdentifier:showTallyBookIdentifier sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    // 分为操作记录和 断电记录
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0: // 操作明细
            return monOperate.count;
            break;
            
        case 1: // 断电明细
        {
            return monException.count;
        }break;
            
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier1 = @"Cell1";
    static NSString *cellIdentifier2 = @"Cell2";
    UITableViewCell *cell;
    // 断电明细
    if (indexPath.section == 1) cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        else cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
    
    if (cell == nil) {
        if (indexPath.section == 1) {//断电明细
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: cellIdentifier1];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator]; // 提示可点击
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: cellIdentifier2];
        }
    }
    // Configure the cell
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  //  BillCell * billCell = (BillCell *)cell;
    //    NSLog(@"configurecell in indexpath%@",indexPath);
    // Return the number of rows in the section.
    switch (indexPath.section) {
        case 0: {// 操作明细
            NSDictionary *aOperate = [monOperate objectAtIndex:indexPath.row];
            NSArray *allKeys = [aOperate allKeys];
            NSString *type,*onOff;
            if ([allKeys containsObject:typeName]) type = [aOperate valueForKey:typeName];
            if ([allKeys containsObject:contentsName]) onOff = [aOperate valueForKey:contentsName];
            if ([allKeys containsObject:getTimeName]) cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[aOperate valueForKey:getTimeName] substringToIndex:16]];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@",[type substringToIndex:2],[onOff isEqualToString:@"2"]?@"开启":@"关闭"];
        }break;
            
        case 1: {// 断电明细
            NSDictionary *aException = [monException objectAtIndex:indexPath.row];
            NSArray *allKeys = [aException allKeys];
            NSString *type,*contents;
            if ([allKeys containsObject:typeName]) type = [aException valueForKey:typeName];
            if ([allKeys containsObject:contentsName]) contents = [aException valueForKey:contentsName];
            if ([allKeys containsObject:getTimeName]) cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[aException valueForKey:getTimeName] substringToIndex:16]];
            cell.textLabel.text = type;
        }break;
            
        default:
            break;
    }
}
#pragma mark - Picker View Data Source
//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger numerInComponent = 0;
    
    switch (component) {
        case 0: // 年
            numerInComponent =    yearArray.count;
            break;
            
        case 1: // 月
            numerInComponent = monthArray.count;
            break;
            
        default:
            break;
    }
    return numerInComponent;
}
#pragma mark Picker View Delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    switch (component) {
        case 0: // 延迟时间
            title = [NSString stringWithFormat:@"%@年",yearArray[row]];
            break;
            
        case 1: { // 打开关闭
            title = [NSString stringWithFormat:@"%@月",monthArray[row]];
        }
            break;
        default:
            break;
    }
    return title;
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //    selectedRoom = (Room *)[roomEntityData objectAtIndex:row];
    NSLog(@"did select row:%ld component：%ld",(long)row,(long)component);
    
    switch (component) {
        case 0: { // 年
            pickerSelectedYear = [yearArray[row] integerValue];
        } break;
            
        case 1: { // 月
            pickerSelectedMonth = [monthArray[row] integerValue];
        } break;
            
        default:
            break;
    }
}
#pragma mark User Function
- (void)requestTimeout:(UISwitch *)sender
{
    // 没有收到数据 显示错误指示5秒钟
    [mbHud showWithTitle:@"错误" detail:@"请求失败，请确认网络连接状态是否正常"];
    [mbHud hide:YES afterDelay:1];
}

- (void)setDateSelectHidden:(BOOL)hidden {
    [myPickerView setHidden:hidden];
    [toolBar setHidden:hidden];
    [logTableView setScrollEnabled:hidden];
    //    [logTableView setUserInteractionEnabled:hidden]; // 隐藏的时候才允许点击

}
// 选择日期确定
- (void)didClickDoneButton {
    [self setDateSelectHidden:YES]; // 隐藏
    if (selectedMonth!=pickerSelectedMonth || selectedYear!=pickerSelectedYear) { // 如果选择的不同才请求数据
        selectedYear = pickerSelectedYear;
        selectedMonth = pickerSelectedMonth;
        [self queryDataAndShowHud]; // 请求数据
    }
}
- (void)didClickCancelButton {
    [self setDateSelectHidden:YES];
}

- (void)didChooseDate:(UITapGestureRecognizer *)sender  {
    if (!myPickerView.hidden) { // 如果不是隐藏的则
        [self setDateSelectHidden:YES];
        return;
    }
    
    [myPickerView reloadAllComponents];
    NSInteger yearIndex = 0;
    for (NSNumber *aYear in yearArray) {
        if (aYear.integerValue == selectedYear) {
            yearIndex = [yearArray indexOfObject:aYear];
        }
    }


    
    [myPickerView selectRow:yearIndex inComponent:0 animated:YES];
    NSInteger monthIndex = 0;
    for (NSNumber *aMonth in monthArray) {
        if (aMonth.integerValue == selectedMonth) {
            monthIndex = [monthArray indexOfObject:aMonth];
        }
    }
    [myPickerView selectRow:monthIndex inComponent:1 animated:YES];
    [self setDateSelectHidden:NO];
}


- (void)queryDataAndShowHud {
    [mbHud showWithTitle:@"Loading..." detail:nil];
    [self performSelector:@selector(requestTimeout:) withObject:nil afterDelay:timeoutRequest];// 5秒的超时
    // 异步线程调用接口
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        [self queryStatusLogData];
        // 返回主线程 处理结果
        dispatch_sync(dispatch_get_main_queue(), ^{
            [mbHud hide:YES];
            [NSObject cancelPreviousPerformRequestsWithTarget:self]; // 取消前面的定时函数
            // 更新界面
            [self updateInterface];
        });
    });
}

// 获取状态日志数据
- (void)queryStatusLogData {
    NSInteger endYear, endMonth;
    endMonth = selectedMonth + 1;
    endYear = selectedYear;
    if (endMonth == 13) { // 如果是最后一个月
        endMonth = 1;
        endYear +=1;
    }
    NSLog(@"year:%ld mon:%ld endyear:%ld endmonth:%ld",(long)selectedYear,(long)selectedMonth,(long)endYear,(long)endMonth);
    NSString *startTime = [NSString stringWithFormat:@"%04ld-%02ld-01 00:00:00",(long)selectedYear,(long)selectedMonth];
    NSString *endTime = [NSString stringWithFormat:@"%04ld-%02ld-01 00:00:00",(long)endYear,(long)endMonth];
    
    // 查询宿舍所有状态记录
    NSArray *requestArray = [WhuControlWebservice queryState:manager.roomID accountType:accountType startTime:startTime endTime:endTime];
    NSLog(@"all statuslog:%@",requestArray);
    // 所有状态记录 归档为 操作 和 断电俩大类
    NSMutableArray *operateArr = [[NSMutableArray alloc]init];
    NSMutableArray *exceptionArr = [[NSMutableArray alloc]init];
    for (NSDictionary *aDic in requestArray) {
        NSArray *allKeys = [aDic allKeys];
        if ([allKeys containsObject:typeName]){
            NSString *tempType = [aDic valueForKey:typeName];
            if ([tempType isEqualToString:operateName]) { // 判断是属于操作记录还是断电记录
                [operateArr addObject:aDic];
            } else {
                [exceptionArr addObject:aDic];
            }
        }
    }
    monOperate = [operateArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj2 valueForKey:getTimeName] compare:[obj1 valueForKey:getTimeName]];
    }];
    monException = [exceptionArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj2 valueForKey:getTimeName] compare:[obj1 valueForKey:getTimeName]];
    }];
    monTotalOperate = [NSString stringWithFormat:@"%lu",monOperate.count];
    monTotalException = [NSString stringWithFormat:@"%lu",monException.count];

//    // 宿舍断电记录
//    NSArray *nonSortArray = [WhuControlWebservice queryChargeBack:manager.roomID accountType:accountType startTime:startTime endTime:endTime freq:@"24"];
//    monException = [nonSortArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        return [[obj2 valueForKey:getTimeName] compare:[obj1 valueForKey:getTimeName]];
//    }];
//    
////    NSLog(@"chargeback is :%@",monException);
//    // 查询学生宿舍操作记录
//    NSArray *nonSortArray2 = [WhuControlWebservice queryRecharge:manager.roomID accountType:accountType startTime:startTime endTime:endTime];
//    monOperate = [nonSortArray2 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        return [[obj2 valueForKey:getTimeName] compare:[obj1 valueForKey:getTimeName]];
//    }];

}
- (void)updateInterface {
    yearLabel.text = [NSString stringWithFormat:@"%04ld",selectedYear];
    monthLabel.text = [NSString stringWithFormat:@"%02ld",selectedMonth];
    monOperateLabel.text = [NSString stringWithFormat:@"%ld",monTotalOperate.integerValue];
    monExceptionLabel.text = [NSString stringWithFormat:@"%ld",monTotalException.integerValue];
    //    [logTableView beginUpdates];
    [logTableView reloadData];
    //    [logTableView endUpdates];
    
}


 #pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
// Get the new view controller using [segue destinationViewController].
// Pass the selected object to the new view controller.
 if ([[segue identifier] isEqualToString:showLogDetailIdentifier]) { // show日志详细页面
     NSIndexPath *indexPath = [logTableView indexPathForSelectedRow];
     LogDetailViewController *logDetailViewController = (LogDetailViewController *)[segue destinationViewController];
     // 异常部分才会进入
     NSDictionary *aException = [monException objectAtIndex:indexPath.row];
     NSArray *allKeys = [aException allKeys];
     NSString *type,*contents;
     if ([allKeys containsObject:typeName]) type = [aException valueForKey:typeName];
     if ([allKeys containsObject:contentsName]) contents = [aException valueForKey:contentsName];
     NSLog(@"selectrow:%dCONTENTS:%@ type:%@",indexPath.row, contents,type);
     logDetailViewController.details = contents;
     logDetailViewController.title = [NSString stringWithFormat:@"%@-%@",accountType,type];
     
 }
}



@end
