//
//  Message.m
//  ChattoSauce
//
//  Created by Drey Mill on 19/12/2018.
//  Copyright © 2018 iOSHive. All rights reserved.
//

#import "Message.h"

@implementation Message

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        self.messageid = dict[@"messageid"];
        self.text = dict[@"text"];
        self.date = [NSDate dateWithTimeIntervalSince1970:[dict[@"date"] doubleValue]];
        self.isSender = [NSNumber numberWithBool:[dict[@"isSender"] boolValue]];
        self.fkfriendid = dict[@"fkfriendid"];
        
        self.dictForm = dict; // custom param
    }
    return self;
}


@end
