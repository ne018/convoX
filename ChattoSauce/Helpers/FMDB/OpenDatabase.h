//
//  OpenDatabase.h
//  ChattoSauce
//
//  Created by Drey Mill on 02/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "prefixHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface OpenDatabase : NSObject

@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;

+ (instancetype)instance;

+ (id)openDb:(NSString *)dbName;
+ (BOOL)truncateAllTables:(NSArray *)tables;

@end

NS_ASSUME_NONNULL_END
