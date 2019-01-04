//
//  MessageTable.h
//  ChattoSauce
//
//  Created by Drey Mill on 02/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageTable : NSObject

@property (nonatomic, strong) NSString *messageid;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *isSender;
@property (nonatomic, strong) NSString *fkfriendid;

@property (nonatomic, strong) NSDictionary *dictForm;

+(NSString *)TABLE_NAME;
+(NSString *)MESSAGEID;
+(NSString *)TEXT;
+(NSString *)DATE;
+(NSString *)ISSENDER;
+(NSString *)FKFRIENDID;

+ (NSString *)CREATE_STRING;
+ (NSString *)CREATE_INDEX;

- (id)initWithDictionary:(NSDictionary *)dict;

- (NSString *)insertString;
- (NSString *)insertBulkString;
- (NSString *)updateString:(NSString *)columnId withParamsToUpdate:(NSDictionary *)params;
- (NSString *)updateBulkString:(NSArray *)columnId withParamsToUpdate:(NSDictionary *)params;
- (NSString *)deleteString:(NSDictionary *)params;
- (NSString *)selectString:(NSDictionary *)columns;
- (NSDictionary *)insertParams;
- (NSDictionary *)getParams;

@end

NS_ASSUME_NONNULL_END
