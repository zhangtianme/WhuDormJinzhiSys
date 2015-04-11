//
//  Room.h
//  webServiceForSchool
//
//  Created by 桂初晴 on 14/11/1.
//  Copyright (c) 2014年 Whu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Room : NSObject

@property (nonatomic, strong) NSString *roomID;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *building;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *floor;
@property (nonatomic, strong) NSString *roomNum;



// some method like
// - (NSString *)returnname;

@end


