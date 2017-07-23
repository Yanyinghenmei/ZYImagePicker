//
//  ZYLocalizableManager.h
//  SpeakEnglish
//
//  Created by Daniel on 16/4/13.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>


#define ZYLocalizedString(key, comment) [ZYLocalizableManager localizedStringForKey:key]

#define ZYLocalizedStringFromTable(key, table, comment)\
[ZYLocalizableManager localizedStringForKey:key fromTable:table]

@interface ZYLocalizableManager : NSObject

+ (NSBundle *)bundle;

+ (NSString *)localizedStringForKey:(NSString *)key fromTable:(NSString *)table;

@end
