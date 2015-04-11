//
//  Room.m
//  webServiceForSchool
//
//  Created by 桂初晴 on 14/11/1.
//  Copyright (c) 2014年 Whu. All rights reserved.
//

#import "Room.h"

@implementation Room

- (id)init {
    self = [super init];
    if (self) {
        // init code
        [self commonInit];
    }
    return self;
}
- (void)commonInit {
    self.area = @"";
    self.building = @"";
    self.unit = @"";
    self.floor = @"";
    self.roomNum = @"";
    self.roomID = @"";
}

- (NSString *)description {
    return [NSString stringWithFormat:@"area:%@ building:%@ unit:%@ floor:%@ roomNum:%@ roomID:%@",self.area,self.building,self.unit,self.floor,self.roomNum,self.roomID];
}





@end
