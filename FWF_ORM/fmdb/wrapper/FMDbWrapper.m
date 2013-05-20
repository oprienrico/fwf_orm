//
//  FMDB extensions
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FMDbWrapper.h"
#include "TargetConditionals.h"
#import "FileManagementUtils.h"


@implementation FMDbWrapper
//wrapper per FMBD,

//  se si vuole usare un db come template non conviene reinizializzare il db ogni volta

//  inizializza un database in posizione standard(dentro la cartella documenti 
//  con privilegi di lettura/scrittura, con possibilità di cancellare la vecchia versione

/*
 
    // let's initialize!
    FMDbWrapper *database = [[FMDbWrapper alloc] initDatabaseFromTemplateWithReset:NO];
    
    //use executeUpdate when committing a query with no result
    [database executeUpdate:@"CREATE TABLE persona (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)"];
    
    [database executeUpdate:@"INSERT INTO persona (id,name) VALUES (NULL,'enrico');INSERT INTO persona (id,name) VALUES (2,'luca');"];
 
    //a quick method to obtain an Array of Dictio
    [database getarrayByExecutingSQL:@"select * from persona"];
 
    //usual method
    FMResultSet *results = [database executeQuery:@"select * from user"];
    while([results next]) {
        NSString *name = [results stringForColumn:@"name"];
        NSInteger age  = [results intForColumn:@"age"];        
        NSLog(@"User: %@ - %d",name, age);
    }
    
    //remember to close the db!
    [database close];

*/

+ (NSString *) standardDbPath{
    return [[FileManagementUtils standardAppSupportFolderPath] stringByAppendingPathComponent:@"database.sqlite"];
}

- (id) initDatabase{
    //try to init db
    self = [FMDbWrapper databaseWithPath:[FMDbWrapper standardDbPath]];
    if (![self open]){
        NSLog(@"Failed to open database!");
        return nil;
    }else {
        #ifdef FMDB_FOREIGN_KEY
            #if FMDB_FOREIGN_KEY == TRUE
                [self executeUpdate:@"PRAGMA foreign_keys=ON;"];
            #else
                [self executeUpdate:@"PRAGMA foreign_keys=OFF;"];
            #endif
        #else
            [self executeUpdate:@"PRAGMA foreign_keys=OFF;"];
        #endif
    }
    
    return self;
}

- (id) initDatabaseWithForeignKeys{
    NSString *db_path = [FMDbWrapper standardDbPath];
    
    //try to init db
    self = [FMDbWrapper databaseWithPath:db_path];
    if ([self open]){
        [self executeUpdate:@"PRAGMA foreign_keys=ON;"];
    }else {
        NSLog(@"Failed to open database!");
        return nil;
    }
    
    return self;
}

- (id) initDatabaseWithoutForeignKeys{
    NSString *db_path = [FMDbWrapper standardDbPath];
    
    //try to init db
    self = [FMDbWrapper databaseWithPath:db_path];
    if ([self open]){
        [self executeUpdate:@"PRAGMA foreign_keys=OFF;"];
    }else {
        NSLog(@"Failed to open database!");
        return nil;
    }
    
    return self;
}

- (void) setupDatabasesDefaults{
    // Default to UTF-8 encoding
    [self executeUpdate:@"PRAGMA encoding = \"UTF-8\""];
    
    //auto-vacuuming set to full keeps the size of the db down, but it leads to fragmentation
    [self executeUpdate:@"PRAGMA auto_vacuum=1"];
}

- (void) activateForeignKeys{
    [self executeUpdate:@"PRAGMA foreign_keys=ON;"];
}

+ (bool) databaseExist{
    return [[NSFileManager defaultManager] fileExistsAtPath:[FMDbWrapper standardDbPath]];
}

+ (bool) resetDatabase{
    NSString *db_path = [FMDbWrapper standardDbPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager removeItemAtPath:db_path error:nil])
        return false;
    //init a db
    FMDbWrapper *db = [FMDbWrapper databaseWithPath:[FMDbWrapper standardDbPath]];
    
    if ([db open]){
        //[db executeUpdate:@"PRAGMA auto_vacuum=1"];
        [db close];
        return true;
    }else{
        NSLog(@"Failed to open database!");
        return false;
    }
}

+ (void) deleteDatabase{
    NSString *db_path = [FMDbWrapper standardDbPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:db_path error:nil];
}

- (id) initDatabaseWithReset:(BOOL)reset{
    if (reset) {
        [[self class] resetDatabase];
    }
    return [self initDatabase];
}

//  init database with a template database (default is "templatedb.sqlite")
- (id)initDatabaseWithTemplateDb{
    return [self initDatabaseWithTemplateDbFromPath:@"templatedb.sqlite" byOverwriting:false];
}

//  init database with a template database from the path specified
- (id) initDatabaseWithTemplateDbFromPath:(NSString *) template_path byOverwriting:(bool)isToOverwrite{
    [[self class] createDatabaseWithTemplateDbFromPath:template_path byOverwriting:isToOverwrite];
    //inizializzo db
    return [self initDatabase];
}

+ (bool) overwriteDatabaseWithTemplateDb{
    return [self createDatabaseWithTemplateDbFromPath:@"templatedb.sqlite" byOverwriting:true];
}

+ (bool) overwriteDatabaseWithTemplateDbFromPath:(NSString *) template_path{
    return [self createDatabaseWithTemplateDbFromPath:template_path byOverwriting:true];
}

+ (bool) createDatabaseWithTemplateDbFromPath:(NSString *) template_path byOverwriting:(bool)isToOverwrite{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *db_path = [FMDbWrapper standardDbPath];
    
    //fix path search (if it doesn't start from radix, make path relative to current app bundle position)
    if ([template_path characterAtIndex:0]!='/')
        template_path =  [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:template_path];
    
    //it template file doesn't exist, return nil
    if (![fm fileExistsAtPath:template_path]) {
        NSLog(@"template database does not exist, do nothing");
        return false;
    }
    
    //if isToOverwrite is true it deletes the current db file (so it will be replaced by the template)
    if (isToOverwrite) {
        if(![fm removeItemAtPath:db_path error:nil])
            return false;
    }
        
    if(![fm copyItemAtPath:template_path toPath:db_path error:nil])
        return false;
    else
        return true;
    //NSLog(@"Database overwritten with template db");
}


- (NSArray *) arrayByExecutingSQL:(NSString *)sql{
    return [[self executeQuery:sql] listAllResultsAsArrayOfDictio];
}

- (NSArray *) arrayByExecutingSQL:(NSString *)sql overridingTypes:(NSArray *)overridedTypes{
    return [[self executeQuery:sql] listAllResultsAsArrayOfDictioWithOverridedTypes:overridedTypes];
}


+ (NSString *) sqlTypeFromObjCObject:(NSObject *) obj{
    return [self mysqlTypeFromObjCObject:obj];
}

+ (NSString *) sqliteTypeFromObjCObject:(NSObject *) obj{
    
    /*
     * TYPES AVAILABLE IN SLQLite
     *  - INTEGER
     *  - TEXT
     *  - BLOB
     *  - REAL
     *  - NUMERIC
     *
     * for reference http://www.sqlite.org/datatype3.html
     */
    NSLog(@"class : %@",[obj class]);
    
    if([obj isKindOfClass:[NSString class]])
        return @"TEXT";
    /*else if ([obj isKindOfClass:[NSMediumString class]])
        return @"TEXT";
    else if ([obj isKindOfClass:[NSLongString class]]
        return @"TEXT";*/
    else if ([obj isKindOfClass:[NSNumber class]])
        return @"REAL";
    else if ([obj isKindOfClass:[OBJInteger class]])
        return @"INTEGER";
    //else if ([obj isKindOfClass:[OBJFloat class]])
    //    return @"REAL";
    else if ([obj isKindOfClass:[OBJBool class]])
        return @"INTEGER";
    else if ([obj isKindOfClass:[NSDate class]])
        return @"INTEGER";
    else
        return @"BLOB";//default
}

+ (NSString *) mysqlTypeFromObjCObject:(NSObject *) obj{
    /*
     * DATATYPES CONVERSION FOR MYSQL
     * for reference http://dev.mysql.com/doc/refman/5.0/en/data-type-overview.html
     */
    
    if([obj isKindOfClass:[NSString class]])
        return @"TEXT";
    /*else if ([obj isKindOfClass:[NSMediumString class]])
        return @"MEDIUMTEXT";
    else if ([obj isKindOfClass:[NSLongString class]])
        return @"LONGTEXT";*/
    else if ([obj isKindOfClass:[NSNumber class]])
        return @"DOUBLE";
    else if ([obj isKindOfClass:[OBJInteger class]])
        return @"INTEGER";
    else if ([obj isKindOfClass:[OBJBool class]])
        return @"BOOLEAN";
    else if ([obj isKindOfClass:[NSDate class]])
        return @"TIMESTAMP";
    else
        return @"BLOB";//default
}

+ (NSString *) stringifyObjForSQL:(id) obj{
    if([obj isKindOfClass:[NSString class]])
        return [self stringQuote:[obj stringValue]];
    /*else if ([obj isKindOfClass:[NSMediumString class]])
        return [self stringQuote:[obj stringValue]];
    else if ([obj isKindOfClass:[NSLongString class]])
        return [self stringQuote:[obj stringValue]];*/
    else if ([obj isKindOfClass:[NSNumber class]])
        return [obj stringValue];
    else if ([obj isKindOfClass:[OBJInteger class]])
        return [obj stringValue];
    else if ([obj isKindOfClass:[OBJBool class]])
        return [obj stringValue];
    else if ([obj isKindOfClass:[NSDate class]])
        return [obj stringValue];
    else //default
        if ([obj respondsToSelector:@selector(stringValue)])
            return [obj stringValue];
        else
            return [NSString stringWithFormat:@"%@", obj];
}

//utils
+ (NSString *) stringQuote:(NSString *) string{
    return [NSString stringWithFormat:@"'%@'", string];
}

- (void) vacuum{
    [self executeUpdate:@"VACUUM;"];
}

- (int) page_count{
    return [self intForQuery:@"PRAGMA page_count;"];
}

- (int) freelist_count{
    return [self intForQuery:@"PRAGMA freelist_count;"];
}

@end
