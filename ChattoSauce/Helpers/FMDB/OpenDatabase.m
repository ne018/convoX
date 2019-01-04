//
//  OpenDatabase.m
//  ChattoSauce
//
//  Created by Drey Mill on 02/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import "OpenDatabase.h"
#import "FileWriter.h"

@implementation OpenDatabase

OpenDatabase *openDbSharedInstance;

+ (instancetype)instance {
    if (openDbSharedInstance == nil) {
        openDbSharedInstance = [[self alloc] init];
    }
    return openDbSharedInstance;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:[OpenDatabase basePath]];
    }
    return self;
}

+ (NSString *)basePath {
    NSString *basePath = [NSString stringWithFormat:@"%@.db", DBNAME];
    return [openDbSharedInstance findDbPath:basePath];
}

- (NSString *)findDbPath:(NSString *)dbName {
    NSString *path = [[FileWriter instance] createFilePath:dbName withFolder:@"Database"];
    return path;
}

+ (id)openDb:(NSString *)dbName {
    NSString *basePath = [NSString stringWithFormat:@"%@.db", dbName];
    NSString *path = [[OpenDatabase instance] findDbPath:basePath];
    if([path isEqualToString:@""] || path == nil) {
        return nil;
    }
    FMDatabaseQueue *databaseQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    if([databaseQueue openFlags]) {
        return databaseQueue;
    }
    return nil;
}

+ (BOOL)truncateAllTables:(NSArray *)tables {
    FMDatabaseQueue *databaseQueue = [OpenDatabase openDb:DBNAME];
    __block BOOL isSuccess = NO;
    [databaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        for (NSString *tablename in tables) {
            isSuccess = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@", tablename]];
            NSLog(@"isSucessTruncate: %@", isSuccess ? @"YES" : @"NO");
        }
    }];
    [databaseQueue close];
    return isSuccess;
}



@end
