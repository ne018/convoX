//
//  Friend.m
//  ChattoSauce
//
//  Created by Drey Mill on 18/12/2018.
//  Copyright © 2018 iOSHive. All rights reserved.
//

#import "Friend.h"

@implementation Friend

-(instancetype)initWithName:(NSString *)name profileImageName:(NSString *)profileImageName{
    self = [super init];
    if(!self) return nil;
    
    _name = name;
    _profileImageName = profileImageName;
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        self.friendid = dict[@"friendid"];
        self.name = dict[@"name"];
        self.profileImageName = dict[@"profileimagename"];
        
        self.dictForm = dict; // custom param
    }
    return self;
}

@end
