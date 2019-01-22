//
//  UserDefaultManager.m
//  ChattoSauce
//
//  Created by Drey Mill on 21/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import "UserDefaultManager.h"

@implementation UserDefaultManager

@synthesize userDefaultManager;

+(id)instance {
    static UserDefaultManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        userDefaultManager = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (BOOL)setValueForDefaults:(id)value withKey:(NSString *)key {
    [userDefaultManager setObject:value forKey:key];
    return [userDefaultManager synchronize];
}

- (BOOL)setValueForBool:(BOOL)value withKey:(NSString *)key{
    [userDefaultManager setBool:value forKey:key];
    return [userDefaultManager synchronize];
}

- (id)getValueForDefaults:(NSString *)key {
    return [userDefaultManager objectForKey:key];
}
- (BOOL)getValueForBool:(NSString *)key {
    return [userDefaultManager boolForKey:key];
}

- (BOOL)removeValueForDefaults:(NSString *)key {
    if([userDefaultManager objectForKey:key]) {
        [userDefaultManager removeObjectForKey:key];
        return [userDefaultManager synchronize];
    }
    return NO;
}

- (BOOL)removeAllValues {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [userDefaultManager removePersistentDomainForName:appDomain];
    return [userDefaultManager synchronize];
}

@end
