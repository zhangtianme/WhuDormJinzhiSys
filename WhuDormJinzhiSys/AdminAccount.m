//
//  AdminAccount.m
//  WhuDormJinzhiSys
//
//  Created by 桂初晴 on 15/4/18.
//  Copyright (c) 2015年 Whu. All rights reserved.
//

#import "AdminAccount.h"
#import "MacroDefinition.h"

@implementation AdminAccount

+ (AdminAccount *)sharedAdminAccount
{
    static AdminAccount *sharedAdminAccount = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAdminAccount = [[self alloc] init];
    });
    
    return sharedAdminAccount;
}

@end
