//
//  FriendHelper.m
//  ChattoSauce
//
//  Created by Drey Mill on 02/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import "FriendHelper.h"
#import "OpenDatabase.h"
#import "FriendTable.h"

@interface FriendHelper()

@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;

@end


@implementation FriendHelper

static FriendHelper *friendHelper;

+ (id)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        friendHelper = [[FriendHelper alloc] init];
    });
    return friendHelper;
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
    NSString *createTableConversation = [FriendTable CREATE_STRING];
    NSString *createTableIndex = [FriendTable CREATE_INDEX];
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

-(NSMutableArray *)fetchFriends {
    NSMutableArray *friendList = [[NSMutableArray alloc] init];
    [self.databaseQueue openFlags];
    [self.databaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        FMResultSet *result = [db executeQuery:@"SELECT * FROM friend"];
        while ([result next]) {
            Friend *friendDomain = [[Friend alloc] initWithDictionary:[result resultDictionary]];
            [friendList addObject:friendDomain];
        }
        [result close];
    }];
    [self.databaseQueue close];
    return friendList;
}

- (Friend *)getFriendByParam:(NSDictionary *)param {
    __block Friend *friendDomain = nil;
    NSString *selectQuery = [[FriendTable alloc] selectString:param];
    [self.databaseQueue openFlags];
    [self.databaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        FMResultSet *result = [db executeQuery:selectQuery];
        while ([result next]) {
            friendDomain = [[Friend alloc] initWithDictionary:[result resultDictionary]];
        }
        [result close];
    }];
    [self.databaseQueue close];
    return friendDomain;
}

- (BOOL)insertFriend:(NSDictionary *)dict{
    __block BOOL isSuccess;
    [self.databaseQueue openFlags];
    [self.databaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        FriendTable *friendTable = [[FriendTable alloc] initWithDictionary:dict];
        NSString *selectQuery = [friendTable selectString:@{@"email":friendTable.email}];
        FMResultSet *result = [db executeQuery:selectQuery];
        Friend *friendDomain = nil;
        while ([result next]) {
            friendDomain = [[Friend alloc] initWithDictionary:[result resultDictionary]];
        }
        [result close];
        if(friendDomain == nil) {
            NSString *insertQuery = friendTable.insertString;
            NSDictionary *params = friendTable.insertParams;
            isSuccess = [db executeUpdate:insertQuery withParameterDictionary:params];
            NSLog(@"isSuccessInsertMessage: %@", isSuccess ? @"YES" : @"NO");
        }
    }];
    [self.databaseQueue close];
    return isSuccess;
}

-(void)insertBulkFriend:(NSMutableArray *)friendsArray withCompletion:(void(^)(NSDictionary* friendDict))completion {
    __block BOOL isSuccess;
    __block Friend *friendDomain = nil;
    [self.databaseQueue openFlags];
    [self.databaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        for (NSDictionary *friend in friendsArray) {
            FriendTable *friendTable = [[FriendTable alloc] initWithDictionary:friend];
            NSDictionary *checkIfExistParam = @{@"friendid":[friend objectForKey:@"friendid"]};
            
            NSString *selectQuery = [[FriendTable alloc] selectString:checkIfExistParam];
            FMResultSet *result = [db executeQuery:selectQuery];
            while ([result next]) {
                friendDomain = [[Friend alloc] initWithDictionary:[result resultDictionary]];
            }
            [result close];
            if(friendDomain == nil){
                NSString *insertQuery = friendTable.insertString;
                NSDictionary *params = friendTable.getParams;
                isSuccess = [db executeUpdate:insertQuery withParameterDictionary:params];
                NSLog(@"isSuccessInsertMessage: %@", isSuccess ? @"YES" : @"NO");
                completion(friend);
            }
        }
    }];
    [self.databaseQueue close];
}

@end
