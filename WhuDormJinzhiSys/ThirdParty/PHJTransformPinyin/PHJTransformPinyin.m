//
//  PHJTransformPinyin.m
//  PHJTransformPinyinDemo
//
//  Created by Haijiao on 14/11/28.
//  Copyright (c) 2014年 olinone. All rights reserved.
//

#import "PHJTransformPinyin.h"

@implementation NSString (TransformToPinyin)

- (NSString *)transformToPinyin
{
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    NSString *pinyinString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return pinyinString;
}

- (NSString *)transformToPinyinWithoutSpace
{
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    NSString *pinyinString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    pinyinString = [pinyinString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return pinyinString;
}
//- (NSString *)transformToPinyin {
//    NSMutableString *mutableString = [NSMutableString stringWithString:self];
//    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
//    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
//    return mutableString;
//}

@end
