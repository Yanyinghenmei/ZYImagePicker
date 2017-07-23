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
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        NSString *language = [def objectForKey:UerLanguageKey];
        
        // 当没设置语言或者为空时, 跟随系统
        if(language.length == 0){
            //获取系统当前语言版本
            NSArray* languages = [def objectForKey:@"AppleLanguages"];
            
            language = [languages objectAtIndex:0];
        }
        
        //获取文件路径
        NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
        bundle = [NSBundle bundleWithPath:path];//生成bundle
    }
    
    return bundle;
}

+ (NSString *)userLanguage {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSString *language = [def objectForKey:UerLanguageKey];
    if (!language.length) {
        NSArray* languages = [def objectForKey:@"AppleLanguages"];
        
        language = [languages objectAtIndex:0];
    }
    
    return language;
}

+ (void)setUserLanguage:(NSString *)language {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setValue:language forKey:UerLanguageKey];
    [def synchronize];
    
    // 跟随系统
    if (!language.length) {
        NSArray* languages = [def objectForKey:@"AppleLanguages"];
        
        NSString *temp = [languages objectAtIndex:0];
        NSRange range = [temp rangeOfString:@"-"];
        
        if (range.length == 0) {
            language = temp;
        } else {
            language = [[languages objectAtIndex:0] substringWithRange:NSMakeRange(0, range.location)];
        }
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];
}

+ (NSString *)localizedStringForKey:(NSString *)key {
    NSString *str = [[ZYLocalizableManager bundle] localizedStringForKey:key value:@"" table:nil];
    if (!str) {
        str = key;
    }
    return str;
}

+ (NSString *)localizedStringForKey:(NSString *)key fromTable:(NSString *)table {
    NSString *str = [[ZYLocalizableManager bundle] localizedStringForKey:key value:@"" table:table];
    if (!str) {
        str = key;
    }
    return str;
}

@end
