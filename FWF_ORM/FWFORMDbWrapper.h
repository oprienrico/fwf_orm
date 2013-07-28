//
//  FWF FMDB Wrapper Extension
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FMDbWrapper.h"

@interface FWFORMDbWrapper : FMDbWrapper

+ (NSString *) defaultStorageFolder;
+ (NSString *) defaultDbPath;
+ (NSString *) defaultBlobsStoragePath;

@end
