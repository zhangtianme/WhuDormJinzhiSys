//
//  DormTypeViewController.m
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/3/20.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import "DormTypeViewController.h"
#import "MacroDefinition.h"
#import "TallyBookViewController.h"
#import "StatusLogViewController.h"
#import "HisDataViewController.h"

#define dormInfoSections    5 // 包括 账户信息、用电状态、人员信息、宿舍详情、电量信息

#define tableViewHeaderHeight   22 // 区头的高度


@interface DormTypeViewController () {
    StudentAccount *manager; // 账户管理
    MBProgressHUD *mbHud;
    
    NSString *selectedHisDataType;  // 进入历史数据的类型
    NSString *selectedHisDataField; // 进入历史数据的类型webservice用
                NSString *selectedHisDataUnit;  // 进入历史数据的单位
}

@end

@implementation DormTypeViewController
@synthesize accountType,chargebackLabel,subsidyLabel,elecMonLabel,elecDayLabel,electricityLabel,stateSwitch,statusLabel,roomDetailsLabel,powerLabel,powerRateLabel,voltageLabel,currentLabel,studentNames,studentFacultys;

- (void)viewDidLoad {
    [super viewDidLoad];
    manager = [StudentAccount sharedStudentAccount];
    self.tableView.backgroundColor = lightBlueColor; // 淡蓝色
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"type view will appear");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"type view did appear");
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: { //0.0为记账本查询 1.1为状态查询 2.x为功率、电量、电压、电流、功率因数查询 4.x为学生查询
            if (indexPath.row == 0) { // 进入记账本
                [self performSegueWithIdentifier:showTallyBookIdentifier sender:self];
            }
        }break;
        case 1: {
            if (indexPath.row == 1) { // 进入状态日志
                [self performSegueWithIdentifier:showStatusLogIdentifier sender:self];
            }
        }break;
        case 2: { // 历史数据
            switch (indexPath.row) { //
                case 0: {selectedHisDataType = @"功率"; selectedHisDataField = powerName; selectedHisDataUnit = @"W";} break;
                case 1: {selectedHisDataType = @"电量"; selectedHisDataField = elecValueName; selectedHisDataUnit = @"度";} break;
                case 2: {selectedHisDataType = @"电压"; selectedHisDataField = voltageName;selectedHisDataUnit = @"V";} break;
                case 3: {selectedHisDataType = @"电流"; selectedHisDataField = currentName;selectedHisDataUnit = @"A";} break;
                case 4: {selectedHisDataType = @"功率因数"; selectedHisDataField = powerRateName;selectedHisDataUnit = @"";} break;
            }
            [self performSegueWithIdentifier:showHisDataIdentifier sender:self];
            
        }break;
        case 3: {
            
        }break;
        case 4: {
            if (indexPath.row <= manager.students.count) {
                [self performSegueWithIdentifier:showStudentDetailIdentifier sender:self];
            }
            
        }break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = tableViewHeaderHeight;
//    if (section == 0) { // 充值明细
//        if(monRecharge.count == 0) height = 0;
//    } else if (section == 1) { // 支出明细
//        if(monChargeback.count == 0) height = 0;
//    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *myHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, tableViewHeaderHeight)];
    myHeader.backgroundColor = lightBlueColor; // 淡蓝色背景色
    
    CGFloat width = myHeader.frame.size.width;
    CGFloat height = myHeader.frame.size.height;
    CGRect detailFrame  = CGRectMake(15, 0, width, height);
    CGFloat detailTextSize = detailFrame.size.height/1.5;
    // detail label
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:detailFrame];
    detailLabel.textAlignment = NSTextAlignmentLeft;
    detailLabel.font = [UIFont systemFontOfSize:detailTextSize];
    detailLabel.textColor = [UIColor darkGrayColor];
    detailLabel.text = @"default";
    //   [label setAdjustsFontSizeToFitWidth:YES];
    [myHeader addSubview:detailLabel];
    switch (section) {
        case 0: // 账户信息
            detailLabel.text = @"账户信息";
            break;
        case 1: // 用电状态
            detailLabel.text = @"用电状态";
            break;
        case 2: // 电量信息
            detailLabel.text = @"电量信息";
            break;
        case 3: // 宿舍详情
            detailLabel.text = @"宿舍详情";
            break;
        case 4: // 人员信息
            detailLabel.text = @"人员信息";
            break;
        default:
            break;
    }
    
    return myHeader;
}

// 数据获取完毕更新界面
- (void)updateInterfaceWithWebserviceData {
    // 先更新共有的数据
    NSLog(@"update interface type:%@",accountType);
    NSString *roomDetails = [[NSString alloc] init];
    if (manager.unit.length == 0) { // 如果单元为空
        roomDetails = [NSString stringWithFormat:@"%@-%@-%@",manager.area,manager.building,manager.roomNum];
    } else {
        roomDetails = [NSString stringWithFormat:@"%@-%@%@-%@",manager.area,manager.building,manager.unit, manager.roomNum];
    }
    roomDetailsLabel.text = roomDetails;
    
    for (int i = 0; i < manager.students.count; i++) {
        ((UILabel *)studentNames[i]).text = [manager.students[i] valueForKey:stuNameName];
        ((UILabel *)studentFacultys[i]).text = [manager.students[i] valueForKey:facultyName];
    }
    [stateSwitch setEnabled:manager.controlLimit.boolValue]; // 是否具有控制权限

    // 空调部分
    if ([accountType isEqualToString:airConName]) {
        chargebackLabel.text = [NSString stringWithFormat:@"%@元",manager.chargebackAirCon];
        subsidyLabel.text = [NSString stringWithFormat:@"%@度",manager.subsidyDegreeAirCon];
        elecMonLabel.text = [NSString stringWithFormat:@"%@度",manager.elecMonAirCon];
        electricityLabel.text = [NSString stringWithFormat:@"%@度",manager.electricityAirCon];
        
        [stateSwitch setOn:manager.stateAirCon.boolValue animated:YES];
        statusLabel.text = [NSString stringWithFormat:@"%@",manager.statusAirCon];
        
        powerLabel.text = [NSString stringWithFormat:@"%@W",manager.powerAirCon];
        elecDayLabel.text = [NSString stringWithFormat:@"%@度",manager.elecDayAirCon];
        voltageLabel.text = [NSString stringWithFormat:@"%@V",manager.voltageAirCon];
        currentLabel.text = [NSString stringWithFormat:@"%@A",manager.currentAirCon];
        powerRateLabel.text = [NSString stringWithFormat:@"%@",manager.powerRateAirCon];
    } else if ([accountType isEqualToString:lightingName]) {
        chargebackLabel.text = [NSString stringWithFormat:@"%@元",manager.chargebackLight];
//        [chargebackLabel alignBottom]; // 垂直底对齐
        subsidyLabel.text = [NSString stringWithFormat:@"%@度",manager.subsidyDegreeLight];
        elecMonLabel.text = [NSString stringWithFormat:@"%@度",manager.elecMonLight];
        electricityLabel.text = [NSString stringWithFormat:@"%@度",manager.electricityLight];
        
        [stateSwitch setOn:manager.stateLight.boolValue animated:YES];
        statusLabel.text = [NSString stringWithFormat:@"%@",manager.statusLight];
        
        powerLabel.text = [NSString stringWithFormat:@"%@W",manager.powerLight];
        elecDayLabel.text = [NSString stringWithFormat:@"%@度",manager.elecDayLight];
        voltageLabel.text = [NSString stringWithFormat:@"%@V",manager.voltageLight];
        currentLabel.text = [NSString stringWithFormat:@"%@A",manager.currentLight];
        powerRateLabel.text = [NSString stringWithFormat:@"%@",manager.powerRateLight];
    }

}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:showStudentDetailIdentifier]) { // show学生
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"selected indexpath%@",indexPath);
        StudentViewController *studentViewController = (StudentViewController *)[segue destinationViewController];
        studentViewController.student = manager.students[indexPath.row];
        studentViewController.roomDetail = roomDetailsLabel.text;
    }else if ([[segue identifier] isEqualToString:showTallyBookIdentifier]) { // show记账本
        TallyBookViewController *tallyBookViewController = (TallyBookViewController *)[segue destinationViewController];
        tallyBookViewController.accountType = accountType;
    }else if ([[segue identifier] isEqualToString:showStatusLogIdentifier]) { // show状态日志
        StatusLogViewController *statusLogViewController = (StatusLogViewController *)[segue destinationViewController];
        statusLogViewController.accountType = accountType;
    }else if ([[segue identifier] isEqualToString:showHisDataIdentifier ]) { // show历史数据
        HisDataViewController *hisDataViewController = (HisDataViewController *)[segue destinationViewController];
        hisDataViewController.accountType = accountType;
        hisDataViewController.hisDataType = selectedHisDataType;
        hisDataViewController.hisDataField = selectedHisDataField;
        hisDataViewController.hisDataUnit = selectedHisDataUnit;
    }
}

@end
