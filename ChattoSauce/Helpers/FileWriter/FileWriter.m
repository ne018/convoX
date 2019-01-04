//
//  FileWriter.m
//  ChattoSauce
//
//  Created by Drey Mill on 02/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import "FileWriter.h"

@implementation FileWriter

static FileWriter *filewriter;

+ (id)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        filewriter = [[FileWriter alloc] init];
    });
    return filewriter;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self.filemanager = [NSFileManager defaultManager];
    }
    return self;
}

+ (NSString *)documentDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (NSString *)createDocumentFolderPath:(NSString *)folder {
    NSError *error;
    
    NSString *documentsDirectory = [FileWriter documentDirectoryPath];
    NSString *basePath = [NSString stringWithFormat:@"%@/%@/", documentsDirectory, folder];
    if (![self.filemanager createDirectoryAtPath:basePath withIntermediateDirectories:YES attributes:nil error:&error]) NSLog(@"Create directory error: %@", error);
    
    BOOL isExist = [self.filemanager fileExistsAtPath:basePath];
    if(isExist) {
        return basePath;
    }
    return nil;
}

- (NSString *)createFilePath:(NSString *)filename withFolder:(NSString *)foldername {
    NSString *documentFolderPath = [self createDocumentFolderPath:foldername];
    NSString *filePath = [documentFolderPath stringByAppendingString:filename];
    BOOL isExist = [self.filemanager fileExistsAtPath:filePath];
    if(isExist) {
        return filePath;
    } else {
        NSError *error;
        NSString *fileBundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:filename];
        BOOL isSuccessCopy = [self.filemanager copyItemAtPath:fileBundlePath toPath:filePath error:&error];
        if(isSuccessCopy){
            return fileBundlePath;
        }else{
            return filePath;
        }
    }
    return nil;
}

- (NSString *)replaceFile:(NSString *)filePath toFolder:(NSString *)folder {
    NSError *error = nil;
    if([self.filemanager fileExistsAtPath:filePath]) {
        [self.filemanager removeItemAtPath:filePath error:&error];
    }
    NSString *newFilePath = [self createFilePath:filePath withFolder:folder];
    return newFilePath;
}

- (BOOL)moveItemPath:(NSString *)path toPath:(NSString *)toPath {
    NSError *error = nil;
    BOOL hasMove = [self.filemanager moveItemAtPath:path toPath:toPath error:&error];
    return hasMove;
}

- (BOOL)writeFile:(NSData *)data withFilePath:(NSString *)filepath {
    return [data writeToFile:filepath atomically:YES];
}

- (BOOL)isFileAvailable:(NSString *)filePath {
    if([self.filemanager isReadableFileAtPath:filePath] && [self.filemanager fileExistsAtPath:filePath]) {
        return YES;
    }
    return NO;
}

- (NSString *)getFileExtensionFromStringURL:(NSString *)stringURL {
    NSString *string = stringURL.lastPathComponent;
    string = [string stringByReplacingOccurrencesOfString:@"." withString:@" "];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    string = [string stringByTrimmingCharactersInSet:whitespace];
    NSMutableArray *words = [[string componentsSeparatedByCharactersInSet:whitespace] mutableCopy];
    return [words lastObject];
}


- (NSString *)getFileNameFromStringURL:(NSString *)stringURL {
    NSString *string = stringURL.lastPathComponent;
    string = [string stringByReplacingOccurrencesOfString:@"." withString:@" "];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    string = [string stringByTrimmingCharactersInSet:whitespace];
    NSMutableArray *words = [[string componentsSeparatedByCharactersInSet:whitespace] mutableCopy];
    [words removeLastObject];
    NSString *filename = nil;
    if(words.count == 1){
        filename = [words firstObject];
    }else{
        filename = [words componentsJoinedByString:@" "];
    }
    return filename;
}


@end
