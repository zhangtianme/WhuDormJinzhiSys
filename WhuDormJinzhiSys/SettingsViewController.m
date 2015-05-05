//
//  SettingsViewController.m
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/4/18.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import "SettingsViewController.h"
#import "MacroDefinition.h"
#define modifyPhoneSection    1// 修改手机号所在行
#define modifyPasswordSection 2// 修改密码所在行
#define aboutSection          3// 关于所在行
#define versionUpdateSection  4// 版本更新所在行
#define logoutSection         5// 退出登陆所在行

@interface SettingsViewController () {
    AccountManager *accountManager;
}

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    accountManager = [AccountManager sharedAccountManager];
    self.tableView.backgroundColor = lightBlueColor;
    self.navigationItem.title = @"设置";
    _userIDLabel.text = accountManager.userID;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            
        }break;
        case modifyPhoneSection:{// 修改手机号
            [self performSegueWithIdentifier:showModifyPhoneIdentifier sender:self];
        }break;
        case modifyPasswordSection:{//修改密码
            [self performSegueWithIdentifier:showModifyPasswordIdentifier sender:self];
        }break;
        case aboutSection:{//关于
            [self performSegueWithIdentifier:showAboutIdentifier sender:self];

        }break;
        case versionUpdateSection:{//版本更新
            NSDictionary *version = [WhuControlWebservice queryVersionWithType:iOSTypeName];
            NSLog(@"version is:%@",version);
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            double doubleCurrentVersion = [[infoDictionary objectForKey:@"CFBundleShortVersionString"] doubleValue];
            double doubleUpdateVersion;
            NSArray *allKeys = [version allKeys];
            if ([allKeys containsObject:versionNameName]) {
                doubleUpdateVersion = [[version valueForKey:versionNameName] doubleValue];
            }
            if (doubleCurrentVersion<doubleUpdateVersion) { // 需要版本更新
                NSLog(@"need upadteversion");
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发现新版本是否需要升级?" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"升级" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {// 升级
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[version valueForKey:urlName]]];
                }]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
            } else { // 不需要更新
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"暂无新版本" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
                
            }
            
        }break;
        case logoutSection:{//退出登录
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定退出登录?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {// 退出登陆
                [accountManager logOut];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];

            [self presentViewController:alertController animated:YES completion:nil];

        }break;
        default:
            break;
    }

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES]; // 反选
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:; forIndexPath:indexPath];
    
    // Configure the cell...
    define
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
