//
//  FileWriter.h
//  ChattoSauce
//
//  Created by Drey Mill on 02/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileWriter : NSObject

@property (nonatomic, strong) NSFileManager *filemanager;

+ (id)instance;
- (NSString *)createFilePath:(NSString *)filename withFolder:(NSString *)foldername;
- (NSString *)replaceFile:(NSString *)filePath toFolder:(NSString *)folder;
- (BOOL)moveItemPath:(NSString *)path toPath:(NSString *)toPath;
- (BOOL)writeFile:(NSData *)data withFilePath:(NSString *)filepath;
- (BOOL)isFileAvailable:(NSString *)filePath;
- (NSString *)getFileExtensionFromStringURL:(NSString *)stringURL;
- (NSString *)getFileNameFromStringURL:(NSString *)stringURL;
+ (NSString *)documentDirectoryPath;


@end

NS_ASSUME_NONNULL_END
