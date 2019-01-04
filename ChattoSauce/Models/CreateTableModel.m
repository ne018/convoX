//
//  CreateTableModel.m
//  ChattoSauce
//
//  Created by Drey Mill on 02/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import "CreateTableModel.h"

@implementation CreateTableModel

+(NSString *)PRIMARY_TYPE{
    return @" INTEGER PRIMARY KEY";
}
+(NSString *)PRIMARY_TYPE_TEXT{
    return @" TEXT PRIMARY KEY";
}
+(NSString *)AUTOINCREMENT{
    return @" AUTOINCREMENT";
}
+(NSString *)TEXT_TYPE{
    return @" TEXT";
}
+(NSString *)INT_TYPE{
    return @" INTEGER";
}
+(NSString *)NUMERIC_TYPE{
    return @" NUMERIC";
}
+(NSString *)COMMA_SEP{
    return @",";
}
+(NSString *)CREATETABLE{
    return @"CREATE TABLE IF NOT EXISTS ";
}
+(NSString *)PARAMSTART{
    return @" (";
}
+(NSString *)PARAMEND{
    return @")";
}
+(NSString *)DEFAULT_0{
    return @" DEFAULT 0";
}
+(NSString *)DEFAULT_TEXT {
    return @" DEFAULT \"0\"";
}
+(NSString *)NOT_NULL {
    return @" NOT NULL";
}
+(NSString *)CREATE_INDEX {
    return @"CREATE INDEX IF NOT EXISTS ";
}
+(NSString *)ON_INDEX {
    return @" ON ";
}

+(NSString *)ALTER_TABLE {
    return @"ALTER TABLE ";
}
+(NSString *)ADD_COLUMN {
    return @" ADD COLUMN ";
}
+(NSString *)RENAME_TO {
    return @" RENAME TO ";
}

+(NSString *)PRAGMA {
    return @"PRAGMA table_info";
}

+(NSString *)DROP {
    return @"DROP TABLE ";
}



#pragma mark TRANSACTIONS
+(NSString *)SELECT {
    return @"SELECT ";
}
+(NSString *)ASTERISK {
    return @" * ";
}
+(NSString *)FROM {
    return @" FROM ";
}
+(NSString *)IN {
    return @" IN ";
}
+(NSString *)WHERE {
    return @" WHERE ";
}
+(NSString *)EQUAL {
    return @" = ";
}
+(NSString *)NOT_EQUAL {
    return @" != ";
}
+(NSString *)LIKE {
    return @" LIKE ";
}
+(NSString *)NOT_LIKE {
    return @" NOT LIKE ";
}
+(NSString *)ORDER_BY {
    return @" ORDER BY ";
}
+(NSString *)ASC {
    return @" ASC";
}
+(NSString *)DESC {
    return @" DESC";
}

+(NSString *)INSERT_INTO{
    return @"INSERT INTO ";
}

@end
