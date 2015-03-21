//
//  WizzMedia+FileManager.h
//  ExampleWizzMediaFramework
//
//  Created by Remi Robert on 20/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "WizzMedia.h"

@interface WizzMedia (FileManager)

+ (BOOL) isFileExist:(NSString *)file;
+ (BOOL) deleteFile:(NSString *)file;
+ (BOOL) writeFile:(NSString *)file dataFile:(NSData *)data;
+ (NSData *) dataFromFile:(NSString *)file;
+ (NSURL *) urlFile:(NSString *)fileName;

@end
