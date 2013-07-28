//
//  FWF FMDB Wrapper Extension
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FWFORMDbWrapper.h"
#import "FileManagementUtils.h"

@implementation FWFORMDbWrapper

+ (NSString *) defaultStorageFolder{
    return [[FileManagementUtils standardAppSupportFolderPath] stringByAppendingPathComponent:@"fwform/"];
}

+ (NSString *) defaultDbPath{
    [self defaultBlobsStoragePath];
    return [[FileManagementUtils standardAppSupportFolderPath] stringByAppendingPathComponent:@"fwform/database.sqlite"];
}

+ (NSString *) defaultBlobsStoragePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *folder = [[FileManagementUtils standardAppSupportFolderPath] stringByAppendingPathComponent:@"fwform/blobs/"];
    
    if ([fileManager fileExistsAtPath: folder] == NO){
        [fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return folder;
}
@end
