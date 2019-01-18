//
//  FriendTable.h
//  ChattoSauce
//
//  Created by Drey Mill on 02/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendTable : NSObject

@property (nonatomic, strong) NSString *friendid;
@property (nonatomic, strong) NSString *uniqueid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *profileimagename;

@property (nonatomic, strong) NSDictionary *dictForm;

+(NSString *)TABLE_NAME;
+(NSString *)FRIENDID;
+(NSString *)UNIQUEID;
+(NSString *)NAME;
+(NSString *)EMAIL;
+(NSString *)PROFILEIMAGENAME;

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
