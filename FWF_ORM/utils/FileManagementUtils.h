//
//  File Management Utilities
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManagementUtils : NSObject

+ (NSString *) genRandStringLength: (int) len;
+ (NSString *) standardAppSupportFolderPath;
@end
