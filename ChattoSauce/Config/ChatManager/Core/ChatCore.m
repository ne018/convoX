//
//  ChatCore.m
//  ChattoSauce
//
//  Created by Drey Mill on 21/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import "ChatCore.h"
#import "AppDelegate.h"
#import "UserDefaultManager.h"

@interface ChatCore ()

@end

@implementation ChatCore{
    dispatch_queue_t csCoreQueue;
    void *csCoreQueueTag;
    
    __block AppDelegate *delegate;
}

static ChatCore *manager;

#pragma mark - Singleton mode

+ (id)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ChatCore alloc] init];
    });
    return manager;
}

-(MainUser *)myUser{
    if(!_myUser){
        _myUser = [[MainUser alloc] init];
    }
    return _myUser;
}

- (instancetype)init {
    self = [super init];
    if(self){
        // setupStream
        self.xmppStream = [[XMPPStream alloc] init];
        
        // delegate
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)];
        
        //use for custom delegation of this class
        self.multicastDelegate = (GCDMulticastDelegate<ChatCoreDelegate> *)[[GCDMulticastDelegate alloc] init];
    }
    return self;
}

-(void)sendPresenceWhenOnline:(XMPPStream *)sender{
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
}

-(void)goOfflineMode {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [self.xmppStream sendElement:presence];
}

- (void)registerWithUsername:(NSString *)username withPassword:(NSString *)pass withHostname:(NSString *)hostname{
    [self connectStream:username hostname:hostname password:pass];
}

// Connecting
- (BOOL)connectStream:(NSString *)username hostname:(NSString *)hostname password:(NSString *)password{
    if(![self.xmppStream isDisconnected]) {
        return YES;
    }
    if(username == nil || username.length == 0) {
        return NO;
    }
    
    self.myUser.hostname = hostname;
    self.myUser.password = password;
    self.myUser.jabberID = username;
    
    [self setStreamComponents:self.xmppStream withUser:username withHostname:hostname withPassword:password];
    return YES;
}

- (void)setStreamComponents:(XMPPStream *)sender withUser:(NSString *)username withHostname:(NSString *)hostname withPassword:(NSString *)password{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self->delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    });
    
    [self validateIfInBackgroundMode];
    
    [sender setMyJID:[XMPPJID jidWithString:username]];
    [sender setHostName:self.myUser.hostname];
    [sender setHostPort:UINT16_C(5222)];
    sender.startTLSPolicy = XMPPStreamStartTLSPolicyAllowed;
    NSError *error = nil;
    if(![sender connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        NSLog(@"Pingooo! %@", error.description);
        if(!self.isDisconnectedStreamFromError) {
            self.isDisconnectedStreamFromError = YES;
            if(self.multicastDelegate && [self.multicastDelegate hasDelegateThatRespondsToSelector:@selector(didDisconnectStreamDueToCertainError:)]) {
                [self.multicastDelegate didDisconnectStreamDueToCertainError:error.description];
            }
        }
    }
    
}

// Authenticating
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    //    __block AppDelegate *delegate;
    dispatch_async(dispatch_get_main_queue(), ^{
        self->delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    });
    
    dispatch_block_t block = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"stream connected");
            [sender authenticateWithPassword:self.myUser.password error:nil];
        });
    };
    
    if(dispatch_get_specific(csCoreQueueTag)) {
        block();
    } else {
        dispatch_async(csCoreQueue, block);
    }
}

-(void)validateIfInBackgroundMode{
    // validate if in bg mode
    if([delegate applicationBackgroundMode]){
        [self disconnectStream];
        return;
    }
}

- (void)disconnectStream {
    if([self.xmppStream isConnected]) {
        [self goOfflineMode];
        [self.xmppStream disconnectAfterSending];
    }
}

- (void)authorizeConnection {
    if(self.xmppStream.isConnected) {
        NSError *error = nil;
        if(!self.xmppStream.isAuthenticated) {
            [self.xmppStream authenticateWithPassword:self.myUser.password error:&error];
        }
    }
}


@end
