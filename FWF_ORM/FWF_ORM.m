//
//  FWF
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FWF_ORM.h"
#import "FMDbWrapper.h"
#import "FileManagementUtils.h"
#import "FWFORMDbWrapper.h"
#import "FWF_Costants.h"

@implementation FWF

+ (bool) resetStorage{
    NSString *path = [FWFORMDbWrapper defaultStorageFolder];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager removeItemAtPath:path error:nil])
        return false;
    //init a db
    FWFORMDbWrapper *db = [FWFORMDbWrapper databaseWithPath:[FWFORMDbWrapper defaultDbPath]];
    
    if ([db open]){
        //[db executeUpdate:@"PRAGMA auto_vacuum=1"];
        [db close];
        return true;
    }else{
        NSLog(@"Failed to open database!");
        return false;
    }
}


+ (void) shrinkDownStorage{
    FWFORMDbWrapper *db = [[FWFORMDbWrapper alloc] initDatabaseWithoutForeignKeys];
    //[FWFORMDbWrapper databaseWithPath:[FWFORMDbWrapper defaultDbPath]];
    NSLog(@"prevacuum\nfreelist_count: %d\npage_count: %d", [db freelist_count], [db page_count]);
    [db vacuum];
    NSLog(@"postvacuum\nfreelist_count: %d\npage_count: %d", [db freelist_count], [db page_count]);
}

+ (NSArray *) listClassesOfStoredEntities{
    NSMutableArray * list = [[NSMutableArray alloc] init];
    FWFORMDbWrapper *db = FWF_STD_DB_ENGINE_NO_FK;
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
    FWFORMDbWrapper *db = FWF_STD_DB_ENGINE_NO_FK;
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
