//
//  FWF
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FWF_ORM.h"

@implementation FWF

+ (void) resetStorage{
    [FMDbWrapper resetDatabase];
}

+ (void) shrinkDownStorage{
    FMDbWrapper *db = [[FMDbWrapper alloc] initDatabaseWithoutForeignKeys];
    //[FMDbWrapper databaseWithPath:[FMDbWrapper getStandardDbPath]];
    //NSLog(@"freelist_count: %d\npage_count: %d", [db freelist_count], [db page_count]);
    [db vacuum];
    //NSLog(@"freelist_count: %d\npage_count: %d", [db freelist_count], [db page_count]);
}

@end
