//
//  HisDataViewController.h
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/4/2.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"

@interface HisDataViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,BEMSimpleLineGraphDataSource,BEMSimpleLineGraphDelegate>

@property (nonatomic, strong) NSString *accountType;    // 查询的账户类型
@property (nonatomic, strong) NSString *hisDataType;    // 查询的历史数据类型
@property (nonatomic, strong) NSString *hisDataField;   // 查询的历史数据类型webservice用
@property (nonatomic, strong) NSString *hisDataUnit;    // 查询的历史数据的单位webservice用


@end

