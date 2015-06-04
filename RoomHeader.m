//
//  RoomHeader.m
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/4/23.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import "RoomHeader.h"
#import "MacroDefinition.h"

@implementation RoomHeader


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
//    NSLog(@"roomcell initWithReuseIdentifier");
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
//    NSLog(@"roomcell initWithCoder");

    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
//            NSLog(@"roomcell initWithFrame");
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setFrame:(CGRect)frame {
//            NSLog(@"set frame frame:%@",NSStringFromCGRect(frame));
    [super setFrame:frame];
    [self setup];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setup];
}

- (void)setup {
    CGFloat width                     = self.contentView.frame.size.width;
    CGFloat height                    = self.contentView.frame.size.height;
//    NSLog(@"width:%f height:%f",width,height);
    // 图标和标签的框架
    CGRect detailLabelFrame         = CGRectMake(15, 0, width, height);
    CGFloat detailLabelTextSize         = height/1.5;
    
    self.backgroundView.backgroundColor = lightBlueColor; // 淡蓝色背景色

    // name label
    if (!_detailLabel) { // 如果空
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.textColor = [UIColor blackColor];
        _detailLabel.text = @"";
        [self addSubview:_detailLabel];
    }
    [_detailLabel setFrame:detailLabelFrame];
    _detailLabel.font = [UIFont systemFontOfSize:detailLabelTextSize];
    
}


@end
