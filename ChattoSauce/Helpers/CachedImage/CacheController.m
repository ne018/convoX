//
//  CacheController.m
//  ChattoSauce
//
//  Created by Drey Mill on 09/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import "CacheController.h"

static CacheController *sharedInstance = nil;

@implementation CacheController

@synthesize cache;

+(CacheController *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CacheController alloc] init];
    });
    return sharedInstance;
}

+(void)destroySharedInstance {
    sharedInstance = nil;
}

-(id)init {
    self = [super init];
    if (self) {
        self.cache = [[NSCache alloc] init];
    }
    return self;
}

-(void)setCache:(id)obj forKey:(NSString *)key {
    [self.cache setObject:obj forKey:key];
}

-(id)getCacheForKey:(NSString *)key {
    return [self.cache objectForKey:key];
}


@end
