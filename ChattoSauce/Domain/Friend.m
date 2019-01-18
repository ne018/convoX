//
//  Friend.m
//  ChattoSauce
//
//  Created by Drey Mill on 18/12/2018.
//  Copyright © 2018 iOSHive. All rights reserved.
//

#import "Friend.h"

@implementation Friend

-(instancetype)initWithName:(NSString *)name email:(NSString *)email profileImageName:(NSString *)profileimagename uniqueID:(NSString *)uniqueid{
    self = [super init];
    if(!self) return nil;
    
    _name = name;
    _email = email;
    _profileimagename = profileimagename;
    _uniqueid = uniqueid;
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        self.friendid = dict[@"friendid"];
        self.name = dict[@"name"];
        self.email = dict[@"email"];
        self.uniqueid = dict[@"uniqueid"];
        self.profileimagename = dict[@"profileimagename"];
        
        self.dictForm = dict; // custom param
    }
    return self;
}

@end
