//
//  Student.m
//  webServiceForSchool
//
//  Created by 桂初晴 on 14/11/1.
//  Copyright (c) 2014年 Whu. All rights reserved.
//

#import "Student.h"

@implementation Student

- (id)init {
    self = [super init];
    if (self) {
        // init code
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.studentID = @"";
    self.studentName = @"";
    self.faculty = @"";
    self.professional = @"";
    self.phoneNum = @"";
    self.roomID = @"";
    self.password = @"";
    self.role = @"";
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ID:%@ name:%@ faculty:%@ professional:%@ phoneNum:%@ roomID:%@ password:%@ role:%@",self.studentID,self.studentName,self.faculty,self.professional,self.phoneNum,self.roomID,self.password,self.role];
}

@end
