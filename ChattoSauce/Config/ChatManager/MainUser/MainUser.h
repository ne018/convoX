//
//  MainUser.h
//  ChattoSauce
//
//  Created by Drey Mill on 21/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainUser : NSObject

@property (nonatomic, strong) NSString *hostname;
@property (nonatomic, strong) NSString *jabberID;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *chatID;

+ (id)instance;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
