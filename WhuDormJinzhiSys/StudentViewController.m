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
}

@end

@implementation StudentViewController
@synthesize student,stuIDLabel,facultyLabel,professionaLabel,phoneLabel,controlLimitLabel,roomDetailLabel,roomDetail;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [student valueForKey:stuNameName];
    stuIDLabel.text = [student valueForKey:stuIDName];
    facultyLabel.text = [student valueForKey:facultyName];
    professionaLabel.text = [student valueForKey:professionalName];
    phoneLabel.text = [student valueForKey:phoneName];
    controlLimitLabel.text = [student valueForKey:isPermissionName];
    roomDetailLabel.text = roomDetail;

//    NSString *roomDetails = [[NSString alloc] init];
//    if (manager.unit.length == 0) { // 如果单元为空
//        roomDetails = [NSString stringWithFormat:@"%@-%@-%@",manager.area,manager.building,manager.roomNum];
//    } else {
//        roomDetails = [NSString stringWithFormat:@"%@-%@%@单元-%@",manager.area,manager.building,manager.unit, manager.roomNum];
//    }
//    roomDetailLabel.text = roomDetails;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
