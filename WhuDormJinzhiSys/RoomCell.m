//
//  RoomCell.m
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/4/22.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import "RoomCell.h"
#import "MacroDefinition.h"

@implementation RoomCell

- (void)awakeFromNib {
    // Initialization code
}
- (id)init {
    self = [super init];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    NSLog(@"roomcell initWithStyle");
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
//        NSLog(@"roomcell initWithCoder");
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
//        NSLog(@"roomcell initWithFrame");
    if (self) {
        [self setup];
    }
    return self;
}
/**
 *  一个神奇的方法
 */
- (void)layoutSubviews {
    [super layoutSubviews];
//    NSLog(@"loyout subviews;");
    [self setup];
}

//- (void)setFrame:(CGRect)frame {
////        NSLog(@"set frame frame:%@",NSStringFromCGRect(frame));
//    [super setFrame:frame];
////    [self setup];
//}
//CGRect headBackgroundImageRect = CGRectMake(0*widthZoom, 0*heightZoom, 320*widthZoom, 44*heightZoom);

- (void)setup {
//    self.contentView.frame.size.height = 60; // 固定高度
//    CGFloat width                     = self.contentView.frame.size.width;
//    CGFloat height                    = self.contentView.frame.size.height;
//    CGFloat heightZoom                 = self.contentView.frame.size.height/60;// 缩放比例
    CGFloat widthZoom                 = self.contentView.frame.size.width/287;// 缩放比例  加上右边箭头之后宽度只有287
    
//    CGFloat heightZoom = self.contentView.frame.size.height/60;// 缩放比例

//        NSLog(@"width:%f height:%f viewheight:%f",width,height,self.bounds.size.height);
    // 图标和标签的框架
    CGRect iconImageViewFrame     = CGRectMake(15, 7, 45, 45);
    CGRect nameLabelFrame         = CGRectMake(70*widthZoom, 19, 30*widthZoom, 21);
    CGRect lightStatusLabelFrame  = CGRectMake(100*widthZoom, 5, 93*widthZoom, 15);
    CGRect lightStateSwitchFrame  = CGRectMake(122*widthZoom, 24, 51*widthZoom, 31);
    CGRect airConStatusLabelFrame = CGRectMake(194*widthZoom, 5, 93*widthZoom, 15);
    CGRect airConStateSwitchFrame = CGRectMake(216*widthZoom, 24, 51*widthZoom, 31);

    CGFloat nameLabelTextSize         = 17.0f;
    CGFloat lightStatusLabelTextSize  = 14.0f;
    CGFloat airConStatusLabelTextSize = 14.0f;

    // icon imageview
    if (!_iconImageView) { // 如果空
//        NSLog(@"icon image nil");
        _iconImageView = [[UIImageView alloc] init];
        [self addSubview:_iconImageView];
    }
    [_iconImageView setFrame:iconImageViewFrame];
    
    // name label
    if (!self.nameLabel) { // 如果空
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.textColor = [UIColor blackColor];
        _nameLabel.text = @"201";
        [self addSubview:_nameLabel];
    }
    [_nameLabel setFrame:nameLabelFrame];
    _nameLabel.font = [UIFont systemFontOfSize:nameLabelTextSize];
    
    // lightning Status Label 照明异常状态
    if (!_lightningStatusLabel) { // 如果空
        _lightningStatusLabel = [[UILabel alloc] init];
        _lightningStatusLabel.textAlignment = NSTextAlignmentCenter;
        _lightningStatusLabel.textColor = [UIColor lightGrayColor];
        _lightningStatusLabel.text = @"照明:正常";
        [self addSubview:_lightningStatusLabel];
    }
    [_lightningStatusLabel setFrame:lightStatusLabelFrame];
    _lightningStatusLabel.font = [UIFont systemFontOfSize:lightStatusLabelTextSize];

    // airCon Status Label 空调异常状态
    if (!_airConStatusLabel) { // 如果空
        _airConStatusLabel = [[UILabel alloc] init];
        _airConStatusLabel.textAlignment = NSTextAlignmentCenter;
        _airConStatusLabel.textColor = [UIColor lightGrayColor];
        _airConStatusLabel.text = @"空调:正常";
        [self addSubview:_airConStatusLabel];
    }
    [_airConStatusLabel setFrame:airConStatusLabelFrame];
    _airConStatusLabel.font = [UIFont systemFontOfSize:airConStatusLabelTextSize];
    
    // lightning State Switch 照明开关状态
    if (!_lightningStateSwitch) { // 如果空
        _lightningStateSwitch = [[UISwitch alloc] initWithFrame:lightStateSwitchFrame];
        _lightningStateSwitch.onTintColor = mainBlueColor;
        [self addSubview:_lightningStateSwitch];
    }
    if (isDemoVersion) { // 是demo版本
        [_lightningStateSwitch setUserInteractionEnabled:NO];// demo版本 不能点击
    }
    [_lightningStateSwitch setFrame:lightStateSwitchFrame];

    
    // airCon State Switch 空调开关状态
    if (!_airConStateSwitch) { // 如果空
        _airConStateSwitch = [[UISwitch alloc] initWithFrame:airConStateSwitchFrame];
        _airConStateSwitch.onTintColor = mainBlueColor;
        [self addSubview:_airConStateSwitch];
    }
    [_airConStateSwitch setUserInteractionEnabled:NO];// demo版本 不能点击
    [_airConStateSwitch setFrame:airConStateSwitchFrame];

}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    NSLog(@"set selected");
//    // Configure the view for the selected state
//}

@end
