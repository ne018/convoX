//
//  Message.h
//  ChattoSauce
//
//  Created by Drey Mill on 19/12/2018.
//  Copyright © 2018 iOSHive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Friend.h"

NS_ASSUME_NONNULL_BEGIN


@interface Message : NSObject

@property (nonatomic, strong) NSString *messageid;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *isSender;
@property (nonatomic, strong) NSString *fkfriendid;

@property (nonatomic, strong) Friend *myFriend;

@property (nonatomic) NSDictionary *dictForm;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
