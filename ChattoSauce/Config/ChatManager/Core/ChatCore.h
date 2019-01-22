//
//  ChatCore.h
//  ChattoSauce
//
//  Created by Drey Mill on 21/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMPPFramework/XMPPFramework.h>
#import <QuartzCore/QuartzCore.h>
#import "MainUser.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ChatCoreDelegate <NSObject>

- (void)didReceivePresence:(XMPPPresence *)presence withStream:(XMPPStream *)stream;

- (void)didReceiveIQ:(XMPPIQ *)iq withStream:(XMPPStream *)stream;
- (void)didReceiveMessage:(XMPPStream *)stream withMessage:(XMPPMessage *)message;

- (void)didSendMessage:(XMPPStream *)stream withMessage:(XMPPMessage *)message;
- (void)didFailToSendMessage:(XMPPStream *)stream withMessage:(XMPPMessage *)message withError:(NSError *)error;

- (void)didFailToSendIQ:(XMPPIQ *)iq withStream:(XMPPStream *)stream withError:(NSError *)error;

- (void)didReceiveInvitation:(XMPPMessage *)message withJid:(XMPPJID *)roomJid;
- (void)didReceiveInvitationDecline:(XMPPMessage *)message withJid:(XMPPJID *)roomJid;
- (void)didSetSuccessfullyListName;

- (void)didReceiveDelayedMessage:(XMPPMessage *)message withDelayedDelivery:(XMPPDelayedDelivery *)delayedDelivery;
- (void)didReceiveDelayedPresence:(XMPPPresence *)message withDelayedDelivery:(XMPPDelayedDelivery *)delayedDelivery;

- (void)didDisconnectStreamDueToCertainError:(NSString *)errorMessage;

- (void)didReceiveBookmarks:(NSArray *)bookmarks;
- (void)didReceiveAcknowledgeStanza:(NSArray *)stanzaIds;

@end

@interface ChatCore : NSObject <XMPPStreamDelegate, XMPPReconnectDelegate, XMPPAutoPingDelegate, XMPPMUCDelegate, XMPPRoomDelegate, XMPPRoomStorage, XMPPPrivacyDelegate, XMPPRosterDelegate, XMPPDelayedDeliveryDelegate, XMPPStreamManagementDelegate>


+ (id)instance;

@property (nonatomic, strong) XMPPStream *xmppStream;
@property (nonatomic, retain) MainUser *myUser;

@property (nonatomic, assign) BOOL isDisconnectedStreamFromError;
- (BOOL)connectStream:(NSString *)username hostname:(NSString *)hostname password:(NSString *)password;
- (void)registerWithUsername:(NSString *)username withPassword:(NSString *)pass withHostname:(NSString *)hostname;
@property (nonatomic, strong) GCDMulticastDelegate <ChatCoreDelegate> *multicastDelegate;

@end

NS_ASSUME_NONNULL_END
