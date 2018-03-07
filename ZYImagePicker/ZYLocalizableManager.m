//
//  ZYLocalizableManager.m
//  SpeakEnglish
//
//  Created by Daniel on 16/4/13.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "ZYLocalizableManager.h"

static NSBundle *bundle = nil;

#define UerLanguageKey  @"userLanguage"

@implementation ZYLocalizableManager

+ (NSBundle *)bundle {
    
    if (bundle == nil) {
        
        NSString *language = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] firstObject];
        //获取文件路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ZYBundle" ofType:@"bundle"];
        NSBundle *zyBundle = [NSBundle bundleWithPath:path];
        NSString *lprojPath = [zyBundle pathForResource:language ofType:@"lproj"];
        bundle = [NSBundle bundleWithPath:lprojPath];//生成bundle
    }
    
    return bundle;
}

+ (NSString *)localizedStringForKey:(NSString *)key fromTable:(NSString *)table {
    NSString *str = [[ZYLocalizableManager bundle] localizedStringForKey:key value:@"" table:table];
    if (!str) {
        str = key;
    }
    return str;
}

@end
