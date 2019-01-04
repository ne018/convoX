//
//  MessageHelper.m
//  ChattoSauce
//
//  Created by Drey Mill on 02/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import "MessageHelper.h"
#import "OpenDatabase.h"
#import "MessageTable.h"
#import "Message.h"

@interface MessageHelper()

@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;

@end

@implementation MessageHelper

static MessageHelper *messageHelper;

+ (id)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        messageHelper = [[MessageHelper alloc] init];
    });
    return messageHelper;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self.databaseQueue = [OpenDatabase openDb:DBNAME];
        [self createTable:self.databaseQueue];
    }
    return self;
}

- (void)createTable:(FMDatabaseQueue *)databaseQueue {
    NSString *createTableConversation = [MessageTable CREATE_STRING];
    NSString *createTableIndex = [MessageTable CREATE_INDEX];
    [self.databaseQueue openFlags];
    [self.databaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        BOOL isSuccess = [db executeStatements:createTableConversation];
        if(isSuccess) {
            BOOL isSuccessIndexing = [db executeStatements:createTableIndex];
            NSLog(@"isSuccessIndexing: %@", isSuccessIndexing ? @"YES" : @"NO");
        }
        NSLog(@"isSuccessCreateTable: %@", isSuccess ? @"YES" : @"NO");
    }];
    [self.databaseQueue close];
}

-(NSMutableArray *)fetchMessagesByFriendID:(NSString *)friendID {
    NSMutableArray *messageList = [[NSMutableArray alloc] init];
    [self.databaseQueue openFlags];
    [self.databaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM message WHERE fkfriendid = %@ ORDER BY date DESC", friendID];
        FMResultSet *result = [db executeQuery:selectQuery];
        while ([result next]) {
            Message *messageDomain = [[Message alloc] initWithDictionary:[result resultDictionary]];
            [messageList addObject:messageDomain];
        }
        [result close];
    }];
    [self.databaseQueue close];
    return messageList;
}

-(NSMutableArray *)fetchMessages {
    NSMutableArray *messageList = [[NSMutableArray alloc] init];
    [self.databaseQueue openFlags];
    [self.databaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        FMResultSet *result = [db executeQuery:@"SELECT * FROM message ORDER BY date DESC"];
        while ([result next]) {
            Message *messageDomain = [[Message alloc] initWithDictionary:[result resultDictionary]];
            [messageList addObject:messageDomain];
        }
        [result close];
    }];
    [self.databaseQueue close];
    return messageList;
}

-(NSMutableArray *)fetchMessagesGroupBy:(NSString *)columnfield{
    NSMutableArray *messageList = [[NSMutableArray alloc] init];
    [self.databaseQueue openFlags];
    [self.databaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM message GROUP BY %@ ORDER BY date DESC", columnfield];
        FMResultSet *result = [db executeQuery:selectQuery];
        while ([result next]) {
            Message *messageDomain = [[Message alloc] initWithDictionary:[result resultDictionary]];
            [messageList addObject:messageDomain];
        }
        [result close];
    }];
    [self.databaseQueue close];
    return messageList;
}

- (BOOL)insertMessage:(NSDictionary *)dict {
    __block BOOL isSuccess;
    [self.databaseQueue openFlags];
    [self.databaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        MessageTable *msgTable = [[MessageTable alloc] initWithDictionary:dict];
        NSString *selectQuery = [msgTable selectString:@{@"messageid":msgTable.messageid}];
        FMResultSet *result = [db executeQuery:selectQuery];
        Message *msgDomain = nil;
        while ([result next]) {
            msgDomain = [[Message alloc] initWithDictionary:[result resultDictionary]];
        }
        [result close];
        if(msgDomain == nil) {
            NSString *insertQuery = msgTable.insertString;
            NSDictionary *params = msgTable.insertParams;
            isSuccess = [db executeUpdate:insertQuery withParameterDictionary:params];
            NSLog(@"isSuccessInsertMessage: %@", isSuccess ? @"YES" : @"NO");
        }
    }];
    [self.databaseQueue close];
    return isSuccess;
}

@end
