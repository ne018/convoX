//
//  MessageTable.m
//  ChattoSauce
//
//  Created by Drey Mill on 02/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import "MessageTable.h"
#import "CreateTableModel.h"

@implementation MessageTable

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self){
        //default values
        NSMutableDictionary *dictModel = @{
                                           @"messageid":@"",
                                           @"text":@"",
                                           @"date":@"",
                                           @"isSender":@"",
                                           @"fkfriendid":@""
                                           }.mutableCopy;
        for (NSString *key in [dict allKeys]) {
            if([self containsKey:dictModel key:key]){
                [dictModel setValue:dict[key] forKey:key];
            }
        }
        for (NSString *key in [dictModel allKeys]) {
            [self setValue:dictModel[key] forKey:key];
        }
        
        [self setValue:dictModel.copy forKey:@"dictForm"];
    }
    return self;
}

- (instancetype)initWithCustomDictionary:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        NSMutableDictionary *dictModel = @{
                                           @"messageid":@"",
                                           @"text":@"",
                                           @"date":@"",
                                           @"isSender":@"",
                                           @"fkfriendid":@""
                                           }.mutableCopy;
        for (NSString *key in [dict allKeys]) {
            if([self containsKey:dictModel key:key]){
                [dictModel setValue:dict[key] forKey:key];
            }
        }
        for (NSString *key in [dictModel allKeys]) {
            [self setValue:dictModel[key] forKey:key];
        }
        
        [self setValue:dictModel.copy forKey:@"dictForm"];
    }
    return self;
}

- (BOOL)containsKey:(NSDictionary*)dict key: (NSString *)key {
    BOOL retVal = 0;
    NSArray *allKeys = [dict allKeys];
    retVal = [allKeys containsObject:key];
    return retVal;
}

- (NSString *)insertString{
    NSMutableArray *part1 = [[NSMutableArray alloc]init];
    NSMutableArray *part2 = [[NSMutableArray alloc]init];
    for (NSString *key in [self.dictForm allKeys]) {
        if(![key isEqualToString:MessageTable.MESSAGEID]){
            [part1 addObject:key];
            [part2 addObject:[NSString stringWithFormat:@":%@", key]];
        }
    }
    NSString *columns = [part1 componentsJoinedByString:@", "];
    NSString *values = [part2 componentsJoinedByString:@", "];
    
    NSMutableArray *stringArr = [[NSMutableArray alloc]init];
    [stringArr addObject:@"INSERT INTO "];
    [stringArr addObject:[MessageTable TABLE_NAME]];
    [stringArr addObject:[CreateTableModel PARAMSTART]];
    [stringArr addObject:columns];
    [stringArr addObject:[CreateTableModel PARAMEND]];
    [stringArr addObject:@" VALUES "];
    [stringArr addObject:[CreateTableModel PARAMSTART]];
    [stringArr addObject:values];
    [stringArr addObject:[CreateTableModel PARAMEND]];
    
    NSString *insert_string = [stringArr componentsJoinedByString:@""];
    return insert_string;
}

- (NSString *)insertBulkString{
    NSMutableArray *part1 = [[NSMutableArray alloc]init];
    NSMutableArray *part2 = [[NSMutableArray alloc]init];
    for (NSString *key in [self.dictForm allKeys]) {
        if(![key isEqualToString:MessageTable.MESSAGEID]) {
            id value = [self valueForKey:key]  != [NSNull null] ? [self valueForKey:key] : @"";
            [part1 addObject:key];
            [part2 addObject:[NSString stringWithFormat:@"\"%@\"",value]];
        }
    }
    NSString *columns = [part1 componentsJoinedByString:@", "];
    NSString *values = [part2 componentsJoinedByString:@", "];
    
    NSMutableArray *stringArr = [[NSMutableArray alloc]init];
    [stringArr addObject:@"INSERT INTO "];
    [stringArr addObject:[MessageTable TABLE_NAME]];
    [stringArr addObject:[CreateTableModel PARAMSTART]];
    [stringArr addObject:columns];
    [stringArr addObject:[CreateTableModel PARAMEND]];
    [stringArr addObject:@" VALUES "];
    [stringArr addObject:[CreateTableModel PARAMSTART]];
    [stringArr addObject:values];
    [stringArr addObject:[CreateTableModel PARAMEND]];
    
    NSString *insert_string = [stringArr componentsJoinedByString:@""];
    return insert_string;
}

- (NSString *)updateString:(NSString *)columnId withParamsToUpdate:(NSDictionary *)params{
    NSMutableArray *part1 = [[NSMutableArray alloc]init];
    NSMutableArray *part2 = [[NSMutableArray alloc]init];
    for (NSString *key in [params allKeys]) {
        if(![key isEqualToString:columnId]){
            [part1 addObject:[NSString stringWithFormat:@"%@ = :%@",key,key]];
        }else{
            [part2 addObject:[NSString stringWithFormat:@"%@ = :%@",key,key]];
        }
    }
    NSString *tobeupdate = [part1 componentsJoinedByString:@", "];
    NSString *where = [part2 componentsJoinedByString:@" AND "];
    
    NSMutableArray *stringArr = [[NSMutableArray alloc]init];
    [stringArr addObject:@"UPDATE "];
    [stringArr addObject:[MessageTable TABLE_NAME]];
    [stringArr addObject:@" SET "];
    [stringArr addObject:tobeupdate];
    [stringArr addObject:@" WHERE "];
    [stringArr addObject:where];
    
    NSString *update_string = [stringArr componentsJoinedByString:@""];
    return update_string;
}

- (NSString *)updateBulkString:(NSArray *)columnId withParamsToUpdate:(NSDictionary *)params{
    NSMutableArray *part1 = [[NSMutableArray alloc]init];
    NSMutableArray *part2 = [[NSMutableArray alloc]init];
    for (NSString *key in [params allKeys]) {
        if(![columnId containsObject:key]) {
            [part1 addObject:[NSString stringWithFormat:@"%@ = \"%@\"", key, [params objectForKey:key]]];
        } else {
            [part2 addObject:[NSString stringWithFormat:@"%@ = \"%@\"",key, [params objectForKey:key]]];
        }
    }
    NSString *tobeupdate = [part1 componentsJoinedByString:@", "];
    NSString *where = [part2 componentsJoinedByString:@" AND "];
    
    NSMutableArray *stringArr = [[NSMutableArray alloc]init];
    [stringArr addObject:@"UPDATE "];
    [stringArr addObject:[MessageTable TABLE_NAME]];
    [stringArr addObject:@" SET "];
    [stringArr addObject:tobeupdate];
    [stringArr addObject:@" WHERE "];
    [stringArr addObject:where];
    
    NSString *update_string = [stringArr componentsJoinedByString:@""];
    return update_string;
}

- (NSString *)deleteString:(NSDictionary *)params {
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in [params allKeys]) {
        [parts addObject:[NSString stringWithFormat:@"%@ = :%@", key, key]];
    }
    
    NSString *whereClause = [parts componentsJoinedByString:@" AND "];
    
    NSMutableArray *stringArr = [[NSMutableArray alloc] init];
    [stringArr addObject:@"DELETE FROM "];
    [stringArr addObject:[MessageTable TABLE_NAME]];
    [stringArr addObject:@" WHERE "];
    [stringArr addObject:whereClause];
    
    NSString *delete_string = [stringArr componentsJoinedByString:@""];
    return delete_string;
}

- (NSString *)selectString:(NSDictionary *)columns {
    NSMutableArray *part1 = [[NSMutableArray alloc] init];
    for(NSString *key in [columns allKeys]) {
        [part1 addObject:[NSString stringWithFormat:@"%@ = '%@'", key, columns[key]]];
    }
    
    NSString *selected = [part1 componentsJoinedByString:@" AND "];
    
    NSMutableArray *stringArr = [[NSMutableArray alloc]init];
    [stringArr addObject:@"SELECT * FROM "];
    [stringArr addObject:[MessageTable TABLE_NAME]];
    [stringArr addObject:@" WHERE "];
    [stringArr addObject:selected];
    
    NSString *update_string = [stringArr componentsJoinedByString:@""];
    return update_string;
}

-(NSDictionary *)insertParams{
    NSMutableDictionary *insert_params = [[NSMutableDictionary alloc]init];
    for (NSString *key in [self.dictForm allKeys]) {
        if(![key isEqualToString:MessageTable.MESSAGEID]) {
            id value = [self valueForKey:key]  != [NSNull null] ? [self valueForKey:key] : @"";
            [insert_params setValue:value forKey:key];
        }
    }
    return insert_params.copy;
}

-(NSDictionary *)getParams{
    NSMutableDictionary *get_params = [[NSMutableDictionary alloc]init];
    for (NSString *key in [self.dictForm allKeys]) {
        if(![key isEqualToString:MessageTable.MESSAGEID]) {
            id value = [self valueForKey:key] != [NSNull null] ? [self valueForKey:key] : @"";
            [get_params setValue:value forKey:key];
        }
    }
    return get_params.copy;
}

+(NSString *)TABLE_NAME{
    return @"message";
}
+(NSString *)MESSAGEID {
    return @"messageid";
}
+(NSString *)TEXT {
    return @"text";
}
+(NSString *)DATE{
    return @"date";
}
+(NSString *)ISSENDER{
    return @"isSender";
}
+(NSString *)FKFRIENDID{
    return @"fkfriendid";
}

+(NSString *)CONVERSATION_INDEX_IDENTIFIER {
    return @"message_indexes";
}

+(NSString *)CREATE_STRING{
    NSMutableArray *stringArr = [[NSMutableArray alloc]init];
    [stringArr addObject:[CreateTableModel CREATETABLE]];
    [stringArr addObject:[self TABLE_NAME]];
    [stringArr addObject:[CreateTableModel PARAMSTART]];
    
    [stringArr addObject:[self MESSAGEID]];
    [stringArr addObject:[CreateTableModel PRIMARY_TYPE]];
    [stringArr addObject:[CreateTableModel AUTOINCREMENT]];
    [stringArr addObject:[CreateTableModel COMMA_SEP]];
    
    [stringArr addObject:[self TEXT]];
    [stringArr addObject:[CreateTableModel TEXT_TYPE]];
    [stringArr addObject:[CreateTableModel COMMA_SEP]];
    
    [stringArr addObject:[self DATE]];
    [stringArr addObject:[CreateTableModel TEXT_TYPE]];
    [stringArr addObject:[CreateTableModel COMMA_SEP]];
    
    [stringArr addObject:[self ISSENDER]];
    [stringArr addObject:[CreateTableModel NUMERIC_TYPE]];
    [stringArr addObject:[CreateTableModel COMMA_SEP]];
    
    [stringArr addObject:[self FKFRIENDID]];
    [stringArr addObject:[CreateTableModel TEXT_TYPE]];
    [stringArr addObject:[CreateTableModel PARAMEND]];
    
    NSString *sql = [stringArr componentsJoinedByString:@""];
    NSLog(@"%@",sql);
    return sql;
}

+(NSString *)CREATE_INDEX {
    NSMutableArray *stringArr = [[NSMutableArray alloc]init];
    [stringArr addObject:[CreateTableModel CREATE_INDEX]];
    [stringArr addObject:[self CONVERSATION_INDEX_IDENTIFIER]];
    [stringArr addObject:[CreateTableModel ON_INDEX]];
    [stringArr addObject:[self TABLE_NAME]];
    [stringArr addObject:[CreateTableModel PARAMSTART]];
    [stringArr addObject:[self MESSAGEID]];
    [stringArr addObject:[CreateTableModel COMMA_SEP]];
    [stringArr addObject:[self DATE]];
    [stringArr addObject:[CreateTableModel COMMA_SEP]];
    [stringArr addObject:[self ISSENDER]];
    [stringArr addObject:[CreateTableModel COMMA_SEP]];
    [stringArr addObject:[self FKFRIENDID]];
    [stringArr addObject:[CreateTableModel PARAMEND]];
    NSString *indexSql = [stringArr componentsJoinedByString:@""];
    NSLog(@"%@",indexSql);
    return indexSql;
}

@end
