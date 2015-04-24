//
//  AllDormInfoViewController.h
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/4/18.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownChooseProtocol.h"

@interface AllDormInfoViewController : UIViewController<UIScrollViewDelegate,DropDownChooseDataSource,DropDownChooseDelegate,UITableViewDelegate,UITableViewDataSource>

@end
