//
//  MessageHelper.h
//  ChattoSauce
//
//  Created by Drey Mill on 02/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageHelper : NSObject

+ (id)instance;

- (NSMutableArray *)fetchMessages;
- (NSMutableArray *)fetchMessagesGroupBy:(NSString *)columnfield;
- (NSMutableArray *)fetchMessagesByFriendID:(NSString *)friendID;

- (BOOL)insertMessage:(NSDictionary *)dict;


@end

NS_ASSUME_NONNULL_END
