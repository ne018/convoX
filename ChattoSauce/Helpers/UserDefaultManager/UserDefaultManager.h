//
//  UserDefaultManager.h
//  ChattoSauce
//
//  Created by Drey Mill on 21/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserDefaultManager : NSObject {
    NSUserDefaults *userDefaultManager;
}

@property (nonatomic, retain) NSUserDefaults *userDefaultManager;

+ (id)instance;
- (BOOL)setValueForDefaults:(id)value withKey:(NSString *)key;
- (BOOL)setValueForBool:(BOOL)value withKey:(NSString *)key;
- (id)getValueForDefaults:(NSString *)key;
- (BOOL)getValueForBool:(NSString *)key;
- (BOOL)removeValueForDefaults:(NSString *)key;
- (BOOL)removeAllValues;

@end

NS_ASSUME_NONNULL_END
