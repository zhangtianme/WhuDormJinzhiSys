//
//  DormTypeViewController.h
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/3/20.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DormTypeViewController : UITableViewController

@property (nonatomic, strong) NSString *accountType; // 是空调还是照明

@property (weak, nonatomic) IBOutlet UILabel  *chargebackLabel;
@property (weak, nonatomic) IBOutlet UILabel  *subsidyLabel;
@property (weak, nonatomic) IBOutlet UILabel  *elecMonLabel;
@property (weak, nonatomic) IBOutlet UILabel  *electricityLabel;

@property (weak, nonatomic) IBOutlet UISwitch *stateSwitch;
@property (weak, nonatomic) IBOutlet UILabel  *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel  *roomDetailsLabel;

@property (weak, nonatomic) IBOutlet UILabel  *powerLabel;
@property (weak, nonatomic) IBOutlet UILabel  *elecDayLabel;
@property (weak, nonatomic) IBOutlet UILabel  *voltageLabel;
@property (weak, nonatomic) IBOutlet UILabel  *currentLabel;
@property (weak, nonatomic) IBOutlet UILabel  *powerRateLabel;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *studentNames;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *studentFacultys;
//TODO:
//???://???:XXX//FIXME: //FIXME: //FIXME: //TODO:
- (void)updateInterfaceWithWebserviceData; // 数据获取完毕更新界面
@end
