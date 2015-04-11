//
//  BillCell.m
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/3/27.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import "BillCell.h"

@implementation BillCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    NSLog(@"billcell initWithStyle");
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
//    NSLog(@"set frame frame:%@",NSStringFromCGRect(frame));
   // frame.size.width= 375;//VIEW_WIDTH这里是屏幕竖屏时的宽
    [super setFrame:frame];
    [self setup];

}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
//    NSLog(@"billcell initWithCoder");
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
//    NSLog(@"billcell initWithFrame");
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    CGFloat width = self.contentView.frame.size.width;
    CGFloat height = self.contentView.frame.size.height;
//    NSLog(@"width:%f height:%f viewheight:%f",width,height,self.bounds.size.height);
    // 图标和标签的框架
    CGRect detailFrame  = CGRectMake(15, height/6, width/2, height/2);
    CGRect dateFrame    = CGRectMake(15, height*2/3, width/2, height/3);
    CGRect priceFrame   = CGRectMake(width/2, 0, width/2-8, height);
    
    CGFloat detailTextSize = detailFrame.size.height/1.5;
    CGFloat dateTextSize = dateFrame.size.height/1.3;
    CGFloat priceTextSize = priceFrame.size.height/2.4;
    
    // detail label
    if (!self.detailLabel) { // 如果空
//        NSLog(@"nil");
        self.detailLabel = [[UILabel alloc] init];
        self.detailLabel.textAlignment = NSTextAlignmentLeft;
        self.detailLabel.textColor = [UIColor blackColor];
        self.detailLabel.text = @"宿舍用电";
        [self addSubview:self.detailLabel];
    }
    [self.detailLabel setFrame:detailFrame];
    self.detailLabel.font = [UIFont systemFontOfSize:detailTextSize];
    //   [label setAdjustsFontSizeToFitWidth:YES];
    
    // date label
    if (!self.dateLabel) { // 如果空
        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.textAlignment = NSTextAlignmentLeft;
        self.dateLabel.textColor = [UIColor lightGrayColor];
        self.dateLabel.text = @"20XX-XX-XX 20:00";
        [self addSubview:self.dateLabel];
    }
    [self.dateLabel setFrame:dateFrame];
    self.dateLabel.font = [UIFont systemFontOfSize:dateTextSize];
    //   [label setAdjustsFontSizeToFitWidth:YES];

    // price label
    if (!self.priceLabel) { // 如果空
        self.priceLabel = [[UILabel alloc] init];
        self.priceLabel.textAlignment = NSTextAlignmentRight;
        self.priceLabel.textColor = [UIColor lightGrayColor];
        self.priceLabel.text = @"-1.0";
        [self addSubview:self.priceLabel];
    }
    [self.priceLabel setFrame:priceFrame];
    self.priceLabel.font = [UIFont systemFontOfSize:priceTextSize];
    //   [label setAdjustsFontSizeToFitWidth:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
