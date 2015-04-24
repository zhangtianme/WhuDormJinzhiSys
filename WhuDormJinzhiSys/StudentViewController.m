//
//  StudentViewController.m
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/3/23.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import "StudentViewController.h"
#import "MacroDefinition.h"
@interface StudentViewController () {
    StudentAccount         *studentAccount;// 账户管理
    MBProgressHUD          *mbHud;

}

@end

@implementation StudentViewController
@synthesize student,stuIDLabel,facultyLabel,professionaLabel,phoneLabel,roomDetailLabel,roomDetail;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = lightBlueColor;
    if (!mbHud) {  // 初始化指示器
        mbHud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        
        [self.view addSubview:mbHud];
        mbHud.dimBackground = YES;
    }
    studentAccount = [StudentAccount sharedStudentAccount];
    
    if (student) {// 非空
        NSLog(@"gere");
        self.navigationItem.title = [student valueForKey:stuNameName];
        stuIDLabel.text = [student valueForKey:stuIDName];
        facultyLabel.text = [student valueForKey:facultyName];
        professionaLabel.text = [student valueForKey:professionalName];
        phoneLabel.text = [student valueForKey:phoneNumName];
        //    controlLimitLabel.text = [student valueForKey:isPermissionName];
        roomDetailLabel.text = roomDetail;
    } else {
        [mbHud showWithTitle:@"Loading..." detail:nil];
        [self performSelector:@selector(requestTimeout:) withObject:nil afterDelay:timeoutRequest];// 5秒的超时
        __block NSDictionary *userInfo = [[NSDictionary alloc] init]; //
        // 异步线程调用接口
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            // 查询学生信息
            userInfo = [WhuControlWebservice queryUserInfo:studentAccount.stuID];
            NSLog(@"userinfo:%@",userInfo);
            [self getDataFromUserInfo:userInfo];
            // 返回主线程 处理结果
            dispatch_sync(dispatch_get_main_queue(), ^{
                [mbHud hide:YES];
                [NSObject cancelPreviousPerformRequestsWithTarget:self]; // 取消前面的定时函数
                [self updateInterface];
            });
        });
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)updateInterface {
    NSLog(@"update ");
    self.navigationItem.title = studentAccount.stuName;
    stuIDLabel.text = studentAccount.stuID;
    facultyLabel.text = studentAccount.faculty;
    professionaLabel.text = studentAccount.professional;
    phoneLabel.text = studentAccount.phoneNum;
    roomDetailLabel.text = [NSString stringWithFormat:@"%@-%@%@-%@",studentAccount.area,studentAccount.building,studentAccount.unit,studentAccount.roomNum];

    [self.tableView reloadData];
}
- (void)requestTimeout:(UISwitch *)sender
{
    // 没有收到数据 显示错误指示5秒钟
    [mbHud showWithTitle:@"错误" detail:@"请求失败，请确认网络连接状态是否正常"];
    [mbHud hide:YES afterDelay:1];
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
    //
    
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

//#pragma mark - Table view data source
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
