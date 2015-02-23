//
//  FileManager.h
//  Wizzem
//
//  Created by Remi Robert on 23/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileManager : NSObject

+ (BOOL) isFileExist:(NSString *)file;
+ (BOOL) deleteFile:(NSString *)file;
+ (BOOL) writeFile:(NSString *)file dataFile:(NSData *)data;
+ (NSData *) getDataFromFile:(NSString *)file;

@end
