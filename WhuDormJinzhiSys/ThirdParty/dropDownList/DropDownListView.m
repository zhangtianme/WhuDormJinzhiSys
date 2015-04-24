//
//  DropDownListView.m
//  DropDownDemo
//
//  Created by 童明城 on 14-5-28.
//  Copyright (c) 2014年 童明城. All rights reserved.
//

#import "DropDownListView.h"
#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians)*(180.0/M_PI))

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define tableviewColor 0XE9F2F9 // 淡蓝色


@interface DropDownListView ()

@property(nonatomic, assign) UIColor *titleColorNormal;
@property(nonatomic, assign) UIColor *titleColorSelected;

@end




@implementation DropDownListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame dataSource:(id)datasource delegate:(id) delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        currentExtendSection = -1;
        self.dropDownDataSource = datasource;
        self.dropDownDelegate = delegate;
        
        NSInteger sectionNum =0;
        if ([self.dropDownDataSource respondsToSelector:@selector(numberOfSections)] ) {
            sectionNum = [self.dropDownDataSource numberOfSections];
        }
        
        if (sectionNum == 0) {
            self = nil;
        }
        
        //初始化默认显示view
        CGFloat sectionWidth = (1.0*(frame.size.width)/sectionNum);
        for (int i = 0; i <sectionNum; i++) {
            UIButton *sectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(sectionWidth*i, 1, sectionWidth, frame.size.height-2)];
            sectionBtn.tag = SECTION_BTN_TAG_BEGIN + i;
            [sectionBtn addTarget:self action:@selector(sectionBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
            NSString *sectionBtnTitle = @"--";
            if ([self.dropDownDataSource respondsToSelector:@selector(titleInSection:index:)]) {
                if ([self.dropDownDataSource respondsToSelector:@selector(defaultShowSection:)]) {
                    sectionBtnTitle = [self.dropDownDataSource titleInSection:i index:[self.dropDownDataSource defaultShowSection:i]];
                } else {
                    sectionBtnTitle = [self.dropDownDataSource titleInSection:i index:0];
                }

            }
            [sectionBtn  setTitle:sectionBtnTitle forState:UIControlStateNormal];
            [sectionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sectionBtn setTitleColor:UIColorFromRGB(0x50A0D2) forState:UIControlStateReserved];
//            NSLog(@"color is %@",self.titleColorNormal);
            sectionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:self.frame.size.height/3];
            [self addSubview:sectionBtn];
            
            UIImageView *sectionBtnIv = [[UIImageView alloc] initWithFrame:CGRectMake(sectionWidth*i +(sectionWidth - 16), self.frame.size.height*3/8, self.frame.size.height/4, self.frame.size.height/4)];
            [sectionBtnIv setImage:[UIImage imageNamed:@"down_white.png"]];
            [sectionBtnIv setContentMode:UIViewContentModeScaleToFill];
            sectionBtnIv.tag = SECTION_IV_TAG_BEGIN + i;
            
            [self addSubview: sectionBtnIv];
            
            if (i<sectionNum && i != 0) {
              //  UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(sectionWidth*i, frame.size.height/4, 0.5, frame.size.height/2)];
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(sectionWidth*i, frame.size.height/8, 0.5, frame.size.height*3/4)];

                lineView.backgroundColor = [UIColor whiteColor];
                [self addSubview:lineView];
            }
        }
        
    }
    return self;
}

- (void)reloadTitle {
    NSInteger sectionNum =0;
    if ([self.dropDownDataSource respondsToSelector:@selector(numberOfSections)] ) {
        sectionNum = [self.dropDownDataSource numberOfSections];
    }
    for (int i = 0; i <sectionNum; i++) {
        NSString *sectionBtnTitle = @"--";
        if ([self.dropDownDataSource respondsToSelector:@selector(titleInSection:index:)]) {
            sectionBtnTitle = [self.dropDownDataSource titleInSection:i index:[self.dropDownDataSource defaultShowSection:i]];
            NSLog(@"reloadi:%d",i);
//
        }
        
        UIButton *btn = (id)[self viewWithTag:SECTION_BTN_TAG_BEGIN +i];
        [btn setTitle:sectionBtnTitle forState:UIControlStateNormal];
        NSLog(@"reloadi:%d",i);
    }
}

- (void)reloadData {
    for (UIView *subviews in self.subviews) {
        [subviews removeFromSuperview];
        NSLog(@"remove tag:%d subview:%@",subviews.tag,subviews);
    }
    
    CGRect frame = self.frame;
    
    NSInteger sectionNum =0;
    if ([self.dropDownDataSource respondsToSelector:@selector(numberOfSections)] ) {
        sectionNum = [self.dropDownDataSource numberOfSections];
    }

//    if (sectionNum == 0) {
//        self = nil;
//    }
//    
    //初始化默认显示view
    CGFloat sectionWidth = (1.0*(frame.size.width)/sectionNum);
    for (int i = 0; i <sectionNum; i++) {
        UIButton *sectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(sectionWidth*i, 1, sectionWidth, frame.size.height-2)];
        sectionBtn.tag = SECTION_BTN_TAG_BEGIN + i;
        [sectionBtn addTarget:self action:@selector(sectionBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
        NSString *sectionBtnTitle = @"--";
        if ([self.dropDownDataSource respondsToSelector:@selector(titleInSection:index:)]) {
            sectionBtnTitle = [self.dropDownDataSource titleInSection:i index:[self.dropDownDataSource defaultShowSection:i]];
        }
        [sectionBtn  setTitle:sectionBtnTitle forState:UIControlStateNormal];
        [sectionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sectionBtn setTitleColor:UIColorFromRGB(0x50A0D2) forState:UIControlStateReserved];
//        NSLog(@"color is %@",self.titleColorNormal);
        sectionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:self.frame.size.height/3];
        [self addSubview:sectionBtn];
        
        UIImageView *sectionBtnIv = [[UIImageView alloc] initWithFrame:CGRectMake(sectionWidth*i +(sectionWidth - 16), self.frame.size.height*3/8, self.frame.size.height/4, self.frame.size.height/4)];
        [sectionBtnIv setImage:[UIImage imageNamed:@"down_white.png"]];
        [sectionBtnIv setContentMode:UIViewContentModeScaleToFill];
        sectionBtnIv.tag = SECTION_IV_TAG_BEGIN + i;
        
        [self addSubview: sectionBtnIv];
        
        if (i<sectionNum && i != 0) {
            //  UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(sectionWidth*i, frame.size.height/4, 0.5, frame.size.height/2)];
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(sectionWidth*i, frame.size.height/8, 0.5, frame.size.height*3/4)];
            
            lineView.backgroundColor = [UIColor whiteColor];
            [self addSubview:lineView];
        }
    }
}

-(void)sectionBtnTouch:(UIButton *)btn
{
    NSInteger section = btn.tag - SECTION_BTN_TAG_BEGIN;
    
    UIImageView *currentIV= (UIImageView *)[self viewWithTag:(SECTION_IV_TAG_BEGIN +currentExtendSection)];//上次的箭头反转过来
    
    [UIView animateWithDuration:0.3 animations:^{
        currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));

    }];
    
    if (currentExtendSection == section) {
        [self hideExtendedChooseView];
    }else{
        currentExtendSection = section;
        currentIV = (UIImageView *)[self viewWithTag:SECTION_IV_TAG_BEGIN + currentExtendSection];
        [UIView animateWithDuration:0.3 animations:^{
            currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
        }];// 这次选择的箭头反转过来
        if ([self.dropDownDataSource respondsToSelector:@selector(defaultShowSection:)]) {
            [self showChooseListViewInSection:currentExtendSection choosedIndex:[self.dropDownDataSource defaultShowSection:currentExtendSection]];
        } else {
            [self showChooseListViewInSection:currentExtendSection choosedIndex:0];

        }
    }

}

- (void)setTitle:(NSString *)title inSection:(NSInteger) section
{
    UIButton *btn = (id)[self viewWithTag:SECTION_BTN_TAG_BEGIN +section];
    [btn setTitle:title forState:UIControlStateNormal];
}

- (BOOL)isShow
{
    if (currentExtendSection == -1) {
        return NO;
    }
    return YES;
}

-  (void)hideExtendedChooseView
{
    if (currentExtendSection != -1) {
        currentExtendSection = -1;
        CGRect rect = self.mTableView.frame;
        rect.size.height = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.mTableBaseView.alpha = 1.0f;
            self.mTableView.alpha = 1.0f;
            
            self.mTableBaseView.alpha = 0.2f;
            self.mTableView.alpha = 0.2;
            
            self.mTableView.frame = rect;
        }completion:^(BOOL finished) {
            [self.mTableView removeFromSuperview];
            [self.mTableBaseView removeFromSuperview];
        }];
    }
}

-(void)showChooseListViewInSection:(NSInteger)section choosedIndex:(NSInteger)index
{
    if (!self.mTableView) {
        self.mTableBaseView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height , self.frame.size.width, self.mSuperView.frame.size.height - self.frame.origin.y - self.frame.size.height)];
//        self.mTableBaseView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        self.mTableBaseView.backgroundColor = UIColorFromRGB(tableviewColor);
        
        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
        [self.mTableBaseView addGestureRecognizer:bgTap];
        
    //    self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 240) style:UITableViewStylePlain];
        self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 240) style:UITableViewStylePlain];
        
        self.mTableView.backgroundColor = UIColorFromRGB(tableviewColor);
//        self.mTableView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
//        self.mTableView.backgroundColor = UIColorFromRGB(0xffffff);

        self.mTableView.delegate = self;
        self.mTableView.dataSource = self;
    }
    
    //修改tableview的frame
    int sectionWidth = (self.frame.size.width)/[self.dropDownDataSource numberOfSections];
    CGRect rect = self.mTableView.frame;
    rect.origin.x = sectionWidth *section;
    rect.size.width = sectionWidth;
    rect.size.height = 0;
    self.mTableView.frame = rect;
    [self.mSuperView addSubview:self.mTableBaseView];
    [self.mSuperView addSubview:self.mTableView];
    
    //动画设置位置
    rect.size.height = 40 *[self.dropDownDataSource numberOfRowsInSection:currentExtendSection];
    [UIView animateWithDuration:0.2 animations:^{
        self.mTableBaseView.alpha = 0.2;
        self.mTableView.alpha = 
        self.mTableBaseView.alpha = 0.8;
        self.mTableView.alpha = 0.8;
        self.mTableView.frame =  rect;
    }];

    [self.mTableView reloadData];
}

-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    UIImageView *currentIV = (UIImageView *)[self viewWithTag:(SECTION_IV_TAG_BEGIN + currentExtendSection)];
    [UIView animateWithDuration:0.3 animations:^{
        currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
    }];
    [self hideExtendedChooseView];
}
#pragma mark -- UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *currentIV = (UIImageView *)[self viewWithTag:(SECTION_IV_TAG_BEGIN + currentExtendSection)];
    [UIView animateWithDuration:0.3 animations:^{
        currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
    }];  // 反转过来
    
    if ([self.dropDownDelegate respondsToSelector:@selector(chooseAtSection:index:)]) {
        NSString *chooseCellTitle = [self.dropDownDataSource titleInSection:currentExtendSection index:indexPath.row];
        
        UIButton *currentSectionBtn = (UIButton *)[self viewWithTag:SECTION_BTN_TAG_BEGIN + currentExtendSection];
        [currentSectionBtn setTitle:chooseCellTitle forState:UIControlStateNormal];
        
        [self.dropDownDelegate chooseAtSection:currentExtendSection index:indexPath.row];
        [self hideExtendedChooseView];
    }
}

#pragma mark -- UITableView DataSource


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dropDownDataSource numberOfRowsInSection:currentExtendSection];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [self.dropDownDataSource titleInSection:currentExtendSection index:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    return cell;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
