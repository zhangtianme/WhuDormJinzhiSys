//
//  TallyBookViewController.m
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/3/24.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import "TallyBookViewController.h"
#import "MacroDefinition.h"

#define tableViewHeaderHeight   20

@interface TallyBookViewController () {
    
    StudentAccount *manager; // 账户管理
    MBProgressHUD *mbHud;
    
    UIImageView *headBackgroundImageView;   // 头的蓝色背景图片
    UIImageView *clickImageView;            // 点击选择日期图片

    
    UILabel *yearLabel;
    UILabel *monthLabel;
    UILabel *constMonthLabel;
    UIImageView *downArrayImageView;
    
    UILabel *constMonRechargeLabel; // 月充值标签
    UILabel *monRechargeLabel;
    
    UILabel *constMonChargebackLabel; // 月支出标签
    UILabel *monChargebackLabel;
    
    UITableView   *billTableView; // 记账的tableview
    
    NSString *monTotalChargeback;       // 月支出总额
    NSString *monTotalRecharge;         // 月收入总额
    NSString *monTotalChargebackDegree; // 月支出总额 换算成度数
    NSString *monTotalRechargeDegree;   // 月收入总额 换算成度数
    
    NSArray  *monChargeback;       // 月支出明细
    NSArray  *monRecharge;         // 月收入总额
    
    NSInteger selectedYear;  // 选择要查询的年月
    NSInteger selectedMonth;
    
    UIPickerView *myPickerView; // 日期选择器
    UIToolbar *toolBar;         // 确定取消按钮
    NSArray *yearArray;         // 年选择数组
    NSArray *monthArray;        // 月选择数组
    NSInteger pickerSelectedYear; // 选择器上选择的年
    NSInteger pickerSelectedMonth; // 选择器上选择的月
    
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation TallyBookViewController

static NSString * const reuseIdentifier = @"billCell";

@synthesize accountType;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSLog(@"load tallybook");
    manager = [StudentAccount sharedStudentAccount];
    
    self.view.backgroundColor = UIColorFromRGB(0XE9F2F9); // 淡蓝色背景色

    // Do any additional setup after loading the view.
    self.navigationItem.title = @"资费记录";
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
    CGRect downArrayImageRect = CGRectMake(66*widthZoom, 45*heightZoom, 14*widthZoom, 14*heightZoom);
    CGFloat yearFontSize = 12.0*widthZoom;
    CGFloat monthFontSize = 32.0*widthZoom;
    CGFloat constMonthFontSize = 12.0*widthZoom;
    
    CGRect constMonRechargeLabelRect = CGRectMake(105*widthZoom, 10*heightZoom, 85*widthZoom, 15*heightZoom);
    CGRect monRechargeLabelRect = CGRectMake(105*widthZoom, 38*heightZoom, 85*widthZoom, 20*heightZoom);
    CGFloat constMonRechargeFontSize = 12.0*widthZoom;
    CGFloat monRechargeFontSize = 20.0*widthZoom;
    
    CGRect constMonChargebackLabelRect = CGRectMake(220*widthZoom, 10*heightZoom, 85*widthZoom, 15*heightZoom);
    CGRect monChargebackLabelRect = CGRectMake(220*widthZoom, 38*heightZoom, 85*widthZoom, 20*heightZoom);
    CGFloat constMonChargebackFontSize = 12.0*widthZoom;
    CGFloat monChargebackFontSize = 20.0*widthZoom;
    
    CGRect tableViewRect = CGRectMake(0*widthZoom, 70*heightZoom, 320*widthZoom, 498*heightZoom-64);// 减去导航栏

    // 背景图片
    headBackgroundImageView = [[UIImageView alloc] initWithFrame:headBackgroundImageRect];
    headBackgroundImageView.backgroundColor = UIColorFromRGB(0x50A0D2);
    [headBackgroundImageView setImage:[UIImage imageNamed:@"dashline.png"]];
    [self.view addSubview:headBackgroundImageView];
    // 选择日期图片
    clickImageView = [[UIImageView alloc] initWithFrame:clickRect];
    clickImageView.userInteractionEnabled = YES;
    //    [clickImageView setImage:[UIImage imageNamed:@"dashline.png"]];
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
    // 充值总计 字样
    constMonRechargeLabel = [[UILabel alloc] initWithFrame:constMonRechargeLabelRect];
    constMonRechargeLabel.font = [UIFont systemFontOfSize:constMonRechargeFontSize];
    constMonRechargeLabel.textAlignment = NSTextAlignmentLeft;
    constMonRechargeLabel.textColor = [UIColor whiteColor];
    constMonRechargeLabel.text = @"充值总计(元)";
    [self.view addSubview:constMonRechargeLabel];
    // 充值总计 数额
    monRechargeLabel = [[UILabel alloc] initWithFrame:monRechargeLabelRect];
    monRechargeLabel.font = [UIFont systemFontOfSize:monRechargeFontSize];
    monRechargeLabel.textAlignment = NSTextAlignmentLeft;
    monRechargeLabel.textColor = [UIColor whiteColor];
    monRechargeLabel.text = @"0.00元";
    [self.view addSubview:monRechargeLabel];
    // 用电总计 字样
    constMonChargebackLabel = [[UILabel alloc] initWithFrame:constMonChargebackLabelRect];
    constMonChargebackLabel.font = [UIFont systemFontOfSize:constMonChargebackFontSize];
    constMonChargebackLabel.textAlignment = NSTextAlignmentLeft;
    constMonChargebackLabel.textColor = [UIColor whiteColor];
    constMonChargebackLabel.text = @"用电总计(元)";
    [self.view addSubview:constMonChargebackLabel];
    // 用电总计 数额
    monChargebackLabel = [[UILabel alloc] initWithFrame:monChargebackLabelRect];
    monChargebackLabel.font = [UIFont systemFontOfSize:monChargebackFontSize];
    monChargebackLabel.textAlignment = NSTextAlignmentLeft;
    monChargebackLabel.textColor = [UIColor whiteColor];
    monChargebackLabel.text = @"0.00元";
    [self.view addSubview:monChargebackLabel];
    //记账的tableview
    billTableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    [billTableView setRowHeight:60.0];
    billTableView.delegate = self;
    billTableView.dataSource = self;
    // Register cell classes
    [billTableView registerClass:[BillCell class] forCellReuseIdentifier:reuseIdentifier];
    billTableView.backgroundColor = UIColorFromRGB(0XE9F2F9); // 淡蓝色背景色
    [self.view addSubview:billTableView];
    

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
    //    myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2)];
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
    [self queryDataAndShowHud]; // 请求数据
}

- (void)requestTimeout:(UISwitch *)sender
{
    // 没有收到数据 显示错误指示5秒钟
    [mbHud showWithTitle:@"错误" detail:@"请求失败，请确认网络连接状态是否正常"];
    [mbHud hide:YES afterDelay:1];
}

- (void)setDateSelectHidden:(BOOL)hidden {
    [myPickerView setHidden:hidden];
    [toolBar setHidden:hidden];
    [billTableView setScrollEnabled:hidden];
//    [billTableView setUserInteractionEnabled:hidden]; // 隐藏的时候才允许点击
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
        [self queryTallyData];
        // 返回主线程 处理结果
        dispatch_sync(dispatch_get_main_queue(), ^{
            [mbHud hide:YES];
            [NSObject cancelPreviousPerformRequestsWithTarget:self]; // 取消前面的定时函数
            // 更新界面
            [self updateInterface];
        });
    });
}


#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = tableViewHeaderHeight;
    if (section == 0) { // 充值明细
        if(monRecharge.count == 0) height = 0;
    } else if (section == 1) { // 支出明细
        if(monChargeback.count == 0) height = 0;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"how high in indexpath:%@",indexPath);
    //    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    //    NSLog(@"height:%d",cell.contentView.frame.size.height);
    //    return cell.contentView.frame.size.height;
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    static NSString *headerIdentifier = @"headerView";
//    UITableViewHeaderFooterView *myHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
//    if(!myHeader) {
//        myHeader = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerIdentifier];
//    }
//    [myHeader setFrame:CGRectMake(0, 0, billTableView.frame.size.height, tableViewHeaderHeight)];
    UIView *myHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, billTableView.frame.size.height, tableViewHeaderHeight)];
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
        case 0: // 充值明细
            detailLabel.text = @"充值明细(元):";
            break;
        case 1: // 支出明细
            detailLabel.text = @"支出明细(元):";
            break;
        default:
            break;
    }

    return myHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self setDateSelectHidden:YES]; //
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    // 分为充值记录和 支出记录
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0: // 充值明细
            return monRecharge.count;
            break;
            
        case 1: // 支出明细
        {
            NSLog(@"chargeback.count:%lu",(unsigned long)monChargeback.count);
            return monChargeback.count;
        }break;
            
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    BillCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[BillCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier: reuseIdentifier];
    }
    // Configure the cell
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    BillCell * billCell = (BillCell *)cell;
//    NSLog(@"configurecell in indexpath%@",indexPath);

    // Return the number of rows in the section.
    switch (indexPath.section) {
        case 0: {// 充值明细
            NSDictionary *aRecharge = [monRecharge objectAtIndex:indexPath.row];
            NSArray *allKeys = [aRecharge allKeys];
            NSString *stuName,*recharge;
            if ([allKeys containsObject:rechargeName]) recharge = [aRecharge valueForKey:rechargeName];
            if ([allKeys containsObject:stuNameName]) stuName = [aRecharge valueForKey:stuNameName];
    
            if ([allKeys containsObject:getTimeName]) billCell.dateLabel.text = [NSString stringWithFormat:@"%@", [[aRecharge valueForKey:getTimeName] substringToIndex:16]];
            billCell.detailLabel.text = [NSString stringWithFormat:@"%@ 充值",stuName];
            billCell.priceLabel.text = [NSString stringWithFormat:@"+%.2f",recharge.floatValue];
            
        }break;
            
        case 1: {// 支出明细
            NSDictionary *aChargeback = [monChargeback objectAtIndex:indexPath.row];
            NSArray *allKeys = [aChargeback allKeys];
            billCell.detailLabel.text = @"宿舍用电";
            if ([allKeys containsObject:chargebackName]) billCell.priceLabel.text = [NSString stringWithFormat:@"-%.2f", ((NSString *)[aChargeback valueForKey:chargebackName]).floatValue];
            if ([allKeys containsObject:getTimeName]) {
                billCell.dateLabel.text = [NSString stringWithFormat:@"%@", [[aChargeback valueForKey:getTimeName] substringToIndex:10]];
            }
        }break;
    
    
            
        default:
            break;
    }
}
- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss+zz:zz"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
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
            numerInComponent = yearArray.count;
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


// 获取账单数据
- (void)queryTallyData {
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

    // 宿舍支出记录
//    monChargeback = [WhuControlWebservice queryChargeBack:manager.roomID accountType:accountType startTime:startTime endTime:endTime freq:@"24"];
    NSArray *nonSortArray = [WhuControlWebservice queryChargeBack:manager.roomID accountType:accountType startTime:startTime endTime:endTime freq:@"24"];
    monChargeback = [nonSortArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj2 valueForKey:getTimeName] compare:[obj1 valueForKey:getTimeName]];
    }];

    NSLog(@"chargeback is :%@",monChargeback);
    // 查询学生宿舍充值记录
    NSArray *nonSortArray2 = [WhuControlWebservice queryRecharge:manager.roomID accountType:accountType startTime:startTime endTime:endTime];
    monRecharge = [nonSortArray2 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj2 valueForKey:getTimeName] compare:[obj1 valueForKey:getTimeName]];
    }];
    NSLog(@"recharge is :%@",monRecharge);
    // 查询学生宿舍某个月充值消费总计
    NSDictionary *billMonth = [WhuControlWebservice queryBillMonth:manager.roomID accountType:accountType year:[NSString stringWithFormat:@"%ld",(long)selectedYear] month:[NSString stringWithFormat:@"%ld",(long)selectedMonth]];
    [self getDataFromBillMonth:billMonth];
}
- (void)updateInterface {
    yearLabel.text = [NSString stringWithFormat:@"%04ld",selectedYear];
    monthLabel.text = [NSString stringWithFormat:@"%02ld",selectedMonth];
    monRechargeLabel.text = [NSString stringWithFormat:@"%.2f",monTotalRecharge.floatValue];
    monChargebackLabel.text = [NSString stringWithFormat:@"%.2f",monTotalChargeback.floatValue];
//    [billTableView beginUpdates];
    [billTableView reloadData];
//    [billTableView endUpdates];

}
- (void)getDataFromBillMonth:(NSDictionary *)billMonth {
    NSArray *allKeys = [billMonth allKeys];
    if ([allKeys containsObject:inRMBName]) monTotalRecharge = [billMonth valueForKey:inRMBName];
    if ([allKeys containsObject:inDegreeName]) monTotalRechargeDegree = [billMonth valueForKey:inDegreeName];
    if ([allKeys containsObject:outRMBName]) monTotalChargeback= [billMonth valueForKey:outRMBName];
    if ([allKeys containsObject:outDegreeName]) monTotalChargebackDegree = [billMonth valueForKey:outDegreeName];
    NSLog(@"in:%@ indegree:%@ out:%@ outdegree:%@",monTotalRecharge,monTotalRechargeDegree,monTotalChargeback,monTotalChargebackDegree);
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
