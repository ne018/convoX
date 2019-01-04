//
//  FriendsViewController+SetupData.m
//  ChattoSauce
//
//  Created by Drey Mill on 19/12/2018.
//  Copyright © 2018 iOSHive. All rights reserved.
//

#import "FriendsViewController+SetupData.h"
#import "Friend.h"
#import "Message.h"
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
    [self createMessageWithText:@"Hello, My name is bill, nice to meet you adrian, i would like to invite you in my office in your country so we could talk further about the project." withFriend:friendBill isSender:false];
    
    NSDictionary *finchDict = @{@"name":@"Finch", @"profileimagename":@"finch"};
    [[FriendHelper instance] insertFriend:finchDict];
    Friend *friendFinch = [[FriendHelper instance] getFriendByParam:@{@"name":@"Finch"}];
    [self createMessageWithText:@"Please always keep in touch my friend, we need to monitor all cameras in BGC" withFriend:friendFinch isSender:false];
    
    NSDictionary *steveJobsDict = @{@"name":@"Steve Jobs", @"profileimagename":@"stevejobs"};
    [[FriendHelper instance] insertFriend:steveJobsDict];
    Friend *friendSteve = [[FriendHelper instance] getFriendByParam:@{@"name":@"Steve Jobs"}];
    [self createMessageWithText:@"Hi there, I would like to invite you for our WWDC as speaker for our new update in Swift version 6" withFriend:friendSteve isSender:false];
    
    NSDictionary *reeseDict = @{@"name":@"Reese", @"profileimagename":@"reese"};
    [[FriendHelper instance] insertFriend:reeseDict];
    Friend *friendReese = [[FriendHelper instance] getFriendByParam:@{@"name":@"Reese"}];
    [self createMessageWithText:@"What time can we meet bro?" withFriend:friendReese isSender:false];
    
    NSDictionary *sundarpichaiDict = @{@"name":@"Sundar Pichai", @"profileimagename":@"sundarpichai"};
    [[FriendHelper instance] insertFriend:sundarpichaiDict];
    Friend *friendSundar = [[FriendHelper instance] getFriendByParam:@{@"name":@"Sundar Pichai"}];
    
    [self createMessageWithText:@"I'm cool bro, i will beep you back once there's some new features in my app" withFriend:friendSundar isSender:true];
    [self createMessageWithText:@"How was it, Adrian?" withFriend:friendSundar isSender:false];
    [self createMessageWithText:@"The quick brown fox jump over the lazy dog." withFriend:friendSundar isSender:false];
    [self createMessageWithText:@"This is only a dummy text message bro, i just want to test your ios chat app." withFriend:friendSundar isSender:false];
    [self createMessageWithText:@"This is only a dummy text message bro, i just want to test your ios chat app." withFriend:friendSundar isSender:false];
    [self createMessageWithText:@"This is only a dummy text message bro, i just want to test your ios chat app." withFriend:friendSundar isSender:false];
    [self createMessageWithText:@"This is only a dummy text message bro, i just want to test your ios chat app." withFriend:friendSundar isSender:false];
    [self createMessageWithText:@"This is only a dummy text message bro, i just want to test your ios chat app." withFriend:friendSundar isSender:false];
    
    [self loadData];
    
}

-(void)createMessageWithText:(NSString *)text withFriend:(Friend *)friend isSender:(BOOL)isSender{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSDictionary *msgDict = @{@"text":text,
                              @"date":[NSString stringWithFormat:@"%f", time],
                              @"fkfriendid":friend.friendid,
                              @"isSender":[NSNumber numberWithBool:isSender]
                              };
    [[MessageHelper instance] insertMessage:msgDict];
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
