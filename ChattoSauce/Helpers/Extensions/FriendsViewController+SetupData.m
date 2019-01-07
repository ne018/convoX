//
//  FriendsViewController+SetupData.m
//  ChattoSauce
//
//  Created by Drey Mill on 19/12/2018.
//  Copyright © 2018 iOSHive. All rights reserved.
//

#import "FriendsViewController+SetupData.h"
#import "MessageHelper.h"
#import "FriendHelper.h"

#import "OpenDatabase.h"

@implementation FriendsViewController (SetupData)

-(void)clearData{
    NSArray *tablesCS = @[@"friend", @"message"];
    [OpenDatabase truncateAllTables:tablesCS];
}

-(void)setupData{
    
    [self clearData];
    
    NSDictionary *billGatesDict = @{@"name":@"Bill Gates", @"profileimagename":@"billgates"};
    [[FriendHelper instance] insertFriend:billGatesDict];
    Friend *friendBill = [[FriendHelper instance] getFriendByParam:@{@"name":@"Bill Gates"}];
    [FriendsViewController createMessageWithText:@"Hello, My name is bill, nice to meet you adrian, i would like to invite you in my office in your country so we could talk further about the project." withFriend:friendBill withMinutes:1 isSender:false];
    
    NSDictionary *finchDict = @{@"name":@"Finch", @"profileimagename":@"finch"};
    [[FriendHelper instance] insertFriend:finchDict];
    Friend *friendFinch = [[FriendHelper instance] getFriendByParam:@{@"name":@"Finch"}];
    [FriendsViewController createMessageWithText:@"Please always keep in touch my friend, we need to monitor all cameras in BGC" withFriend:friendFinch withMinutes:1 isSender:false];
    
    NSDictionary *steveJobsDict = @{@"name":@"Steve Jobs", @"profileimagename":@"stevejobs"};
    [[FriendHelper instance] insertFriend:steveJobsDict];
    Friend *friendSteve = [[FriendHelper instance] getFriendByParam:@{@"name":@"Steve Jobs"}];
    [FriendsViewController createMessageWithText:@"Hi there, I would like to invite you for our WWDC as speaker for our new update in Swift version 6" withFriend:friendSteve withMinutes:1 isSender:false];
    
    NSDictionary *reeseDict = @{@"name":@"Reese", @"profileimagename":@"reese"};
    [[FriendHelper instance] insertFriend:reeseDict];
    Friend *friendReese = [[FriendHelper instance] getFriendByParam:@{@"name":@"Reese"}];
    [FriendsViewController createMessageWithText:@"What time can we meet bro?" withFriend:friendReese withMinutes:1 isSender:false];
    
    NSDictionary *sundarpichaiDict = @{@"name":@"Sundar Pichai", @"profileimagename":@"sundarpichai"};
    [[FriendHelper instance] insertFriend:sundarpichaiDict];
    Friend *friendSundar = [[FriendHelper instance] getFriendByParam:@{@"name":@"Sundar Pichai"}];

    [FriendsViewController createMessageWithText:@"This is only a dummy text message bro, i just want to test your ios chat app." withFriend:friendSundar withMinutes:1 isSender:false];
    [FriendsViewController createMessageWithText:@"This is only a dummy text message bro, i just want to test your ios chat app." withFriend:friendSundar withMinutes:1 isSender:false];
    [FriendsViewController createMessageWithText:@"This is only a dummy text message bro, i just want to test your ios chat app." withFriend:friendSundar withMinutes:1 isSender:false];
    [FriendsViewController createMessageWithText:@"This is only a dummy text message bro, i just want to test your ios chat app." withFriend:friendSundar withMinutes:1 isSender:false];
    [FriendsViewController createMessageWithText:@"This is only a dummy text message bro, i just want to test your ios chat app." withFriend:friendSundar withMinutes:1 isSender:false];
    [FriendsViewController createMessageWithText:@"The quick brown fox jump over the lazy dog." withFriend:friendSundar withMinutes:1 isSender:false];
    [FriendsViewController createMessageWithText:@"How was it, Adrian?" withFriend:friendSundar withMinutes:1 isSender:false];
    [FriendsViewController createMessageWithText:@"I'm cool bro, i will beep you back once there's some new features in my app" withFriend:friendSundar withMinutes:1 isSender:true];
    
    [self loadData];
    
}

+(Message *)createMessageWithText:(NSString *)text withFriend:(Friend *)friend withMinutes:(int)minutes isSender:(BOOL)isSender{
    NSTimeInterval timeA = [[NSDate date] timeIntervalSince1970];
    NSDate *minusMinutes = [[NSDate date] dateByAddingTimeInterval:-minutes * 60];
    NSTimeInterval timeintervalMinus = [minusMinutes timeIntervalSinceReferenceDate];
    NSDictionary *msgDict = @{@"text":text,
                              @"date":[NSString stringWithFormat:@"%f", timeintervalMinus],
                              @"fkfriendid":friend.friendid,
                              @"isSender":[NSNumber numberWithBool:isSender]
                              };
    BOOL inserted = [[MessageHelper instance] insertMessage:msgDict];
    if(inserted){
        NSLog(@"inserted msg: %@", text);
    }
    Message *msgInserted = [[Message alloc] initWithDictionary:msgDict];
    msgInserted.myFriend = friend;
    return msgInserted;
}

-(void)loadData{
    NSMutableArray *fetchMessages = [[MessageHelper instance] fetchMessagesGroupBy:@"fkfriendid"];
    if(fetchMessages.count > 0){
        for (Message *msg in fetchMessages) {
            Friend *friend = [[FriendHelper instance] getFriendByParam:@{@"friendid":msg.fkfriendid}];
            msg.myFriend = friend;
            [self.messages addObject:msg];
        }
    }
}



@end
