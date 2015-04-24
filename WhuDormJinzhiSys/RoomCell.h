//
//  RoomCell.h
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/4/22.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomCell : UITableViewCell

@property (strong, nonatomic) UIImageView  *iconImageView;
@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *lightningStatusLabel;
@property (strong, nonatomic) UISwitch *lightningStateSwitch;

@property (strong, nonatomic) UILabel *airConStatusLabel;
@property (strong, nonatomic) UISwitch *airConStateSwitch;

@end
