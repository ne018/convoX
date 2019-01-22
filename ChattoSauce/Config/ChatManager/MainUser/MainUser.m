//
//  MainUser.m
//  ChattoSauce
//
//  Created by Drey Mill on 21/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import "MainUser.h"

@implementation MainUser

static MainUser *myUser;

+ (id)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myUser = [[MainUser alloc] init];
    });
    return myUser;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if(self = [super init]) {
        self.password = [dict objectForKey:@"password"];
        self.jabberID = [dict objectForKey:@"jabberID"];
        self.chatID = [dict objectForKey:@"chatID"];
        self.hostname = [dict objectForKey:@"hostname"];
    }
    return self;
}

+ (NSString *)getHostname:(NSString *)jabberID {
    return [[jabberID componentsSeparatedByString:@"@"] objectAtIndex:1];
}


@end
