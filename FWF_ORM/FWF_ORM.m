//
//  FWF
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FWF_ORM.h"
#import "FMDbWrapper.h"
#import "FWF_Costants.h"

@implementation FWF

+ (void) resetStorage{
    [FMDbWrapper resetDatabase];
}

+ (void) shrinkDownStorage{
    FMDbWrapper *db = [[FMDbWrapper alloc] initDatabaseWithoutForeignKeys];
    //[FMDbWrapper databaseWithPath:[FMDbWrapper standardDbPath]];
    //NSLog(@"freelist_count: %d\npage_count: %d", [db freelist_count], [db page_count]);
    [db vacuum];
    //NSLog(@"freelist_count: %d\npage_count: %d", [db freelist_count], [db page_count]);
}

+ (NSArray *) listClassesOfStoredEntities{
    NSMutableArray * list = [[NSMutableArray alloc] init];
    FMDbWrapper *db = FWF_STD_DB_ENGINE_NO_FK;
    FMResultSet *rs = [db executeQuery:@"select name from sqlite_master where type='table'"];
    
    while ([rs next]) {
        NSString *entityName = [[rs resultDictionary] objectForKey:@"name"];
        if (!([entityName isEqualToString:@"sqlite_sequence"] || [entityName hasPrefix:@"fwflu_"])) {
            [list addObject:NSClassFromString(entityName)];
        }
    }
    return list;
}

+ (NSArray *) listNamesOfStoredEntities{
    NSMutableArray * list = [[NSMutableArray alloc] init];
    FMDbWrapper *db = FWF_STD_DB_ENGINE_NO_FK;
    FMResultSet *rs = [db executeQuery:@"select name from sqlite_master where type='table'"];
    
    while ([rs next]) {
        NSString *entityName = [[rs resultDictionary] objectForKey:@"name"];
        if (!([entityName isEqualToString:@"sqlite_sequence"] || [entityName hasPrefix:@"fwflu_"])) {
            [list addObject:entityName];
        }
    }
    return list;
}

@end
