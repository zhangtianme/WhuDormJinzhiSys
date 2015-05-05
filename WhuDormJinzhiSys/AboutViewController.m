//
//  AboutViewController.m
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/4/23.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import "AboutViewController.h"
#import "MacroDefinition.h"
@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.title = @"关于";
    self.view.backgroundColor = mainBlueColor;
//    NSString *version = [[NSBundle mainBundle]  objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
//    NSString *build = [[NSBundle mainBundle]  objectForInfoDictionaryKey:@"CFBundleVersion"];
//    NSString *name = [[NSBundle mainBundle]  objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];

     double doubleversion = version.doubleValue;
    NSLog(@"veision:%@ build:%@ name:%@ doubleversion:%f",version,build,name,doubleversion);
    _nameLabel.text = [NSString stringWithFormat:@"武大宿舍用电V%@(%@)",version,build];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
