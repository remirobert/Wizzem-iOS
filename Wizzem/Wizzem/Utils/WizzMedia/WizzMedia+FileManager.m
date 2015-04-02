//
//  WizzMedia+FileManager.m
//  ExampleWizzMediaFramework
//
//  Created by Remi Robert on 20/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "WizzMedia+FileManager.h"

@implementation WizzMedia (FileManager)

+ (BOOL) isFileExist:(NSString *)file {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:file];
    
    return [fileManager fileExistsAtPath:filePath];
}

+ (BOOL) deleteFile:(NSString *)file {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:file];
    NSError *error = nil;
    
    if (![fileManager removeItemAtPath:filePath error:&error]) {
        NSLog(@"[Error] %@ (%@)", error, filePath);
        return false;
    }
    return true;
}

+ (BOOL) writeFile:(NSString *)file dataFile:(NSData *)data {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:file];
    
    if ([fileManager isWritableFileAtPath:filePath]) {
        return [data writeToFile:filePath atomically:true];
    }
    return false;
}

+ (NSData *) dataFromFile:(NSString *)file {
    if ([self isFileExist:file] == false) {
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:file];
    
    NSData *data = [fileManager contentsAtPath:filePath];
    return data;
}

+ (NSURL *) urlFile:(NSString *)fileName {
    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), fileName];
    NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:outputPath]) {
        NSError *error;
        if ([fileManager removeItemAtPath:outputPath error:&error] == NO) {
            NSLog(@"error file %@", error);
            return nil;
        }
    }
    return outputURL;
}

@end
