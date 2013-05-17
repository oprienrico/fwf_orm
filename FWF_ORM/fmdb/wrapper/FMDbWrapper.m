//
//  FMDB extensions
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FMDbWrapper.h"
#include "TargetConditionals.h"

#define FMDB_EXCEPTION_UNSUPPORTED_PLATFORM [NSException exceptionWithName:@"FMDB_EXCEPTION_UNSUPPORTED_PLATFORM" reason:@"This platform is not recognized so it cannot be supported. Could not save the database." userInfo:nil]


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
    [database getArrayFromExecutingSQL:@"select * from persona"];
 
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

+ (NSString *) getStandardDbPath{
#if TARGET_OS_IPHONE
    // iOS
    NSString *documents_dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [documents_dir stringByAppendingPathComponent:[NSString stringWithFormat:@"database.sqlite"]];
#elif TARGET_IPHONE_SIMULATOR
    // iOS Simulator
    NSString *documents_dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [documents_dir stringByAppendingPathComponent:[NSString stringWithFormat:@"database.sqlite"]];
#elif TARGET_OS_MAC
    // Other kinds of Mac OS
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *folder = [NSString stringWithFormat:@"~/Library/Application Support/%@/",[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutablePath"] lastPathComponent]];
    folder = [folder stringByExpandingTildeInPath];
    
    if ([fileManager fileExistsAtPath: folder] == NO){
        [fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
        //[fileManager createDirectoryAtPath: folder attributes: nil];
    }

    return [folder stringByAppendingPathComponent:[NSString stringWithFormat:@"database.sqlite"]];;
#else
    @throw FMDB_EXCEPTION_UNSUPPORTED_PLATFORM;
#endif
    
}

- (id)initDatabase{
    //try to init db
    self = [FMDbWrapper databaseWithPath:[FMDbWrapper getStandardDbPath]];
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

- (id)initDatabaseWithForeignKeys{
    NSString *db_path = [FMDbWrapper getStandardDbPath];
    
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

- (id)initDatabaseWithoutForeignKeys{
    NSString *db_path = [FMDbWrapper getStandardDbPath];
    
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

+ (bool) resetDatabase{
    NSString *db_path = [FMDbWrapper getStandardDbPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:db_path error:nil];
    //init a db
    FMDbWrapper *db = [FMDbWrapper databaseWithPath:[FMDbWrapper getStandardDbPath]];
    
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
    NSString *db_path = [FMDbWrapper getStandardDbPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:db_path error:nil];
}

- (id)initDatabaseWithReset:(BOOL)reset{
    if (reset) {
        [[self class] resetDatabase];
    }
    return [self initDatabase];
}

//  inizializza database da template predefinito
- (id)initDatabaseFromTemplateWithReset:(BOOL) reset{
    return [self initDatabaseFromTemplateFile:@"templatedb.sqlite" reset:reset];
}

//  inizializza database da template specificandone nome
- (id)initDatabaseFromTemplateFile:(NSString *) fileTemplate reset:(BOOL)reset{

    NSFileManager *fm = [NSFileManager defaultManager];    
    NSString *db_path = [FMDbWrapper getStandardDbPath];
    NSString *template_path =  [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileTemplate];
    
    //se il template non esiste ritorna nil
    if (![fm fileExistsAtPath:template_path]) {
        NSLog(@"template not existent");
        return nil;
    }
    
    //se reset YES cancella copia precedente del db e forza reinizializzazione da template
    if(reset){
        [fm removeItemAtPath:db_path error:nil];
        NSLog(@"Database reset");
    }
    //se esiste già non copio nulla e lascio il file precedente
    if (![fm fileExistsAtPath:db_path]){
        [fm copyItemAtPath:template_path toPath:db_path error:nil];
        NSLog(@"Database copied from template");
    }
        
    //inizializzo db
    return [self initDatabase];
    
}

- (NSArray *)arrayFromExecutingSQL:(NSString *)sql{
    return [[self executeQuery:sql] getResultArrayOfDictio];
}

- (NSArray *)arrayFromExecutingSQL:(NSString *)sql overridingTypes:(NSArray *)overridedTypes{
    return [[self executeQuery:sql] getResultArrayOfDictioWithOverridedTypes:overridedTypes];
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
