//
//  FriendHelper.h
//  ChattoSauce
//
//  Created by Drey Mill on 02/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Friend.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendHelper : NSObject

+ (id)instance;

- (NSMutableArray *)fetchFriends;
- (BOOL)insertFriend:(NSDictionary *)dict;
- (Friend *)getFriendByParam:(NSDictionary *)param;
- (void)insertBulkFriend:(NSMutableArray *)friendsArray withCompletion:(void(^)(NSDictionary* friendDict))completion;

@end

NS_ASSUME_NONNULL_END
