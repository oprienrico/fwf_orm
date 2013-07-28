//
//  File Management Utilities
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FileManagementUtils.h"

@implementation FileManagementUtils

+ (NSString *) genRandStringLength: (int) len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}

+ (NSString *) standardAppSupportFolderPath{
#if TARGET_OS_IPHONE
    // iOS
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

#elif TARGET_IPHONE_SIMULATOR
    // iOS Simulator
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
#elif TARGET_OS_MAC
    // Other kinds of Mac OS
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *folder = [NSString stringWithFormat:@"~/Library/Application Support/%@/",[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutablePath"] lastPathComponent]];
    folder = [folder stringByExpandingTildeInPath];
    
    if ([fileManager fileExistsAtPath: folder] == NO){
        [fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
        //[fileManager createDirectoryAtPath: folder attributes: nil];
    }
    
    return folder;
#else
    @throw [NSException exceptionWithName:@"FMDB_EXCEPTION_UNSUPPORTED_PLATFORM" reason:@"This platform is not recognized so it cannot be supported. Could not get the required base folder." userInfo:nil];
#endif
    
}


@end
