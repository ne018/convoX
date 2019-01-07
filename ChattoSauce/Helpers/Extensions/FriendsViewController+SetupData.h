//
//  FriendsViewController+SetupData.h
//  ChattoSauce
//
//  Created by Drey Mill on 19/12/2018.
//  Copyright © 2018 iOSHive. All rights reserved.
//

#import "FriendsViewController.h"
#import "Friend.h"
#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendsViewController (SetupData)

-(void)setupData;
+(Message *)createMessageWithText:(NSString *)text withFriend:(Friend *)friend withMinutes:(int)minutes isSender:(BOOL)isSender;

@end

NS_ASSUME_NONNULL_END
