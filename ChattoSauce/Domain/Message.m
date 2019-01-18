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
        self.fromuniqueid = dict[@"fromUniqueId"];
        self.touniqueid = dict[@"toUniqueId"];
        self.imageUrl = dict[@"imageUrl"];
        self.imageWidth = dict[@"imageWidth"];
        self.imageHeight = dict[@"imageHeight"];
        self.type = dict[@"type"];
        
//        self.isSender = [NSNumber numberWithBool:[dict[@"isSender"] boolValue]];
//        self.fkfriendid = dict[@"fkfriendid"];
        
        self.dictForm = dict; // custom param
    }
    return self;
}

-(NSString *)chatPartnerId{
    return [self.fromuniqueid isEqualToString:FIRAuth.auth.currentUser.uid] ? self.touniqueid : self.fromuniqueid;
}


@end
