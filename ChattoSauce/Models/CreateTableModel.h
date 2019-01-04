//
//  CreateTableModel.h
//  ChattoSauce
//
//  Created by Drey Mill on 02/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CreateTableModel : NSObject

+(NSString *)PRIMARY_TYPE;
+(NSString *)PRIMARY_TYPE_TEXT;
+(NSString *)AUTOINCREMENT;
+(NSString *)TEXT_TYPE;
+(NSString *)INT_TYPE;
+(NSString *)NUMERIC_TYPE;
+(NSString *)COMMA_SEP;
+(NSString *)CREATETABLE;
+(NSString *)PARAMSTART;
+(NSString *)PARAMEND;
+(NSString *)DEFAULT_0;
+(NSString *)NOT_NULL;
+(NSString *)DEFAULT_TEXT;

+(NSString *)CREATE_INDEX;
+(NSString *)ON_INDEX;

+(NSString *)ALTER_TABLE;
+(NSString *)ADD_COLUMN;
+(NSString *)RENAME_TO;

+(NSString *)PRAGMA;
+(NSString *)TABLE_INFO;

+(NSString *)DROP;

+(NSString *)SELECT;
+(NSString *)ASTERISK;
+(NSString *)FROM;
+(NSString *)IN;
+(NSString *)WHERE;
+(NSString *)EQUAL;
+(NSString *)NOT_EQUAL;
+(NSString *)LIKE;
+(NSString *)NOT_LIKE;
+(NSString *)ORDER_B;
+(NSString *)ASC;
+(NSString *)DESC;
+(NSString *)INSERT_INTO;

@end

NS_ASSUME_NONNULL_END
